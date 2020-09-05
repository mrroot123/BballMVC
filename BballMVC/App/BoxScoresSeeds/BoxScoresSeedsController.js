
'use strict';
angular.module('app').controller('BoxScoresSeedsController', function ($rootScope, $scope, f, url, ajx) {
   kdAlert("BxSeedController");

   $scope.PopulateBoxScoresSeeds = function () {

      $scope.LeagueName = $rootScope.oBballInfoDTO.LeagueName;
      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

      ajx.AjaxGet(url.UrlGetData, {
         UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toDateString()
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName, CollectionType: "GetBoxScoresSeeds"
      })
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO = data;
            $scope.ocBoxScoresSeedsDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO;
            $scope.$apply;
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }; // PopulateBoxScoresSeeds

   $scope.UpdateBoxScoresSeeds = function () {
      let ocBBSupdates = [];
      let rowNum = 0;
      while ($("#AdjustmentAmountMade_" + rowNum).val() !== undefined) {
         ocBBSupdates.push({
               Team: $("#Team_" + rowNum).text(),
            AdjustmentAmountMade: parseInt($("#AdjustmentAmountMade_" + rowNum).val()),
            AdjustmentAmountAllowed: parseInt($("#AdjustmentAmountAllowed_" + rowNum).val())
         });

         rowNum++;
      }  // while

      /* kd 8/28/2020 not a clue what this css does
      let oBBSdata = {
         UserName: $rootScope.oBballInfoDTO.UserName
         , GameDate: $rootScope.oBballInfoDTO.GameDate
         , LeagueName: $rootScope.oBballInfoDTO.LeagueName
         , ocBBSupdates: ocBBSupdates
      };
      $('#screen').css({ oBBSdata });  */

      ajx.AjaxPost(url.UrlPostBoxScoresSeeds
         , {
            UserName: $rootScope.oBballInfoDTO.UserName, GameDate: $rootScope.oBballInfoDTO.GameDate.toDateString(), LeagueName: $rootScope.oBballInfoDTO.LeagueName
               , ocBBSupdates: ocBBSupdates
         })
         .then(data => {
            $rootScope.oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO = data;   
            $scope.ocBoxScoresSeedsDTO = $rootScope.oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO;
            $scope.$apply;
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
      $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });

   }; // UpdateBoxScoresSeeds

   
   $scope.CalcProp = function (prop) {
      return 1.1;
   };

   $scope.adjScoredChange = function (oAdj) {
      var x = oAdj.index;
   };
});   // controller
