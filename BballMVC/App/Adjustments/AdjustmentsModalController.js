
angular.module('app').controller('AdjustmentsModalController', function ($rootScope, $scope, f, ajx, url) {
   let rowWasInserted = false;

   $scope.$on('eventOpenAdjustmentsModal', function (e) {
      rowWasInserted = false;
      $scope.ClearAdjustmentEntryForm();
      f.GreyScreen($rootScope.ADJUSTMENTSLISTCONTAINER);
      //$scope.GreyOutAdjustmentList();
      $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
   });

   $scope.$on('eventPopulateTeamsAdjTypes', function () {
      $scope.TeamList = $rootScope.oBballInfoDTO.oBballDataDTO.ocTeams;
      $scope.AdjustmentNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustmentNames;
      $scope.$apply();
   });

   $scope.AdjustmentsModalClose = function () {    // invoked by Close click on Adjustment Entry Modal
      $('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal
      $scope.$emit("eventReshowAdjustmentsListContainer", rowWasInserted);
   };


   $scope.clickInsertAdjustment = function () {

      let oAdjustmentWrapper = {};
      let oAdjustmentDTO = {};
      oAdjustmentDTO.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
      oAdjustmentDTO.StartDate = $rootScope.oBballInfoDTO.GameDate.toLocaleDateString();

      oAdjustmentDTO.AdjustmentType = $scope.AdjustmentType;
      oAdjustmentDTO.Team = $scope.Team;
      oAdjustmentDTO.AdjustmentAmount = $scope.AdjustmentAmount;
      oAdjustmentDTO.Player = $scope.Player;
      oAdjustmentDTO.Description = $scope.Description;

      oAdjustmentWrapper.DescendingAdjustment = $scope.cbDescendingAdjustment;
      oAdjustmentWrapper.DescendingDays = $scope.DescendingDays === "" ? 0 : $scope.DescendingDays;
      oAdjustmentWrapper.oAdjustmentDTO = oAdjustmentDTO;

      //if (!ValidateAdjustmentEntry(oAdjustmentDTO, $scope)) {
      //   return;  // errors in Adj Entry I/P
      //}

      $scope.setAdjustmentsModal = f.showHideModal(false);  // $scope.showAdjustmentsModal(false);
      ajx.AjaxPost(url.UrlPostData + "?CollectionType=InsertAdjustment", oAdjustmentWrapper)     // , "text/plain")
         .then(data => {
            rowWasInserted = true;
            $rootScope.$broadcast('eventSetRefreshTodaysMatchups');  
            f.MessageSuccess("Insert Complete");
            $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
         })
         .catch(error => {
            f.DisplayErrorMessage("Adjustment Insert Error/n" + f.FormatResponse(error));
            $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
         });

      $scope.ClearAdjustmentEntryForm();
   }; // InsertAdjustment

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
      $scope.cbDescendingAdjustment = false;
      $scope.DescendingDays = "";

   };
}); // Adjustments Modal controller
