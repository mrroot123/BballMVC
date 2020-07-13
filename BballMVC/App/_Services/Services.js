angular.module('app').service('url', function () {
   const urlPrefix = "../../api/";
   this.UrlGetLeagueNames = urlPrefix + "Data/GetLeagueNames";
   this.UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
   this.UrlPostProcessUpdates = urlPrefix + "Adjustments/PostProcessUpdates";
   this.UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
   this.UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";
   this.UrlGetLeagueData = urlPrefix + "Data/GetLeagueData";
   this.UrlGetTodaysMatchups = urlPrefix + "TodaysMatchups/GetTodaysMatchups";
   

});
angular.module('app').service('ajx', function () {

   this.AjaxGet = function (URL, Data) {
      return new Promise((resolve, reject) => {
         $.ajax({
            url: URL,
            type: 'GET',
            data: Data,
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
               resolve(data);
            },
            error: function (error) {
               reject(error);
            }
         });   // ajax
      });   // Promise
   };  // AjaxGet

   this.AjaxPost = function (URL, Data) {
      return new Promise((resolve, reject) => {
         $.ajax({
            url: URL,
            type: 'POST',
            data: JSON.stringify(Data),
            contentType: 'application/json; charset=utf-8',
            success: function (returnData) {
               resolve(returnData);
            },
            error: function (error) {
               reject(error);
            }
         });   // ajax
      });   // Promise
   };  // AjaxPost

});

angular.module('app').service('f', function () {

   this.DisplayMessage = function (msg) {
      alert(msg);
   };

   this.FormatResponse = function (response) {
      var msg;
      if (response.status !== undefined)
         msg += "status: " + response.status + "\n";
      if (response.statusText !== undefined)
         msg += "statusText: " + response.statusText + "\n";
      if (response.responseText !== undefined)
         msg += "responseText: " + response.responseText + "\n";
      if (response.message !== undefined)
         msg += "message: " + response.message + "\n";
      if (response.stack !== undefined)
         msg += "stack: " + response.stack + "\n";

      return msg;
   };

   this.MessageSuccess = function (msg) {
      alert("Success: " + msg);
   };

   this.parseJsonDate = function (jsonDateString) {
      return new Date(parseInt(jsonDateString.replace('/Date(', '')));
   };

   this.showHideModal = function (show) {
      return show ? { "display": "block" } : { "display": "none" };
   };

   this.wrapTag = function (tag, innerHtml) {
      let ar = tag.split(" ");
      return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
   };
});
