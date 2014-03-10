class ApiController < ApplicationController
#class ApiController < RocketPants::Base
#   include ActionController::Head
#   include Doorkeeper::Helpers::Filter
#   
#   version 1
#   
#   #doorkeeper_for :all
#   
#   map_error! ActiveRecord::RecordNotFound, RocketPants::NotFound
#   
#   caching_options[:must_revalidate] = true
#   
#   jsonp # Offer JSON across the whole api.
#   
#   
#   private
# 
#    # Find the user that owns the access token
#    def current_resource_owner
#      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
#    end
#   
# end
end
