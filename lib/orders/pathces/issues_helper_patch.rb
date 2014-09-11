module IssuesHelper
  def template_contract_options_for_select(institute)
    p = Wiki.find_page("Курсы:#{institute}")
    a = p ? p.children.inject([]) {|a, i| a << [i.title,i.title]} : []
    options_for_select(a)
  end
end
