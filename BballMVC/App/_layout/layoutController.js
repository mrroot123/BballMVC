angular.module("app").controller("layoutController", function ($scope) {
   $scope.showAccordian = false; // hide accordian on app init

   $scope.$on('showAccordian', function (e) {
      $scope.showAccordian = true;
   });

   $scope.displayAccordian = function () { $scope.showAccordian = true;  };

});