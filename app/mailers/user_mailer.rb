class UserMailer < ActionMailer::Base
  default from: "postbox@grabapeach.com"
  
  def channel_invite(invite)
    @invite = invite
    mail(:to => invite.email, :subject => "You've been invited to Peach")
  end
end
