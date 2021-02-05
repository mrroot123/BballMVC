
angular.module('app').controller('AdjustmentsByTeamModalController', function ($rootScope, $scope, f, ajx, url) {

   $scope.$on('OpenAdjustmentsByTeamEvent', function (e, Team, SideLine) {
     // $scope.GreyOutAdjustmentList();
      $('#AdjustmentsByTeamModal').css({ "display": "block" });   // Show AdjustmentsByTeam Modal
      $scope.AdjustmentsByTeamTeam = Team;
      ajx.AjaxGet(url.UrlGetAdjustmentsByTeam
         , {
            GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString()
            , LeagueName: $rootScope.oBballInfoDTO.LeagueName
            , Team: Team
            , SideLine: SideLine
         })   // Get AdjustmentsByTeam from server
         .then(data => {
            populateAdjustmentsByTeam(data);
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   });
   

   function populateAdjustmentsByTeam(data) {
      $scope.ocAdjustmentsByTeam = data;
      $scope.$apply();
   }


   //$scope.CloseAdjustmentEntry = function () {    // invoked by Close click on Adjustment Entry Modal
   //   $('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal
   //   $scope.$emit("CloseAdjustmentEntry", rowWasInserted);
   //};

}); // Adjustments Modal controller
