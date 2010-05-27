class Reporter < ActiveRecord::Base
  has_many :reports
  validates_uniqueness_of :name, :address
end