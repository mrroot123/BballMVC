
angular.module('app').controller('templateModalController', function ($rootScope, $scope, f, ajx, url) {
   const modalName = "templateModal";
   const containerName = "parentContainer";

   $scope.$on('eventOpenTemplateModal', function (e, objAdj) {
      // Optional init modal
   });

   $scope.$on('eventCloseTemplateModal', function (e, objAdj) {
      // Optional do closing logic modal
   });

}); // Adjustments Modal controller
