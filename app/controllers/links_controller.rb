class LinksController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    
    params[:s] ||= 'kept'
    
    @links = if params[:s] && ArchivedLink::ARCHIVE_TYPES.keys.include?(params[:s].to_sym)
      current_user.links.merge(ArchivedLink.send(params[:s].to_sym))
    else
      current_user.links
    end
  end
  
  
end
