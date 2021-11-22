
'use strict';
angular.module('app').controller('TodaysMatchupsController', function ($rootScope, $scope, f, ajx, url) {
   //alert("TodaysMatchupsController");
   let TodaysMatchupsParms = { scope: $scope, f: f, LeagueName: $rootScope.oBballInfoDTO.LeagueName, ajx: ajx };
   let localGameDate = $rootScope.oBballInfoDTO.GameDate;

   setCheckBoxes();
   $rootScope.RefreshTodaysMatchupsState = true;

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
      //   , { name: "Bill", defaultAmount: 200 }
   ];
   let defaultAmount = 0;
   ocPlayers.forEach(function (item, index) {
      defaultAmount += item.defaultAmount;
   });

   // When ADJs do Updates, this makes MUPs refresh & on App Init so it Refreshes the first time
   $scope.$on("eventSetRefreshTodaysMatchups", function (ev) {
      $rootScope.RefreshTodaysMatchupsState = true;
   });


   // When Todays Matchups is clicked in Accordion it will refresh
   $scope.$on("eventRefreshTodaysMatchups", function (ev) {
      if ($rootScope.RefreshTodaysMatchupsState && isProductionRelease()) {
         $scope.RefreshTodaysMatchups(true);
      }
   });
   function isProductionRelease() {
      return $("#release").html().toLowerCase().indexOf("test") < 0;
   }
   $scope.OpenTMunAdjTotalsModal = function (arObj) {
      $rootScope.$broadcast('eventOpenTMunAdjTotalsModal', arObj);
   };

   /*
     Make 3 Entry Points
     1) Refresh TMs click  (true)      UrlRefreshTodaysMatchups
     2) Select GameDate    ()          UrlGetPastMatchups
     3) Yesterday, Today, Tomorrow Click  (false, newDateLiteral)
   */
   $scope.RefreshTodaysMatchups = function () {
      getTodaysMatchupsData("RefreshTodaysMatchups");
//      getTodaysMatchups(url.UrlRefreshTodaysMatchups);
   };
   /*
    *    $scope.SelectGameDate = function () {
      let URL = $rootScope.oBballInfoDTO.GameDate < f.Today() ? url.UrlGetPastMatchups : url.UrlRefreshTodaysMatchups;
      checkForSameDate($rootScope.oBballInfoDTO.GameDate, URL);
   };
   $scope.GetYesterday = function () {
      let newDate = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 1);
      checkForSameDate(newDate, url.UrlGetPastMatchups);
   };
   $scope.GetByDayButton = function (dateOffset) {
      let newDate = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() + dateOffset);
      checkForSameDate(newDate, url.UrlRefreshTodaysMatchups);
   };

   function checkForSameDate(newDate, URL){
      if (newDate.toDateString() === localGameDate.toDateString()) {
         alert(localGameDate.toLocaleDateString() + " is already Selected");
         return;
      }
      $rootScope.oBballInfoDTO.GameDate = newDate;
      getTodaysMatchups(URL);
   };
   */
   $scope.SelectGameDate = function () {
      let CollectionType = $rootScope.oBballInfoDTO.GameDate < f.Today() ? "GetPastMatchups" : "RefreshTodaysMatchups";
      checkForSameDate($rootScope.oBballInfoDTO.GameDate, CollectionType);
   };
   $scope.GetYesterday = function () {
      let newDate = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 1);
      checkForSameDate(newDate, "GetPastMatchups");
   };
   $scope.GetByDayButton = function (dateOffset) {
      let newDate = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() + dateOffset);
      checkForSameDate(newDate, "RefreshTodaysMatchups");
   };

   function checkForSameDate(newDate, CollectionType){
      if (newDate.toDateString() === localGameDate.toDateString()) {
         alert(localGameDate.toLocaleDateString() + " is already Selected");
         return;
      }
      $rootScope.oBballInfoDTO.GameDate = newDate;
      getTodaysMatchupsData(CollectionType);
   };

   function getTodaysMatchupsData(CollectionType) {
      localGameDate = $rootScope.oBballInfoDTO.GameDate;
      setCheckBoxes();

      // Data/UrlRefreshTodaysMatchups - exec uspCalcTodaysMatchups
      // Data/UrlGetPastMatchups
      // GetTodaysMatchups
      // GetDailySummaryDTO
      // GetUserLeagueParmsDTO
      ajx.AjaxGet(url.UrlGetBballData, {
         UserName: $rootScope.oBballInfoDTO.UserName
         , GameDate: localGameDate.toLocaleDateString()
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         , CollectionType: CollectionType
      })   // Get TodaysMatchups from server
         .then(data => {
            // See ajx.AjaxGet in HeaderController for same moves
            $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = data.ocTodaysMatchupsDTO;
            $rootScope.oBballInfoDTO.oBballDataDTO.oDailySummaryDTO = data.oDailySummaryDTO;
            //$rootScope.oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO = data.oUserLeagueParmsDTO;

            $rootScope.oBballInfoDTO.oBballDataDTO = oBballInfoDTO.oBballDataDTO;
            f.PopulateObjectFromJson($rootScope.oBballInfoDTO.oBballDataDTO);

            populateTodaysMatchups();

            f.GreyScreen(containerName);
            f.ShowScreen(containerName);
            let msg;
            if (data.ocTodaysMatchupsDTO.length === 0) {
               msg = "No Games Scheduled for ";
            }
            else if (localGameDate < f.Today()) {
               msg = "Matchups Retrieved for ";
            }
            else {
               msg = "Matchups Refreshed for ";
            }
            f.MessageSuccess(msg + f.Getmdy($rootScope.oBballInfoDTO.GameDate));
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   } // GetTodaysMatchups

   function getTodaysMatchups(URL) {
      localGameDate = $rootScope.oBballInfoDTO.GameDate;
      setCheckBoxes();
     
      // Data/UrlRefreshTodaysMatchups - exec uspCalcTodaysMatchups
      // Data/UrlGetPastMatchups
      // GetTodaysMatchups
      // GetDailySummaryDTO
      // GetUserLeagueParmsDTO
      ajx.AjaxGet(URL, {
           UserName:   $rootScope.oBballInfoDTO.UserName
         , GameDate:   localGameDate.toLocaleDateString()
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         })   // Get TodaysMatchups from server
         .then(data => {
            // See ajx.AjaxGet in HeaderController for same moves
            $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = data.ocTodaysMatchupsDTO;
            $rootScope.oBballInfoDTO.oBballDataDTO.oDailySummaryDTO = data.oDailySummaryDTO;
            //$rootScope.oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO = data.oUserLeagueParmsDTO;

            $rootScope.oBballInfoDTO.oBballDataDTO = oBballInfoDTO.oBballDataDTO;
            f.PopulateObjectFromJson($rootScope.oBballInfoDTO.oBballDataDTO);

            populateTodaysMatchups();

            f.GreyScreen(containerName);
            f.ShowScreen(containerName);
            let msg;
            if (data.ocTodaysMatchupsDTO.length === 0) {
               msg = "No Games Scheduled for ";
            }
            else if (localGameDate < f.Today()){
               msg = "Matchups Retrieved for ";
            }
            else {
               msg = "Matchups Refreshed for ";
            }
            f.MessageSuccess(msg + f.Getmdy($rootScope.oBballInfoDTO.GameDate));
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   } // GetTodaysMatchups

   function setCheckBoxes(){
      $rootScope.RefreshTodaysMatchupsState = false;
      $scope.PlayEntry = false;
      $scope.ShowPlaysOnly = false;
      $scope.Multi = true;
      $scope.ShowDailySummary = true;
      $scope.ShowCanceledGames = true;
      $scope.ShowHistory = true;
   }

   $scope.GetAdjustmentsByTeam = function (LeagueName, GameDate, Team) {
      // get adjs
      ajx.AjaxGet(url.UrlGetAdjustmentsByTeam, { GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName, Team })   // Get TodaysMatchups from server
         .then(data => {
            // See ajx.AjaxGet in HeaderController for same moves
            var x = data.ocAdjustmentsDTO;

            populateTodaysMatchups();
            f.ShowScreen("screen");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            f.ShowScreen("screen");
         });
      // pop modal
      // show it
   };
   function populateTodaysMatchups() {
      let ctrOurTotalLine = 0;
      let totOurTotalLine = 0;
      let ctrTotalLine = 0;
      let totTotalLine = 0;
      let ctrOpenTotalLine = 0;
      let totOpenTotalLine = 0;

      $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO.forEach(function (item, index) {
         if (item.OurTotalLine) {
            ctrOurTotalLine++;
            totOurTotalLine += item.OurTotalLine;
         }
         if (item.TotalLine) {
            ctrTotalLine++;
            totTotalLine += item.TotalLine;
         }
         if (item.OpenTotalLine) {
            ctrOpenTotalLine++;
            totOpenTotalLine += item.OpenTotalLine;
         }
      });
      $scope.avgOurTotalLine = totOurTotalLine / ctrOurTotalLine;
      $scope.avgTotalLine = totTotalLine / ctrTotalLine;
      $scope.avgOpenTotalLine = totOpenTotalLine / ctrOpenTotalLine;

      $scope.GameDate = $rootScope.oBballInfoDTO.GameDate;

      $scope.ocTodaysMatchups = $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO;
      $scope.LeagueColor = $rootScope.oBballInfoDTO.oBballDataDTO.oLeagueDTO.LeagueColor;
      $scope.TMparms =     $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];

      $scope.$apply();
      //    $scope.InitPlayEntry();
   }

   const ssRotNum = "RotNum";
   const ssGameTime = "GameTime";
   let sortSeq = ssRotNum;
   const containerName = "TodaysMatchupsContainer";
   $scope.toggleSort = function () {
      if (sortSeq === ssRotNum) {
         sortSeq = ssGameTime;

      } else {
         sortSeq = ssRotNum;
      }
      sortTodaysMatchups(sortSeq, $scope.ocTodaysMatchups);
    //  $scope.$apply();
   };

   function sortTodaysMatchups(sortBy, obj) {
      // https://www.javascripttutorial.net/array/javascript-sort-an-array-of-objects/
      // this site has links at bottom to protoype & 
      /*
       * javaScript Constructor Prototype
      JavaScript Constructor Function
      JavaScript Class Expressions
      JavaScript Static Method
      */
      if (sortBy === ssRotNum) {
         obj.sort((a, b) => {
            return a.RotNum - b.RotNum;
         });
      } else {
         obj.sort((a, b) => {
            let fa = a.GameTime.toLowerCase() === "canceled" ? "" : a.GameTime.toLowerCase()
              , fb = b.GameTime.toLowerCase() === "canceled" ? "" : b.GameTime.toLowerCase();
            
            if (fa < fb) {
               return -1;
            }
            if (fa > fb) {
               return 1;
            }
            return 0;
         });
      }

      // sort by date
      //employees.sort((a, b) => {
      //   let da = new Date(a.joinedDate),
      //      db = new Date(b.joinedDate);
      //   return da - db;
      //});

   }


   // Used in html - visable in this scope
   $scope.Getmdy = function (GameDate) {
      return f.Getmdy(GameDate);
   };
   //$scope.GameDateChange = function (GameDate) {
   //   alert("GameDateChange");
   //   // $rootScope.oBballInfoDTO.GameDate = GameDate;
   //};
   // <tr ng-repeat="item in ocTodaysMatchups" 
   // ng - hide=" (ShowPlaysOnly && '{{item.Play.trim()}}' === '') ||  " >
   $scope.HideMatchupRow = function (obj) {
      if (obj.item.Canceled && !$scope.ShowCanceledGames)
         return true;
      if (obj.item.Play === null)
         obj.item.Play = "";
      if ($scope.ShowPlaysOnly && (obj.item.Play === null || obj.item.Play.trim() === '') )
         return true;

      return false;
   };
   $scope.DisplayTimeAmPm = function (obj) {
      if (obj.item.Canceled) {
         $("#RotNumGameTime_" + obj.$index).addClass("under");
         $("#GameTime_" + obj.$index).addClass("under");
         return "Canceled";
      }
      let GameTime = obj.item.GameTime;
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
      $scope.condensed = $scope.PlayEntry;   // flip to condensed for play entry
      // 1)PlayLength	2)PlayType	3)Line	4)Out	5)Juice	6)Amount	7)Weight	8)Process
      let defaultJuice = -105;
      let defaultWeight = 1;
      let rowNum = 0;
      while ($rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO.length > rowNum) {
         let play = $("#Play_" + rowNum).text().trim();
         if (play) {
            // set playtype
            document.getElementById('PlayDirection_'+rowNum ).value = play;

            $("#Line_" + rowNum).val($("#TotalLine_" + rowNum).text());
            // set juice
            $("#Juice_" + rowNum).val(defaultJuice);

            $("#PlayAmount_" + rowNum).val(defaultAmount);
            $("#PlayWeight_" + rowNum).val(defaultWeight);

         }
         rowNum++;
      }  // while

   }; // InitPlayEntry
   $scope.PlayAmountBlur = function (obj) {
      var rowNum = obj.$index;
      var x = $("#PlayAmount_" + rowNum).val() / defaultAmount;
      $("#PlayWeight_" + rowNum).val(x);
   };
   $scope.PlayWeightBlur = function (obj) {
      var rowNum = obj.$index;
      var x = $("#PlayWeight_" + rowNum).val() * defaultAmount;
      $("#PlayAmount_" + rowNum).val(x);
   };
   // 1)PlayLength	2)PlayType	3)Line	4)Out	5)Juice	6)Amount	7)Weight	8)cbProcessPlay
   $scope.ProcessPlays = function () {
      let ocTodaysPlaysDTO = [];
      let thisSunday =  setToSunday(new Date($rootScope.oBballInfoDTO.GameDate));
      
      let rowNum = 0;
      while ($rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO.length > rowNum) {
         let play = $("#Play_" + rowNum).text().trim();  // Over / Under
         if (document.getElementById("cbProcessPlay_" + rowNum).checked) {
            let oTodaysPlaysDTO = {};
            // Validate Data

            // build & insert row

            oTodaysPlaysDTO.CreateUser = $rootScope.oBballInfoDTO.UserName;
            oTodaysPlaysDTO.CreateDate = new Date().toLocaleString();
         //   oTodaysPlaysDTO.GameDate = $scope.Getmdy($rootScope.oBballInfoDTO.GameDate);
            oTodaysPlaysDTO.GameDate = $rootScope.oBballInfoDTO.GameDate.toLocaleDateString();
            oTodaysPlaysDTO.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
            oTodaysPlaysDTO.RotNum = $("#RotNum_" + rowNum).text();
            oTodaysPlaysDTO.GameTime = $("#GameTime_" + rowNum).text();
            oTodaysPlaysDTO.TeamAway = $("#TeamAway_" + rowNum).text();
            oTodaysPlaysDTO.TeamHome = $("#TeamHome_" + rowNum).text();
            oTodaysPlaysDTO.WeekEndDate = thisSunday;
            // IP Cols 1-8
            // 1)PlayLength 2)PlayDirection (un/ov) 3)Line 4)Out   5)Juice 6)PlayAmount 7)PlayWeight 8)cbProcessPlay
            oTodaysPlaysDTO.PlayLength = $("#PlayLength_" + rowNum).val();       // Game, H1-h2, Q1-Q4
            oTodaysPlaysDTO.PlayDirection = $("#PlayDirection_" + rowNum).val(); // Un/Ov, Side
            oTodaysPlaysDTO.Line = $("#Line_" + rowNum).val();
            oTodaysPlaysDTO.Out = $("#Out_" + rowNum).val();

            oTodaysPlaysDTO.Juice = parseInt($("#Juice_" + rowNum).val()) / 100;
            oTodaysPlaysDTO.PlayAmount = $("#PlayAmount_" + rowNum).val();
            oTodaysPlaysDTO.PlayWeight = $("#PlayWeight_" + rowNum).val();

            oTodaysPlaysDTO.Author = $rootScope.oBballInfoDTO.UserName;
            oTodaysPlaysDTO.Info = "";

            ocTodaysPlaysDTO.push(oTodaysPlaysDTO); // Add oTodaysPlaysDTO object to ocTodaysPlaysDTO collection
         }
         rowNum++;
      }  // while
      if (ocTodaysPlaysDTO.length === 0) {
         f.MessageInformational("No Plays Selected");
         return;
      }

      ajx.AjaxPost(url.UrlPostObject + "?CollectionType=ProcessPlays", ocTodaysPlaysDTO)     // , "text/plain")
         .then(data => {
            f.MessageSuccess(ocTodaysPlaysDTO.length + " Plays Processed");
            resetAfterPlays();
         })
         .catch(error => {
            f.DisplayErrorMessage("Process Plays Error/n" + f.FormatResponse(error));
         });


   }; // ProcessPlays
   function setJuice(play, rowNum) {

   }
   function setToSunday(d) {
      var n = d.getDay();
      n = (7 - (n - 7) % 7) % 7;
      return $scope.Getmdy(new Date( d.setDate(d.getDate() + n)));
   }
   function formatDateToYYYY_MM_DD_string(date) {
      var d = new Date(date),
         month = '' + (d.getMonth() + 1),
         day = '' + d.getDate(),
         year = d.getFullYear();

      if (month.length < 2)
         month = '0' + month;
      if (day.length < 2)
         day = '0' + day;

      return [year, month, day].join('-');
   }
   function resetAfterPlays() {
      let rowNum = 0;
      while ($rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO.length > rowNum) {
         if (document.getElementById("cbProcessPlay_" + rowNum).checked) {
            document.getElementById("cbProcessPlay_" + rowNum).checked = false;
            $("#Played_" + rowNum).text("PLAYED");
         }
         rowNum++;
      }  // while
   } // resetAfterPlays

   // styles
   //  ng-class="applyClassXXX(this)"
   $scope.applyTotalLineDirection = function (obj) {
      if (!obj.item.TotalLine || !obj.item.OpenTotalLine) return;

      if (obj.item.TotalLine > obj.item.OpenTotalLine) return "over";
      if (obj.item.TotalLine < obj.item.OpenTotalLine) return "under";
      return;
   };
   $scope.applyClassPlayColor = function (obj) {
      if (obj.item.Play === null)
         return "";
      return obj.item.Play.trim().toLowerCase();
   };
   $scope.applyDogFavColor = function (obj, Venue) {
      if (obj.item.SideLine === 0) {  // no fav or dog
         return;
      }
      if (Venue === "Away") {
         if (obj.item.SideLine > 0){  // Away is Fav
            return "blackBoldFG";
         }
         return "redFG";
      }
      // Home
      if (obj.item.SideLine < 0) {  // Home is Fav
         return "blackBoldFG";
      }
      return "redFG";
   };
   $scope.applyMinusRedColor = function (n1, n2) {
      try {

         if (!n1 || !n2)
            return "";

         if (n1 < n2)
            return "redFG";
         // style = 'color:red;'
         return "";
      }
      catch {
         alert(n1 + '-' + n2);
      }
   };


});   // controller
