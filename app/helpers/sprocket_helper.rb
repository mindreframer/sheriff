# is included in Rails.application.assets.context_class.class_eval
module SprocketHelper
  POSSIBLE_FORMATS = ["html", 'erb']
  ALL_PERMUTATIONS = POSSIBLE_FORMATS.permutation.to_a + POSSIBLE_FORMATS.map{|x|[x]}

  # http://ididitmyway.heroku.com/past/2010/5/31/partials/
  ### redid as very basic version
  def partial(template,locals=nil)
    # prepend basename with underscore
    template = File.join(File.dirname(template.to_s), '_' + File.basename(template.to_s))
    # render
    erb (template, {}, locals)
  end

  def erb(template_path, options={}, locals=nil)
    base_path        = Rails.root.join("app/assets/templates")
    file_path        = base_path.join(template_path.to_s)
    possible_files   = ALL_PERMUTATIONS.map{|e| "#{file_path}.#{e.join('.')}"}
    # check existence
    possible_files   = possible_files.reject{|x| not File.exists?(x)}
    raise "no file found for template_path" if possible_files.size == 0
    content          = File.read(possible_files.first)
    template         = ERB.new(content)
    template.result(binding)
  end
end
