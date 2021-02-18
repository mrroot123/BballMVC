
// Add remove loading class on body element depending on Ajax request status
   $(document).on({
      ajaxStart: function () {
         //alert("ajaxStart");
         $("body").addClass("loading");
      },
      ajaxStop: function () {
        // alert("ajaxStop");
         $("body").removeClass("loading");
      }
   });
