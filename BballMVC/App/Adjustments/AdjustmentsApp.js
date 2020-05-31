//import GetAdjustmentInfo from './AdjustmentsFunctions.js';
const urlPrefix = "../../api/";
const UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
const UrlPostProcessUpdates = urlPrefix + "Adjustments/PostProcessUpdates";
const UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
const UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";
const UrlGetTodaysMatchups = urlPrefix + "TodaysMatchups/GetTodaysMatchups";


   'use strict';

const LeagueName = 'NBA';
const GameDate = "12/01/2018";
   angular.module('app', []);

   //angular.module('app').service('url', function () {
   //   const urlPrefix = "../../api/";
   //   this.UrlPostInsertAdjustment = urlPrefix + "Adjustments/PostInsertAdjustment";
   //   this.UrlPostProcessUpdates = urlPrefix + "Adjustments/PostProcessUpdates";
   //   this.UrlGetAdjustmentInfo = urlPrefix + "Adjustments/GetAdjustmentInfo";
   //   this.UrlGetAdjustments = urlPrefix + "Adjustments/GetAdjustments";

   //   this.UrlGetTodaysMatchups = urlPrefix + "TodaysMatchups/GetTodaysMatchups";

   //});
   //angular.module('app').service('ajx', function () {

   //   this.AjaxGet = function (URL, Data) {
   //      return new Promise((resolve, reject) => {
   //         $.ajax({
   //            url: URL,
   //            type: 'GET',
   //            data: Data,
   //            contentType: 'application/json; charset=utf-8',
   //            success: function (data) {
   //               resolve(data);
   //            },
   //            error: function (error) {
   //               reject(error);
   //            }
   //         });   // ajax
   //      });   // Promise
   //   };  // AjaxGet

   //   this.AjaxPost = function (URL, Data) {
   //      return new Promise((resolve, reject) => {
   //         $.ajax({
   //            url: URL,
   //            type: 'POST',
   //            data: JSON.stringify(Data),
   //            contentType: 'application/json; charset=utf-8',
   //            success: function (returnData) {
   //               resolve(returnData);
   //            },
   //            error: function (error) {
   //               reject(error);
   //            }
   //         });   // ajax
   //      });   // Promise
   //   };  // AjaxPost

   //});

   //angular.module('app').service('f', function () {

   //   this.DisplayMessage = function (msg) {
   //      alert(msg);
   //   };

   //   this.FormatResponse = function (response) {
   //      return "status: " + response.status + "\n"
   //         + "statusText: " + response.statusText + "\n"
   //         + "responseText: " + response.responseText;
   //   };

   //   this.MessageSuccess = function (msg) {
   //      alert("Success: " + msg);
   //   };

   //   this.parseJsonDate = function (jsonDateString) {
   //      return new Date(parseInt(jsonDateString.replace('/Date(', '')));
   //   };

   //   this.showHideModal = function (show) {
   //      return show ? { "display": "block" } : { "display": "none" };
   //   };

   //   this.wrapTag = function (tag, innerHtml) {
   //      let ar = tag.split(" ");
   //      return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
   //   };
   //});

   //angular.module('app').controller('AdjustmentsController', function ($scope,  f, ajx) {
   //   $scope.ocAdjustments;
   //   let rowWasInserted = false;
   //   let GetAdjustmentsParms = { scope: $scope, f: f, LeagueName: LeagueName, ajx: ajx };
   //   GetAdjustmentInfo(GetAdjustmentsParms);

   //   $scope.cbChange = function (adjAmtID) {
   //      alert("cb");
   //   };
   //   $scope.ProcessUpdates = function () {
   //      let ocAdjustmentDTO = [];
   //      let rowNum = 0;
   //      while ($("#adjAmt_" + rowNum).val() !== undefined) {
   //         if ($("#cb_" + rowNum).prop('checked')) { // push Delete AdjustmentID
   //            ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")) });
   //         }
   //         else if ($("#adjAmt_" + rowNum).val()) {  // push Delete AdjustmentID & Adj Amt
   //            ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-AdjustmentID")), AdjustmentAmount: parseFloat($("#adjAmt_" + rowNum).val()) });
   //         }
   //         rowNum++;
   //      }  // while

   //      if (ocAdjustmentDTO.length === 0) {
   //         f.DisplayMessage("No Updates were made");
   //         return;
   //      }

   //      $scope.GreyOutAdjustmentList();
   //      // let URL = "api/Adjustments/PostProcessUpdates";
   //      ajx.AjaxPost(UrlPostProcessUpdates, ocAdjustmentDTO)
   //         .then(data => {
   //            $scope.GetAdjustments($scope, f, ajx);  //GetAdjustments(GetAdjustmentsParms);
   //            f.DisplayMessage("Updates Complete");
   //            $scope.ShowAdjustmentList();
   //         })
   //         .catch(error => {
   //            f.DisplayMessage(f.FormatResponse(error));
   //         });
   //   };   // processUpdates 
   //   $scope.OpenAdjustmentEntryModal = function () {
   //      $scope.GreyOutAdjustmentList
   //      $scope.$broadcast('OpenAdjustmentEntryModalEvent');
   //   };
   //   $scope.$on('CloseAdjustmentEntry', function (e, rowWasInserted) {
   //      if (rowWasInserted)
   //         $scope.GetAdjustments($scope, f, ajx);
   //      $scope.ShowAdjustmentList();
   //   });

   //   $scope.GetAdjustments = function ($scope, f, ajx) {
   //      let refreshAdjustments = function (ocAdjustments) {
   //         $scope.ocAdjustments = ocAdjustments;
   //         $scope.ocAdjustments.forEach(function (item) {
   //            item.cb_ID = "cb_" + item.AdjustmentID;
   //         });
   //         $scope.$apply();
   //      };

   //      ajx.AjaxGet(UrlGetAdjustments, { LeagueName: LeagueName })   // Get Adjustments from server
   //         .then(data => {
   //            refreshAdjustments(data);
   //         })
   //         .catch(error => {
   //            f.DisplayMessage(f.FormatResponse(error));
   //         });
   //   }; // GetAdjustments

   //   $scope.ShowAdjustmentList = function () {
   //      $('#AdjustmentsList').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
   //   };
   //   // grey out Adjustments
   //   $scope.GreyOutAdjustmentList = function () {
   //      $('#AdjustmentsList').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
   //   };

   //   function GetAdjustmentInfo(Parms) { // called once at Controller init
   //      var f = Parms.f;
   //      var ajx = Parms.ajx;
   //      let fProcessAdjustmentInfo = {
   //         scope: Parms.scope
   //         , process: function (oAdjustmentInitDataDTO) {
   //            $scope.GetAdjustments($scope, f, ajx);
   //            // Populate Teams DropDown form Adjustment Entry
   //            this.scope.TeamList = oAdjustmentInitDataDTO.ocTeams;
   //            this.scope.AdjustmentNameList = oAdjustmentInitDataDTO.ocAdjustmentNames;
   //         }
   //      }; // fProcessAdjustmentInfo

   //      ajx.AjaxGet(UrlGetAdjustmentInfo, { LeagueName: Parms.LeagueName })
   //         .then(data => {
   //            fProcessAdjustmentInfo.process(data);
   //         })
   //         .catch(error => {
   //            f.DisplayMessage(f.FormatResponse(error));
   //         });
   //      return;
   //   }  // GetAdjustmentInfo

   //}); // Adjustments controller

   angular.module('app').controller('AdjustmentsModalController', function ($scope,  f, ajx, url) {
      let rowWasInserted = false;
      let GetAdjustmentsParms = { scope: $scope, f: f, LeagueName: LeagueName, ajx: ajx };

      $scope.$on('OpenAdjustmentEntryModalEvent', function (e) {
         rowWasInserted = false;
         $scope.ClearAdjustmentEntryForm();
         $scope.GreyOutAdjustmentList();
         $('#AdjustmentsModal').css({ "display": "block" });   // Show Adjustment Entry Modal
      });

      $scope.clickInsertAdjustment = function () {

         let oAdjustment = {};
         oAdjustment.LeagueName = LeagueName;

         oAdjustment.AdjustmentType = $scope.AdjustmentType;
         oAdjustment.Team = $scope.Team;
         oAdjustment.AdjustmentAmount = $scope.AdjustmentAmount;
         oAdjustment.Player = $scope.Player;
         oAdjustment.Description = $scope.Description;

         //if (!ValidateAdjustmentEntry(oAdjustment, $scope)) {
         //   return;  // errors in Adj Entry I/P
         //}

         $scope.setAdjustmentsModal = f.showHideModal(false);  // $scope.showAdjustmentsModal(false);

         ajx.AjaxPost(url.UrlPostInsertAdjustment, oAdjustment)
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

      $scope.CloseAdjustmentEntry = function () {    // invoked by Close click on Adjustment Entry Modal
         $('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal
         $scope.$emit("CloseAdjustmentEntry", rowWasInserted);   
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

      $scope.ClearAdjustmentEntryForm = function () {
         $scope.AdjustmentType = "";
         $scope.Team = "";
         $scope.AdjustmentAmount = "";
         $scope.AdjustmentAmount = "";
         $scope.Player = "";
         $scope.Description = "";

      };
   }); // Adjustments Modal controller




function xValidateAdjustmentEntry(oAdjustment, scope) {
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

function xGetAdjustmentInfo(Parms) { // called once at Controller init
   var f = Parms.f;
   var ajx = Parms.ajx;
   const Data = { LeagueName: Parms.LeagueName };
   let fProcessAdjustmentInfo = {
      scope: Parms.scope
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
         f.DisplayMessage(f.FormatResponse(error));
      });
   return;
}  // GetAdjustmentInfo

function xGetAdjustments(Parms) {
   var f = Parms.f;
   var ajx = Parms.ajx;
   let fProcessAdjustments = {
      scope: Parms.scope
      , process: function (ocAdjustments) {
         Parms.scope.ocAdjustments = ocAdjustments;
         Parms.scope.ocAdjustments.forEach(function (item) {
            item.cb_ID = "cb_" + item.AdjustmentID;
         });

         Parms.scope.$apply();
      }
   }; // fProcessAdjustments

   ajx.AjaxGet(UrlGetAdjustments, { LeagueName: Parms.LeagueName })   // Get Adjustments from server
      .then(data => {
         fProcessAdjustments.process(data);
      })
      .catch(error => {
         f.DisplayMessage(f.FormatResponse(error));
      });

}  // GetAdjustments


function xFormatResponse(response) {
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





