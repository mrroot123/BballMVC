
'use strict';

var alertDisplay = false;  // Display kdAlert for debugging
//alertDisplay = true; 
kdAlert("alertDisplay in app.module.js is on for Debugging");

function kdAlert(msg) {
   if (alertDisplay)
      alert(msg);
}
angular.module('app', []);
