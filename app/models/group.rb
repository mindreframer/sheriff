class Group < ActiveRecord::Base
  include ErrorLevelPropagation

  # inline schema
  col :name,         :type => :string, :null => false
  col :group_id,     :type => :integer
  col :created_at,   :type => :datetime
  col :updated_at,   :type => :datetime
  col :description,  :type => :text
  col :current_error_level, :type => :integer, :default => 0, :null => false

  add_index [:group_id, :name], :unique => true
  add_index [:name, :group_id], :unique => true

  belongs_to :group
  has_many :children, :class_name => 'Group', :order => 'name asc', :dependent => :destroy
  has_many :reports, :dependent => :destroy

  validates_uniqueness_of :name, :scope => :group_id

  scope :level1, :conditions => {:group_id => nil}, :order => 'name asc'

  def reports_or_children_reports
    level1? ? children_reports : reports
  end

  def level1?
    not group_id?
  end

  def children_reports
    Report.where(:group_id => children.map(&:id))
  end

  def full_name
    group ? "#{group.name}.#{name}" : name
  end

  def self.find_or_create_for_level1(name)
    find_or_create_by_name_and_group_id(name, nil)
  end

  def find_or_create_child(name)
    self.class.find_or_create_by_name_and_group_id(name, id)
  end

end
