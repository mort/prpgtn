class FwdWorker

  include Sidekiq::Worker

  def perform(id)
    
    f = Forwarding.find(id)
    
    original_fwd_id = f.item.forwardings.first.id if f.fwd
    
    Item.create!(body: f.item.body, channel: f.channel, user: f.user, fwd: true, original_fwd_id: original_fwd_id)

  end


end