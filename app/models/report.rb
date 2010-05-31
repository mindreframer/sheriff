class Report < ActiveRecord::Base
  belongs_to :group
  belongs_to :reporter

  has_many :historic_values, :dependent => :destroy, :order => 'reported_at desc'
  
  NESTED_VALIDATIONS = [:run_every_validation, :run_between_validation, :value_validation]
  NESTED_VALIDATIONS.each{|v| has_one v}
  accepts_nested_attributes_for *NESTED_VALIDATIONS

  # TODO STI?
  def validations
    NESTED_VALIDATIONS.map{|x| send(x)}.compact
  end

  validates_uniqueness_of :group_id, :scope => :reporter_id

  def full_name
    "#{group.full_name} - #{reporter.full_name}"
  end

  def self.report!(value, groups, options={})
    raise if groups.size != 2
    group = Group.find_or_create_for_level1(groups.first)
    group = group.find_or_create_child(groups[1])

    reporter = Reporter.find_or_create_by_address_or_name(options[:address], options[:name])

    if report = first(:conditions => {:group_id => group.id, :reporter_id => reporter.id})
      report.historic_values.create!(:value => report.value, :reported_at => report.reported_at)
      report.update_attributes!(:value => value, :reported_at => Time.now)
    else
      report = create!(:value => value, :group => group, :reporter => reporter, :reported_at => Time.now)
    end

    report.validations.each(&:check!)

    report
  end
end