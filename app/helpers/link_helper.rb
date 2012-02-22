module LinkHelper
  def link_to_object(object, options={})
    link_to name_for_object(object, options), object, options
  end

  def link_to_edit(object, options={})
    text = options.delete(:text)||'edit'
    link_to text, edit_polymorphic_path(object), options
  end

  def name_for_object(object, options={})
    return options[:name] if options[:name]
    case object
    when Group, Deputy, Report then object.full_name
    when Plugin, Summary then object.name
    else "No name found"
    end
  end

  def link_to_new
    link_to 'New', new_resource_path
  end

  def link_to_delete(object, options={})
    text    = options.delete(:text) || 'delete'
    message = "Delete #{object.class} '#{name_for_object(object)}' ?"
    link_to text, object, options.merge(:method => :delete, :confirm => message, :title => 'Delete')
  end

  def button_to_delete(object, options={})
    options[:class] = (options[:class] ||'')  + " btn btn-danger btn-mini"
    link_to_delete(object, options)
  end

  def current_url(options)
    url_for(params.merge(options).except(:controller, :action))
  end

  def sort_head(name, options={})
    column = options[:column] || name.downcase.sub(' ','_')
    current = h(params[:order])
    down = "#{column} asc"
    down_icon = "<i class='icon-arrow-down'></i>".html_safe
    up_icon = "<i class='icon-arrow-up'></i>".html_safe
    link_to(name, current_url(:order => down), :style => 'text-decoration:none') + ' ' +
    [[up_icon, down], [down_icon, "#{column} desc"]].map do |arrow, order|
      link_to arrow, current_url(:order => order), :class => (current == order ? 'highlight' : ''), :style => 'text-decoration:none;padding:0 1px 0 1px;'
    end.join.html_safe
  end
end
