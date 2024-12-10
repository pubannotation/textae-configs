class Config < ApplicationRecord
	belongs_to :user, optional: true

	before_save :generate_json_body

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

	def self.parse_body(raw_body)
		parsed_body = JSON.parse(raw_body)

		parsed_body.slice(
			"autocompletion_ws",
			"entity types",
			"relation types",
			"attribute types",
			"delimiter characters",
			"non-edge characters"
		).transform_values(&:presence).compact
	end

	def pretty_body
		parsed_body = JSON.parse(body)
		JSON.pretty_generate(parsed_body)
	end

	private

	def generate_json_body
		# body is saved in ruby format through controller.
		# To save as JSON, convert format using gsub.
		parsed_body = JSON.parse(body.gsub('=>', ':'))
		self.body = JSON.generate(parsed_body)
	end
end
