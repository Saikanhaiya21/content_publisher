class Publication < ApplicationRecord
  belongs_to :user

  STATUSES = %w[draft published archived].freeze

  validates :title, presence: true
  validates :content, presence: true
  validates :status, inclusion: { in: STATUSES }
end
