﻿angular.module('app').run(function (f, ajx, url, $rootScope) {
   kdAlert("run");
   $rootScope.ADJUSTMENTSLISTCONTAINER = "AdjustmentsListContainer";
   $rootScope.RefreshTodaysMatchupsState = true;

   

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
      oSeasonInfoDTO: {},
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

   ajx.AjaxGet(url.UrlGetData, {
      UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
      , LeagueName: "", CollectionType: "AppInit"
   })
      .then(oBballInfoDTO => {
         let oBballDataDTO = oBballInfoDTO.oBballDataDTO;    // 10/09/2021 - oBballInfoDTO returned instead of oBballDataDTO
         $rootScope.oBballInfoDTO.ElapsedTimeAppInit = oBballDataDTO.et; //alert("AppInit ET: " + oBballDataDTO.et);
         $rootScope.oBballInfoDTO.BaseDir = oBballDataDTO.BaseDir;
         $rootScope.DataConstants = oBballDataDTO.DataConstants;
         $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames = oBballDataDTO.ocLeagueNames;
         $rootScope.oBballInfoDTO.ConnectionString = oBballInfoDTO.ConnectionString;
         $rootScope.oBballInfoDTO.BaseDirectory = oBballInfoDTO.BaseDirectory;
         $rootScope.$broadcast('eventPopulateLeagueNamesDropDown');
         if (oBballDataDTO.MessageNumber !== 0) {
            f.DisplayErrorMessage(oBballDataDTO.Message);
         }
      })
      .catch(error => {
         alert("Error caught in Run.js Initial GetData-AppInit call");
         f.DisplayErrorMessage(f.FormatResponse(error));
      });
});