
'use strict';
angular.module('app').controller('todaysPlaysController', function ($rootScope, $scope, f, ajx, url) {
   //alert("TodaysPlaysController");
   let UrlRefreshTodaysPlays = "../../api/TodaysPlays/GetTodaysPlays";

   $scope.DisplayYesterdaysPlays = function () {
      $scope.GameDate = f.Yesterday();
      RefreshTodaysPlays();
   }
   $scope.RefreshTodaysPlays = function () {
      f.GreyScreen("screen");

      if ($scope.GameDate === undefined) {
         $scope.GameDate = new Date();
      }
      ajx.AjaxGet(UrlRefreshTodaysPlays, { GameDate: $scope.GameDate.toLocaleDateString() })   // Get TodaysPlays from server
         .then(data => {
            // See ajx.AjaxGet in HeaderController for same moves
            $scope.ctrWLamt = 0;
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

   $scope.applyClassPlayDirection = function (obj) {
      return obj.item.PlayDirection.toLowerCase();
   };
   //  ng-class="applyClassOvUnStatus(this)"
   $scope.applyClassOvUnStatus = function (obj) {
      if (obj.item.OvUnStatus.toLowerCase().indexOf("ov") >= 0) {
         return obj.item.PlayDirection.toLowerCase() === "over" ? "winning" : "losing";
      }
      if (obj.item.OvUnStatus.toLowerCase().indexOf("un") >= 0) {
         return obj.item.PlayDirection.toLowerCase() === "under" ? "winning" : "losing";
      }
      if (obj.item.OvUnStatus.toLowerCase().indexOf("win") >= 0) {
         return "winning";
      }
      if (obj.item.OvUnStatus.toLowerCase().indexOf("loss") >= 0) {
         return "losing";
      }
      return "";
   };
   
   function editData(value, ix, data) {
      if (data[ix].Score === 0) {
         data[ix].Score = "";
         data[ix].ScoreHome = "";
         data[ix].ScoreAway = "";
      }
      if (data[ix].OvUnStatus.substring(0, 3) === "Ov ") {
         let ar = data[ix].OvUnStatus.split(" ");
         $scope.ctrWLamt += ar[1];
      }
      if (data[ix].OvUnStatus.substring(0, 3) === "Un ") {
         let ar = data[ix].OvUnStatus.split(" ");
         $scope.ctrWLamt -= ar[1];
      }
   }  // editDate
});