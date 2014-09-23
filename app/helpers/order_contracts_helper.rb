module OrderContractsHelper
  def orders_stylesheet_link_tag(source)
    css_dir = Rails.root.join("plugins","orders","assets","stylesheets")
    css_text = "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end

  def attachment_img_tag(container, name='', html_options)
    return ''.html_safe unless a = Attachment.where(:container_id => container.id, :description => name).first
    str = params["action"] == "preview" ? "/attachments/download/#{a.id}/#{a.filename}" : "file:///#{Rails.root}/files/#{a.disk_directory}/#{a.disk_filename}"
    options = html_options.merge(:src => str)
    tag("img", options)
  end

  def stamp_img_tag(contract, type = :stamp)
    contract_container = contract.parent
    stamp_name = l("label_#{type.to_s}")
    html_options = {:class => "#{type.to_s}"}
    attachment_img_tag(contract_container, stamp_name, html_options)
  end

  def sign_line(&block)
    s = "_"*25
    s << "/"
    if block_given?
      s << capture(&block) 
    elsif
      s << "_"*14
    end
    s << "/"
  end

  def account_props(name, item)
    s = l("label_#{item}") 
    s << ": "
    s << "{{#{name.to_s}.#{item}}}"
  end

  def contract_date
    Russian::strftime(Time.now, '%d %B %Y')+" "+l(:label_short_year)
  end
end
