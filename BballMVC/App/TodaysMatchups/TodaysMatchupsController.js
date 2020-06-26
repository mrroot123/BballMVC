
'use strict';
angular.module('app').controller('TodaysMatchupsController', function ($scope,  f, ajx) {
   //alert("TodaysMatchupsController");
   let TodaysMatchupsParms = {scope: $scope, f: f, LeagueName: oBballInfoDTO.LeagueName, ajx: ajx };

   $scope.Multi = false;
   $scope.showHistory = true;

   $scope.$on("populateTodaysMatchups", function (ev) {
      populateTodaysMatchups();
   });

   $scope.GetTodaysMatchups = function ($scope, f, ajx, url) {
      ajx.AjaxGet(UrlGetTodaysMatchups, { GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get TodaysMatchups from server
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocTodaysMatchups = data;
            populateTodaysMatchups();
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   }; // GetTodaysMatchups

   function populateTodaysMatchups() {
      $scope.ocTodaysMatchups = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO;
      $scope.TMparms = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];
      $scope.$apply();
   };


});   // controller
