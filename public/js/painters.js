




function paint_user_data(user){
  
  var n = user.display_name+'.'+user.id;
  
  var p = $('<p>'+n+'</p>');
  $('section#canvas header').append(p);         
    
  
}



function paint_login() {
  
  $('#sbmt').unbind('click').on('click', function(){
  
    var e = $('#email').val();
    var p = $('#password').val();        
    grant_credentials(e,p);
  
    return false;
  
  
  });
  
  $('#login').show();
  $('#app').hide();
}




function paint_channel_items(s) {
  
  $('section#canvas header').append(s);
  
  $('#channels_menu').on('change', function(e){
    get_channel_items($('#channels_menu').val());
  });

  get_channel_items($('#channels_menu').val());

}

function paint_items(items, channel){
  
  var emotes = channel.emotes;
  
  $('#canvas #viewport').html('');
  
  _.each(items,function(v,k,l){
    
    if (v.link != null) {
      
      var link = v.link;
    
      var c = $("<div></div>");
      var p = $('<p></p>');
      var p2 = $('<p>'+link.og_description+'</p>');
      var a = $("<a>"+link.og_title+"</a>");
      a.attr('href', link.og_url);
    
      p.append(a);
      c.append(p);
      c.append(p2);
      c.append(build_item_buttons(v, emotes));
      
      $('#canvas #viewport').append(c);
      
  }
    
  });
  
  $('a.emote_on').on('click', function(e){
    
    var id_arr = $(this).attr('id').split('_');
    var item_id = id_arr[1];
    var emote_id = id_arr[2];
    
    post_emote(item_id, emote_id);
    
    $(this).unbind('click').removeClass('emote_on');
    e.preventDefault();
    
  });
}



function paint_login() {
  
  $('#sbmt').unbind('click').on('click', function(){
  
    var e = $('#email').val();
    var p = $('#password').val();        
    grant_credentials(e,p);
  
    return false;
  
  
  });
  
  $('#login').show();
  $('#app').hide();
}
