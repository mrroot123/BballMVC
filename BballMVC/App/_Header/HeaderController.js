﻿angular.module('app').controller('HeaderController', function ($rootScope, $scope, f, ajx, url) {
   kdAlert("HeaderController");
   $scope.ShowLeagueDropDown = false;
   GetLeagueNames();   // on app init
  // RefreshLeagueNamesDropDown();
   $scope.GameDate = new Date();
   $rootScope.oBballInfoDTO.GameDate = new Date(); // Today as Object

   // funtions
   function GetLeagueNames() {
      $rootScope.oBballInfoDTO.UserName = "Test";
      var xx = 1;
      if (xx===2)     // $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         RefreshLeagueNamesDropDown();
      else {
         $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
         ajx.AjaxGet(url.UrlGetData, {
            UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
            , LeagueName: $rootScope.oBballInfoDTO.LeagueName, CollectionType: "GetLeagueNames"
         })
            .then(data => {
               $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames = data.ocLeagueNames;
               $rootScope.oBballInfoDTO.oBballDataDTO.BaseDir = data.BaseDir;
               RefreshLeagueNamesDropDown();
            })
            .catch(error => {
               f.DisplayErrorMessage(f.FormatResponse(error));
            });
         $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
      }
   }   // GetLeagueNames
   function RefreshLeagueNamesDropDown() {
      $scope.LeagueNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames;
      $scope.ShowLeagueDropDown = true;
      $scope.$apply();
   }
   $scope.SelectLeague = function () {
      if ($scope.LeagueName === undefined || $scope.LeagueName === null || $scope.LeagueName === "--Select League--") {
         alert("Select League");
         return;
      }

      $rootScope.oBballInfoDTO.LeagueName = $scope.LeagueName;
      $rootScope.oBballInfoDTO.GameDate = new Date(); // Today as Object

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

      ajx.AjaxGet(url.UrlGetData, {
         UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toDateString()
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         , CollectionType: "GetLeagueData"
      })
         .then(data => {
            // See $scope.RefreshTodaysMatchups in TodaysMatchupsController for same moves
            // 1) ocAdjustments  2) ocAdjustmentNames  3) ocTeams  4) LeagueParmsDTO
            $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustments = data.ocAdjustments;             // 1) lg data
            $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = data.ocAdjustmentNames;     // 2) lg data
            $rootScope.oBballInfoDTO.oBballDataDTO.ocTeams = data.ocTeams;                         // 3) lg data
            $rootScope.oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO = data.oUserLeagueParmsDTO; // 4) lg data
            $rootScope.$broadcast('populateAdjustments');                                          // 1) lg data
            $rootScope.$broadcast('populateTeams_AdjTypes');                                       // 2) lg data

            //$rootScope.oBballInfoDTO.oBballDataDTO.oDailySummaryDTO = data.oDailySummaryDTO;          
            //$rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = data.ocAdjustmentNames;     // 2) lg data
            //$rootScope.oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO = data.oUserLeagueParmsDTO; // 4) lg data
            //$rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustments = data.ocAdjustments;             // 1) lg data
            //$rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO = data.ocPostGameAnalysisDTO;   
            //$rootScope.oBballInfoDTO.oBballDataDTO.ocTeams = data.ocTeams;                         // 3) lg data
            //$rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = data.ocTodaysMatchupsDTO;   
            //$rootScope.$broadcast('populateTodaysMatchups');
            //$rootScope.$broadcast('populatePostGameAnalysis');
            //$rootScope.$broadcast('populateAdjustments');                                          // lg data
            //$rootScope.$broadcast('populateTeams_AdjTypes');                                       // lg data

            $scope.$emit('showAccordian');
            $scope.$apply;
            $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
            alert($rootScope.oBballInfoDTO.LeagueName + " selected");

         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

         });

   }; // SelectLeague

   //function Getmdy(d) {
   //   return (d.getMonth()+1) + "/" + d.getDate() + "/" + (d.getYear()+1900);
   //}
});