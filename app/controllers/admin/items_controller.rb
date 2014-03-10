class Admin::ItemsController < Admin::AdminController

  def index
  
    @items = Item.all
  
  end


  def show
    
    @item = Item.find params[:id]
  
  end

end