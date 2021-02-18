
angular.module('app').controller('AlertModalController', function ($rootScope, $scope, f, ajx, url) {
   const modalName = "AlertModal";
   const containerName = "screen";
   $scope.$on('eventOpenAlertModal', function (e, msg) {
      f.GreyScreen(containerName);
      f.GreyScreen("TodaysMatchupsContainer");
      // $('#' + modalName).css({ "display": "block" });   // Show AdjustmentsByTeam Modal
      var oModal = document.getElementById(modalName);
     // $scope.msg = editMsg(msg);
      $("#AlertModalMsg").html(editMsg(msg));
      $scope.$apply();
            // oModal.style.height = 100 + data.length * 50;
      f.ShowModal(modalName);
      //      $scope.setAdjustmentsModal = f.showHideModal(true);

   }); // $on
   // 
   $scope.AlertModalClose = function () {    // invoked by Close click on Modal
      f.ShowScreen(containerName);
      f.ShowScreen("TodaysMatchupsContainer");

      f.HideModal(modalName); // Hide AlertModal Modal
      $scope.$emit("eventReshowTodaysMatchupsContainer");
   };
   function editMsg(msg) {
      // Split Then join the pieces putting the replace string in between:
      return msg.split("\n").join("<br>");
   }

}); // Adjustments Modal controller
