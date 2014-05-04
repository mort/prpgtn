function get_state(){

  var url = ENDPOINT + '/api/v0/me.json';

  $.ajax({
      url: url,
      headers: { 'Authorization': 'Bearer '+a },
      success: function(d){

        paint_user_data(d.user);
        window.peach.current_user = d.user
        paint_channel_selector();
        
        _.each(d.user.channels, function(c){
          paint_channel_section(c);
        });
        
        $('article[peach_asset_only=true]').hoverIntent(_item_hover_in,_item_hover_out);  
        
      }, 
      error: function(d){
        
        if (d.status == 401) {
          paint_login();
        }
        
      }
  });

}


function get_new_activities(){
  
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
           el.signature = function() {
             
             if (this.content.actor.objectType == 'person') {
               var ot = 'person';
             } else {
               var ot = 'roboto';
             }

             return ot+"_"+this.content.verb+'_'+this.content.object.objectType;
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


function get_credentials(e,p){
  
  var url = ENDPOINT + '/oauth/token'

  var data = {
    'grant_type': 'password',
    'client_id': CLIENT_ID,
    'client_secret': CLIENT_SECRET,
    'username': e,
    'password': p
  };
  
  $.post(url, data, function(d){
    localStorage.setItem('access_token', d.access_token);    
  });
  
};

