class Admin::RobotosController < Admin::AdminController
  
  def index
    @robotos = Roboto.all
  end
  
  def show
    @roboto = Roboto.find params[:id]
  end
  
  
end
