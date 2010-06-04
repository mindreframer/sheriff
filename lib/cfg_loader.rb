require 'erb'
module CFGLoader
  def self.read(*files)
    config = {}
    files.each do |file|
      next unless File.exist? file
      data = YAML::load(ERB.new((IO.read(file))).result)[Rails.env]
      data ||= {}
      config.merge!(data)
    end
    config.with_indifferent_access.freeze
  end
end
