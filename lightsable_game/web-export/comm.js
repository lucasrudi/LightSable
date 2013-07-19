//this socket.io source should be found on the nodejs server so change this adress to wherever that is running
var serverHostname = location.hostname;
document.write("<script src=\"http://" + serverHostname + ":9999/socket.io/socket.io.js\"></script>");

window.onload = function () {
    tryFindSketch();
}

var send = function(playerId, x, y, z)
{
      var socket = io.connect('http://'+ serverHostname + ':9999'); //nodejs server address
      socket.emit("playerPosition",{'playerId': playerId, 'posX': x, 'posY': y, 'posZ': z});
}

var getplayerid = function(playerId)
{
      var socket = io.connect('http://'+ serverHostname + ':9999'); //nodejs server address
      socket.emit("playerId", playerId);
}

function tryFindSketch () {
    var sketch = Processing.getInstanceById("lightsablegame"); 
    if ( sketch == undefined )
        return setTimeout(tryFindSketch, 200); // try again in 0.2 secs
    var socket = io.connect('http://'+ serverHostname + ':9999'); //nodejs server address
    socket.on("serverMsg",function(data){
      sketch.receive(data.txt);
    });
    socket.on("receivePlayerId",function(data){
      console.log(data);
      sketch.setPlayerId(data.c);
    });
}
