class InstituteDrop < Liquid::Drop
  def initialize(institute)
    @institute = institute.class == WikiPage ? YAML.load(institute.text) : {}
  end
  def name
    @institute["name"]
  end
  def full_name
    @institute["full_name"]
  end
  def inn
    @institute["inn"]
  end
  def kpp
    @institute["kpp"]
  end
  def bank
    @institute["bank"]
  end
  def rs
    @institute["rs"]
  end
  def ks
    @institute["ks"]
  end
  def bik
    @institute["bik"]
  end
  def email
    @institute["email"]
  end
  def phone
    @institute["phone"]
  end
  def postal_address
    @institute["postal_address"]
  end
  def legal_address
    @institute["legal_address"]
  end
  def boss
    @institute["boss"]
  end
  def boss_contract_string
    @institute["boss_contract_string"]
  end

  def boss_for_sign
    name = @institute["boss"]
    if name
      a = name.split 
      "#{a[1][0]}.#{a[2][0]}.#{a[0]}"
    else
      ""
    end
  end

  def legal_postal_address
    legal_address
  end

end
