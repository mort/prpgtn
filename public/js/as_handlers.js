function handler_for(event, data) {
   
  var s = "handler_"+event;
  window[s](data);
  
}

function handler_person_post_comment(activity) {

  var u = window.peach.current_user;
      
  if (u.as_id != activity.content.actor.id) {
    
    var el = $('[peach_as_id="'+activity.content.inReplyTo+'"]');
    
    var r = '<p class="incoming_emoting" peach_as_id="'+activity.content.object.id+'">'+activity.content.actor.displayName+' says: '+activity.content.object.content+'</p>';

    window.setTimeout(function(){
      $('p[peach_as_id="'+activity.content.object.id+'"]').fadeOut();
    }, 6000);

    el.prepend(r);
    
    
    
  }
  
  
  
}

function handler_person_post_bookmark(activity) {

  paint_incoming_item(activity);
  
}