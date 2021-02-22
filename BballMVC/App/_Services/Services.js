angular.module('app').service('url', function () {
   const urlPrefix = "../../api/";
   // Adjustments
 // 01/25/2021  this.UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
   this.UrlPostAdjustmentUpdates = urlPrefix + "Adjustments/PostAdjustmentUpdates";
 // 01/25/2021    this.UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
   this.UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";
   this.UrlGetAdjustmentsByTeam = urlPrefix + "Adjustments/GetAdjustmentsByTeam";
  // this.UrlUpdateYesterdaysAdjustments = urlPrefix + "Adjustments/UpdateYesterdaysAdjustments";

   this.UrlGetLeagueNames = urlPrefix + "Data/GetLeagueNames";
   this.UrlGetData = urlPrefix + "Data/GetData";
   
   this.UrlPostJsonString = urlPrefix + "Data/PostJsonString";
   this.UrlPostData = urlPrefix + "Data/PostData";
   this.UrlPostObject = urlPrefix + "Data/PostObject";
   this.UrlPostTest = urlPrefix + "Data/PostTest";

   this.UrlPostBoxScoresSeeds = urlPrefix + "Data/PostBoxScoresSeeds";
   //this.UrlRefreshCollection = urlPrefix + "Data/RefreshCollection";
   //  this.UrlGetTodaysMatchups = urlPrefix + "TodaysMatchups/GetTodaysMatchups";
   // this.UrlLoadBoxScores = urlPrefix + "TodaysMatchups/LoadBoxScores";
   this.UrlRefreshTodaysMatchups = urlPrefix + "Data/RefreshTodaysMatchups";
   this.UrlGetPastMatchups = urlPrefix + "Data/GetPastMatchups";

   this.UrlLogMessage = urlPrefix + "Log/LogMessage";


});
angular.module('app').service('ajx', function () {
   /*
   processData (default: true)
Type: Boolean
   By default, data passed in to the data option as an object 
   (technically, anything other than a string) will be processed and transformed into a query string, 
   fitting to the default content-type "application/x-www-form-urlencoded". 
   If you want to send a DOMDocument, or other non-processed data, set this option to false.
   */
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
   //JSON.stringify(Data),
   this.AjaxPost = function (URL, Data, ContentType) {
      if (!ContentType)
         ContentType = 'application/json; charset=utf-8';
      var startTime = new Date();
      return new Promise((resolve, reject) => {
         $.ajax({
            url: URL,
            type: 'POST',
            data: JSON.stringify(Data),
            contentType: ContentType,  
            success: function (returnData) {
               returnData.et = new Date() - startTime;
               resolve(returnData);
            },
            error: function (error) {
               reject(error);
            }
         });   // ajax
      });   // Promise
   };  // AjaxPost

   this.AjaxPostString = function (URL, sData, ContentType) {
      var Data = { sJsonString: JSON.stringify(sData) };
      if (!ContentType)
         ContentType = 'application/json; charset=utf-8';
      var startTime = new Date();
      return new Promise((resolve, reject) => {
         $.ajax({
            url: URL,
            type: 'POST',
            data: JSON.stringify(Data),
            contentType: ContentType,
            success: function (returnData) {
               returnData.et = new Date() - startTime;
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
      var userName = typeof x === "undefined" ? "No User" : $rootScope.oBballInfoDTO.UserName;
      var TTILogMessage = {
         UserName: userName,
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
      $("body").removeClass("loading");
      $rootScope.$broadcast('eventOpenAlertModal', msg);


     // alert(msg);
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



   // Date functions
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
   this.GetDayOfWeekLiteral = function (date) {
      //Create an array containing each day, starting with Sunday.
      var weekdays = new Array(
         "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
      );
      //Use the getDay() method to get the day.
      var day = date.getDay();
      //Return the element that corresponds to that index.
      return weekdays[day];
   }
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

// MODAL ============================
   this.ShowModalHideParent = function (Parent, Modal) {
      this.GreyScreen(Parent);
      this.ShowModal(Modal);
   };

   this.ShowParentHideModal = function (Parent, Modal) {
      this.ShowScreen(Parent);
      this.HideModal(Modal);
   };
   // MODAL ============================

   this.screenShow = function (show) {
      return;
      if (show) {
         $('#screen').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
      }
      else {
         $('#screen').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
      }
   };
   this.ShowScreen = function (ScreenID) {
      $('#' + ScreenID).css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
   };

   this.GreyScreen = function (ScreenID) {
      $('#' + ScreenID).css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
   };

   this.ShowModal = function (modalName) {
      $('#' + modalName).css({ "display": "block" });   // Show AdjustmentsByTeam Modal
   };
   this.HideModal = function (modalName) {
      $('#' + modalName).css({ "display": "none" });   // Show AdjustmentsByTeam Modal
   };
   this.showHideModal = function (show) {
      return show ? { "display": "block" } : { "display": "none" };
   };

   this.wrapTag = function (tag, innerHtml) {
      let ar = tag.split(" ");
      return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
   };
});
