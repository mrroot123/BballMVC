//import GetAdjustmentInfo from './AdjustmentsFunctions.js';

const UrlPostInsertAdjustment = "/Adjustments/PostInsertAdjustment";
const UrlPostProcessUpdates = "api/Adjustments/PostProcessUpdates";
const UrlGetAdjustmentInfo = "/Adjustments/GetAdjustmentInfo";
const UrlGetAdjustments = "/Adjustments/GetAdjustments";

(function () {
   'use strict';
   try {
      const LeagueName = 'NBA';


      var app = angular.module('app', []);

      app.service('ajx', function () {

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

      app.service('f', function () {

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

      //var f;
      app.controller('appController', function ($scope, $compile, f, ajx) {
         let GetAdjustmentsParms = { scope: $scope, compile: $compile, f: f, LeagueName: LeagueName, ajx: ajx };
         GetAdjustmentInfo(GetAdjustmentsParms);

         $scope.InsertAdjustment = function () {
            let oAdjustment = {};
            oAdjustment.LeagueName = LeagueName;
            oAdjustment.AdjustmentType = document.getElementById("AdjType").value;
            oAdjustment.Team = document.getElementById("Team").value;
            oAdjustment.AdjustmentAmount = document.getElementById("AdjAmount").value;
            oAdjustment.Player = document.getElementById("Player").value;
            oAdjustment.Description = document.getElementById("Description").value;

            ajx.AjaxPost(UrlPostInsertAdjustment, oAdjustment)
               .then(data => {
                  f.MessageSuccess("Insert Complete");
               })
               .catch(error => {
                  f.DisplayMessage("Adjustment Insert Error/n" + f.FormatResponse(error));
                 });
             endAdjustmentEntry();
         }; // InsertAdjustment

         $scope.ProcessUpdates = function () {
            let ocAdjustmentDTO = [];
            let rowNum = 1;
            while ($("#adjAmt_" + rowNum).val() !== undefined) {
               if ($("#cb_" + rowNum).prop('checked')) {
                  ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-id")) });
               }
               else if ($("#adjAmt_" + rowNum).val()) {
                  ocAdjustmentDTO.push({ AdjustmentID: parseInt($("#adjAmt_" + rowNum).attr("data-id")), AdjustmentAmount: parseFloat($("#adjAmt_" + rowNum).val()) });
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
      }); // controller
   }
   catch (error) {
      console.error(error);
   }
})(); // main

function xSetDropDown(arDropDownItems, f) {
   let html = "";
   for (var item in arDropDownItems) {
      html += `<option value='${item[0]}'>${item[item.length-1]}</option>`;
   }
   f(html);
}

function GetAdjustmentInfo(Parms) {
   var f = Parms.f;
   var ajx = Parms.ajx;
   const Data = { LeagueName: Parms.LeagueName };
   //const URL = "/Adjustments/GetAdjustmentInfo";
   let fProcessAdjustmentInfo = {
      scope: Parms.scope
      , compile: Parms.compile
      , process: function (oAdjustmentInitDataDTO) {
         DisplayAdjustments(Parms, oAdjustmentInitDataDTO.ocAdjustments);
          // Populate Teams DropDown form Adjustment Entry
          var selList = document.getElementById("Team");
          for (var item in oAdjustmentInitDataDTO.ocTeams) {
              selList.innerHTML += "<option value=" + oAdjustmentInitDataDTO.ocTeams[item] + ">" + oAdjustmentInitDataDTO.ocTeams[item] + "</option>";
         }
         // Populate Adj Type DropDown form Adjustment Entry
          var adjCodeList = document.getElementById("AdjType");
          for (let item in oAdjustmentInitDataDTO.ocAdjustmentNames) {
              if (oAdjustmentInitDataDTO.ocAdjustmentNames[item].localeCompare("Trade") === 0) {
                  adjCodeList.innerHTML += "<option value=R>" + oAdjustmentInitDataDTO.ocAdjustmentNames[item] + "</option>";
              }
              else if (oAdjustmentInitDataDTO.ocAdjustmentNames[item].localeCompare("TV") === 0) {
                  adjCodeList.innerHTML += "<option value=V>" + oAdjustmentInitDataDTO.ocAdjustmentNames[item] + "</option>";
              }
              else {
                  adjCodeList.innerHTML += "<option value=" + oAdjustmentInitDataDTO.ocAdjustmentNames[item].charAt(0) + ">" + oAdjustmentInitDataDTO.ocAdjustmentNames[item] + "</option>";
              }
          }
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
   let Data = { LeagueName: Parms.LeagueName };
   //const URL = "/Adjustments/GetAdjustments";
   let fProcessAdjustments = {
      scope: Parms.scope
      , compile: Parms.compile
      , process: function (ocAdjustments) {
         DisplayAdjustments(Parms, ocAdjustments);
      }
   }; // fProcessAdjustments

   ajx.AjaxGet(UrlGetAdjustments, Data)
      .then(data => {
         fProcessAdjustments.process(data);
      })
      .catch(error => {
         f.DisplayMessage(FormatResponse(error));
      });
   return;

}  // GetAdjustments

function DisplayAdjustments(Parms, ocAdjustments) {
   var f = Parms.f;
   let rows = buildAdjustmentsRows(ocAdjustments);   // Adjustments coming from MVC controller methed
   var elmn = angular.element(document.querySelector('#adjustmentRows'));
   elmn.empty();
   Parms.compile(elmn)(Parms.scope);

   let compRows = Parms.compile(rows)(Parms.scope);       // Compile rows for AngularJS
   $(compRows).appendTo($('#adjustmentRows'));

   function buildAdjustmentsRows(ocAdjustments) {
      let rows = "";
      let rowNum = 0;
      $.each(ocAdjustments, function (key, oAdjustment) {
         // Add a tr for each Adjustment
         let tag = 'tr';
         // <tr ng-show="cbShowOverTimeAdjustments">
         // <tr ng-show="cbShowZeroAdjustments">
         if (oAdjustment.AdjustmentAmount === 0)
            tag += ' ng-show="cbShowZeroAdjustments"';
         else if (oAdjustment.AdjustmentType === "S" | oAdjustment.AdjustmentType.trim() === "SideOvertime")
            tag += ' ng-show="cbShowOverTimeAdjustments"';
         let tr = f.wrapTag(tag, formatAdjusment(oAdjustment, ++rowNum));
         rows += tr;
      });
      return rows;

      function formatAdjusment(oAdjustment, rowNum) {
         let tr = "";
         tr += '<td> <div ><input id="adjAmt_{rowNum}" data-id="{AdjID}" ng-disabled="cb_{AdjID}" class=" col-sm-6" type="text"  /></div></td>';
         tr += '<td><input id="cb_{rowNum}"  type="checkbox"  ng-model="cb_{AdjID}" ng-checked="false" /> </td>';
         //tr += '<td><p data-placement="top" data-toggle="tooltip" title="Delete">'
         //   + '<button ng-model="delButton_{AdjID}"  ng-click="delButtonClick({AdjID})" class="btn btn-danger btn-xs" data-title="Delete" data-toggle="modal" data-target="#delete">'
         //   + '< span class="glyphicon glyphicon-trash" ></span ></button ></p ></td > ';
         tr += f.wrapTag('td', f.parseJsonDate(oAdjustment.StartDate));
         tr += f.wrapTag('td', oAdjustment.AdjustmentType);
         tr += f.wrapTag('td', oAdjustment.Team);
         tr += f.wrapTag('td', oAdjustment.AdjustmentAmount);
         tr += f.wrapTag('td', oAdjustment.Player);
         tr += f.wrapTag('td', oAdjustment.Description);
         tr += f.wrapTag('td', oAdjustment.AdjustmentID);

         return tr.replace(/{AdjID}/g, oAdjustment.AdjustmentID).replace(/{rowNum}/g, rowNum);
      }  // formatAdjusment
   }  // buildAdjustmentsRows
}

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
$(function () {
   var showAdjustmentEntryModal = function () {
      ClearAdjustmentEntryForm();
      GreyOutAdjustmentList();
      ShowAdjustmentsModal();
   };
   $('#btOpenAdjustmentEntryModal').click(showAdjustmentEntryModal);  // Invoked by New Adj button click
   $(window).resize(function () {
      $('#AdjustmentsModal').css("display") === 'block' ? showAdjustmentEntryModal.call($('#btOpenAdjustmentEntryModal')) : "";
   });
});
function ClearAdjustmentEntryForm() {
    $("#AdjType").val('');
    $("#Team").val('');
    document.getElementById("AdjAmount").value = "";
    document.getElementById("Player").value = "";
    document.getElementById("Description").value = "";
}

function endAdjustmentEntry() {
   $('#AdjustmentsModal').css({ "display": "none" }); // Hide Adjustment Entry Modal
   // Show Adjustments 
   ShowAdjustmentList();
   ClearAdjustmentEntryForm();
}

function ShowAdjustmentList() {
   $('#AdjustmentsList').css({ "display": "block", opacity: 1, "width": $(document).width(), "height": $(document).height() });
}

// grey out Adjustments
function GreyOutAdjustmentList() {
   $('#AdjustmentsList').css({ "display": "block", opacity: 0.2, "width": $(document).width(), "height": $(document).height() });
}
// Show Adjustments Modal
function ShowAdjustmentsModal() {
$('#AdjustmentsModal').css({ "display": "block" });
}


//function xAjaxGet(URL, Data) {
//   return new Promise((resolve, reject) => {
//      $.ajax({
//         url: URL,
//         type: 'GET',
//         data: Data,
//         contentType: 'application/json; charset=utf-8',
//         success: function (data) {
//            resolve(data);
//         },
//         error: function (error) {
//            reject(error);
//         }
//      });   // ajax
//   });   // Promise
//}  // AjaxGet
//function xAjaxPost(URL, Data) {
//   return new Promise((resolve, reject) => {
//      $.ajax({
//         url: URL,
//         type: 'POST',
//         data: JSON.stringify(Data),
//         contentType: 'application/json; charset=utf-8',
//         success: function (returnData) {
//            resolve(returnData);
//         },
//         error: function (error) {
//            reject(error);
//         }
//      });   // ajax
//   });   // Promise
//}  // AjaxPost
   //function xbuildAdjustmentsRows(ocAdjustments) {
   //   let rows = "";
   //   let rowNum = 0;
   //   $.each(ocAdjustments, function (key, oAdjustment) {
   //      // Add a tr for each Adjustment
   //      let tag = 'tr';
   //      // <tr ng-show="cbShowOverTimeAdjustments">
   //      // <tr ng-show="cbShowZeroAdjustments">
   //      if (oAdjustment.AdjustmentAmount === 0)
   //         tag += ' ng-show="cbShowZeroAdjustments"';
   //      else if (oAdjustment.AdjustmentType === "S" | oAdjustment.AdjustmentType.trim() === "SideOvertime")
   //         tag += ' ng-show="cbShowOverTimeAdjustments"';
   //      let tr = f.wrapTag(tag, formatAdjusment(oAdjustment, ++rowNum));
   //      rows += tr;
   //   });
   //   return rows;
   //   function formatAdjusment(oAdjustment, rowNum) {
   //      let tr = "";
   //      tr += '<td> <div ><input id="adjAmt_{rowNum}" data-id="{AdjID}" ng-disabled="cb_{AdjID}" class=" col-sm-6" type="text"  /></div></td>';
   //      tr += '<td><input id="cb_{rowNum}"  type="checkbox"  ng-model="cb_{AdjID}" ng-checked="false" /> </td>';
   //      //tr += '<td><p data-placement="top" data-toggle="tooltip" title="Delete">'
   //      //   + '<button ng-model="delButton_{AdjID}"  ng-click="delButtonClick({AdjID})" class="btn btn-danger btn-xs" data-title="Delete" data-toggle="modal" data-target="#delete">'
   //      //   + '< span class="glyphicon glyphicon-trash" ></span ></button ></p ></td > ';
   //      tr += f.wrapTag('td', f.parseJsonDate(oAdjustment.StartDate));
   //      tr += f.wrapTag('td', oAdjustment.AdjustmentType);
   //      tr += f.wrapTag('td', oAdjustment.Team);
   //      tr += f.wrapTag('td', oAdjustment.AdjustmentAmount);
   //      tr += f.wrapTag('td', oAdjustment.Player);
   //      tr += f.wrapTag('td', oAdjustment.Description);
   //      tr += f.wrapTag('td', oAdjustment.AdjustmentID);
   //      return tr.replace(/{AdjID}/g, oAdjustment.AdjustmentID).replace(/{rowNum}/g, rowNum);
   //   }  // formatAdjusment
   //}  // buildAdjustmentsRows

