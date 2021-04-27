class Config < ActiveRecord::Base
  belongs_to :user

  include FriendlyId
  friendly_id :name

  serialize :body, JSON

  validates_format_of :name, :with => /\A[a-z0-9\-_]+\z/i

  scope :accessibles, -> (current_user) {
    if current_user.present?
      where("is_public = true OR user_id = #{current_user.id}")
    else
      where(is_public: true)
    end
  }

end
