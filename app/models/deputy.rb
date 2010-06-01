class Deputy < ActiveRecord::Base
  has_many :reports, :dependent => :destroy
  has_many :deputy_plugins, :dependent => :destroy
  accepts_nested_attributes_for :deputy_plugins

  validates_uniqueness_of :name, :address

  def full_name
    "#{name} (#{address})"
  end

  def self.find_or_create_by_address_or_name(address, name)
    first(:conditions => ["address = ? OR name = ?", address, name]) || create!(:address => address, :name => name)
  end
end