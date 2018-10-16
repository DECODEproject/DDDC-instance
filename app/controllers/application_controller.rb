class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "dddc", password: "dddc"
end
