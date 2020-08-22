angular.module('app').run(function (f, ajx, url) {

   ajx.AjaxGet(url.UrlUpdateYesterdaysAdjustments)   // Update Yesterdays Adjustments
      .then(data => {
         oBballInfoDTO.BaseDir = data;
      })
      .catch(error => {
         f.DisplayErrorMessage(f.FormatResponse(error));
      });
});