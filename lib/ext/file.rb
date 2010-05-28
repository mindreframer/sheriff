class File
  def File.write(file,data, options={})
    mode = options[:mode] || 'w'
    FileUtils.mkdir_p File.dirname(file) if options[:mkdir]
    File.open(file,mode){|f|f.write(data)}
  end
end