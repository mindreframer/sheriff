module LinkHelper
  def link_to_object(object, options={})
    link_to name_for_object(object), object, options
  end

  def link_to_edit(object, options={})
    link_to 'edit', edit_polymorphic_path(object), options
  end

  def name_for_object(object)
    case object
    when Group then object.full_name
    when Deputy then object.full_name
    when Plugin then object.name
    end
  end

  def link_to_new
    link_to 'New', new_resource_path
  end
end