angular.module('app').controller('HeaderController', function ($rootScope, $scope, f, ajx, url) {
   GetLeagueNames();   // on app init

   // funtions
   function GetLeagueNames() {
      // oBballInfoDTO.LeagueName = $scope.LeagueName;

      oBballInfoDTO.UserName = "Test";
      oBballInfoDTO.GameDate = '12/1/2018';
     // url.UrlGetLeagueNames = "../../api/Data/GetLeagueNames";
      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
      ajx.AjaxGet(url.UrlGetLeagueNames, { UserName: oBballInfoDTO.UserName })
         .then(data => {
            oBballInfoDTO = data;   // refresh oBballInfoDTO
            $scope.LeagueNameList = oBballInfoDTO.oBballDataDTO.ocLeagueNames;
            $scope.$apply();
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }; // GetLeagueNames

   $scope.SelectLeague = function () {
      oBballInfoDTO.LeagueName = $scope.LeagueName;
      oBballInfoDTO.UserName = "Test";
      oBballInfoDTO.GameDate = '12/1/2018';

      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

      ajx.AjaxGet(url.UrlGetLeagueData, { UserName: oBballInfoDTO.UserName,  GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })
         .then(data => {
            oBballInfoDTO = data;   // refresh oBballInfoDTO
            $rootScope.$broadcast('populateTodaysMatchups');
            $rootScope.$broadcast('populateAdjustments');
            $rootScope.$broadcast('populateTeams_AdjTypes');
           
            $scope.$emit('showAccordian');
            $scope.$apply;
           // f.DisplayMessage("League Selected");
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
         });
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }; // SelectLeague
});