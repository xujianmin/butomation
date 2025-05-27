class Sites::Pokermon < ApplicationRecord
  belongs_to :virtual_user

  validates :registry_cellphone, :registry_postcode, :registry_fandi, :reg_password, presence: true

  def generate_registry_jp_cellphone
    # 日本手机号格式：090-1234-5678
    # 090/080 是日本手机号区号
    # 1234 是手机号前四位
    # 5678 是手机号后四位
    # 所以，日本手机号格式为：090-1234-5678

    [ "080", "090" ].sample + (0...8).map { Random.new.rand(0..9) }.join
  end

  def email_address
    self.email + self.domain
  end
end
