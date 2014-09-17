module Orders
  module WikiMacros
    Redmine::WikiFormatting::Macros.register do
      desc "Stamps"
      macro :stamp do |obj, args|
        if obj.class == WikiPage
          p = obj.parent
          stamp_name = args.empty? ? l(:label_stamp) : args.first
          a = Attachment.where(:container_id => p.id, :description => stamp_name).first
          #s = "!/attachments/download/1148/signature.png!"
          a ? tag("img", src: "file:///#{Rails.root}/files/#{a.disk_directory}/#{a.disk_filename}", style: "width:150px;height:150px") : ''.html_safe
        end
      end
    end

  end
end
