class Config < ActiveRecord::Base
  belongs_to :user

  include FriendlyId
  friendly_id :name

  serialize :body, JSON

  validates_format_of :name, :with => /\A[a-z0-9\-_]+\z/i
end
