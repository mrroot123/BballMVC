
angular.module('app').controller('AdjustmentsByTeamModalController', function ($rootScope, $scope, f, ajx, url) {
   const modalName = "AdjustmentsByTeamModal";
   const containerName = "TodaysMatchupsContainer";
   $scope.$on('eventOpenAdjustmentsByTeamModal', function (e, Team, SideLine) {
      f.GreyScreen(containerName);
     // $('#' + modalName).css({ "display": "block" });   // Show AdjustmentsByTeam Modal
      var oModal = document.getElementById(modalName);
      $scope.AdjustmentsByTeamTeam = Team;
      ajx.AjaxGet(url.UrlGetAdjustmentsByTeam
         , {
            GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString()
            , LeagueName: $rootScope.oBballInfoDTO.LeagueName
            , Team: Team
            , SideLine: SideLine
         })   // Get AdjustmentsByTeam from server
         .then(data => {
            $scope.ocAdjustmentsByTeam = data;
            $scope.AdjustmentsByTeamAdjTotal = 0;
            $scope.ocAdjustmentsByTeam.forEach(function (item, index) {
               $scope.AdjustmentsByTeamAdjTotal += item.AdjustmentAmount;
            });
            
            $scope.$apply();
           // oModal.style.height = 100 + data.length * 50;
            f.ShowModal(modalName);
            $scope.setAdjustmentsModal = f.showHideModal(true);

         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
      var y = 1;
   });
   // 
   $scope.AdjustmentsByTeamModalClose = function () {    // invoked by Close click on Modal
      f.HideModal(modalName); // Hide AdjustmentsByTeamModal Modal
      $scope.$emit("eventReshowTodaysMatchupsContainer");
   };


}); // Adjustments Modal controller
