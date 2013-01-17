class PluginsForDeputyAction < BaseAction
  attr_accessor :request
  def initialize(params, request)
    super(params)
    @request = request
  end

  def perform
    address, name = Deputy.extract_address_and_name(request)
    deputy = Deputy.find_by_address_or_name(address, name)
    info = "(name:#{name} or address:#{address})"
    text = if deputy
      if deputy.deputy_plugins.empty?
        "# there are not plugins for you #{info}"
      else
        "# your plugins #{info}\n" +
        deputy.deputy_plugins(:include => :plugin).map{|dp| "##{dp.plugin.name}\n#{dp.code_for_deputy}" }.join()
      end
    else
      "# you are not registered #{info}"
    end
    return text
  end
end