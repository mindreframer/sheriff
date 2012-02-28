# Angular.js and Rails (slide 31)
### SLIDE: https://docs.google.com/presentation/d/1XjdTioX07-f62lIJoiLjo326bP7MxTcaKAKp8rYuDt0/edit?pli=1#slide=id.g6c2677_1_80
### as suggested here: http://stackoverflow.com/questions/6515436/rails-3-1-include-root-in-json
# Be sure to restart your server when you modify this file.
#
# This file contains settings for ActionController::ParamsWrapper which
# is enabled by default.
# http://edgeapi.rubyonrails.org/classes/ActionController/ParamsWrapper.html

# Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.
ActionController::Base.wrap_parameters :format => [:json]

# Disable root element in JSON by default.
if defined?(ActiveRecord)
  ActiveRecord::Base.include_root_in_json = false
end
