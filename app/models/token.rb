class Token < ActiveRecord::Base
  class Invalid < StandardError; end

  belongs_to :user

  validates :key, presence: true, uniqueness: true

  scope :valid, -> { where(active: true).where("expires_at > ?", Time.now) }

  def disable!
    update active: false
  end

  def disabled?
    !active?
  end
end
