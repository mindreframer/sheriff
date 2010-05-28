module LinkHelper
  def link_to_object(object, options={})
    link_to name_for_object(object), object, options
  end

  def name_for_object(object)
    case object
    when Group then object.full_name
    when Reporter then object.full_name
    end
  end
end