//import GetAdjustments from './AdjustmentsFunctions.js';

(function () {
   'use strict';
   try {
      var LeagueName = 'NBA';

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

         this.parseJsonDate = function (jsonDateString) {
            return new Date(parseInt(jsonDateString.replace('/Date(', '')));
         };

         this.wrapTag = function (tag, innerHtml) {
            let ar = tag.split(" ");
            return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
         };

         this.FormatResponse = function (response) {
            return "status: " + response.status + "\n"
               + "statusText: " + response.statusText + "\n"
               + "responseText: " + response.responseText;

         };

         this.DisplayMessage = function (msg) {
            alert(msg);
         };

         this.fun = function () {

         };
      });

      //var f;
      app.controller('appController', function ($scope, $compile, f, ajx) {
         let GetAdjustmentsParms = { scope: $scope, compile: $compile, f: f, LeagueName: LeagueName, ajx: ajx };
         GetAdjustments(GetAdjustmentsParms);

         $scope.InsertAdjustment = function () {
            let oAdjustment = {};
            oAdjustment.AdjustmentType = this.AdjustmentType;
            oAdjustment.Team = this.Team;
            oAdjustment.AdjustmentAmount = this.AdjustmentAmount;
            oAdjustment.Player = this.Player;
            oAdjustment.Description = this.Description;
            let URL = "/Adjustments/PostInsertAdjustment";

            ajx.AjaxPost(URL, oAdjustment)
               .then(data => {
                  console.log(data);
               })
               .catch(error => {
                  alert('Insert Error: ' + error);
               });
         }; // InsertAdjustment

         $scope.processUpdates = function () {
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
            let URL = "/Adjustments/PostProcessUpdates";
            ajx.AjaxPost(URL, ocAdjustmentDTO)
               .then(data => {
                  GetAdjustments(GetAdjustmentsParms);
                  f.DisplayMessage("Updates Complete");
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


function GetAdjustments(Parms) {
   var f = Parms.f;
   var ajx = Parms.ajx;
   let Data = { LeagueName: Parms.LeagueName };
   let URL = "/Adjustments/GetAdjustments";
   let fProcessAdjustments = {
      scope: Parms.scope
      , compile: Parms.compile
      , process: function (response) {
         let rows = buildAdjustmentsRows(response);   // Adjustments coming from MVC controller methed
         //    $('#adjustmentRows').empty();                // clear any previous rows
         var elmn = angular.element(document.querySelector('#adjustmentRows'));
         elmn.empty();
         Parms.compile(elmn)(Parms.scope);

         //    var matches = elmn.querySelectorAll("tr");
         //    matches.remove();
         let compRows = Parms.compile(rows)(Parms.scope);       // Compile rows for AngularJS
         $(compRows).appendTo($('#adjustmentRows'));

         //let rowNum = 1;
         //while ($("#cb_" + rowNum) !== undefined) {
         //   var x = $("#cb_" + rowNum).prop('checked');
         //   $("#cb_" + rowNum).prop('checked') = false;
         //   rowNum++;
         //}
      }
   }; // fProcessAdjustments

   ajx.AjaxGet(URL, Data)
      .then(data => {
         fProcessAdjustments.process(data);
      })
      .catch(error => {
         f.DisplayMessage(FormatResponse(error));
      });
   return;

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
}  // GetAdjustments


function xInsertAdjustment() {
   let oAdjustment = {
      // YOUR $Scope code here
      LeagueName: "NBA"
      , Team: " "
      , AdjustmentType: " "
      , AdjustmentAmount: " "
      , Player: " "
      , Description: " "
   };
   let URL = "/Adjustments/PostInsertAdjustment";

   AjaxPost(URL, oAdjustment)
      .then(data => {
         console.log(data);
      })
      .catch(error => {
         alert('Insert Error: ' + error);
      });
}  // InsertAdjustment

function AjaxGet(URL, Data) {
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
}  // AjaxGet

function AjaxPost(URL, Data) {
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
}  // AjaxPost



function FormatResponse(response) {
   return "status: " + response.status + "\n"
      + "statusText: " + response.statusText + "\n"
      + "responseText: " + response.responseText;
}
