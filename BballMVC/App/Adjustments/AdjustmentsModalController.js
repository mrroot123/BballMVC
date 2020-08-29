
angular.module('app').controller('AdjustmentsModalController', function ($rootScope, $scope, f, ajx, url) {
   let rowWasInserted = false;
  // let GetAdjustmentsParms = { scope: $scope, f: f, LeagueName: $rootScope.oBballInfoDTO.LeagueName, ajx: ajx };

   $scope.$on('OpenAdjustmentEntryModalEvent', function (e) {
      rowWasInserted = false;
      $scope.ClearAdjustmentEntryForm();
      $scope.GreyOutAdjustmentList();
      $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
   });

   $scope.$on('populateTeams_AdjTypes', function () {
      $scope.TeamList = $rootScope.oBballInfoDTO.oBballDataDTO.ocTeams;
      $scope.AdjustmentNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustmentNames;
      $scope.$apply();
   });


   $scope.clickInsertAdjustment = function () {

      let oAdjustment = {};
      oAdjustment.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
      oAdjustment.StartDate = $rootScope.oBballInfoDTO.GameDate;

      oAdjustment.AdjustmentType = $scope.AdjustmentType;
      oAdjustment.Team = $scope.Team;
      oAdjustment.AdjustmentAmount = $scope.AdjustmentAmount;
      oAdjustment.Player = $scope.Player;
      oAdjustment.Description = $scope.Description;

      //if (!ValidateAdjustmentEntry(oAdjustment, $scope)) {
      //   return;  // errors in Adj Entry I/P
      //}

      $scope.setAdjustmentsModal = f.showHideModal(false);  // $scope.showAdjustmentsModal(false);

      ajx.AjaxPost(url.UrlPostInsertAdjustment, oAdjustment)
         .then(data => {
            rowWasInserted = true;
            f.MessageSuccess("Insert Complete");
            $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
         })
         .catch(error => {
            f.DisplayErrorMessage("Adjustment Insert Error/n" + f.FormatResponse(error));
            $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
         });

      $scope.ClearAdjustmentEntryForm();
   }; // InsertAdjustment

   $scope.CloseAdjustmentEntry = function () {    // invoked by Close click on Adjustment Entry Modal
      $('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal
      $scope.$emit("CloseAdjustmentEntry", rowWasInserted);
   };

   // --- Validations ---
   $scope.ValidateAdjustmentForm = function () {
      return $scope.AdjustmentType && $scope.ValidateTeam && $scope.ValidateAdjustmentAmount
         && $scope.ValidatePlayer && $scope.ValidateDescription;
   };
   $scope.ValidateAdjustmentType = () => { return $scope.AdjustmentType; };
   $scope.ValidateTeam = function () { return $scope.Team || $scope.AdjustmentType === 'L'; };
   $scope.ValidateAdjustmentAmount = function () {
      return !isNaN($scope.AdjustmentAmount) && $scope.AdjustmentAmount < 10 && $scope.AdjustmentAmount > -10;
   };
   $scope.ValidatePlayer = function () { return !(!Player && (AdjustmentType === 'I' || AdjustmentType === 'R')); };
   $scope.ValidateDescription = function () { return $scope.Description; };

   $scope.ClearAdjustmentEntryForm = function () {
      $scope.AdjustmentType = "";
      $scope.Team = "";
      $scope.AdjustmentAmount = "";
      $scope.AdjustmentAmount = "";
      $scope.Player = "";
      $scope.Description = "";

   };
}); // Adjustments Modal controller
