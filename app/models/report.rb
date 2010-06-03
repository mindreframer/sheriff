class Report < ActiveRecord::Base
  include ErrorLevelPropagation
  include SerializedValue

  belongs_to :group
  belongs_to :deputy

  has_many :historic_values, :dependent => :destroy, :order => 'reported_at desc'

  # TODO use validations <-> controller
  NESTED_VALIDATIONS = [:run_every_validation, :run_between_validation, :value_validation]
  NESTED_VALIDATIONS.each{|v| has_one v}
  accepts_nested_attributes_for *NESTED_VALIDATIONS

  has_many :validations

  validates_uniqueness_of :group_id, :scope => :deputy_id

  def full_name
    "#{group.full_name} @ #{deputy.full_name}"
  end

  def historic_values_including_current
    [self] + historic_values
  end

  def self.report!(value, groups, options={})
    raise if groups.size != 2
    group = Group.find_or_create_for_level1(groups.first)
    group = group.find_or_create_child(groups[1])

    deputy = Deputy.find_or_create_by_address_or_name(options[:address], options[:name])
    deputy.update_last_report_at!

    if report = first(:conditions => {:group_id => group.id, :deputy_id => deputy.id})
      report.historic_values.create!(report.attributes.slice('reported_at', 'value', 'current_error_level'))
      report.update_attributes!(:value => value, :reported_at => Time.now)
    else
      report = create!(:value => value, :group => group, :deputy => deputy, :reported_at => Time.now)
    end

    report.validations.each(&:check!)

    report
  end
end