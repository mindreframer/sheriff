class Validation < ActiveRecord::Base
  include ErrorLevelPropagation
end