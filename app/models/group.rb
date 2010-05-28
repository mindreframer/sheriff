class Group < ActiveRecord::Base
  belongs_to :group
  has_many :children, :class_name => 'Group', :order => 'name asc'
  has_many :reports

  validates_uniqueness_of :name, :scope => :group_id

  scope :level1, :conditions => {:group_id => nil}, :order => 'name asc'

  def full_name
    "#{group.name}.#{name}"
  end

  def self.find_or_create_for_level1(name)
    find_or_create_by_name_and_group_id(name, nil)
  end

  def find_or_create_child(name)
    self.class.find_or_create_by_name_and_group_id(name, id)
  end
end