function build_channels_menu(channels, latest_updated_channel_id){
  
  // console.log(channels);
  
  var c = [];
  
  var s = $('<select id="channels_menu"></select>');
  
  _.each(channels, function(v,k,l){
    
    var o = $('<option value="'+v.id+'" peach_as_id="'+v.as_id+'">'+v.title+'</option>');
    
    if (v.id == latest_updated_channel_id){
      o.attr('selected','selected')
    }
    
    s.append(o);
    
    c.push({
      id: v.id,
      as_id: v.as_id,
      title: v.title
    });
    
  });
  
  if (localStorage.getItem('peach_channels') == null) {
    localStorage.setItem('peach_channels', JSON.stringify(c));
  }
  
  return s;
  
}


function build_item_buttons(item, channels) {
  
  var buttons = $('<div class="buttons"><p class="i_buttons"><a>[Keep]</a></p><p> Send to: <a>Twitter</a> | <a>Facebook</a> | <a>Email</a> | <a>Pocket</a> </p></div>');
   
  var em = build_emotes(item);   
  var fwd = build_fwd_menu(item, channels);
  var keep = build_keep_button(item);
  
  buttons.append(em);
  buttons.append(fwd);
  
  if (item.user != null) {
    var u = $('<p>'+item.user.display_name+'</p>');

    if (item.user.as_image != null) {
      var img = $('<img id="user_avatar">');
      img.attr('src', item.user.as_image.url);
      u.prepend(img);
    }

    buttons.append(u);
  }
  

  return buttons;
  
} 

function build_emotes(item) {
    
  var k = 'emotes:'+item.channel_as_id;  
  var emotes = JSON.parse(localStorage.getItem(k));
        
  var emotes_from_user = item.current_user_emotes;
  
  var em = $('<ul class="emotes"></ul>');
  
  _.each(emotes, function(e){
    
    //console.log(e);
    var emote_on = true;

    if (_.contains(emotes_from_user, e.id)) {
      var emote_on = false; 
    }

    var e_id = 'emote_'+item.id+'_'+e.id;
    var li = $('<li></li>');
    var a = $('<a id="'+e_id+'">'+e.content+'</a>');

    if (emote_on) {
      a.addClass('emote_on');
      a.on('click', _click_emote);
    }
    
    li.append(a);
    em.append(li);


  });


  
  return em;
          
}

function _urn_to_id(urn){

  var arr = urn.split(':');
  return arr[arr.length-1];
}


function build_fwd_menu(item){
  
  var fwd_from_user = item.current_user_forwardings;
  var form = $('<form></form>');  
  var s = $('<select class="fwd_menu"></select>');
  
  var channels = JSON.parse(localStorage.getItem('peach_channels'));
  
  _.each(channels, function(channel){
    
    
    if (!_.contains(fwd_from_user, parseInt(_urn_to_id(channel.as_id)))) {
        
      if (channel.as_id != item.channel_as_id) {
        
        var o = $('<option value="fwd_'+item.id+'_'+_urn_to_id(channel.as_id)+'" peach_as_id="'+channel.as_id+'">'+channel.title+'</option>');
        s.append(o);    
      
      }
    
    } 
      
    
    
  });
  
  var button = $('<button>fwd</button>');
  
  form.append(s);
  form.append(button);
  form.on('submit', _click_fwd);
  
  if (s.children('option').length < 1) {
    form = '';
  }
  
  return form;
}

function build_keep_button(item) {
  
}

function _build_item(v) {
  var link = v.link;
  
  var has_asset = false;

  var c = $("<article></article>");
  var p = $('<h3></h3>');
  
  if (link.og_title != null) {
    var a = $("<a target='_blank'>"+link.og_title+"</a>");
    a.attr('href', link.og_url);
    p.append(a);
  }
  
  c.append(p);
  

  if (link.image != undefined) {
    
    var has_asset = true;
    
    var img = $('<img>');
    img.attr('src', link.image.url);
    img.css('height', link.image.height);
    img.css('width', link.image.width);
    //c.append(img);
    c.css('background-image', 'url('+link.image.url+')');
    
    
    c.attr('peach_has_asset', 'true');
    c.attr('peach_asset_width', link.image.height);
    c.attr('peach_asset_height', link.image.width);
  } else {
    c.attr('peach_has_asset', 'false');
  }
  
  if (link.og_title == null && has_asset) {
     c.attr('peach_asset_only', 'true');
  }
  
  c.attr('peach_as_id', v.as_id);

  
  return c;
  
}

function _build_incoming_item(data) {
  
  return _build_item({
    user: data.content.actor,
    link: {
      og_title: data.content.object.displayName,
      og_url: data.content.object.url,
      image: data.content.object.image
    }
  });
 
}