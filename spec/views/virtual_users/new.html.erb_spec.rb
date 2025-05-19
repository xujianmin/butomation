require 'rails_helper'

RSpec.describe "virtual_users/new", type: :view do
  before(:each) do
    assign(:virtual_user, VirtualUser.new(
      last_name,: "MyString",
      first_name,: "MyString",
      gender,: "MyString",
      email,: "MyString",
      civ_style: "MyString"
    ))
  end

  it "renders new virtual_user form" do
    render

    assert_select "form[action=?][method=?]", virtual_users_path, "post" do

      assert_select "input[name=?]", "virtual_user[last_name,]"

      assert_select "input[name=?]", "virtual_user[first_name,]"

      assert_select "input[name=?]", "virtual_user[gender,]"

      assert_select "input[name=?]", "virtual_user[email,]"

      assert_select "input[name=?]", "virtual_user[civ_style]"
    end
  end
end
