require 'rails_helper'

RSpec.describe "virtual_users/show", type: :view do
  before(:each) do
    assign(:virtual_user, VirtualUser.create!(
      last_name,: "Last Name,",
      first_name,: "First Name,",
      gender,: "Gender,",
      email,: "Email,",
      civ_style: "Civ Style"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Last Name,/)
    expect(rendered).to match(/First Name,/)
    expect(rendered).to match(/Gender,/)
    expect(rendered).to match(/Email,/)
    expect(rendered).to match(/Civ Style/)
  end
end
