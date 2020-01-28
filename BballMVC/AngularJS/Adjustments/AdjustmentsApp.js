(function () {
   'use strict';
  // alert("app.js entered");
   var app = angular.module('app', []);
  // alert("start controller");
   //module('app')
   app.controller('appController',
      function ($scope) {
         $scope.apptitle = "Adjustment";
         alert("function - " + $scope.apptitle);
      }
   );

   function controller($scope) {
      /* jshint validthis:true */
     // alert("inside controller");
      var vm = this;
      debugger;
      vm.title = 'controller';
      $scope.title = "my App";
      activate();

       function activate() {
          //Lance added another comment line
         // Ajax call to controller
         // Get rows from ajax
         // build tr html for each adjustment row
         // Append tr to table to display using jQuery function
          //Line added to test git.
         // added by keith2
      }
   }
})();