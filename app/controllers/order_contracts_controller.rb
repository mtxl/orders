class OrderContractsController < ApplicationController
  unloadable

  before_filter :find_issue

  def create
    pdf = WickedPdf.new.pdf_from_string render_contract
    save_contract_as_attachment(pdf)
    redirect_to issue_path(@issue), :notice => "Invoice created!"
  end
  
  def preview
    @text = render_contract
    render :partial =>"preview"
  end

  private

  def find_issue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def contract_page
    Wiki.find_page("#{@project.name}:#{params['contract']['institute_id']}")
  end
  
  def institute
    Wiki.find_page(@project.name + ":" + @issue.custom_field_value(8))
  end

  def contractor
    @issue.contacts.first
  end
  
  def render_contract
    s = render_to_string 'base.html.erb', 
                          :layout => false,
                          :locals => {:page => contract_page},
                          :formats => [:html]
    c = @issue.contacts.first

    tmpl = Liquid::Template.parse(s)
    tmpl.assigns['contact'] = ContactDrop.new c
    tmpl.assigns['institute'] = InstituteDrop.new institute
    tmpl.render
  end

  def save_contract_as_attachment(pdf)
    current_user = User.current
    fn = "Invoice-#{@issue.id}"
    a = Attachment.create(:file => pdf, :filename => fn,  :author => current_user)
    j = @issue.init_journal(current_user, "Проект договора")
    @issue.save_attachments("1" => {"filename" => fn, "token" => a.token} )
    @issue.save
  end
end
