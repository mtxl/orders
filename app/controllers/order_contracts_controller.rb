class OrderContractsController < ApplicationController
  unloadable

  before_filter :find_issue

  def new

  end

  def create
    create_from_template
    redirect_to issue_path(@issue), :notice => "Invoice created!"
  end

  private

  def find_issue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def create_from_template
    t = Wiki.find_page("Курсы:МИРДО")
    c = @issue.contacts.first
    tmpl = Liquid::Template.parse(t.text)
    tmpl.assigns['contact'] = ContactDrop.new c
    s = '<meta http-equiv="content-type" content="text/html; charset=utf-8" />'
    s += Redmine::WikiFormatting.to_html(Setting.text_formatting, tmpl.render)
    pdf = WickedPdf.new.pdf_from_string(s)

    current_user = User.current
    fn = "Invoice-#{@issue.id}"
    a = Attachment.create(:file => pdf, :filename => fn,  :author => current_user)
    j = @issue.init_journal(current_user, "Проект договора")
    @issue.save_attachments("1" => {"filename" => fn, "token" => a.token} )
    @issue.save
  end
end
