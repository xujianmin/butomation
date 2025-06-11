class Lottery < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", optional: true

  before_validation :set_default_owner, on: :create

  validates :title, :target_url, presence: true

  private

  def set_default_owner
    self.owner_id ||= Current.user&.id
  end
end
