//import GetAdjustmentInfo from './AdjustmentsFunctions.js';
const urlPrefix = "../../api/";
const UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
const UrlPostProcessUpdates = urlPrefix + "Adjustments/PostProcessUpdates";
const UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
const UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";

//(function () {
   'use strict';
   try {
      const LeagueName = 'NBA';
      var d = new Date();
      alert("App elim2 started - " + d.getMinutes());
      angular.module('app', []);

      angular.module('app').service('ajx', function () {

         this.AjaxGet = function (URL, Data) {
            return new Promise((resolve, reject) => {
               $.ajax({
                  url: URL,
                  type: 'GET',
                  data: Data,
                  contentType: 'application/json; charset=utf-8',
                  success: function (data) {
                     resolve(data);
                  },
                  error: function (error) {
                     reject(error);
                  }
               });   // ajax
            });   // Promise
         };  // AjaxGet

         this.AjaxPost = function (URL, Data) {
            return new Promise((resolve, reject) => {
               $.ajax({
                  url: URL,
                  type: 'POST',
                  data: JSON.stringify(Data),
                  contentType: 'application/json; charset=utf-8',
                  success: function (returnData) {
                     resolve(returnData);
                  },
                  error: function (error) {
                     reject(error);
                  }
               });   // ajax
            });   // Promise
         };  // AjaxPost

         this.fun = function () {

         };
         this.FormatResponse = function (response) {
            return "status: " + response.status + "\n"
               + "statusText: " + response.statusText + "\n"
               + "responseText: " + response.responseText;
         };
      });

      angular.module('app').service('f', function () {

         this.DisplayMessage = function (msg) {
            alert(msg);
         };

         this.FormatResponse = function (response) {
            return "status: " + response.status + "\n"
               + "statusText: " + response.statusText + "\n"
               + "responseText: " + response.responseText;
         };

         this.MessageSuccess = function (msg) {
            alert("Success: " + msg);
         };

         this.parseJsonDate = function (jsonDateString) {
            return new Date(parseInt(jsonDateString.replace('/Date(', '')));
         };

         this.wrapTag = function (tag, innerHtml) {
            let ar = tag.split(" ");
            return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
         };

         this.fun = function () {

         };
      });


      angular.module('app').controller('AdjustmentsController', function ($scope, $compile, f, ajx) {
         $scope.ocAdjustments;
         let rowWasInserted = false;
         let GetAdjustmentsParms = { scope: $scope, compile: $compile, f: f, LeagueName: LeagueName, ajx: ajx };
         //   $scope.setAdjustmentsModal = $scope.showAdjustmentsModal(false);
         GetAdjustmentInfo(GetAdjustmentsParms);

         $scope.InsertAdjustment = function () {

            let oAdjustment = {};
            oAdjustment.LeagueName = LeagueName;

            oAdjustment.AdjustmentType = $scope.AdjustmentType;
            oAdjustment.Team = $scope.Team;
            oAdjustment.AdjustmentAmount = $scope.AdjustmentAmount;
            oAdjustment.Player = $scope.Player;
            oAdjustment.Description = $scope.Description;

            if (!ValidateAdjustmentEntry(oAdjustment, $scope)) {
               return;  // errors in Adj Entry I/P
            }

            $scope.setAdjustmentsModal = $scope.showAdjustmentsModal(false);

            //$('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal

            ajx.AjaxPost(UrlPostInsertAdjustment, oAdjustment)
               .then(data => {
                  rowWasInserted = true;
                  f.MessageSuccess("Insert Complete");
                  $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
               })
               .catch(error => {
                  f.DisplayMessage("Adjustment Insert Error/n" + f.FormatResponse(error));
                  $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
               });


            $scope.ClearAdjustmentEntryForm();
         }; // InsertAdjustment

         $scope.showAdjustmentsModal = function (show) {
            return show ? { "display": "block" } : { "display": "none" };
         };

         $scope.ProcessUpdates = function () {
            let ocAdjustmentDTO = [];
            let rowNum = 0;
            while ($("#adjAmt_" + rowNum).val() !== undefined) {
               if ($("#cb_" + rowNum).prop('checked')) { // push Delete AdjustmentID
                  ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")) });
               }
               else if ($("#adjAmt_" + rowNum).val()) {  // push Delete AdjustmentID & Adj Amt
                  ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")), AdjustmentAmount: parseFloat($("#adjAmt_" + rowNum).val()) });
               }
               rowNum++;
            }  // while

            if (ocAdjustmentDTO.length === 0) {
               f.DisplayMessage("No Updates were made");
               return;
            }

            GreyOutAdjustmentList();
            // let URL = "api/Adjustments/PostProcessUpdates";
            ajx.AjaxPost(UrlPostProcessUpdates, ocAdjustmentDTO)
               .then(data => {
                  GetAdjustments(GetAdjustmentsParms);
                  f.DisplayMessage("Updates Complete");
                  ShowAdjustmentList();
               })
               .catch(error => {
                  f.DisplayMessage(FormatResponse(error));
               });
         };   // processUpdates 
         $scope.OpenAdjustmentEntryModal = function () {
            rowWasInserted = false;
            $scope.ClearAdjustmentEntryForm();
            GreyOutAdjustmentList();
            $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
         };
         $scope.CancelAdjustmentEntry = function () {    // invoked by Cancel click on Adjustment Entry Modal
            if (rowWasInserted)
               GetAdjustments(GetAdjustmentsParms);
            $('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal
            // Show Adjustments 
            ShowAdjustmentList();
         };

         // --- Validations ---
         $scope.ValidateAdjustmentForm = function () {
            return $scope.AdjustmentType && $scope.ValidateTeam && $scope.ValidateAdjustmentAmount
               && $scope.ValidatePlayer && $scope.ValidateDescription;
         };
         $scope.ValidateAdjustmentType = () => { return $scope.AdjustmentType; };
         $scope.ValidateTeam = function () { return $scope.Team || $scope.AdjustmentType === 'L'; };
         $scope.ValidateAdjustmentAmount = function () {
            return !isNaN($scope.AdjustmentAmount) && $scope.AdjustmentAmount < 10 && $scope.AdjustmentAmount > -10;
         };
         $scope.ValidatePlayer = function () { return !(!Player && (AdjustmentType === 'I' || AdjustmentType === 'R')); };
         $scope.ValidateDescription = function () { return $scope.Description; };


         $scope.ValidateAdjustmentEntry = function () {
            var rc = true;

            validateField(oAdjustment.AdjustmentType, "errAdjustmentType");
            if (oAdjustment.AdjustmentType !== "L") validateField(oAdjustment.Team, "errTeam");
            validateField(oAdjustment.AdjustmentAmount, "errAdjustmentAmount");
            if (oAdjustment.AdjustmentType === "I") validateField(oAdjustment.Player, "errPlayer");
            validateField(oAdjustment.Description, "errDescription");

            return rc;

            function validateFieldNG(input, errName, b) {
               if (IsEmpty(input)) {
                  rc = false;
                  b = true;
               } else {
                  b = false;
               }
            }

            function validateField(input, errName) {
               if (IsEmpty(input)) {
                  rc = false;
                  $('#' + errName).css({ "display": "block", "color": "red", "background": "yellow" });
               } else {
                  $('#' + errName).css({ "display": "none" });
               }
            }
            function IsEmpty(input) {
               return !input || !input.trim();
            }
         };

         $scope.ClearAdjustmentEntryForm = function () {
            $scope.AdjustmentType = "";
            $scope.Team = "";
            $scope.AdjustmentAmount = "";
            $scope.AdjustmentAmount = "1";
            $scope.Player = "";
            $scope.Description = "";

         };
      }); // controller
   }
   catch (error) {
      console.error(error);
   }
// })(); // main

function ValidateAdjustmentEntry(oAdjustment, scope) {
   var rc = true;

   validateField(oAdjustment.AdjustmentType, "errAdjustmentType");
   if (oAdjustment.AdjustmentType !== "L") validateField(oAdjustment.Team, "errTeam");
   validateField(oAdjustment.AdjustmentAmount, "errAdjustmentAmount");
   if (oAdjustment.AdjustmentType === "I") validateField(oAdjustment.Player, "errPlayer");
   validateField(oAdjustment.Description, "errDescription");

   return rc;

   function validateFieldNG(input, errName, b) {
      if (IsEmpty(input)) {
         rc = false;
         b = true;
      } else {
         b = false;
      }
   }

   function validateField(input, errName) {
      if (IsEmpty(input)) {
         rc = false;
         $('#' + errName).css({ "display": "block", "color": "red", "background": "yellow" });
      } else {
         $('#' + errName).css({ "display": "none" });
      }
   }
   function IsEmpty(input) {
      return !input || !input.trim();
   }
}

function GetAdjustmentInfo(Parms) { // called once at Controller init
   var f = Parms.f;
   var ajx = Parms.ajx;
   const Data = { LeagueName: Parms.LeagueName };
   let fProcessAdjustmentInfo = {
      scope: Parms.scope
      , compile: Parms.compile
      , process: function (oAdjustmentInitDataDTO) {
         GetAdjustments(Parms);
         // Populate Teams DropDown form Adjustment Entry

         this.scope.TeamList = oAdjustmentInitDataDTO.ocTeams;
         this.scope.AdjustmentNameList = oAdjustmentInitDataDTO.ocAdjustmentNames;
      }
   }; // fProcessAdjustmentInfo

   ajx.AjaxGet(UrlGetAdjustmentInfo, Data)
      .then(data => {
         fProcessAdjustmentInfo.process(data);
      })
      .catch(error => {
         f.DisplayMessage(FormatResponse(error));
      });
   return;
}  // GetAdjustmentInfo

function GetAdjustments(Parms) {
   var f = Parms.f;
   var ajx = Parms.ajx;
   //   let Data = { LeagueName: Parms.LeagueName };
   let fProcessAdjustments = {
      scope: Parms.scope
      , compile: Parms.compile
      , process: function (ocAdjustments) {
         Parms.scope.ocAdjustments = ocAdjustments;
         Parms.scope.ocAdjustments.forEach(function (item) {
            item.cb_ID = "cb_" + item.AdjustmentID;
         });

         Parms.scope.$apply();
         // DisplayAdjustments(Parms, ocAdjustments);
      }
   }; // fProcessAdjustments

   ajx.AjaxGet(UrlGetAdjustments, { LeagueName: Parms.LeagueName })   // Get Adjustments from server
      .then(data => {
         fProcessAdjustments.process(data);
      })
      .catch(error => {
         f.DisplayMessage(FormatResponse(error));
      });

}  // GetAdjustments


function FormatResponse(response) {
   if (response.status !== undefined) {
      return "status: " + response.status + "\n"
         + "statusText: " + response.statusText + "\n"
         + "responseText: " + response.responseText;
   }
   if (response.message !== undefined) {
      return response.message;
   }
   return response;
}

function ShowAdjustmentList() {
   $('#AdjustmentsList').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
}
// grey out Adjustments
function GreyOutAdjustmentList() {
   $('#AdjustmentsList').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
}



