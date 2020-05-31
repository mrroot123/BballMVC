
'use strict';
angular.module('app').controller('TodaysMatchupsController', function ($scope,  f, ajx) {
   //alert("TodaysMatchupsController");
   let TodaysMatchupsParms = {scope: $scope, f: f, LeagueName: LeagueName, ajx: ajx };

   $scope.Multi = true;
   $scope.showHistory = true;
   $scope.tutorial = [
            {TeamAway: "BOS", TeamHome: "ATL" },
            {TeamAway: "NO", TeamHome: "LAL" },
            {TeamAway: "NY", TeamHome: "MIA" }
   ];
   $scope.GetTodaysMatchups = function ($scope, f, ajx, url) {

      let refreshTodaysMatchups = function (ocTodaysMatchups) {
         $scope.ocTodaysMatchups = ocTodaysMatchups;
         $scope.TMparms = ocTodaysMatchups[0];
         $scope.$apply();
      };

      ajx.AjaxGet(UrlGetTodaysMatchups, { GameDate: GameDate, LeagueName: LeagueName })   // Get TodaysMatchups from server
         .then(data => {
            refreshTodaysMatchups(data);
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   }; // GetTodaysMatchups
   $scope.GetTodaysMatchups($scope, f, ajx);


});   // controller
