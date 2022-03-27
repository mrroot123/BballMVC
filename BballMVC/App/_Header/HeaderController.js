﻿'use strict';

angular.module('app').controller('HeaderController', function ($rootScope, $scope, f, ajx, url) {
   kdAlert("HeaderController");
   $scope.ShowLeagueDropDown = false;


 //  GetLeagueNames();   // on app init
  // RefreshLeagueNamesDropDown();
   $scope.GameDate = new Date();
   $scope.Today = f.GetDayOfWeekLiteral($scope.GameDate) + " " + $scope.GameDate.toLocaleDateString();
   $rootScope.oBballInfoDTO.GameDate = new Date(); // Today as Object



   $scope.$on("eventPopulateLeagueNamesDropDown", function (ev) {
      RefreshLeagueNamesDropDown();
   });

   // funtions
   function GetLeagueNames() {
      $rootScope.oBballInfoDTO.UserName = "Test";
      var xx = 2;
      if (xx===2)     // $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         RefreshLeagueNamesDropDown();
      else {
         ajx.AjaxGet(url.UrlGetData, {
            UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
            , LeagueName: $rootScope.oBballInfoDTO.LeagueName, CollectionType: "GetLeagueNames"
         })
            .then(oBballInfoDTO => {
               let data = oBballInfoDTO.oBballDataDTO;   // 10/09/2021 - oBballInfoDTO returned instead of oBballDataDTO
               $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames = data.ocLeagueNames;
               $rootScope.oBballInfoDTO.oBballDataDTO.BaseDir = data.BaseDir;
               RefreshLeagueNamesDropDown();
               if (data.MessageNumber !== 0) {
                  f.DisplayErrorMessage(data.Message);
               }
            })
            .catch(error => {
               f.DisplayErrorMessage(f.FormatResponse(error));
            });
      }
   }   // GetLeagueNames
   function RefreshLeagueNamesDropDown() {
      $scope.LeagueNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames;
      $scope.ShowLeagueDropDown = true;
      $scope.$apply();
   }
   $scope.SelectLeague = function () {
      var currentLeagueName = $scope.LeagueName;
      if ($scope.LeagueName === undefined || $scope.LeagueName === null || $scope.LeagueName === "--Select League--") {
         if (!currentLeagueName) {
            $scope.LeagueName = currentLeagueName;
            return;
         }
         alert("Select League");
         return;
      }

      $rootScope.oBballInfoDTO.LeagueName = $scope.LeagueName;
      $rootScope.oBballInfoDTO.GameDate = new Date(); // Today as Object


      ajx.AjaxGet(url.UrlGetData, {
         UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString()  
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         , CollectionType: "GetLeagueData"
      })
         .then(oBballInfoDTO => {
            let data = oBballInfoDTO.oBballDataDTO;   // 10/09/2021 - oBballInfoDTO returned instead of oBballDataDTO
          //  // See $scope.RefreshTodaysMatchups in TodaysMatchupsController for same moves
          //  // 1) ocAdjustments  2) ocAdjustmentNames  3) ocTeams  4) LeagueParmsDTO
          //  $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustments = data.ocAdjustments;             // 1) lg data
          //  $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = data.ocAdjustmentNames;     // 2) lg data
          //  $rootScope.oBballInfoDTO.oBballDataDTO.ocTeams = data.ocTeams;                         // 3) lg data
          ////  $rootScope.oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO = data.oUserLeagueParmsDTO; // 4) lg data
          //  $rootScope.oBballInfoDTO.oBballDataDTO.oLeagueDTO = data.oLeagueDTO; // 5) lg data

            $rootScope.oBballInfoDTO.oBballDataDTO = oBballInfoDTO.oBballDataDTO;
            f.PopulateObjectFromJson($rootScope.oBballInfoDTO.oBballDataDTO);

            $rootScope.$broadcast('eventPopulateAdjustments');                                          // 1) lg data
            $rootScope.$broadcast('eventPopulateTeamsAdjTypes');                                       // 2) lg data
            if (data.MessageNumber !== 0) {
               f.DisplayErrorMessage(data.Message);
            }
       //     $scope.$emit('showAccordion'); // <-- will SHOW screen kdtodo is this line necessary anymore
            $scope.$apply;
          //  alert($rootScope.oBballInfoDTO.LeagueName + " selected");

         })
         .catch(error => {
            error.CollectionType = "GetLeagueData";
            error.ControllerName = "HeaderController";
            f.DisplayErrorMessage(f.FormatResponse(error));
         });

   }; // SelectLeague

   // kdtodo delete code 11/14/2021
   function xPopulateObjectFromJson(oBballDataDTO) {
      oBballDataDTO.OcJsonObjectDTO.forEach(populate);

         function populate(o) {
            let oJson = JSON.parse(o.JsonString)[0];
            eval("oBballDataDTO." + o.ObjectName + " = oJson")
            //switch (o.ObjectName) {
            //   case "UserLeagueParms":
            //      oBballDataDTO.oUserLeagueParmsDTO = null;
            //      oBballDataDTO.oUserLeagueParmsDTO = oJson;
            //}  // switch
         }  // populate
     
   }  // PopulateObjectFromJson
});