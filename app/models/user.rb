class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def self.from_github_oauth auth
    User.where(github_uid: auth.uid).first_or_create! do |u|
      u.email = auth.info.email
      u.password = SecureRandom.hex(64)
      u.github_data = auth.to_h
    end
  end
end
