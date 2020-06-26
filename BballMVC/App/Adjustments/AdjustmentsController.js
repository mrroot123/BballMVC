
angular.module('app').controller("AdjustmentsController", function ($scope, f, ajx, url) {
   $scope.ocAdjustments;
   $scope.cbShowZeroAdjustments = true;
   let rowWasInserted = false;
   let GetAdjustmentsParms = { scope: $scope, f: f, LeagueName: oBballInfoDTO.LeagueName, ajx: ajx };
 //  GetAdjustmentInfo(GetAdjustmentsParms);

   $scope.cbChange = function (adjAmtID) {
      alert("cb");
   };
   $scope.ProcessUpdates = function () {
      let ocAdjustmentDTO = [];
      let rowNum = 0;
      while ($("#adjAmt_" + rowNum).val() !== undefined) {
         if ($("#cb_" + rowNum).prop('checked')) { // push Delete AdjustmentID
            ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")) });
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
      // let URL = "api/Adjustments/PostProcessUpdates";
      ajx.AjaxPost(url.UrlPostProcessUpdates, ocAdjustmentDTO)
         .then(data => {
            $scope.GetAdjustments($scope, f, ajx);  
            f.DisplayMessage("Updates Complete");
            $scope.ShowAdjustmentList();
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   };   // processUpdates 
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

      ajx.AjaxGet(UrlGetAdjustments, { GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })   // Get Adjustments from server
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocAdjustments = data;
            populateAdjustments();
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
   }; // GetAdjustments

   function populateAdjustments() {
      $scope.ocAdjustments = oBballInfoDTO.oBballDataDTO.ocAdjustments;
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

   //function xGetAdjustmentInfo(Parms) { // called once at Controller init
   //   var f = Parms.f;
   //   var ajx = Parms.ajx;
   //   let fProcessAdjustmentInfo = {
   //      scope: Parms.scope
   //      , process: function (oBballDataDTO) {
   //         $scope.GetAdjustments(Parms.scope, f, ajx);
   //         // Populate Teams DropDown form Adjustment Entry
   //         this.scope.TeamList = oBballDataDTO.ocTeams;
   //         this.scope.AdjustmentNameList = oBballDataDTO.ocAdjustmentNames;
   //      }
   //   }; // fProcessAdjustmentInfo

   //   ajx.AjaxGet(url.UrlGetAdjustmentInfo, { GameDate: oBballInfoDTO.GameDate,  LeagueName: Parms.LeagueName })
   //      .then(data => {
   //         oBballInfoDTO.oBballDataDTO.ocTeams = oBballDataDTO.ocTeams;
   //         oBballInfoDTO.oBballDataDTO.AdjustmentNameList = oBballDataDTO.ocAdjustmentNames;
   //         oBballInfoDTO.oBballDataDTO.ocAdjustments = oBballDataDTO.ocAdjustments;
   //         populateAdjustments();
   //      })
   //      .catch(error => {
   //         f.DisplayMessage(f.FormatResponse(error));
   //      });
   //   return;
   //}  // GetAdjustmentInfo

}); // Adjustments controller
