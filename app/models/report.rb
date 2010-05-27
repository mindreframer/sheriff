class Report < ActiveRecord::Base
  belongs_to :group
  belongs_to :server
  validates_uniqueness_of :group_id, :scope => :server_id
end