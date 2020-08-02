
'use strict';
angular.module('app').controller('BoxScoresSeedsController', function ($scope, f, url, ajx) {

   $scope.PopulateBoxScoresSeeds = function () {

      $scope.LeagueName = oBballInfoDTO.LeagueName;
      $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });

      ajx.AjaxGet(url.UrlGetBoxScoresSeeds, { UserName: oBballInfoDTO.UserName, GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName })
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO = data;
            $scope.ocBoxScoresSeedsDTO = oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO;
            $scope.$apply;
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
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

      let oBBSdata = {
         UserName: oBballInfoDTO.UserName
         , GameDate: oBballInfoDTO.GameDate
         , LeagueName: oBballInfoDTO.LeagueName
         , ocBBSupdates: ocBBSupdates
      };

      $('#screen').css({ oBBSdata });

      ajx.AjaxPost(url.UrlPostBoxScoresSeeds
         , {
            UserName: oBballInfoDTO.UserName, GameDate: oBballInfoDTO.GameDate, LeagueName: oBballInfoDTO.LeagueName
               , ocBBSupdates: ocBBSupdates
         })
         .then(data => {
            oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO = data;   
            $scope.ocBoxScoresSeedsDTO = oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO;
            $scope.$apply;
         })
         .catch(error => {
            f.DisplayMessage(f.FormatResponse(error));
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
