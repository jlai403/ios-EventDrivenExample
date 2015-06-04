var querystring = require('querystring');
var app = require('express')();
var server = require('http').Server(app);
server.listen(1337, function(){
  console.log('listening on :1337')
});

app.get('/', function(req,res){
  res.sendFile(__dirname + '/index.html');
});

var socketIO = require('socket.io')(server);

var clients = {}

function deleteClient(socketId) {
    for(var userId in clients) {
        if(clients.hasOwnProperty(userId) && clients[userId] == socketId) {
            delete clients[userId];
            break;
        }
    }
}

socketIO.on('connection', function(socket){
  var userId = socket.handshake.query.userId;
  console.log("a user connected: " + userId);
  clients[userId] = socket.id;

  socket.on('disconnect', function() {
    console.log("a user disconnected");
    deleteClient(socket.id);
    console.log("clients: " + Object.keys(clients));
  });

  socket.on('broadcast message', function(params) {
    var data = querystring.parse(params);
    console.log(data);
    socketIO.emit('message', data.message);
  });

  socket.on('private message', function(params){
    var data = querystring.parse(params);
    console.log(data);
    var destination = clients[data.userId];
    socketIO.to(destination).emit('message', data.message);
  });

});
