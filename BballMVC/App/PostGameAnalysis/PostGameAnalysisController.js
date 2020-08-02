
'use strict';
angular.module('app').controller('PostGameAnalysisController', function ($scope, f, ajx) {
   let PostGameAnalysisParms = { scope: $scope, f: f, LeagueName: oBballInfoDTO.LeagueName, ajx: ajx };
   $scope.LeagueName = oBballInfoDTO.LeagueName;
   $scope.GameDate = oBballInfoDTO.GameDate;


   $scope.$on("populatePostGameAnalysis", function (ev) {
      populatePostGameAnalysis();
      //$scope.ocPostGameAnalysisDTO = oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      //$scope.$apply();
   });


   function populatePostGameAnalysis() {
      $scope.ocPostGameAnalysisDTO = oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      $scope.LeagueName = oBballInfoDTO.LeagueName;
      $scope.GameDate = oBballInfoDTO.GameDate;

    //  $scope.TMparms = oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];
      $scope.$apply();
   }


});   // controller
