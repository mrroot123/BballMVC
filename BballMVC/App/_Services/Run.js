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

   $rootScope.Getmdy = function (d) {
      return f.Getmdy(d);
   };
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

   //ajx.AjaxGet(url.UrlRefreshBballInfo)
   //   .then(oBballInfoDTO => {
   //      $rootScope.oBballInfoDTO = oBballInfoDTO;
   //   })
   //   .catch(error => {
   //      alert("Error caught in Run.js Initial RefreshBballInfo call");
   //      f.DisplayErrorMessage(f.FormatResponse(error));
   //   });

   // Populate Global Dropdowns
   // LeagueNames
   // Adj Types

   ajx.AjaxGet(url.UrlGetData, {
   //   testIt();
      UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
      , LeagueName: "", CollectionType: "AppInit"
   })
      .then(oBballInfoDTO => {
         let oBballDataDTO = oBballInfoDTO.oBballDataDTO;    // 10/09/2021 - oBballInfoDTO returned instead of oBballDataDTO

         $rootScope.oBballInfoDTO.ElapsedTimeAppInit = oBballDataDTO.et; //alert("AppInit ET: " + oBballDataDTO.et);
        // $rootScope.oBballInfoDTO.BaseDir = oBballDataDTO.BaseDir;
         $rootScope.oBballInfoDTO.BaseDirectory = oBballInfoDTO.BaseDirectory;
      //   $rootScope.DataConstants = oBballDataDTO.DataConstants;
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