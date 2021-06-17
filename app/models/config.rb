class Config < ActiveRecord::Base
	belongs_to :user

	include FriendlyId
	friendly_id :name

	validates_format_of :name, :with => /\A[a-z0-9\-_]+\z/i
	validates :body, presence: true

	scope :accessibles, -> (current_user) {
		if current_user.present?
			where("is_public = ? OR user_id = ?", true, current_user.id)
		else
			where(is_public: true)
		end
	}

end
