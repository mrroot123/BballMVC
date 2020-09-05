
'use strict';
angular.module('app').controller('PostGameAnalysisController', function ($rootScope, $scope, f, ajx, url) {
   kdAlert("PGAController");
   //if ($rootScope.oBballInfoDTO.GameDatePGA >= f.GetDateOnly()) {
   //   $scope.$emit('HidePostGameAnalysis');
   //   return;
   //}
  // let PostGameAnalysisParms = { scope: $scope, f: f, LeagueName: $rootScope.oBballInfoDTO.LeagueName, ajx: ajx };
   $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
   $rootScope.oBballInfoDTO.GameDatePGA = f.Yesterday();

   $scope.RefreshDate = function () {
      if ($rootScope.oBballInfoDTO.GameDatePGA >= f.Today()) {
         f.MessageWarning("Date must be in the past");
         return;
      }

      f.GreyScreen("screen");

      ajx.AjaxGet(url.UrlGetData, { UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDatePGA.toDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName, CollectionType: "RefreshPostGameAnalysis" })   // Get TodaysMatchups from server
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO = data.ocPostGameAnalysisDTO;
            populatePostGameAnalysis();
            f.MessageSuccess("Post Game Analysis Refreshed for " + f.Getmdy($rootScope.oBballInfoDTO.GameDatePGA));
            f.ShowScreen("screen");
         })
         .catch(error => {
            f.MessageError(f.FormatResponse(error));
            f.ShowScreen("screen");
         });
   };
   $scope.$on("populatePostGameAnalysis", function (ev) {
      populatePostGameAnalysis();
      //$scope.ocPostGameAnalysisDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      //$scope.$apply();
   });


   function populatePostGameAnalysis() {
      $scope.ocPostGameAnalysisDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
     // $rootScope.oBballInfoDTO.GameDatePGA = f.Yesterday();

    //  $scope.TMparms = $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];
      $scope.$apply();
   }


});   // controller
