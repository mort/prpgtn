class Admin::LinksController < Admin::AdminController
  
  def index
    @links = Link.all
  end
  
  def show
    @link = Link.find params[:id]
  end
  
  
end
