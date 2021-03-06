module ApplicationHelper
  def error_attribute(object)
    raw %{class="error_level_#{error_level object}"}
  end

  def error_class(object)
    raw %{error_level_#{error_level object}}
  end

  def visual_error(object, text=nil)
    text ||= error_level(object)
    level_class = case error_level(object)
      when 3 then "label-important"
      when 2 then "label-warning"
      else ''
    end
    raw %{<span class="label #{level_class}">#{text}</span>}
  end

  def error_level(object)
    case object
    when Deputy, Group, Report, Validation then object.current_error_level
    when Alert then object.error_level
    end
  end

  def detailed_time(time)
    return unless time
    "#{time.to_s(:db)} <br/> #{time_ago time}".html_safe
  end

  def short_validations(report)
    report.validations.map do |v|
      uppercase_letters(v.type) +
      validation_value_info(v) +
      ":<span title='error level #{v.error_level}'>#{v.error_level}</span>"
    end.sort.join(' ').html_safe
  end

  def human_validation_display(report)
    report.validations.map do |v|
      v.human_display
    end.join(' <br/> ').html_safe
  end

  def uppercase_letters(name)
    letters = name.split('').select{|c|c =~ /[A-Z]/}[0..-2].join('')
    "<span title='#{name}'>#{letters}</span>"
  end

  def validation_value_info(validation)
    case validation
    when ValueValidation then "<span title='#{validation.value_as_text}'>:#{validation.value_as_text.first(10)}</span>"
    when RunEveryValidation then "<span title='#{validation.humanized_interval}'>:#{validation.interval_value}#{validation.interval_unit_as_text.first.downcase}</span>"
    when RunBetweenValidation then ""
    else raise "unknown validation #{validation}"
    end
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
        "<span #{error_attribute @resource}>#{name_for_object @resource}</span> #{button_to_delete @resource, :text => 'x'}"
      end
    elsif @collection
      count = resource_class.respond_to?(:visible) ? resource_class.visible.count : resource_class.count
      "#{resource_class.to_s.pluralize} (#{count})"
    end
    raw text
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
    add.each{|klass| object.send(many).build :type => klass }

    index = -1
    form.fields_for many do |vf|
      index += 1
      yield vf, index
    end
  end

  def help_for_validations(validation)
    case validation.class.to_s
    when 'ValueValidation' then
      { :title => 'Check the value range/type',
        :content => "Fill the values for positive outcome."}
    when 'RunEveryValidation' then
      { :title => 'Check how often it should run',
        :content => "Choose the period, how often a report should come in. Check only_once-checkbox, if only one report is expected."}
    when 'RunBetweenValidation' then
      { :title => 'Check when (night/special hours) it should run',
        :content => "If some reports are expected in special daily hours, set them here."}
    else
      raise validation.class
    end
  end

  def select_options_tag(name,list,options={})
    selected = options[:value] || h(params[name])
    select_tag(name, options_for_select(list,selected), options)
  end

  def check_box_with_label(name, value, checked, label, options={})
    label_for = options[:id] || name
    chk_bx_html = check_box_tag(name, value, checked, options)
    label_tag(label_for, chk_bx_html  + label, options)
  end

  def should_show_group?(group)
    !!(group.current_error_level != 0 or is_current_or_parent?(group))
  end

  def is_current_or_parent?(group)
    current_group = @group || @report.try(:group)
    current_group and (group == current_group or current_group.group == group)
  end

  def toogle_all_check_boxes(klass, options={})
    link_to_function (options[:text]||'all'), "$.each($('.#{klass}'), function(){this.checked = !this.checked})", options
  end

  def nbsp(x=1)
    ('&nbsp;' * x).html_safe
  end
end
