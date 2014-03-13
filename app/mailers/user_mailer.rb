class UserMailer < ActionMailer::Base
  default from: "postbox@prpgtn.com"
  
  def channel_invite(invite)
    @invite = invite
    mail(:to => invite.email, :subject => "You've been invited to Propagation")
  end
end
