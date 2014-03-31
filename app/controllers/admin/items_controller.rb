class Admin::ItemsController < Admin::AdminController

  def index
  
    @items = Item.with_link
  
  end


  def show
    
    @item = Item.find params[:id]
  
  end

end