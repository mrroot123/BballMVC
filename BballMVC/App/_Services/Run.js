angular.module('app').run(function (f, ajx, url, $rootScope) {
   kdAlert("run");
   
   $rootScope.oBballInfoDTO = 
   {
      UserName: "",
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

   ajx.AjaxGet(url.UrlUpdateYesterdaysAdjustments)   // Update Yesterdays Adjustments
      .then(data => {
         $rootScope.oBballInfoDTO.BaseDir = data;
      })
      .catch(error => {
         f.DisplayErrorMessage(f.FormatResponse(error));
      });
});