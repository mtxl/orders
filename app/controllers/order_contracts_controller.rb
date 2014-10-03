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

  def contract_id
    if institute.title == "МИРДО"
      @issue.id.to_s
    else
      "###"
    end

  end
  
  def institute
    Wiki.find_page(@project.name + ":" + @issue.custom_field_value(8))
  end

  def order
    @issue.order_info
  end

  def contractor
    @issue.order_info['contractor']
  end

  def product
    @issue.order_info['product_info']
  end

  def render_contract
    s = render_to_string 'base.html.erb', 
                          :layout => false,
                          :locals => {:page => contract_page},
                          :formats => [:html]

    tmpl = Liquid::Template.parse(s)
    tmpl.assigns['contractor'] = ContractorDrop.new contractor
    tmpl.assigns['order'] = OrderDrop.new order
    tmpl.assigns['product'] = ProductDrop.new product
    tmpl.assigns['institute'] = InstituteDrop.new institute
    tmpl.assigns['contract'] = ContractDrop.new contract_id, contract_page
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
