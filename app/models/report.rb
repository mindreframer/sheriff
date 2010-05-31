class Report < ActiveRecord::Base
  belongs_to :group
  belongs_to :reporter

  validates_uniqueness_of :group_id, :scope => :reporter_id

  def full_name
    "#{group.full_name} - #{reporter.full_name}"
  end

  def reporting_value
    reporting_interval / reporting_unit
  end

  def reporting_unit
    return 1.day if reporting_interval == 0
    [1.day, 1.hour, 1.minute, 1.second].detect{|unit| reporting_interval.to_f % unit == 0 }
  end

  def self.report!(value, groups, options={})
    raise if groups.size != 2
    group = Group.find_or_create_for_level1(groups.first)
    group = group.find_or_create_child(groups[1])

    reporter = Reporter.find_or_create_by_address_or_name(options[:address], options[:name])

    if report = first(:conditions => {:group_id => group.id, :reporter_id => reporter.id})
      report.update_attributes!(:value => value, :reported_at => Time.now)
    else
      create!(:value => value, :group => group, :reporter => reporter, :reported_at => Time.now)
    end
  end
end