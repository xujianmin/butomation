class VirtualUser < ApplicationRecord
  enum :civ_style, {
    east: "东方",
    west: "西方"
  }, prefix: true

  def fullname
    if civ_style_east?
      "#{last_name}#{first_name}"
    else
      "#{first_name} #{last_name}"
    end
  end
end
