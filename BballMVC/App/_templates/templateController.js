
'use strict';
angular.module('app').controller('templateController', function ($rootScope, $scope, f, ajx, url) {

   const modalName = "templateModal";
   const containerName = "templateContainer";
   $scope.$on('eventReshowtemplateContainer', function (ev) {
      f.ShowScreen(containerName);
   });




   $scope.templateAjax = function (parms) {

      f.GreyScreen("screen");
      var URL = "urlTemplate";
      ajx.AjaxGet(URL, {
         UserName: $rootScope.oBballInfoDTO.UserName
         , GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName
      })   // Get TodaysMatchups from server
         .then(data => {
            
            $rootScope.oBballInfoDTO.oBballDataDTO.templateDTO = data.templateDTO;
            populateTemplate();

            f.GreyScreen(containerName); //???
            f.ShowScreen(containerName);//???

            f.MessageSuccess("template message");
            f.ShowScreen("screen");
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            f.ShowScreen("screen");
         });
   }; // GetTodaysMatchups

   function populateTemplate() {
      let xx = 0;


      $rootScope.oBballInfoDTO.oBballDataDTO.templateDTO.forEach(function (item, index) {
         if (item.xxx) {
            var x = "";
         }

      });
      $scope.xxx = "";

      $scope.$apply();
   }  // populateTemplate

 
   // styles
   //  ng-class="applyClassXXX(this)"
   $scope.applyClassxxxr = function (obj) {
      return obj.item.xxx.trim().toLowerCase();
   };


});   // controller
