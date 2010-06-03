module ApplicationHelper
  def error_attribute(object)
    raw(%{class="#{error_level object}"})
  end

  def error_level(object)
    level = (object.is_a?(Alert) ? object.error_level : object.current_error_level)
    "error_level_#{level}"
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
end