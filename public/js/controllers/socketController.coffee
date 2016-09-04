                                                                                                                                                                            
function SocketController()
{
	var socket = io()

	socket.on('jq', function(q){
		
		for (var key in q) for (var sel in q[key])	$(key)[sel](q[key][sel])
		
	})
	
	// 	$.each(value, function(sel, target) $(key)[sel](value);

  // Whenever the server emits 'login', log the login message
  socket.on('login', function (data) {
    // Display the welcome message
    var message = 'Welcome to Socket.IO Chat – ';
  	$('body').overhang({
  		type: 'success',
  		message: message
		});
  });

  
  socket.on('data', function (data) {
      console.log('data', data);
  });

  socket.on('error', function (reason){
    console.error('Unable to connect Socket.IO', reason);
  });

  socket.on('connect', function (){
    console.info('successfully established a working and authorized connection');
  });
  return socket;
}
