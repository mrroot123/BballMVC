'use strict';

var alertDisplay = false;  // Display kdAlert for debugging
//alertDisplay = true; 
kdAlert("alertDisplay in todaysPlays.js is on for Debugging");

function kdAlert(msg) {
   if (alertDisplay)
      alert(msg);
}
angular.module('app', []);

