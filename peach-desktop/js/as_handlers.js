function handler_for(event, data) {
   
  var s = "handler_"+event;
  console.log(s);
  console.log(data);
  
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

function handler_roboto_post_bookmark(activity) {

  paint_incoming_item(activity);
  
}

function handler_person_join_group(activity) {

  console.log(activity);
  
}

function handler_person_leave_group(activity) {

  console.log(activity);
  
}

function handler_roboto_join_group(activity) {

  console.log(activity);
  
}

function handler_roboto_leave_group(activity) {

  console.log(activity);
  
}