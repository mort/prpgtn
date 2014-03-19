class OnboardingController < ApplicationController
  before_filter :authenticate_user!
  
  MAX_STEPS = 2
  
  def step
    n = params[:n]|| 1 
    @n_link = next_url(n.to_i)
    @p_link = prev_url(n.to_i)
    render :template => "onboarding/step_#{n}"
  end
  
  private
  
  def next_url(n)
    (n > MAX_STEPS) ? url_for(:overwrite_params => {:n => n}) : nil
  end
  
  def prev_url(n)  
    (n > 1) ? url_for(:overwrite_params => {:n => n}) : nil
  end
  

end
