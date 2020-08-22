angular.module('app').service('url', function () {
   const urlPrefix = "../../api/";
   this.UrlGetLeagueNames = urlPrefix + "Data/GetLeagueNames";
   this.UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
   this.UrlPostAdjustmentUpdates = urlPrefix + "Adjustments/PostAdjustmentUpdates";
   this.UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
   this.UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";
   this.UrlUpdateYesterdaysAdjustments = urlPrefix + "Adjustments/UpdateYesterdaysAdjustments";
   this.UrlGetLeagueData = urlPrefix + "Data/GetLeagueData";
   this.UrlGetBoxScoresSeeds = urlPrefix + "Data/GetBoxScoresSeeds";
   this.UrlPostBoxScoresSeeds = urlPrefix + "Data/PostBoxScoresSeeds";
   this.UrlPostBoxScoresSeeds = urlPrefix + "Data/PostBoxScoresSeeds";
   //  this.UrlGetTodaysMatchups = urlPrefix + "TodaysMatchups/GetTodaysMatchups";
   // this.UrlLoadBoxScores = urlPrefix + "TodaysMatchups/LoadBoxScores";
   this.UrlRefreshTodaysMatchups = urlPrefix + "Data/RefreshTodaysMatchups";


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

angular.module('app').service('f', function (ajx) {
   this.DisplayErrorMessage = function (msg) {
      var TTILogMessage = {
         UserName: oBballInfoDTO.UserName,
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
      //ajx.AjaxPost(u, TTILogMessage)
      //   .then(data => {
      //      alert(data);
      //     // this.DisplayMessage(data);
      //   })
      //   .catch(error => {
      //      alert(error);
      //     // this.DisplayMessage(f.FormatResponse(error));
      //   });


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
      return (d.getMonth() + 1) + "/" + d.getDate() + "/" + (d.getYear() + 1900);
   };

   this.MessageSuccess = function (msg) {
      alert("Success: " + msg);
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
