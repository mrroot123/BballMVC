
'use strict';

var alertDisplay = false;  // Display kdAlert for debugging
//alertDisplay = true;

function kdAlert(msg) {
   if (alertDisplay)
      alert(msg);
}
angular.module('app', []);
