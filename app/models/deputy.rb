class Deputy < ActiveRecord::Base
  include ErrorLevelPropagation

  # inline schema
  col "name",                :null => false
  col "address",             :null => false
  col "last_report_at",      :type => :datetime
  col "current_error_level", :type => :integer, :default => 0, :null => false
  col "human_name"
  col "disabled_until",      :type => :datetime
  col_timestamps


  has_many :reports, :dependent => :destroy
  has_many :deputy_plugins, :dependent => :destroy
  accepts_nested_attributes_for :deputy_plugins

  validates_uniqueness_of :address
  validates_uniqueness_of :name, :if => lambda{|d| d.name != UNKNOWN_HOST }
  validates_uniqueness_of :human_name, :allow_blank => true

  UNKNOWN_HOST = 'unknown_host'
  UNKNOWN_ADDRESS = 'unknown_address'

  def full_name
    "#{human_name.presence || name}"
  end

  def update_last_report_at!
    return if last_report_at and last_report_at > 1.minute.ago
    update_attributes(:last_report_at => Time.current)
  end

  def update_name!(name)
    return if name.blank?
    update_attributes(:name => name) if self.name != name
  end

  def disabled?
    disabled_until? and disabled_until > Time.current
  end

  def self.find_by_address_or_name(address, name)
    if name == UNKNOWN_HOST and address == UNKNOWN_ADDRESS
      raise 'Cannot possibly find anything'
    elsif name == UNKNOWN_HOST
      first(:conditions => {:address => address})
    elsif address == UNKNOWN_ADDRESS
      first(:conditions => {:name => name})
    else
      first(:conditions => ["name = ? OR address = ?", name, address])
    end
  end

  def self.find_or_create_by_address_or_name(address, name)
    find_by_address_or_name(address, name) || create!(:address => address, :name => name)
  end

  def self.extract_address_and_name(request)
    [extract_ip(request), extract_host(request)]
  end

  def self.extract_host(request)
    request.params[:hostname].presence || request.remote_host.presence || UNKNOWN_HOST
  end

  def self.extract_ip(request)
    request.params[:ip].presence ||
      (request.params[:forced_host] ? UNKNOWN_ADDRESS : request.ip)
  end

  def self.move_settings_from_to(old_ip, new_ip)
    old_deputy = Deputy.find_by_address(old_ip)
    new_deputy = Deputy.find_by_address(new_ip)

    ### reports
    reports = old_deputy.reports
    reports.map{|r| r.update_attributes(:deputy_id => new_deputy.id)}

    ### plugins
    plugins = old_deputy.deputy_plugins
    plugins.map{|r| r.update_attributes(:deputy_id => new_deputy.id)}
  end
end
