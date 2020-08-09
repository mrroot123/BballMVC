
'use strict';
angular.module('app').controller('TodaysMatchupsController', function ($scope,  f, ajx, url) {
   //alert("TodaysMatchupsController");
   let TodaysMatchupsParms = {scope: $scope, f: f, LeagueName: oBballInfoDTO.LeagueName, ajx: ajx };

   $scope.Multi = false;
   $scope.showHistory = true;

   $scope.$on("populateTodaysMatchups", function (ev) {
      populateTodaysMatchups();
   });

   //$scope.GetTodaysMatchups = function () { #kd delete
   //   $scope.LeagueColor = oBballInfoDTO.LeagueName === "NBA" ? "blue" : "red";
   //   ajx.AjaxGet(UrlGetTodaysMatchups, { GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get TodaysMatchups from server
   //      .then(data => {
   //         oBballInfoDTO.oBballDataDTO.ocTodaysMatchups = data;
   //         populateTodaysMatchups();
   //         $rootScope.$broadcast('populatePostGameAnalysis');
   //      })
   //      .catch(error => {
   //         f.DisplayErrorMessage(f.FormatResponse(error));
   //      });
   //}; // GetTodaysMatchups
   $scope.RefreshTodaysMatchups = function () {
      f.GreyScreen("screen");
      
      ajx.AjaxGet(url.UrlRefreshTodaysMatchups, { UserName: oBballInfoDTO.UserName, GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get TodaysMatchups from server
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = data;
            populateTodaysMatchups();
            f.MessageSuccess("Matchups Refreshed");
            f.ShowScreen("screen");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            f.ShowScreen("screen");
         });
   }; // GetTodaysMatchups

   function populateTodaysMatchups() {
      $scope.ocTodaysMatchups = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO;
      $scope.LeagueColor = oBballInfoDTO.LeagueName === "NBA" ? "blue" : "red";
      $scope.TMparms = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];
      $scope.$apply();
   };


});   // controller
