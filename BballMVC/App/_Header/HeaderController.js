angular.module('app').controller('HeaderController', function ($rootScope, $scope, f, ajx, url) {
   kdAlert("HeaderController");
   $scope.ShowLeagueDropDown = false;
   GetLeagueNames();   // on app init
   $scope.GameDate = new Date();
   $rootScope.oBballInfoDTO.GameDate = new Date(); // Today as Object

   // funtions
   function GetLeagueNames() {
      $rootScope.oBballInfoDTO.UserName = "Test";

      if ($rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames)
         RefreshLeagueNamesDropDown();
      else {
         $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
         ajx.AjaxGet(url.UrlGetData, {
            UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
            , LeagueName: $rootScope.oBballInfoDTO.LeagueName, CollectionType: "GetLeagueNames"
         })
            .then(data => {
               $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames = data.ocLeagueNames;
               RefreshLeagueNamesDropDown();
            })
            .catch(error => {
               f.DisplayErrorMessage(f.FormatResponse(error));
            });
         $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
      }
   }   // GetLeagueNames
   function RefreshLeagueNamesDropDown() {
      $scope.LeagueNameList = $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames;
      $scope.ShowLeagueDropDown = true;
      $scope.$apply();
   }
   $scope.SelectLeague = function () {
      if ($scope.LeagueName === undefined || $scope.LeagueName === null || $scope.LeagueName === "--Select League--") {
         alert("Select League");
         return;
      }

      $rootScope.oBballInfoDTO.LeagueName = $scope.LeagueName;
      $rootScope.oBballInfoDTO.GameDate = new Date(); // Today as Object

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

      ajx.AjaxGet(url.UrlGetData, {
         UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toDateString()
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         , CollectionType: "GetLeagueData~GetDailySummaryDTO"
      })
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO.oDailySummaryDTO = data.oDailySummaryDTO;   
            $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = data.ocAdjustmentNames;   
            $rootScope.oBballInfoDTO.oBballDataDTO.ocAdjustments = data.ocAdjustments;   
            $rootScope.oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO = data.ocPostGameAnalysisDTO;   
            $rootScope.oBballInfoDTO.oBballDataDTO.ocTeams = data.ocTeams;   
            $rootScope.oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = data.ocTodaysMatchupsDTO;   
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