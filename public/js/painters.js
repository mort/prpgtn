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


function paint_channel_selector() {
  
  var user = window.peach.current_user;
  var s = build_channels_menu(user.channels, user.latest_updated_channel_id);
  
  $('section#canvas header').append(s);
  
  $('#channels_menu').on('change', function(e){
    var cid = $(this).val();
    $('section.channel').fadeOut();
    $('section#channel_'+cid).fadeIn();   
  });

}

function paint_channel_section(channel){
  
  var emotes = channel.emotes;
  var items = channel.viewport_items;  
      
  var section = $('<section class="channel">');    
  section.attr('peach_as_id', channel.as_id);
  section.attr('id', 'channel_'+channel.id)
  var h = $('<h2>'+channel.title+'</h2>');      
  section.append(h);
        
  _.each(items,function(item,k,l){
          
    c = _build_item(item);
    c.append(build_item_buttons(item, emotes));
    c.append('<hr>')
    
    section.append(c);
        
   
  });
  
  if (window.peach.current_user.latest_updated_channel_id != channel.id) {
    section.css('display', 'none');
  }
  
  $('section#viewport').append(section);
  
  $('a.emote_on').on('click', function(e){
    
    var id_arr = $(this).attr('id').split('_');
    var item_id = id_arr[1];
    var emote_id = id_arr[2];
    
    post_emote(item_id, emote_id);
    
    $(this).unbind('click').removeClass('emote_on');
    e.preventDefault();
    
  });
  
}

function paint_incoming_item(activity){
  
  var c = _build_incoming_item(activity);  
  console.log(activity);
  var target_id = activity.content.target.id;
  console.log("Appending to "+'section[peach_as_id="'+target_id+'"]');
  $('section[peach_as_id="'+target_id+'"]').prepend(c);
  
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
