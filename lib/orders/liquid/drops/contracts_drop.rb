class ContractDrop < Liquid::Drop

  def initialize(contract_id, contract)
    institute = contract.parent
    @contract = YAML.load(institute.text)[contract.title]
    @contract_id = contract_id
  end

  def name
    @contract[0]
  end

  def subject
    @contract[1]
  end

  def city
    @contract[2]
  end

  def id
    @contract_id
  end

end
