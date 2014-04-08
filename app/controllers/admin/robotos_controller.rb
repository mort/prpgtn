class Admin::RobotosController < Admin::AdminController
  
  def index
    @feeds = Feed.all.pluck(:title, :id)
    @robotos = Roboto.all.order('created_at DESC')
    @roboto = Roboto.new
  end
  
  def show
    
    @roboto = Roboto.find params[:id]
    
    @feeds = Feed.all.pluck(:title, :id)
    @feeds = (@feeds - [@roboto.feed.title, @roboto.feed.id]) if @roboto.feed
    
  end
  
  def create

    @roboto = Roboto.new(roboto_params)
    @roboto.admin_created = true
    p = params[:return_to] || admin_robotos_path
    
    if @roboto.save
      
      respond_to do |format|
      
        format.html {
          redirect_to p, notice: "Roboto created"
        }
      
      end
      
    else 
      
      respond_to do |format|
      
        format.html {
          redirect_to p, error: "Problem creating roboto_params"
        }
        
      
      end
      
      
    end

  end
  
  def update
    
    @roboto = Roboto.find params[:id]
    
    if @roboto.update_attributes(roboto_params)
        
      respond_to do |format|
      
        format.html {
          
          redirect_to admin_roboto_path(@roboto), notice: 'Roboto updated'
          
        }
      
      
      end
    
    else
      
      respond_to do |format|

        format.html { redirect_to admin_roboto_path(@roboto), notice: "Roboto NOT updated #{roboto_params.inspect}" }
        
        
      end
    
    
    end
    
    
    
  end
  

  def fire
  
    r = Roboto.find params[:id]
    
    r.quit
    
    respond_to do |format|
    
      format.html {
        redirect_to admin_robotos_path, notice: "Roboto #{r.id} fired successfully"
      }
    
    end
    
  
  end

  
  private
  
  def roboto_params
    
    params.require(:roboto).permit(:feed_id)
    
  end
  
  
end
