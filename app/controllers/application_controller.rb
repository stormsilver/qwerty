class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter do
    # reload the app configs if necessary. there will be at least one filesystem operation per possible config file
    ApplicationConfig.reload_if_needed
  end
end
