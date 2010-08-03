# validates_uniqueness_of produces "LOWER(text) = BINARY column" queries
# for :case_insensitive=>true, which will not use existing indices, so we add this
# EVIL HACK to make
# ALL validates_uniqueness_of in-case-sensitive
class ActiveRecord::ConnectionAdapters::MysqlAdapter
  def case_sensitive_equality_operator
    "="
  end
end