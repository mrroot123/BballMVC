angular.module('app').run(function (f, ajx, url, $rootScope) {
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

   ajx.AjaxGet(url.UrlGetData, {
      UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
      , LeagueName: "", CollectionType: "AppInit"
   })
      .then(oBballDataDTO => {
         $rootScope.oBballInfoDTO.ElapsedTimeAppInit = oBballDataDTO.et; //alert("AppInit ET: " + oBballDataDTO.et);
         $rootScope.oBballInfoDTO.BaseDir = oBballDataDTO.BaseDir;
         $rootScope.DataConstants = oBballDataDTO.DataConstants;
         $rootScope.oBballInfoDTO.oBballDataDTO.ocLeagueNames = oBballDataDTO.ocLeagueNames;
         $rootScope.$broadcast('eventPopulateLeagueNamesDropDown');
      })
      .catch(error => {
         f.DisplayErrorMessage(f.FormatResponse(error));
      });
});