app.config(function ($provide) {
   $provide.provider('globalsetting', function () {
      this.$get = function () {
         var appname = "Lawyer App";
         return {
            appName: appname
         };
      }
   })
});
