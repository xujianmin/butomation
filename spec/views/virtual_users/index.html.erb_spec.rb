require 'rails_helper'

RSpec.describe "virtual_users/index", type: :view do
  before(:each) do
    assign(:virtual_users, [
      VirtualUser.create!(
        last_name,: "Last Name,",
        first_name,: "First Name,",
        gender,: "Gender,",
        email,: "Email,",
        civ_style: "Civ Style"
      ),
      VirtualUser.create!(
        last_name,: "Last Name,",
        first_name,: "First Name,",
        gender,: "Gender,",
        email,: "Email,",
        civ_style: "Civ Style"
      )
    ])
  end

  it "renders a list of virtual_users" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Last Name,".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("First Name,".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Gender,".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email,".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Civ Style".to_s), count: 2
  end
end
