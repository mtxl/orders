class ContractorDrop < Liquid::Drop

  CONTRACTOR_ATTR = %w(name full_name inn kpp email phone postal_address 
                       bank boss representing_contract doc)

  def initialize(contractor)
    @contractor = contractor
  end


  def before_method(meth)
    if CONTRACTOR_ATTR.include? meth 
      @contractor[meth]
    end
  end

  def legal_postal_address
    @contractor["legal_address"]
  end
end
