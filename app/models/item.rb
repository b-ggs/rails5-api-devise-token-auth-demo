class Item < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :quantity, presence: true
end
