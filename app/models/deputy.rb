class Deputy < ActiveRecord::Base
  include ErrorLevelPropagation

  has_many :reports, :dependent => :destroy
  has_many :deputy_plugins, :dependent => :destroy
  accepts_nested_attributes_for :deputy_plugins

  validates_uniqueness_of :address
  validates_uniqueness_of :name, :if => lambda{|d| d.name != UNKNOWN }
  validates_uniqueness_of :human_name, :allow_blank => true

  UNKNOWN = 'unknown_host'

  def full_name
    "#{human_name.presence || name} (#{address})"
  end

  def update_last_report_at!
    return if last_report_at and last_report_at > 1.minute.ago
    update_attribute(:last_report_at, Time.current)
  end

  def self.find_by_address_or_name(address, name)
    if name == UNKNOWN
      first(:conditions => {:address => address})
    else
      first(:conditions => ["address = ? OR name = ?", address, name])
    end
  end

  def self.find_or_create_by_address_or_name(address, name)
    find_by_address_or_name(address, name) || create!(:address => address, :name => name)
  end

  def self.extract_address_and_name(request)

    remote_host = request.headers['HTTP_REMOTE_HOST'] || request.remote_host.presence || UNKNOWN
    logger.info "!!!!!!!!!!!!! " + request.headers.inspect if request.ip =~  /\.75/
    [request.ip, remote_host]
  end
end