angular.module("app").controller("layoutController", function ($scope) {
   kdAlert("layoutController");
   $scope.Accordian = false; // hide accordian on app init
   $scope.PostGameAnalysis = true;
   $scope.$on('showAccordian', function (e) {
      displayAccordian();
   //   $scope.Accordian = true;
      $scope.$apply;
   });

   function displayAccordian () {
      $scope.Accordian = true;
      $scope.$apply;
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }

});