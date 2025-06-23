require 'rails_helper'

RSpec.describe Subordination, type: :model do
  let(:user) { create(:user) }
  let(:virtual_user) { create(:virtual_user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:virtual_user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:virtual_user) }

    it 'should validate uniqueness of user_id scoped to virtual_user_id' do
      create(:subordination, user: user, virtual_user: virtual_user)
      duplicate = build(:subordination, user: user, virtual_user: virtual_user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include('该虚拟用户已经被分配给此用户')
    end
  end

  describe 'creating subordination' do
    it 'creates a valid subordination' do
      subordination = Subordination.new(user: user, virtual_user: virtual_user)
      expect(subordination).to be_valid
    end
  end
end
