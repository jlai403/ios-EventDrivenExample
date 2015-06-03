var app = require('express')();
var server = require('http').Server(app);
server.listen(1337, function(){
  console.log('listening on :1337')
});

app.get('/message', function(req,res){
  res.sendFile(__dirname + '/message.html');
});

var socketIO = require('socket.io')(server);

var clients = new Array()

socketIO.on('connection', function(socket){
  var userId = socket.handshake.query.userId
  console.log("a user connected: " + userId);
  clients[userId] = socket.id

  socket.on('disconnect', function() {
    console.log("a user disconnected");
    delete clients[clients.indexOf(socket.id)]
    console.log("number of clients: " + clients.length);
  });

  socket.on('broadcast message', function(message) {
    console.log("socket: " + socket.id + " - " + message)
    socketIO.emit('message', message)
  });

  socket.on('private message', function(data){
    var destination = clients[data.userId];
    socketIO.sockets.socket(destination).emit(data.message);
  });

});
