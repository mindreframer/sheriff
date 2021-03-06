class Plugin < ActiveRecord::Base
  EXAMPLE_CODE = <<-Ruby.gsub(/^    /,'')
    class MyPlugin < Scout::Plugin
      def build_report
        report "my_metric" => 42
      end
    end
  Ruby

  col :name,  :type => :string, :null => false
  col :url,   :type => :string
  col :code,  :type => :text, :null => false
  col_timestamps

  add_index [:name], :unique => true



  has_many :deputies, :class_name => 'DeputyPlugin'
  has_many :deputy_plugins, :dependent => :destroy

  validates_presence_of :code, :name
  validates_uniqueness_of :name
  validate do
    if error = self.class.syntax_error(code)
      errors.add(:code, error)
    end
  end
  before_validation :download_code, :on => :create

  def self.names
    all(:select => 'name').map(&:name).sort
  end

  protected

  def download_code
    return unless url.present?
    self.code = open(url).read
  end

  def self.syntax_error(code)
    eval("BEGIN {return false}\n#{code}", nil, 'Plugin code', 0)
  rescue Exception
    $!.message
  end
end
