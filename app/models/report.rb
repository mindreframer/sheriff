class Report < ActiveRecord::Base
  belongs_to :group
  belongs_to :reporter

  validates_uniqueness_of :group_id, :scope => :reporter_id

  def self.report!(value, groups, options={})
    raise if groups.size != 2
    group = Group.find_or_create_for_level1(groups.first)
    group = group.find_or_create_child(groups[1])

    reporter = Reporter.find_or_create_by_address_or_name(options[:address], options[:name])

    if report = first(:conditions => {:group_id => group.id, :reporter_id => reporter.id})
      report.update_attributes!(:value => value)
    else
      create!(:value => value, :group => group, :reporter => reporter)
    end
  end
end