# validates_uniqueness_of produces "LOWER(text) = BINARY column" queries
# for :case_insensitive=>true, which will not use existing indices, so we add this
# EVIL HACK to make
# ALL validates_uniqueness_of in-case-sensitive
class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  def case_sensitive_equality_operator
    "="
  end
end

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  def self.concat_sql(*values)
    "CONCAT(#{values * ', '})"
  end
end

# for heroku
class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def self.concat_sql(*values)
    values * " || "
  end
end
