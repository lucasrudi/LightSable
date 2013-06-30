//this socket.io source should be found on the nodejs server so change this adress to wherever that is running
var serverHostname = location.hostname;
document.write("<script src=\"http://" + serverHostname + ":9999/socket.io/socket.io.js\"></script>");

window.onload = function () {
    tryFindSketch();
}

var send = function(s)
{
      var socket = io.connect('http://'+ serverHostname + ':9999'); //nodejs server address
      socket.emit("clientMsg",{txt:s});
}

function tryFindSketch () {
    var sketch = Processing.getInstanceById("lightsavergame"); //remember to change this name to whatever you processing app name is
    if ( sketch == undefined )
        return setTimeout(tryFindSketch, 200); // try again in 0.2 secs
    
    var socket = io.connect('http://'+ serverHostname + ':9999'); //nodejs server address
    socket.on("serverMsg",function(data){
    sketch.receive(data.txt);
    });
}
