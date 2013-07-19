var express = require('express');
var app = express();
var socket = require('socket.io');
var clients = [];

app.configure(function(){
  app.use(express.static(__dirname + '/'));
});
//nodejs server listens to msgs on port 8080
var server = app.listen(9999);
//io sockets would address to all the web-clients talking to this nodejs server
var io = socket.listen(server);

//using node-osc library: 'npm install node-osc'
//this will also install 'osc-min'
var osc = require('node-osc');
//listening to OSC msgs to pass on to the web via nodejs
var oscServer = new osc.Server(3334, '127.0.0.1');
//sending OSC msgs to a client
var oscClient = new osc.Client('127.0.0.1', 3333);

//some web-client connects
io.sockets.on('connection', function (socket) {
  console.log("connnect");
  //msg sent whenever someone connects
  socket.emit("serverMsg",{txt:"Connected to server"});
  var amoutOfClients = 0;
  if (clients.length) {
    amoutOfClients = clients.length;
  }
  clients[amoutOfClients] = 'd';
  console.log("clients" + clients);
  clientId = amoutOfClients + 1;

  socket.emit("receivePlayerId", {c:clientId});
    

  //some web-client disconnects
  socket.on('disconnect', function (socket) {
    console.log("disconnect");
  });

  //some web-client sents in a msg
  socket.on('playerPosition', function (data) {

    console.log("data------" , data);
    //pass the msg on to the oscClient
    var jsonString = JSON.stringify(data);
    var msg =  new osc.Message('/playerPosition')
    console.log("message ---- " , msg);
    msg.append(jsonString)
    oscClient.send(msg)
  });
  socket.on('playerId', function (socket) {
    console.log("playerId------" , socket);
    //pass the msg on to the oscClient
    
  });

  //received an osc msg
  oscServer.on("message", function (msg, rinfo) {
    console.log("Message:");
    console.log(msg);
    //pass the msg on to all of the web-clients
    //msg[1] stands for the first argument received which in this case should be a string
    socket.emit("serverMsg",{txt: msg[1]});
  });
});