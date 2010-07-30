module LinkHelper
  def link_to_object(object, options={})
    link_to name_for_object(object), object, options
  end

  def link_to_edit(object, options={})
    text = options.delete(:text)||'edit'
    link_to text, edit_polymorphic_path(object), options
  end

  def name_for_object(object)
    case object
    when Group, Deputy, Report then object.full_name
    when Plugin then object.name
    else "No name found"  
    end
  end

  def link_to_new
    link_to 'New', new_resource_path
  end

  def link_to_delete(object, options={})
    text = options.delete(:text) || 'delete'
    link_to text, object, options.merge(:method => :delete, :confirm => 'delete ?', :title => 'Delete')
  end

  def current_url(options)
    url_for(params.merge(options).except(:controller, :action))
  end

  def sort_head(name, options={})
    column = options[:column] || name.downcase.sub(' ','_')
    current = h(params[:order])
    down = "#{column} asc"
    link_to(name, current_url(:order => down), :style => 'text-decoration:none') + ' ' +
    [['^', down], ['v', "#{column} desc"]].map do |arrow, order|
      link_to arrow, current_url(:order => order), :class => (current == order ? 'highlight' : ''), :style => 'text-decoration:none'
    end.join.html_safe
  end
end