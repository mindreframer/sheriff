module ApplicationHelper
  def title
    strip_tags "#{heading} - Sheriff"
  end

  def heading
    text = if @resource
      if @resource.new_record?
        "New #{@resource.class}"
      else
        "#{name_for_object @resource} #{link_to_delete @resource, :text => 'x'}"
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