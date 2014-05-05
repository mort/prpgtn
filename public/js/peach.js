$(function(){
  
  var Peach = {
    
    run: function(access_token){
      
      window.a = access_token;
      
      $('#login').hide();
      $('#app').show();
    
      get_state();
      setInterval(get_new_activities, 5000);
      //window.peach.listen();
      
    }
  
    
  }
  
  window.peach = Peach;
  var a = localStorage.getItem('access_token');

  if (a) {
    window.peach.run(a);          
  } else{
    
    $('#sbmt').on('click', function(e){
      
      var u = $('#email').val();
      var p = $('#password').val();
      
      e.preventDefault();
      get_credentials(u,p);
      return false;
      
    });
    
  }
});





