class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :tokens

  serialize :github_data, JSON

  def self.from_github_oauth auth
    User.where(github_uid: auth.uid).first_or_create! do |u|
      u.email = auth.info.email
      u.password = SecureRandom.hex(64)
      u.github_data = auth.to_h
    end
  end

  def github_token
    github_data["credentials"]["token"]
  end

  def octoclient
    @_octoclient ||= Octokit::Client.new(access_token: github_token)
  end

  def github_user_data
    octoclient.user
  end

  def generate_api_token!
    key = SecureRandom.hex 24 # TODO: what if this collides?
    expiration = Time.now + 2.weeks
    tokens.create! key: key, expires_at: expiration
  end

  def self.find_by_api_token key
    token = Token.where(key: key).first
    token.user
  end
end
