
angular.module('app').controller('AlertModalController', function ($rootScope, $scope, f, ajx, url) {
   const modalName = "AlertModal";
   let currentParent = null;

   $scope.$on('eventOpenAlertModal', function (e, msg) {
      currentParent = e.targetScope.ParentContainerName;
      f.GreyScreen(e.targetScope.ParentContainerName);      //"TodaysMatchupsContainer");
      // $('#' + modalName).css({ "display": "block" });   // Show AdjustmentsByTeam Modal
      var oModal = document.getElementById(modalName);
      //$scope.msg = editMsg2(msg);
      $("#AlertModalMsg").html(msg);
      $scope.$apply();
            // oModal.style.height = 100 + data.length * 50;
      f.ShowModal(modalName);
      //      $scope.setAdjustmentsModal = f.showHideModal(true);
      //setTimeout(function () {
      //   $scope.AlertModalClose();
      //}, 3000);
   }); // $on
   // 
   $scope.AlertModalClose = function () {    // invoked by Close click on Modal
      f.ShowScreen(currentParent);  // kdtodo make TodaysMatchupsContainer generic

      f.HideModal(modalName); // Hide AlertModal Modal
    //  $scope.$emit("eventReshowTodaysMatchupsContainer");   //  kdtodo make eventReshowTodaysMatchupsContainer generic
   };
   function editMsg(msg) {
     // var patt1 = /\n/;
     // var result = str.search(patt1);
      // Split Then join the pieces putting the replace string in between:
      const newLine = /\n/;
      return msg.split(newLine).join("<br>");
   }
   function editMsg2(msg) {
      // substr(zeroIx, len)
      const newLine = /\n/;
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
}); // Alert Modal controller
