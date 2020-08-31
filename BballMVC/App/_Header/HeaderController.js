angular.module('app').controller('HeaderController', function ($rootScope, $scope, f, ajx, url) {
   $scope.ShowLeagueDropDown = false;
   GetLeagueNames();   // on app init
   $scope.GameDate = new Date();
   $rootScope.oBballInfoDTO.GameDate = f.Getmdy($scope.GameDate);

   // funtions
   function GetLeagueNames() {
      $rootScope.oBballInfoDTO.UserName = "Test";

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
      ajx.AjaxGet(url.UrlGetLeagueNames, { UserName: $rootScope.oBballInfoDTO.UserName })
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO = data;   // refresh $rootScope.oBballInfoDTO
            $scope.LeagueNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames;
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
      if ($scope.LeagueName === undefined) {
         alert("Select League Name");
         return;
      }
      $rootScope.oBballInfoDTO.LeagueName = $scope.LeagueName;

      $rootScope.oBballInfoDTO.GameDate = new Date();

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

//      ajx.AjaxGet(url.UrlGetLeagueData, { UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName })

      ajx.AjaxGet(url.UrlGetLeagueData, { UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName })
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO = data;   // refresh $rootScope.oBballInfoDTO
            $rootScope.$broadcast('populateTodaysMatchups');
            $rootScope.$broadcast('populatePostGameAnalysis');
            $rootScope.$broadcast('populateAdjustments');
            $rootScope.$broadcast('populateTeams_AdjTypes');

            $scope.$emit('showAccordian');
            $scope.$apply;
            $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });


         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
            $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

         });

   }; // SelectLeague

   //function Getmdy(d) {
   //   return (d.getMonth()+1) + "/" + d.getDate() + "/" + (d.getYear()+1900);
   //}
});