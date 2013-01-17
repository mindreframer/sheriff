# just structure for all action classes
class BaseAction
  attr_accessor :params
  def initialize(params)
    @params = params
  end

  ## used to mangle the params hash.. maybe some cleaner way?
  def convert_interval(hash)
    return unless hash
    if hash[:interval_unit].present?
      hash[:interval] = hash[:interval_value].to_i * hash[:interval_unit].to_i
    end
    hash.delete :interval_value
    hash.delete :interval_unit
  end

end