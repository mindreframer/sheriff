class Alert < ActiveRecord::Base
  belongs_to :validation, :polymorphic => true
  belongs_to :report
end