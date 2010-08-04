class GenericJob
  @queue = :jobs

  def self.perform(klass, method, options={})
    klass.constantize.send(method, *options['args'])
  end

  def self.publish(klass, method, options={})
    Resque.enqueue(self, klass.to_s, method.to_s, options)
  end
end
