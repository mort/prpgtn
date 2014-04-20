function get_channel_items(channel){
  //console.log("Retrieve items channel #"+channel);
  
  var url = ENDPOINT + '/api/v0/channels/'+channel+'.json';
  
  
  $.ajax({
      url: url,
      headers: { 'Authorization': 'Bearer '+a },
      success: function(d){
        console.log(d);
        paint_items(d.channel.viewport_items, d.channel.emotes);
      }
  });
  
}

function get_user_data(){

  var url = ENDPOINT + '/api/v0/me.json';

  $.ajax({
      url: url,
      headers: { 'Authorization': 'Bearer '+a },
      success: function(d){
        paint_user_data(d.user);
        channels = d.user_channels;
        window.peach.current_user = d.user
        var s = build_channels_menu(d.user.channels, d.user.latest_updated_channel_id);
        paint_channel_items(s);
        
        
      }, 
      error: function(d){
        //console.log("Error!");
        //console.log(d.status);
        if (d.status == 401) {
          paint_login();
        }
        
      }
  });

}



function get_user_activities(){
  
   var url = ENDPOINT + '/api/v0/me/activities.json';
   
   var since = localStorage.getItem('latest_activities_date');
   
   if (since != null) {
     url += '?since='+since;
   }
   
   
   $.ajax({
       url: url,
       headers: { 'Authorization': 'Bearer '+a },
       success: function(d){
                        
         _.each(d.activities, function(el){
           // console.log(el);
           el.signature = function() {
             return this.content.actor.objectType+"_"+this.content.verb+'_'+this.content.object.objectType;
          };
                     
           handler_for(el.signature(), el);
           
           
         });          
         
         localStorage.setItem('latest_activities_date', d.meta.publishedAt);
       }, 
       error: function(d){
         console.log("Error!");
         console.log(d.status);
        
       }
   });
  
}

function handler_for(event, data) {
 
  console.log(event);
  
  var s = "handler_"+event;
  
  window[s](data);
  
}

function handler_person_post_comment(activity) {
  //console.log(data);

  console.log(window.peach.current_user);
  var u = window.peach.current_user;
    
  console.log(activity);
  
  if (u.as_id != activity.content.actor.id) {
    console.log("Comment from other actor");
    
    var el = $('[peach_as_id="'+activity.content.inReplyTo+'"]');
    console.log(el);
    
    var r = '<p>'+activity.content.actor.displayName+' says: '+activity.content.object.content+'</p>';
    el.prepend(r);
    
  }
  
  
  
}

function handler_person_post_bookmark(activity) {
  console.log("handler_person_post_bookmark ________________");
  //console.log(data);
  var c = _paint_item_activity(activity);  
  $('section#viewport').prepend(c);
  
}


function grant_credentials(e,p){
  
  var url = ENDPOINT + '/oauth/token'
  var CLIENT_ID = '5905a513cb652e3030adccc8abf845cd2f1200e0238ee254cd803fefb65eb4ea';
  var CLIENT_SECRET = 'c8e187c8f0fe494639ea78350b7be0b45b868141762353182fad372c9101798f';
  
  var data = {
    'grant_type': 'password',
    'client_id': CLIENT_ID,
    'client_secret': CLIENT_SECRET,
    'username': e,
    'password': p
  };
  
  $.post(url, data, function(d){
    localStorage.setItem('access_token', d.access_token);
    //console.log(localStorage.getItem('access_token'));
    
  });
  
};

function get_channel_items(channel){
  //console.log("Retrieve items channel #"+channel);
  
  var url = ENDPOINT + '/api/v0/channels/'+channel+'.json';
  
  
  $.ajax({
      url: url,
      headers: { 'Authorization': 'Bearer '+a},
      success: function(d){
        paint_items(d.channel.viewport_items, d.channel);
      }
  });
  
}