
'use strict';
angular.module('app').controller('todaysPlaysController', function ($rootScope, $scope, f, ajx, url) {
   //alert("TodaysPlaysController");
   let UrlRefreshTodaysPlays = "../../api/TodaysPlays/GetTodaysPlays";
   const containerName = "TodaysPlaysContainer";

   $scope.colWid = 5;
   $scope.DisplayYesterdaysPlays = function () {
      if ($scope.FromDate === undefined) {
         $scope.FromDate = f.Yesterday();
      } else {
         $scope.FromDate = f.AddDays($scope.FromDate, -1);
      }

      $scope.ToDate = $scope.FromDate;
      $scope.RefreshTodaysPlays();
   }
   $scope.DisplayLastWeeksPlays = function () {
      if ($scope.FromDate === undefined) {
         $scope.FromDate = new Date();
      }

      $scope.ToDate = f.setToSunday(f.AddDays($scope.FromDate, -7)); // ToDate = Last Sunday
      $scope.FromDate = f.AddDays($scope.ToDate, -6);
      $scope.RefreshTodaysPlays();
   }
   $scope.RefreshTodaysPlays = function () {
      if ($scope.FromDate === undefined) {
         $scope.FromDate = new Date();
         $scope.ToDate = new Date();
      } else if ($scope.ToDate === undefined) {
         $scope.ToDate = $scope.FromDate;
      } else if ($scope.FromDate > $scope.ToDate) {
         $scope.ToDate = $scope.FromDate;
      }

      let AjaxParms = {
         Url: UrlRefreshTodaysPlays
         , UrlData: { FromDate: $scope.FromDate.toLocaleDateString(), ToDate: $scope.ToDate.toLocaleDateString()}
         , containerName: containerName
         , ProcessFunction: processResults
      };
      f.GetAjax(AjaxParms, $scope, f);
   }; // GetTodaysPlays

   $scope.OLDRefreshTodaysPlays = function () {
      f.GreyScreen("screen");

      if ($scope.FromDate === undefined) {
         $scope.FromDate = new Date();
         $scope.ToDate = new Date();
      } else if ($scope.ToDate === undefined) {
         $scope.ToDate = $scope.FromDate;
      } else if ($scope.FromDate > $scope.ToDate) {
         $scope.ToDate = $scope.FromDate;
      }

      let ajaxPromise =
         ajx.AjaxGet(UrlRefreshTodaysPlays
            , { FromDate: $scope.FromDate.toLocaleDateString(), ToDate: $scope.ToDate.toLocaleDateString() }
         )   // Get TodaysPlays from server
            .then(data => {
               // See ajx.AjaxGet in HeaderController for same moves
               processResults(data);

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

   function processResults(data) {
      let arTodaysPlays = data.Payload;
      $scope.ctrWins = 0;
      $scope.ctrLosses = 0;
      let arLeagues = [];

      $scope.savLeagueName = "";
      $scope.savGameDate = "1/1/2000";
      $scope.SingleDate = true;
      arTodaysPlays.forEach(editData);

      $scope.SingleLeagueName = arLeagues.length === 1 ? arLeagues[0] : "";

      $scope.ocTodaysPlays = arTodaysPlays;
      return;

      function editData(value, ix, arTodaysPlays) {
         if (arLeagues.length === 0 || !arLeagues.includes(value.LeagueName)) {
            var x = value.LeagueName;
            arLeagues.push(x);      //value.LeagueName);
         }

         if ($scope.savLeagueName != value.LeagueName) {
            $scope.savLeagueName = value.LeagueName;
         } else {
            value.LeagueName = "";
         }
         if ($scope.savGameDate != value.GameDate) {
            if ($scope.savGameDate !== "1/1/2000") {
               $scope.SingleDate = false;
            }
            $scope.savGameDate = value.GameDate;
         } else {
            value.GameDate = "";
         }
         if (value.Result === 1) {
            $scope.ctrWins++;
         } else if (value.Result === -1) {
            $scope.ctrLosses++;
         }



         if (value.Score === 0) {
            value.Score = "";
            value.ScoreHome = "";
            value.ScoreAway = "";
         }
         if (value.OvUnStatus.substring(0, 3) === "Ov ") {
            let ar = value.OvUnStatus.split(" ");
         }
         if (value.OvUnStatus.substring(0, 3) === "Un ") {
            let ar = value.OvUnStatus.split(" ");
         }
      }  // editDate
   }

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
   

});