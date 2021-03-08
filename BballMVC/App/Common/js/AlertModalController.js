
angular.module('app').controller('AlertModalController', function ($rootScope, $scope, f, ajx, url) {
   const modalName = "AlertModal";

   $scope.$on('eventOpenAlertModal', function (e, msg) {
      f.GreyScreen("TodaysMatchupsContainer");
      // $('#' + modalName).css({ "display": "block" });   // Show AdjustmentsByTeam Modal
      var oModal = document.getElementById(modalName);
      //$scope.msg = editMsg2(msg);
      $("#AlertModalMsg").html(msg);
      $scope.$apply();
            // oModal.style.height = 100 + data.length * 50;
      f.ShowModal(modalName);
      //      $scope.setAdjustmentsModal = f.showHideModal(true);

   }); // $on
   // 
   $scope.AlertModalClose = function () {    // invoked by Close click on Modal
      f.ShowScreen("TodaysMatchupsContainer");

      f.HideModal(modalName); // Hide AlertModal Modal
      $scope.$emit("eventReshowTodaysMatchupsContainer");
   };
   function editMsg(msg) {
      // Split Then join the pieces putting the replace string in between:
      return msg.split("\n").join("<br>");
   }
   function editMsg2(msg) {
      // substr(zeroIx, len)
      var msgOut = "";
      var i;
      for (i = 0; i < msg.length - 1; i++ ) {
         if (msg.substr(i, 2) === "\n") {
            msgOut += "<br>";
            i++;
         }
         else {
            msgOut += msg.substr(i, 1);
         }
      }  // for
      return msgOut;
   }  // editMsg2
}); // Adjustments Modal controller
