angular.module('app').service('url', function () {
   const urlPrefix = "../../api/";
   // Adjustments
   this.UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
   this.UrlPostAdjustmentUpdates = urlPrefix + "Adjustments/PostAdjustmentUpdates";
   this.UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
   this.UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";
   this.UrlUpdateYesterdaysAdjustments = urlPrefix + "Adjustments/UpdateYesterdaysAdjustments";

   this.UrlGetLeagueNames = urlPrefix + "Data/GetLeagueNames";
   this.UrlGetData = urlPrefix + "Data/GetData";

   this.UrlGetBoxScoresSeeds = urlPrefix + "Data/GetBoxScoresSeeds";
   this.UrlPostBoxScoresSeeds = urlPrefix + "Data/PostBoxScoresSeeds";
   //this.UrlRefreshCollection = urlPrefix + "Data/RefreshCollection";
   //  this.UrlGetTodaysMatchups = urlPrefix + "TodaysMatchups/GetTodaysMatchups";
   // this.UrlLoadBoxScores = urlPrefix + "TodaysMatchups/LoadBoxScores";
   this.UrlRefreshTodaysMatchups = urlPrefix + "Data/RefreshTodaysMatchups";

   this.UrlLogMessage = urlPrefix + "Log/LogMessage";


});
angular.module('app').service('ajx', function () {

   this.AjaxGet = function (URL, Data) {
      var startTime = new Date();
      return new Promise((resolve, reject) => {
         $.ajax({
            url: URL,
            type: 'GET',
            data: Data,
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
               data.et = new Date() - startTime;
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

angular.module('app').service('f', function ($rootScope, ajx, url) {
   this.DisplayErrorMessage = function (msg) {
      var TTILogMessage = {
         UserName: $rootScope.oBballInfoDTO.UserName,
         ApplicationName: "Bball",
         TS: new Date(),
         MessageNum: 0,
         MessageText: msg,
         MessageType: "Error"
      };
      //var uu = "http://www.ttilog.com.violet.arvixe.com/api/Log/GetMessage?s=aabbcc";   // oBballInfoDTO.TTILogUrl
      //// uu = "http://localhost:3000/api/Log/GetMessage?s=aabbcc";   // oBballInfoDTO.TTILogUrl
      //ajx.AjaxGet(uu)
      //   .then(data => {
      //      alert(data);
      //      // this.DisplayMessage(data);
      //   })
      //   .catch(error => {
      //      alert(error);
      //      // this.DisplayMessage(f.FormatResponse(error));
      //   });
      //var u = "http://www.ttilog.com.violet.arvixe.com/api/Log/LogMessage";   // oBballInfoDTO.TTILogUrl
      ajx.AjaxPost(url.UrlLogMessage, TTILogMessage)
         .then(data => {
           // alert(data);
           // this.DisplayMessage(data);
         })
         .catch(error => {
            alert(error);
           // this.DisplayMessage(f.FormatResponse(error));
         });


      alert(msg);
   };

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

   this.Getmdy = function (d) {
      if (typeof (d) === "string")
         d = new Date(d);
      return (d.getMonth() + 1) + "/" + d.getDate() + "/" + (d.getYear() + 1900);
   };
   this.Today = function () {
      return new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
   };
   this.Yesterday = function () {
      return new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 1);
   };

   //
   // Messages
   //
   this.MessageError = function (msg) {
      alert(msg);
   };
   this.MessageInformational = function (msg) {
      alert(msg);
   };

   this.MessageSuccess = function (msg) {
      alert("Success: " + msg);
   };
   this.MessageWarning = function (msg) {
      alert(msg);
   };

   this.parseJsonDate = function (jsonDateString) {
      return new Date(parseInt(jsonDateString.replace('/Date(', '')));
   };

   this.ShowScreen = function (ScreenID) {
      $('#' + ScreenID).css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
   };

   this.GreyScreen = function (ScreenID) {
      $('#' + ScreenID).css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
   };

   this.showHideModal = function (show) {
      return show ? { "display": "block" } : { "display": "none" };
   };

   this.wrapTag = function (tag, innerHtml) {
      let ar = tag.split(" ");
      return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
   };
});
