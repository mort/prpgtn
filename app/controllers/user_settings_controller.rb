class UserSettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def edit  
    @user = current_user
  end
  
  def update
    
    u = current_user
    
    u.update_attributes(user_params)
    
    if u.save
    
      respond_to do |format|
        
        format.html {
          redirect_to edit_user_settings_path, :notice => 'Updated'
        }
        
      end
    
    
    end
    
    
    
  end
  
  private
  
  def user_params
    params.require(:user).permit(:avatar, :display_name)
  end
  
end
