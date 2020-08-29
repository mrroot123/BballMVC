
'use strict';
angular.module('app').controller('PostGameAnalysisController', function ($rootScope, $scope, f, ajx) {
   kdAlert("PGAController");
   //if ($scope.GameDate >= f.GetDateOnly()) {
   //   $scope.$emit('HidePostGameAnalysis');
   //   return;
   //}
   let PostGameAnalysisParms = { scope: $scope, f: f, LeagueName: $rootScope.oBballInfoDTO.LeagueName, ajx: ajx };
   $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
   $scope.GameDate = $rootScope.oBballInfoDTO.GameDate;


   $scope.$on("populatePostGameAnalysis", function (ev) {
      populatePostGameAnalysis();
      //$scope.ocPostGameAnalysisDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      //$scope.$apply();
   });


   function populatePostGameAnalysis() {
      $scope.ocPostGameAnalysisDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
      $scope.GameDate = $rootScope.oBballInfoDTO.GameDate;

    //  $scope.TMparms = $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO[0];
      $scope.$apply();
   }


});   // controller
