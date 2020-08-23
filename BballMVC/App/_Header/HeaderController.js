angular.module('app').controller('HeaderController', function ($rootScope, $scope, f, ajx, url) {
   $scope.ShowLeagueDropDown = false;
   GetLeagueNames();   // on app init
   $scope.GameDate = new Date();
   oBballInfoDTO.GameDate = f.Getmdy($scope.GameDate);

   // funtions
   function GetLeagueNames() {
      // oBballInfoDTO.LeagueName = $scope.LeagueName;

      oBballInfoDTO.UserName = "Test";

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
      ajx.AjaxGet(url.UrlGetLeagueNames, { UserName: oBballInfoDTO.UserName })
         .then(data => {
            oBballInfoDTO.oBballDataDTO = data;   // refresh oBballInfoDTO
            $scope.LeagueNameList = oBballInfoDTO.oBballDataDTO.ocLeagueNames;
            $scope.ShowLeagueDropDown = true;
            $scope.$apply();
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }   // GetLeagueNames

   $scope.SelectLeague = function () {
      if ($scope.LeagueName === "--Select League--") {
         alert("Select League");
         return;
      }
      if ($scope.GameDate === undefined) {
         alert("Enter Game Date");
         return;
      }
      oBballInfoDTO.LeagueName = $scope.LeagueName;

      oBballInfoDTO.GameDate = f.Getmdy($scope.GameDate);

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

      ajx.AjaxGet(url.UrlGetLeagueData, { UserName: oBballInfoDTO.UserName, GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })
         .then(data => {
            oBballInfoDTO.oBballDataDTO = data;   // refresh oBballInfoDTO
            $rootScope.$broadcast('populateTodaysMatchups');
            $rootScope.$broadcast('populatePostGameAnalysis');
            $rootScope.$broadcast('populateAdjustments');
            $rootScope.$broadcast('populateTeams_AdjTypes');
            $scope.$apply;

            $scope.$emit('showAccordian');

         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }; // SelectLeague

   //function Getmdy(d) {
   //   return (d.getMonth()+1) + "/" + d.getDate() + "/" + (d.getYear()+1900);
   //}
});