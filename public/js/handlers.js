function _click_emote(e){
    
    
  var id_arr = $(this).attr('id').split('_');
  var item_id = id_arr[1];
  var emote_id = id_arr[2];

  post_emote(item_id, emote_id);

  $(this).unbind('click').removeClass('emote_on');
  e.preventDefault();
  return false;
}


function _click_fwd(e){
  //         
  // console.log($(this).find('option:selected').val());
  // return false;        
                
  var opt = $(this).find('option:selected');              
  var id_arr = opt.val().split('_');
  var item_id = id_arr[1];
  var channel_id = id_arr[2];

  post_fwd(item_id, channel_id);

  
  opt.remove();
  
  if (($(this).find('option').length < 1)) {
    $(this).fadeOut();
  }

  e.preventDefault();
  return false;
  
}
