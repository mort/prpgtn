function post_emote(item_id, emote_id){
 
    var url = ENDPOINT + '/api/v0/items/'+item_id+'/emotings';
    
    var data = {
      'emoting[emote_id]': emote_id
    }    
    
        
    $.ajax({
        url: url,
        type: 'POST',
        data: data,
        headers: { 'Authorization': 'Bearer '+a },
        success: function(d){
          // console.log(d);
        }, 
        error: function(d){
          console.log("Error!");
          console.log(d);
        }
    });
    
  
}

function post_fwd(item_id, channel_id){
 
    var url = ENDPOINT + '/api/v0/items/'+item_id+'/forwardings';
    
    var data = {
      'forwarding[channel_id]': channel_id
    }    
            
    $.ajax({
        url: url,
        type: 'POST',
        data: data,
        headers: { 'Authorization': 'Bearer '+a },
        success: function(d){
          // console.log(d);
        }, 
        error: function(d){
          console.log("Error!");
          console.log(d);
        }
    });
    
  
}