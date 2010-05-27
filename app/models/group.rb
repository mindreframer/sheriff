class Group < ActiveRecord::Base
  belongs_to :group
  has_many :reports
  validates_uniqueness_of :name, :scope => :group_id

  def self.find_or_create_for_level1(name)
    find_or_create_by_name_and_group_id(name, nil)
  end
end