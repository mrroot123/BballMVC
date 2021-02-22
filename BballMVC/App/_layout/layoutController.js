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
      //$('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
      f.screenShow(true);
      $scope.$apply;
   }  // displayAccordion

   $scope.clickRefreshTodaysMatchups = function () {
      $scope.$broadcast('eventRefreshTodaysMatchups');
   };

   $scope.clickAccordion = function (ParentContainerName, eventName) {
      $rootScope.ParentContainerName = ParentContainerName;
      if (eventName)
         $scope.$broadcast(eventName);
   };

   $scope.ClickBballManagement = function () {
      $scope.$broadcast('eventInitBballManagement');
   };
});