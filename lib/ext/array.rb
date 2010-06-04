#converts a array to an ActiveSupport::OrderedHash
#more convinient then building it by hand
class Array
  def to_ordered_hash
    oh = ActiveSupport::OrderedHash.new
    each do |k,v|
      oh[k]=v
    end
    oh
  end
end