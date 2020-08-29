
'use strict';
var xoBballInfoDTO = {
   UserName: "",
   GameDate: "",
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




var alertDisplay = false;
//alertDisplay = true;

function kdAlert(msg) {
   if (alertDisplay)
      alert(msg);
}
angular.module('app', []);

   //.config(["", function () {
   //   $rootScope.oBballInfoDTO = oBballInfoDTO;

   //}]) ;

//angular.module("app", [])
//   .component("helloWorld", {
//      templateUrl: 'Components/helloWorld.html'
//      , bindings: { name: '@' }
//   });

//angular.module("app", [])
//   .component("accordianSection", {
//      templateUrl: 'Components/accordianSection.html'
//      , bindings: { heading: '@', id: '@', html1: '@' }
//   });
