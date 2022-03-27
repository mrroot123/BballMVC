'use strict';

//import { testIt } from '_Services/CommonCode.js'

angular.module('app').run(function (f, ajx, url, $rootScope, JsonToHtml) {
   kdAlert("run");
   $rootScope.ADJUSTMENTSLISTCONTAINER = "AdjustmentsListContainer";
   
   // Global functions
   $rootScope.ParentContainerName = true;
   $rootScope.OpenModal = function (thisObj, ParentContainerName, Modal, eventBroadcast) {

      // Note: eventBroadcast = 'eventOpen' + Modal
      // ex: 'AdjustmentsByTeamModal', 'eventOpenAdjustmentsByTeamModal'
      f.ShowModalHideParent($rootScope.ParentContainerName, Modal);
      if (eventBroadcast)
         $rootScope.$broadcast(eventBroadcast, thisObj);

   }; // OpenModal


   // ng-click="CloseModal(this, 'AdjustmentsListContainer', 'AdjustmentsModal', 'eventGetAdjustments' )"
   $rootScope.CloseModal = function (thisObj, ParentContainerName, Modal, eventBroadcast) {

      f.ShowParentHideModal($rootScope.ParentContainerName, Modal);
      if (eventBroadcast)
         $rootScope.$broadcast(eventBroadcast, thisObj);
   }; // CloseModal

   $rootScope.OpenInlineModal = function (modal, stringOfJsonParms, trID) {
      alert("OpenInlineModal hit");
      // Call ajax to get Json Sql
      // Exec jsonToHtml
      // Append Html to trID

      ajx.AjaxGet(url.UrlGetJsonSql, {
         Modal: modal, Parms: stringOfJsonParms
      })
         .then(oBballInfoDTO => {
            let html = JsonToHtml.jsonToHtml(oBballInfoDTO.oBballDataDTO.JsonSql);
            $("#" + trID.$index).closest('tr').after(html);

         })
         .catch(error => {
            alert("Error caught in OpenInlineModal");
            f.DisplayErrorMessage(f.FormatResponse(error));
         });

   }; // OpenInlineModal

   //$rootScope.Getmdy = function (d) {  2/6/2022 - kdtodo commented --- delete after confirmation
   //   return f.Getmdy(d);
   //};
   //  ng-class="applyMinusRedColor({{item.PlayDiff}} )"
   // kdtodo 11/24/2021 move to functions
   $rootScope.applyMinusRedColor = function (n1, n2) {
      try {

         if (!n1)
            return "";

         if (!n2)
            n2 = 0;  

         if (n1 < n2)
            return "redFG";
         // style = 'color:red;'
         return "";
      }
      catch {
         alert(n1 + '-' + n2);
      }
   };
   // global end

   $rootScope.oBballInfoDTO = 
   {
      UserName: "Test",
      GameDate: "",
      newGameDate: "",
      LeagueName: "",
      BaseDir: "",
      TTILogMessage: {
         AppName: "Bball",
         UserName: "Test",
         TS: "",
         MessageNum: 0,
         MessageText: "",
         CallStack: ""
      },
      TTILogUrl: "",
    //  oSeasonInfoDTO: {},
      oBballDataDTO: {}
   };

   Date.prototype.addDays = function (noOfDays) {
      var tmpDate = new Date(this.valueOf());
      tmpDate.setDate(tmpDate.getDate() + noOfDays);
      return tmpDate;
   }

   Date.prototype.getDayOfWeekLiteral = function () {
      //Create an array containing each day, starting with Sunday.
      var weekdays = new Array(
         "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
      );
      //Use the getDay() method to get the day.
      var day = this.getDay();
      //Return the element that corresponds to that index.
      return weekdays[day];
   }
   Date.prototype.getMDYwithSeperator = function (sep) {
      if (!sep)
         sep = "/";
      return (this.getMonth() + 1) + sep + this.getDate() + sep + (this.getYear() + 1900);
   };
   Date.prototype.setToSunday = function () {
      var n = this.getDay();
      n = (7 - (n - 7) % 7) % 7;
      return this.addDays(n);
   }
   Date.prototype.yesterday = function (noOfDays) {
      return new Date() - 1;
   }


   // Populate Global Dropdowns
   // LeagueNames
   // Adj Types

   let Async = true;
   let URL = Async ? url.UrlGetDataAsync : url.UrlGetData;
   let collectionType = Async ? "AppInitAsync" : "AppInit";

   ajx.AjaxGet(URL, {
   //   testIt();
      UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
      , LeagueName: "", CollectionType: collectionType
   })
      .then(oBballInfoDTO => {
         let oBballDataDTO = oBballInfoDTO.oBballDataDTO;    // 10/09/2021 - oBballInfoDTO returned instead of oBballDataDTO

         $rootScope.oBballInfoDTO.ElapsedTimeAppInit = oBballDataDTO.et; //alert("AppInit ET: " + oBballDataDTO.et);
         $rootScope.oBballInfoDTO.BaseDirectory = oBballInfoDTO.BaseDirectory;
         $rootScope.oBballInfoDTO.ConnectionString = oBballInfoDTO.ConnectionString;

         $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames = oBballDataDTO.ocLeagueNames;
         
         $rootScope.$broadcast('eventPopulateLeagueNamesDropDown');
         if (oBballDataDTO.MessageNumber !== 0) {
            f.DisplayErrorMessage(oBballDataDTO.Message);
         }
      })
      .catch(error => {
         alert("Error caught in Run.js Initial GetData-AppInit call");
         f.DisplayErrorMessage(f.FormatResponse(error));
      });   // AjaxGet
});