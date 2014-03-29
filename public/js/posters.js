function post_emote(item_id, emote_id){
 
    var url = ENDPOINT + '/api/v0/items/'+item_id+'/emotings';
    console.log(url);
    
    var data = {
      'emote_id': emote_id
    }
    
    console.log(data);
    
    $.ajax({
        url: url,
        type: 'POST',
        data: data,
        headers: { 'Authorization': 'Bearer '+a },
        success: function(d){
          console.log(d);
        }
    });
    
  
}