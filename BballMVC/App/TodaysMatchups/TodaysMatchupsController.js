
'use strict';
angular.module('app').controller('TodaysMatchupsController', function ($scope,  f, ajx, url) {
   //alert("TodaysMatchupsController");
   let TodaysMatchupsParms = {scope: $scope, f: f, LeagueName: oBballInfoDTO.LeagueName, ajx: ajx };

   $scope.Multi = false;
   $scope.showHistory = true;

   $scope.$on("populateTodaysMatchups", function (ev) {
      populateTodaysMatchups();
   });

   $scope.GetTodaysMatchups = function () {
      ajx.AjaxGet(UrlGetTodaysMatchups, { GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get TodaysMatchups from server
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocTodaysMatchups = data;
            populateTodaysMatchups();
            $rootScope.$broadcast('populatePostGameAnalysis');
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   }; // GetTodaysMatchups
   $scope.RefreshTodaysMatchups = function () {
      ajx.AjaxGet(url.UrlRefreshTodaysMatchups, { UserName: oBballInfoDTO.UserName, GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get TodaysMatchups from server
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = data;
            populateTodaysMatchups();
            f.MessageSuccess("Matchups Refreshed");
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   }; // GetTodaysMatchups
   $scope.LoadBoxScores = function () {
      ajx.AjaxGet(url.UrlLoadBoxScores, { GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get TodaysMatchups from server
         .then(data => {
            f.MessageSuccess("BoxScores and Rotation Updated");
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   }; // GetTodaysMatchups

   function populateTodaysMatchups() {
      $scope.ocTodaysMatchups = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO;
      //$scope.TMparms = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];
      $scope.$apply();
   };


});   // controller
