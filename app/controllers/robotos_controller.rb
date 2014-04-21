class RobotosController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  
  def show
  
    @roboto = current_user.robotos.find params[:id]
  
  end
  
  def index

    @robotos = current_user.robotos.all
    
  end
  
end
