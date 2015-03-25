class Token < ActiveRecord::Base
  belongs_to :user

  validates :key, presence: true, uniqueness: true

  def disable!
    update active: false
  end

  def disabled?
    !active?
  end
end
