class ActiveRecord::Base
  def self.col_timestamps
    col "created_at",          :type => :datetime
    col "updated_at",          :type => :datetime
  end
end
