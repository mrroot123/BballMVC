angular.module("app").controller("layoutController", function ($rootScope, $scope, f) {
   kdAlert("layoutController");
   $scope.Accordion = false; // hide Accordion on app init
   $scope.PostGameAnalysis = true;


   $scope.$on('showAccordion', function (e) {
      displayAccordion();
  //   $scope.Accordion = true;
   //   $scope.$apply;
   });

   function displayAccordion () {
      $scope.Accordion = true;
      $scope.$apply;
   }  // displayAccordion

   //$scope.clickRefreshTodaysMatchups = function () {
   //   $scope.$broadcast('eventRefreshTodaysMatchups');
   //};

   $scope.clickAccordion = function (ParentContainerName, eventName, ev) {
      if (isAccordionOpen(ev))
         return;

      if (!$rootScope.oBballInfoDTO.LeagueName) {
         f.DisplayMessage("League not selected");
         return;
      }

      $rootScope.ParentContainerName = ParentContainerName;
      if (eventName)
         $scope.$broadcast(eventName);
   };
   function isAccordionOpen(ev) {
      var id = ev.target.id;
      var accID = $('#' + id).attr('href');
      var accOpen = $(accID).attr("aria-expanded") ? $(accID).attr("aria-expanded") : "false";
      return accOpen === "true";
   }
   //$scope.ClickBballManagement = function () {
   //   $scope.$broadcast('eventInitBballManagement');
   //};
});