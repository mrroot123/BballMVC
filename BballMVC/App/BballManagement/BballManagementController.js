
'use strict';
angular.module('app').controller('BballManagementController', function ($rootScope, $scope, f, ajx, url) {

   $scope.$on('eventInitBballManagement', function (ev) {
      InitBballManagement();
   });

   function InitBballManagement() {
      $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
      $scope.ConnectionString = $rootScope.oBballInfoDTO.ConnectionString;
      $scope.BaseDirectory = $rootScope.oBballInfoDTO.BaseDirectory;
      
 //     $scope.$apply();
   };

   //const modalName = "BballManagementModal";
   //const containerName = "BballManagementContainer";


   $scope.ReloadBoxScores = function () {
      $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
      if (!$scope.LeagueName || $scope.LeagueName === "--Select League--") {
         alert("Select League");
         return;
      }
      if (!$scope.GameDate === undefined) {
         alert("Select Game Date");
         return;
      }
      let CollectionType = $scope.cbAsync ? "ReloadBoxScoresAsync" : "ReloadBoxScores";
      let URL = $scope.cbAsync ? url.UrlGetDataAsync : url.UrlGetData;

      ajx.AjaxGet(URL, {
         UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $scope.GameDate.toLocaleDateString()
         , LeagueName: $scope.LeagueName, CollectionType: CollectionType
      })
         .then(oBballInfoDTO => {
            f.MessageSuccess("Reload complete");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   }; // ReloadBoxScores

   $scope.RefreshBballInfo = function () {

      ajx.AjaxGet(url.UrlRefreshBballInfo)   
         .then(oBballInfoDTO => {
            $rootScope.oBballInfoDTO = oBballInfoDTO;
            $scope.ConnectionString = f.EditConnectionString($rootScope.oBballInfoDTO.ConnectionString);
            $scope.BaseDirectory = $rootScope.oBballInfoDTO.BaseDirectory;
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   }; // RefreshBballInfo

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

   class Bball {
      constructor() {

      }
   }
});   // controller
