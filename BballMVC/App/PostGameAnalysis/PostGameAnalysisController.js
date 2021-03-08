
'use strict';
angular.module('app').controller('PostGameAnalysisController', function ($rootScope, $scope, f, ajx, url) {
   kdAlert("PGAController");

   $scope.GameDate = f.Yesterday();

   $scope.$on("eventInitPostGameAnalysis", function (ev) {
      $scope.RefreshDate();

   });

   $scope.RefreshDate = function () {
      //$scope.GameDate = $scope.pgaGameDate;

      if ($scope.GameDate >= f.Today()) {
         f.MessageWarning("Date must be in the past");
         return;
      }

      ajx.AjaxGet(url.UrlGetData, {
         UserName: $rootScope.oBballInfoDTO.UserName
         , GameDate: $scope.GameDate.toDateString()
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         , CollectionType: "RefreshPostGameAnalysis"
      })   // Get TodaysMatchups from server
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO = data.ocPostGameAnalysisDTO;
            populatePostGameAnalysis();
            f.MessageSuccess("Post Game Analysis Refreshed for " + f.Getmdy($scope.GameDate));
         })
         .catch(error => {
            f.MessageError(f.FormatResponse(error));
         });
   };

   $scope.DetermineOT = function (OTperiods) {
      const OTs = ["", "OverTime", "Double OverTime", "Triple OverTime", "Quadruple OverTime"];
      return OTs[OTperiods];
   };
   
   
   function populatePostGameAnalysis() {
      $scope.ocPostGameAnalysisDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO;
      $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;

      $scope.$apply();
   }


   $scope.hidePGArow = function (obj) {
      $("#cbShowRow_" + obj.$index).closest("tr").hide();
   };

   $scope.applyPGAclass = function (OTperiods) {
      const OTs = ["", "OverTime", "Double OverTime", "Triple OverTime", "Quadruple OverTime"];
      return OTs[OTperiods];
   };

});   // controller
