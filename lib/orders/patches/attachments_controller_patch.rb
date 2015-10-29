require 'tempfile'
require 'zip'
module  Orders
  module AttachmentsControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def bulk_download
        attachments = Attachment.where(container_type: "Issue", container_id: params[:issues_ids]) if params[:issues_ids]
        if attachments.nil? || attachments == []
          flash[:warning] = l('msg_no_attachments')
          redirect_to :back
          return
        end
        download_entries(params[:issues_ids].split("/"))
      end

      private

      def download_entries(issues_ids)
        zip = Tempfile.new(['attachments_zip','.zip'])
        Zip::File.open(zip.path, Zip::File::CREATE) do |zip_file|
          issues_ids.each do |id|
            issue = Issue.find_by_id(id)
            files = issue.attachments if issue
            folder = issue.id.to_s
            zip_file.mkdir(folder)
            files.each do |f|
              next unless (f.visible? && f.filename[0] != '-')
              zip_file.add(File.join(folder, f.filename), f.diskfile)
            end
          end
          send_file(zip.path, filename: 'attachments-' + DateTime.now.strftime('%Y-%m-%d %H%M%S') + '.zip', type: 'application/zip', disposition: 'attachment')
        end
      end
    end
  end
end

AttachmentsController.send(:include, Orders::AttachmentsControllerPatch)
