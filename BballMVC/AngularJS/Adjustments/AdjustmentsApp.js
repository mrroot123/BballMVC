(function () {
    'use strict';
    try {
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

       app.controller('appController', function ($scope, $compile, f, ajx) {
           GetAdjustments($scope, $compile);

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

       }); // controler
    }
    catch (error) {
        console.error(error);
    }

})();

function GetAdjustments($scope, $compile) {
    let LeagueName = 'NBA';    // hardcode for now

    $.ajax({
        type: "GET",
        url: "/Adjustments/GetAdjustments",
        data: { LeagueName: LeagueName },
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response !== null) {
                let rows = displayAdjustments(response);     // Adjustments coming from MVC controller methed
                let compRows = $compile(rows)($scope);       // Compile rows for AngularJS
                $(compRows).appendTo($('#adjustmentRows'));
            } else {
                alert("response Error: \n" + FormatResponse(response));
            }
        },
        failure: function (response) {
            alert("failure: \n" + FormatResponse(response));
        },
        error: function (response) {
            alert("error: \n" + FormatResponse(response));
        }
    });

    function displayAdjustments(ocAdjustments) {
        let rows = "";
        var num = 1;
        $.each(ocAdjustments, function (key, oAdjustment) {
            // Add a tr for each Adjustment
            let tag = 'tr id="tr' + num + '"';
            // <tr ng-show="cbShowOverTimeAdjustments">
            // <tr ng-show="cbShowZeroAdjustments">
            if (oAdjustment.AdjustmentAmount === 0)
                tag += ' ng-show="cbShowZeroAdjustments"';
            else if (oAdjustment.AdjustmentType === "S")
                tag += ' ng-show="cbShowOverTimeAdjustments"';
            let tr = wrapTag(tag, formatAdjusment(oAdjustment));
            rows += tr;
            num=num+1;
        });
        return rows;

        function formatAdjusment(oAdjustment) {
            //<script src="moment.js"></script>;
            var a = parseJsonDate(oAdjustment.StartDate);
            let tr = "";
            tr += '<td><input type="text" class="deleteClicked col-sm-4 col-md-6 col-lg-8" id="TX'
                + oAdjustment.AdjustmentID + '" onchange="txBox(this)" /></td>';
            tr += '<td><p data-placement="top" data-toggle="tooltip" title="Delete"><button class="btn btn-danger btn-xs" id="DL'
                + oAdjustment.AdjustmentID + '" data-title="Delete" data-toggle="modal" data-target="#delete" onclick="delButton(this)"> <span class="glyphicon glyphicon-trash"></span></button ></p ></td > ';
            tr += wrapTag('td', parseJsonDate(oAdjustment.StartDate));
            tr += wrapTag('td', oAdjustment.AdjustmentType);
            tr += wrapTag('td', oAdjustment.Team);
            tr += wrapTag('td', oAdjustment.AdjustmentAmount);
            tr += wrapTag('td', oAdjustment.Player);
            tr += wrapTag('td', oAdjustment.Description);
            tr += wrapTag('td', oAdjustment.AdjustmentID);

            return tr;
        }


        // https://momentjs.com/
        function parseJsonDate(jsonDateString) {
            var a = new Date(parseInt(jsonDateString.replace('/Date(', '')));
            var b = a.toDateString().substr(4);
            return b;
        }
        function wrapTag(tag, innerHtml) {
            let ar = tag.split(" ");
            return "<" + tag + ">" + innerHtml + "</" + ar[0] + ">";
        }
    }
}

function FormatResponse(response) {
    return "status: " + response.status + "\n"
        + "statusText: " + response.statusText + "\n"
        + "responseText: " + response.responseText;
}
function xInsertAdjustment() {
    console.log("here");
    let oAdjustment = {};
    oAdjustment.AdjustmentType = $Scope.AdjustmentType;
    oAdjustment.Team = $Scope.Team;
    oAdjustment.AdjustmentAmount = $Scope.AdjustmentAmount;
    oAdjustment.Player = $Scope.Player;
    oAdjustment.Description = $Scope.Description;
    consol.log(oAdjustment.Team);
    consol.log(oAdjustment.Player);

    // Ajax call POST
}