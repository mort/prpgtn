require 'grape'

module Sputnik
  
  class Api < Grape::API
    prefix "api"
    version "1", :using => :header, :vendor => 'sputnik'
    format :json
    
    resource :ping do

      get  do
        'pong'
      end
      
    end
    
    resource :channel do
      
      get ":id" do      
        Channel.find(params[:id])
      end
      
      get ":id/items" do
        Channel.find(params[:id]).items
      end
      
    end
    
    resource :item do

      get ":id" do      
        Item.find_by_item_token(params[:id])
      end

    end
    
 
  end
end