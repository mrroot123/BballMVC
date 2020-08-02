angular.module("app").controller("layoutController", function ($scope) {
   $scope.showAccordian = false; // hide accordian on app init

   $scope.$on('showAccordian', function (e) {
      displayAccordian();
   //   $scope.showAccordian = true;
   });

   function displayAccordian () {
      $scope.showAccordian = true;
      $scope.$apply;
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   };

});