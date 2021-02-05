
angular.module('app').controller("AdjustmentsController", function ($rootScope, $scope, f, ajx, url) {
   $scope.ocAdjustments;
   $scope.cbShowZeroAdjustments = true;
   let rowWasInserted = false;

   $scope.cbChange = function (adjAmtID) {
      alert("cb");
   };
   $scope.Getmdy = function (d) {
      return f.Getmdy(d);
   };
   $scope.ProcessAdjustmentUpdates = function () {
      let ocAdjustmentDTO = [];
      let rowNum = 0;
      while ($("#adjAmt_" + rowNum).val() !== undefined) {
         if ($("#cb_" + rowNum).prop('checked')) { // push Delete AdjustmentID
            ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")), AdjustmentAmount: null });
         }
         else if ($("#adjAmt_" + rowNum).val()) {  // push Delete AdjustmentID & Adj Amt
            ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")), AdjustmentAmount: parseFloat($("#adjAmt_" + rowNum).val()) });
         }
         rowNum++;
      }  // while

      if (ocAdjustmentDTO.length === 0) {
         f.DisplayMessage("No Updates were made");
         return;
      }

      $scope.GreyOutAdjustmentList();
      ajx.AjaxPost(url.UrlPostAdjustmentUpdates, ocAdjustmentDTO)
         .then(data => {
            $scope.GetAdjustments($scope, f, ajx);
            f.DisplayMessage("Updates Complete");
            $scope.ShowAdjustmentList();
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            $scope.ShowAdjustmentList();
         });
   };   // ProcessAdjustmentUpdates 
   $scope.OpenAdjustmentEntryModal = function () {
      $scope.GreyOutAdjustmentList();
      $scope.$broadcast('OpenAdjustmentEntryModalEvent');
   };
   $scope.$on('CloseAdjustmentEntry', function (e, rowWasInserted) {
      if (rowWasInserted)
         $scope.GetAdjustments($scope, f, ajx);
      $scope.ShowAdjustmentList();
   });

   $scope.$on('populateAdjustments', function () {
      populateAdjustments();
   });

   $scope.GetAdjustments = function ($scope, f, ajx) {
      let refreshAdjustments = function (ocAdjustments) {
         $scope.ocAdjustments = ocAdjustments;
         $scope.ocAdjustments.forEach(function (item) {
            item.cb_ID = "cb_" + item.AdjustmentID;
         });
         $scope.$apply();
      };

      ajx.AjaxGet(url.UrlGetAdjustments, { GameDate: $rootScope.oBballInfoDTO.GameDate.toLocaleDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName })   // Get Adjustments from server
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustments = data;
            populateAdjustments();
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   }; // GetAdjustments

   function populateAdjustments() {
      $scope.ocAdjustments = $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustments;
      $scope.ocAdjustments.forEach(function (item) {
         item.cb_ID = "cb_" + item.AdjustmentID;
      });
      $scope.$apply();
   }

   $scope.ShowAdjustmentList = function () {
      $('#AdjustmentsList').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
   };
   // grey out Adjustments
   $scope.GreyOutAdjustmentList = function () {
      $('#AdjustmentsList').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
   };

}); // Adjustments controller
