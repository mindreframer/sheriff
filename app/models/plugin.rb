class Plugin < ActiveRecord::Base
  has_many :deputies, :class_name => 'DeputyPlugin'
  has_many :deputy_plugins, :dependent => :destroy

  validates_presence_of :code
  validates_uniqueness_of :name
  before_validation :download_code, :on => :create

  def self.names
    all(:select => 'name').map(&:name).sort
  end

  protected

  def download_code
    return unless url.present?
    self.code = open(url).read
  end
end