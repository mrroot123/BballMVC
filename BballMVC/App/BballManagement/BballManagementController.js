
'use strict';
angular.module('app').controller('BballManagementController', function ($rootScope, $scope, f, ajx, url) {

   $scope.$on('eventInitBballManagement', function (ev) {
      InitBballManagement();
   });

   function InitBballManagement() {
      $scope.LeagueNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames;
 //     $scope.$apply();
   };

   //const modalName = "BballManagementModal";
   //const containerName = "BballManagementContainer";



   $scope.ReloadBoxScores = function () {
      if (!$scope.LeagueName || $scope.LeagueName === "--Select League--") {
         alert("Select League");
         return;
      }
      if (!$scope.GameDate === undefined) {
         alert("Select Game Date");
         return;
      }

      ajx.AjaxGet(url.UrlGetData, {
         UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $scope.GameDate.toLocaleDateString()
         , LeagueName: $scope.LeagueName, CollectionType: "ReloadBoxScores"
      })   
         .then(data => {
            f.MessageSuccess("Reload complete");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   }; // GetTodaysMatchups

   $scope.BballManagementAjax = function (parms) {

      f.GreyScreen("screen");
      var URL = "urlBballManagement";
      ajx.AjaxGet(URL, {
         UserName: $rootScope.oBballInfoDTO.UserName
         , GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName
      })   // Get TodaysMatchups from server
         .then(data => {

            $rootScope.oBballInfoDTO.oBballDataDTO.BballManagementDTO = data.BballManagementDTO;
            populateBballManagement();

            f.GreyScreen(containerName); //???
            f.ShowScreen(containerName);//???

            f.MessageSuccess("BballManagement message");
            f.ShowScreen("screen");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            f.ShowScreen("screen");
         });
   }; // GetTodaysMatchups

   function populateBballManagement() {
      let xx = 0;


      $rootScope.oBballInfoDTO.oBballDataDTO.BballManagementDTO.forEach(function (item, index) {
         if (item.xxx) {
            var x = "";
         }

      });
      $scope.xxx = "";

      $scope.$apply();
   }  // populateBballManagement


   // styles
   //  ng-class="applyClassXXX(this)"
   $scope.applyClassxxxr = function (obj) {
      return obj.item.xxx.trim().toLowerCase();
   };


});   // controller
