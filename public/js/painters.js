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
  
  var k = 'emotes:'+channel.as_id;

  if (localStorage.getItem(k) == null){ 
    localStorage.setItem(k, JSON.stringify(emotes));
  }
      
  var section = $('<section class="channel">');    
  section.attr('peach_as_id', channel.as_id);
  section.attr('id', 'channel_'+channel.id)
  var h = $('<h2>'+channel.title+'</h2>');      
  section.append(h);
        
  _.each(items,function(item,k,l){
          
    c = _build_item(item);
    c.append(build_item_buttons(item));
    c.append('<hr>')
    
    section.append(c);
        
   
  });
  
  if (window.peach.current_user.latest_updated_channel_id != channel.id) {
    section.css('display', 'none');
  }
  
  $('section#viewport').append(section);
    
}

function paint_incoming_item(activity){
  
  var c = _build_incoming_item(activity);  
  
  var item = {
     id: _urn_to_id(activity.content.object.id),
     channel_as_id: activity.content.target.id  
   };
   
  c.append(build_item_buttons(item));
  
  c.addClass('incoming_item');
  c.append('<hr>')
  
  var target_id = activity.content.target.id;
  $('section[peach_as_id="'+target_id+'"] h2').after(c);
  
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



