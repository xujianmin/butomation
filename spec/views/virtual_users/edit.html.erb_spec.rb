require 'rails_helper'

RSpec.describe "virtual_users/edit", type: :view do
  let(:virtual_user) {
    VirtualUser.create!(
      last_name,: "MyString",
      first_name,: "MyString",
      gender,: "MyString",
      email,: "MyString",
      civ_style: "MyString"
    )
  }

  before(:each) do
    assign(:virtual_user, virtual_user)
  end

  it "renders the edit virtual_user form" do
    render

    assert_select "form[action=?][method=?]", virtual_user_path(virtual_user), "post" do

      assert_select "input[name=?]", "virtual_user[last_name,]"

      assert_select "input[name=?]", "virtual_user[first_name,]"

      assert_select "input[name=?]", "virtual_user[gender,]"

      assert_select "input[name=?]", "virtual_user[email,]"

      assert_select "input[name=?]", "virtual_user[civ_style]"
    end
  end
end
