class ActiveRecord::Base
  def self.col_timestamps
    col "created_at",          :type => :datetime
    col "updated_at",          :type => :datetime
  end

  def self.migrate_all
    # collect all subclasses for activerecord
    (models = ::ObjectSpace.each_object(::Class).select do |c|
      c.ancestors.include?(ActiveRecord::Base)
    end - [ActiveRecord::Base])

    # run migrations
    models.each do |m|
      m.auto_upgrade!
    end
  end
end
