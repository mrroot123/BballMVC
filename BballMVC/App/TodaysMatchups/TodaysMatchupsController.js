
'use strict';
angular.module('app').controller('TodaysMatchupsController', function ($scope, f, ajx, url) {
   //alert("TodaysMatchupsController");
   let TodaysMatchupsParms = { scope: $scope, f: f, LeagueName: oBballInfoDTO.LeagueName, ajx: ajx };

   $scope.PlayEntry = false;
   $scope.ShowPlaysOnly = false;
   $scope.Multi = false;
   $scope.showHistory = true;

   let ocOuts = [
      { name: "Pin", juice: "105" }
      , { name: "Chris", juice: "110" }
      , { name: "OTHER", juice: "110" }
   ];
   let outDDlist = [];
   ocOuts.forEach(function (item, index) {
      outDDlist.push({ value: item.juice, text: item.name });
   });

   let ocPlayers = [
      { name: "Keith", defaultAmount: 100 }
      , { name: "Bill", defaultAmount: 200 }
   ];
   let defaultAmount = 0;
   ocPlayers.forEach(function (item, index) {
      defaultAmount += item.defaultAmount;
   });

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
            f.MessageSuccess("Matchups Refreshed for " + f.Getmdy(oBballInfoDTO.GameDate));
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

   $scope.DisplayTimeAmPm = function (GameTime) {
      if (!GameTime)
         return;
      if (GameTime.indexOf(":") === -1)
         return GameTime;

      const arTime = GameTime.split(":");
      let hrs = parseInt(arTime[0]);
      let am = "";
      if (hrs < 12)
         am = " am";
      if (hrs > 12)
         hrs -= 12;
      return hrs + ":" + arTime[1] + am;
   };


   $scope.InitPlayEntry = function () {
      // 1)PlayLength	2)PlayType	3)Line	4)Out	5)Juice	6)Amount	7)Weight	8)Process
      let defaultJuice = -105;
      let defaultWeight = 1;
      let rowNum = 0;
      while (oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO.length > rowNum) {
         let play = $("#Play_" + rowNum).text().trim();
         if (play) {
            // set playtype
            $("#PlayType_" + rowNum).val(play);
            $("#Line_" + rowNum).val($("#TotalLine_" + rowNum).text());
            // set juice
            $("#Juice_" + rowNum).val($("#Out_" + rowNum).val());

            $("#Amount_" + rowNum).val(defaultAmount);
            $("#Weight_" + rowNum).val(defaultWeight);

         }
         rowNum++;
      }  // while

   }; // InitPlayEntry
   $scope.ProcessPlays = function () {
      let rowNum = 0;
      while (oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO.length > rowNum) {
         let play = $("#Play_" + rowNum).text().trim();
         if ($("#cbProcessPlay_" + rowNum).checked) {
            // Validate Data

            // build & insert row

            // set playtype
            $("#PlayType_" + rowNum).val(play);
            $("#Line_" + rowNum).val($("#TotalLine_" + rowNum).text());
            // set juice
            $("#Juice_" + rowNum).val($("#Out_" + rowNum).val());

            $("#Amount_" + rowNum).val(defaultAmount);
            $("#Weight_" + rowNum).val(defaultWeight);

            //ocTodaysPlaysDTO.push({
            //   GameDate: oBballInfoDTO.GameDate ,
            //   LeagueName: oBballInfoDTO.LeagueName,
            //   RotNum: $("#RotNum_" + rowNum).text().trim(),
            //   GameTime: $("#GameTime_" + rowNum).text().trim(),
            //   TeamAway: $("#TeamAway_" + rowNum).text().trim(),
            //   TeamHome: $("#TeamHome_" + rowNum).text().trim(),

            //   PlayLength: ,
            //   PlayType: ,
            //   Line: ,
            //   Info: ,
            //   PlayAmount: ,
            //   PlayWeight: ,
            //   Juice: ,
            //   Out: ,

            //});
         }
         rowNum++;
      }  // while

   }; // ProcessPlays
   function setJuice(play, rowNum) {

   }

});   // controller
