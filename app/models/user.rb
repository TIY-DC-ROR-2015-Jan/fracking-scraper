class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

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
end
