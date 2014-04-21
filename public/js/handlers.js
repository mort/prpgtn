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
                
  var id_arr = $(this).find('option:selected').val().split('_');
  var item_id = id_arr[1];
  var channel_id = id_arr[2];

  post_fwd(item_id, channel_id);

  $(this).unbind('click');
  e.preventDefault();
  return false;
  
}
