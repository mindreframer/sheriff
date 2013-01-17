# just structure for all action classes
class BaseAction
  attr_accessor :params
  def initialize(params)
    @params = params
  end
end