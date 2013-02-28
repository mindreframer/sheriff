class Report < ActiveRecord::Base
  include ErrorLevelPropagation
  include SerializedValue

  # inline schema
  col :group_id,            :type => :integer, :null => false
  col :deputy_id,           :type => :integer, :null => false
  col :value,               :type => :string,  :null => false
  col :config,              :type => :string
  col :reported_at,         :type => :datetime,:null => false
  col :current_error_level, :type => :integer, :default => 0, :null => false
  col :description,         :type => :text
  col :deleted_at,          :type => :datetime
  col_timestamps

  add_index [:deputy_id]
  add_index [:group_id, :deputy_id], :unique => true


  belongs_to :group
  belongs_to :deputy

  has_many :historic_values, :dependent => :destroy, :order => 'reported_at desc'
  has_many :alerts, :dependent => :destroy, :order => 'id desc'

  has_many :validations, :dependent => :destroy
  accepts_nested_attributes_for :validations, :allow_destroy => true

  validates_uniqueness_of :group_id, :scope => :deputy_id

  def self.visible
    where(:deleted_at => nil)
  end

  def full_name
    "#{(group||Group.new).full_name} @ #{(deputy|| Deputy.new).full_name}"
  end

  def historic_values_including_current
    [self] + historic_values
  end

  # try to find the plugin that reported
  def deputy_plugin
    DeputyPlugin.first(:conditions => {:deputy_id => deputy_id, 'plugins.name' => group.try(:group).try(:name)}, :joins => :plugin)
  end

  def delete
    # remove historic values
    # remove alerts
    # delete validatios
    self.update_attributes({:deleted_at => Time.now.utc})
    self.historic_values.map{|x| x.destroy}
    self.alerts.map{|x| x.destroy}
    self.validations.map{|x| x.delete}
  end

  def self.delayed_report(*args)
    GenericJob.publish(Report, :report!, :args => args)
  end

  def self.report!(value, groups, options={})
    raise if groups.size != 2
    group = Group.find_or_create_for_level1(groups.first)
    group = group.find_or_create_child(groups[1])

    deputy = Deputy.find_or_create_by_address_or_name(options[:address], options[:name])
    deputy.update_last_report_at!
    deputy.update_name!(options[:name])

    if report = first(:conditions => {:group_id => group.id, :deputy_id => deputy.id})
      report.store_state_as_historic_value
      report.update_attributes!(:value => value, :reported_at => Time.current)
    else
      report = create!(:value => value, :group => group, :deputy => deputy, :reported_at => Time.current)
    end

    report.validations.each(&:check!)

    report
  end

  def store_state_as_historic_value
    historic = historic_values.build
    ['reported_at', 'value', 'current_error_level'].each{|v| historic[v] = self[v] }
    historic.save!

    # keep last 30 values
    (historic_values.sort_by(&:reported_at).reverse[30..-1]||[]).each(&:destroy)
  end
end
