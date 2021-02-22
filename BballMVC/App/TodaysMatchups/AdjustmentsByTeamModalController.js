
angular.module('app').controller('AdjustmentsByTeamModalController', function ($rootScope, $scope, f, ajx, url) {
   const modalName = "AdjustmentsByTeamModal";
   const containerName = "TodaysMatchupsContainer";

   $scope.$on('eventOpenAdjustmentsByTeamModal', function (e, objAdj) {
      let Team = objAdj[1] === 'Away' ? objAdj[0].item.TeamAway : objAdj[0].item.TeamHome;
      let SideLine = objAdj[0].item.SideLine;

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

         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
      var y = 1;
   });

}); // Adjustments Modal controller
