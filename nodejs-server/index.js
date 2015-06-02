var app = require('express')();
var server = require('http').Server(app);
server.listen(1337, function(){
  console.log('listening on :1337')
});

app.get('/message', function(req,res){
  res.sendFile(__dirname + '/emitMessage.html');
});

var socketIO = require('socket.io')(server);

var users = new Array()

socketIO.on('connection', function(socket){
  console.log("a user connected");


  socket.on('add user', function(userId) {
    users[userId] = socket.id;
    console.log("users: " + userIds.toString());
  });

  socket.on('broadcast message', function(message) {
    console.log("socket: " + socket.id + " - " + message)
    socketIO.emit('message', message)
  });

  socket.on('private message', function(data){
    var destination = users[data.userId];
    socketIO.sockets.socket(destination).emit(data.message);
  });

});
