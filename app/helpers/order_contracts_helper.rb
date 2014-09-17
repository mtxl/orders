module OrderContractsHelper
  def orders_stylesheet_link_tag(source)
    css_dir = Rails.root.join("plugins","orders","assets","stylesheets")
    css_text = "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end
end
