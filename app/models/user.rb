class User < ApplicationRecord
	has_many :configs, dependent: :destroy
	has_one :access_token, dependent: :destroy

	include FriendlyId
	friendly_id :email

	# validates_format_of :name, :with => /\A[a-z0-9]+\z/i

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable,
				:recoverable, :rememberable, :trackable, :validatable,
				:omniauthable, :omniauth_providers => [:github, :google_oauth2]

	def self.from_omniauth(auth)
		user = User.find_by(email: auth.info.email)

		if user and user.confirmed?
			user.provider = auth.provider
			user.uid = auth.uid
			return user
		end

		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.skip_confirmation!
			user.provider = auth.provider
			user.uid = auth.uid
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
		end
	end
end
