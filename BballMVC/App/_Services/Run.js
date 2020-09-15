angular.module('app').run(function (f, ajx, url, $rootScope) {
   kdAlert("run");
   
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
   //debugger;
   //aj2(url.UrlPostTest, {mystring: 2})
   //   .then(data => {
   //      f.MessageSuccess(o.ocTodaysPlaysDTO.length + " Plays Processed");
   //   })
   //   .catch(error => {
   //      f.DisplayErrorMessage("Process Plays Error/n" + f.FormatResponse(error));
   //   });
   //function aj2(URL, sData, ContentType) {
   //   ContentType = 'application/json; charset=utf-8';
   //   URL = "../../api/" + "Data/PostJsonString?CollectionType=ProcessPlays";

   //   var Data = { sJsonString: JSON.stringify(sData) };     //  JSON.stringify(sData) };
   //   if (!ContentType)
   //      ContentType = 'application/json; charset=utf-8';
   //   var startTime = new Date();
   //   return new Promise((resolve, reject) => {
   //      $.ajax({
   //         url: URL,
   //         type: 'POST',
   //         data: JSON.stringify(Data),
   //         contentType: ContentType,
   //         success: function (returnData) {
   //            returnData.et = new Date() - startTime;
   //            resolve(returnData);
   //         },
   //         error: function (error) {
   //            reject(error);
   //         }
   //      });   // ajax
   //   });   // Promise
   //};  // AjaxPost
   //function aj(URL, sData, ContentType) {
   //   var Data = { MyString: sData };
   //   if (!ContentType)
   //      ContentType = 'application/json; charset=utf-8';
   //   var startTime = new Date();
   //   return new Promise((resolve, reject) => {
   //      $.ajax({
   //         url: URL,
   //         type: 'POST',
   //         data: JSON.stringify(Data),
   //         contentType: ContentType,
   //         success: function (returnData) {
   //            returnData.et = new Date() - startTime;
   //            resolve(returnData);
   //         },
   //         error: function (error) {
   //            reject(error);
   //         }
   //      });   // ajax
   //   });   // Promise
   //};  // AjaxPost

   ajx.AjaxGet(url.UrlGetData, {
      UserName: $rootScope.oBballInfoDTO.UserName, GameDate: new Date().toDateString()
      , LeagueName: "", CollectionType: "AppInit"
   })
      .then(oBballDataDTO => {
         $rootScope.oBballInfoDTO.ElapsedTimeAppInit = oBballDataDTO.et; //alert("AppInit ET: " + oBballDataDTO.et);
         $rootScope.oBballInfoDTO.BaseDir = oBballDataDTO.BaseDir;
         $rootScope.DataConstants = oBballDataDTO.DataConstants;
      })
      .catch(error => {
         f.DisplayErrorMessage(f.FormatResponse(error));
      });
});