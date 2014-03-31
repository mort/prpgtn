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
        window.peach.user = d.user
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
      headers: { 'Authorization': 'Bearer '+a },
      success: function(d){
        console.log(d);
        paint_items(d.channel.viewport_items, d.channel);
      }
  });
  
}