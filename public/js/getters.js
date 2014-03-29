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
        Peach.user = d.user
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


function grant_credentials(e,p){
  
  var url = ENDPOINT + '/oauth/token'
  var CLIENT_ID = '70f0fb61fe4e466de9a09d65376ad140ea1f35694b654c03f63e77f687b25701';
  var CLIENT_SECRET = '3a29000fa5d04c0bb030710ca4065818f8feaa93d511e30e1ad51ccdf27163e1';
  
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
      headers: { 'Authorization': 'Bearer '+a },
      success: function(d){
        console.log(d);
        paint_items(d.channel.viewport_items, d.channel);
      }
  });
  
}