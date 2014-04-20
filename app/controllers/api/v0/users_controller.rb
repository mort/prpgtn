class Api::V0::UsersController < Api::V0::ApiController
  
  include ActionController::Live
  
  
  def me
    respond_with current_user
  end
  
  def index  
    respond_with current_user.channels.find(params[:channel_id]).subscribers
  end

  def activities
    
    _t = Time.now
    
    _since = if params[:since] 
      Time.parse params[:since].to_s
    else
       Time.now - 24.hours
     end
    
    
    activities = current_user.activities.where("activities.created_at >= :since AND activities.created_at <= :t", {since: _since, t: _t}).order('created_at DESC')
    
    # h = { totalItems: activities.size,
#         objectType: 'collection',
#         itemsAfter: since,
#         itemsBefore: t,
#         publishedAt: t,
#         items: activitites
#       }
#       

    t = DateTime.parse(_t.to_s).rfc3339
    since = DateTime.parse(_since.to_s).rfc3339
    
    respond_with activities, root: 'activities', meta: { objectType: 'collection', itemsAfter: since,  itemsBefore: t, publishedAt: t}
  end

  def stream
    
   response.headers['Content-Type'] = 'text/event-stream'
   ch = current_user.as_id
     
   conn.subscribe(ch) do |on| 
     on.message do |channel, message|        
       response.stream.write payload(message)
     end
   end
           
   ensure
    response.stream.close
  end  


  private
  
  def conn
    @redis ||= Redis.new
  end

  def payload(msg)
            
    "id: #{Time.now}\n"+
    # "event: Foo\n"+
    "data: #{msg}" +
    "\r\n\n"
    
  end
  
  
  

end

class ActivityCollection < OpenStruct
end