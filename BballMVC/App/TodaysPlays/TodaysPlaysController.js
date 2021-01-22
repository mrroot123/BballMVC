
'use strict';
angular.module('app').controller('todaysPlaysController', function ($rootScope, $scope, f, ajx, url) {
   //alert("TodaysPlaysController");
   let UrlRefreshTodaysPlays = "../../api/TodaysPlays/GetTodaysPlays";

   $scope.RefreshTodaysPlays = function () {
      f.GreyScreen("screen");

      ajx.AjaxGet(UrlRefreshTodaysPlays)   // Get TodaysPlays from server
         .then(data => {
            // See ajx.AjaxGet in HeaderController for same moves
            data.forEach(editData);
            
            $scope.ocTodaysPlays = data;
            $scope.$apply();
            //            f.MessageSuccess("Matchups Refreshed for " + f.Getmdy($rootScope.oBballInfoDTO.GameDate));
            f.ShowScreen("screen");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            f.ShowScreen("screen");
         });
   }; // GetTodaysPlays

   function editData(value, ix, data) {
      if (data[ix].Score === 0) {
         data[ix].Score = "";
         data[ix].ScoreHome = "";
         data[ix].ScoreAway = "";
      }
   }
});