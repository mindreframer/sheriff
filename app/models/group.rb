class Group < ActiveRecord::Base
  belongs_to :group
  has_many :reports
  validates_uniqueness_of :name, :scope => :group_id
end