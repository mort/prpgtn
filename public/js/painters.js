function paint_user_data(user){
  
  // console.log(user);
  
  var div = $('<div>');
  
  var n = user.display_name+'.'+user.id;
  
  //var p = $('<p>'+n+'</p>');
  //div.append(p);
  
  if (user.as_image != undefined) {
    
    var img = $('<img>');
    img.attr('src', user.as_image.url);
    img.addClass('avatar');
    div.append(img);
  
  }
  
  $('section#canvas header').append(div);         
  
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
    _display_channel(cid);
  });

}

function _display_channel(cid) {
  localStorage.setItem('current_channel_id', cid);
  $('section.channel').fadeOut();
  $('section#channel_'+cid).fadeIn();     
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
    
    // console.log(item);      
    c = _build_item(item);
    c.append(build_item_buttons(item));
    //c.append('<hr>')
    
    section.append(c);
        
   
  });
  
  if (window.peach.current_user.latest_updated_channel_id != channel.id) {
    section.css('display', 'none');
  }
  
  $('section#viewport').append(section);
    
}

function paint_incoming_item(activity){
  
  var c = _build_incoming_item(activity);  
  
   
  c.append(build_item_buttons({
     id: _urn_to_id(activity.content.object.id),
     channel_as_id: activity.content.target.id  
   }));
  
  
  var target_id = activity.content.target.id;
  $('section[peach_as_id="'+target_id+'"] h2').after(c);
}

function paint_incoming_invite(activity){
  
  console.log('Painting incoming invite');   
  paint_in_current_channel(_build_incoming_invite(activity));
  
}


function paint_in_current_channel(content) {
  
  var target_id = _current_channel_id();

  console.log("Current_channel "+target_id);
  
  $('section[peach_as_id="urn:peach:channels:'+target_id+'"] h2').after(content);
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

function _current_channel_id() {
  return localStorage.getItem('current_channel_id')
}

