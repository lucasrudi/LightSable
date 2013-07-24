function GeoPosition(){
  position = {
    positioning : new Array(),
    getValues    : function() {return this;},
    getLatitude  : function() {return this.latitude;},
    getLongitude : function() {return this.longitude;},
    getAltitude : function() {return this.altitude;}
  };
  
  position.latitude = 0;
  position.longitude = 0;
  position.altitude = 0;
  
  if (navigator.geolocation) {
    var geo_options = {
        enableHighAccuracy: true, 
        maximumAge        : 0,
        timeout           : 100
    };
    navigator.geolocation.watchPosition(showPosition, geo_error, geo_options);
  }
  function showPosition(currentPosition) {
      position.latitude = currentPosition.coords.latitude;
      position.longitude = currentPosition.coords.longitude;
      position.altitude = currentPosition.coords.altitude;
  }
  function geo_error() {
    alert("Sorry, no position available.");
   }  
  return position;
}
