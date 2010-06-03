module ApplicationHelper
  def error_attribute(object)
    raw %{class="error_level_#{error_level object}"}
  end

  def error_level(object)
    case object
    when Deputy, Group, Report, Validation then object.current_error_level
    when Alert then object.error_level
    end
  end

  def detailed_time(time)
    return unless time
    "#{time.to_s(:db)} : #{time_ago time}"
  end

  def time_ago(time)
    return unless time
    "#{time_ago_in_words time} ago"
  end

  def title
    strip_tags "#{heading} - Sheriff"
  end

  def heading
    text = if @resource
      if @resource.new_record?
        "New #{@resource.class}"
      else
        "<span #{error_attribute @resource}>#{name_for_object @resource}</span> #{link_to_delete @resource, :text => 'x'}"
      end
    elsif @collection
      "#{resource_class.to_s.pluralize}"
    end
    raw text
  end

  def check_box_with_label(name, value, checked, label, options={})
    label_for = options[:id] || name
    check_box_tag(name, value, checked, options) + label_tag(label_for, label)
  end

  def time_units_for_select(options={})
    IntervalAccessors::UNITS.map(&:reverse).reject{|x,y| (options[:without]||[]).include?(x) }
  end

  def clearer
    content_tag :div, '', :class => 'clearer'
  end

  # building for sti does not work (even with correct type set in build() )
  # so we hack araound...
  def fields_for_sti(form, many, add)
    object = form.object
    add.each{ object.send(many).build }

    index = -1
    form.fields_for many do |vf|
      index += 1
      vf.object = add.pop.new if not vf.object.type
      yield vf, index
    end
  end
end