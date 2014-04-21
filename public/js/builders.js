function build_channels_menu(channels, latest_updated_channel_id){
  
  // console.log(channels);
  
  var s = $('<select id="channels_menu"></select>');
  
  _.each(channels, function(v,k,l){
    
    var o = $('<option value="'+v.id+'" peach_as_id="'+v.as_id+'">'+v.title+'</option>');
    
    if (v.id == latest_updated_channel_id){
      o.attr('selected','selected')
    }
    
    s.append(o);
    
  });
  
  return s;
  
}


function build_item_buttons(item, emotes, channels) {
  
   var buttons = $('<div><p class="i_buttons"><a>[Keep]</a></p><p> Send to: <a>Twitter</a> | <a>Facebook</a> | <a>Email</a> | <a>Pocket</a> </p></div>');
   
  var em = build_emotes(item, emotes);   
  var fwd = build_fwd_menu(item, channels);
  var keep = build_keep_button(item);
  
  
  buttons.append(em);
  return buttons;
  
} 

function build_emotes(item, emotes) {
  

  var emotes_from_user = item.current_user_emotes;
  
  var em = $('<ul class="emotes"></ul>');
  
  _.each(emotes, function(e){
    //console.log(e);

    // Let's check if the user has already used this emote

    var emote_on = true;

    if (_.contains(emotes_from_user, e.id)) {
      var emote_on = false; 
    }

    var e_id = 'emote_'+item.id+'_'+e.id;
    var li = $('<li></li>');
    var a = $('<a id="'+e_id+'">'+e.content+'</a>');

    if (emote_on) {
      a.addClass('emote_on');
    }

    li.append(a);
    em.append(li);


  });

  return em;
          
}


function build_fwd_menu(item, channels){
  
}

function build_keep_button(item) {
  
}

function _build_item(v) {
  
  console.log(v);
  
  var link = v.link;

  var c = $("<article></article>");
  var p = $('<h3></h3>');
  var a = $("<a>"+link.og_title+"</a>");
  a.attr('href', link.og_url);

  p.append(a);
  c.append(p);
  c.attr('peach_as_id', v.as_id);

  
  return c;
  
}

function _build_incoming_item(data) {
  
  content = data.content;
  //console.log(content);
  
  var c = $("<div></div>");
  var p = $('<p></p>');
  var a = $("<a>New: "+content.object.displayName+"</a>");
  a.attr('href', content.object.url);

  p.append(a);
  c.append(p);
  
  return c;
  
  
}