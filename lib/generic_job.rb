class GenericJob
  @queue = :jobs

  def self.perform(klass, method, options={})
    options = options.with_indifferent_access
    klass.constantize.send(method, *options[:args])
  end

  def self.perform_all
    loop do
      job = Resque.reserve(:jobs)
      break unless job
      job.perform
    end
  end

  def self.publish(klass, method, options={})
    if CFG[:resque]
      Resque.enqueue(self, klass.to_s, method.to_s, options)
    else
      perform(klass.to_s, method.to_s, options)
    end
  end
end
