(function () {
    'use strict';
    try {


        var app = angular.module('app', []);
        app.controller('appController',
            function ($scope, $compile) {
                $scope.apptitle = "Adjustment";
                GetAdjustments($scope, $compile);
            }
        );
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
            tr += '<td><input type="text" class="deleteClicked col-sm-4 col-md-6 col-lg-8" data-AdjID="'
                + oAdjustment.AdjustmentID + '" /></td>';
            tr += '<td><p data-placement="top" data-toggle="tooltip" title="Delete"><button class="btn btn-danger btn-xs del" data-title="Delete" data-toggle="modal" data-target="#delete"><span class="glyphicon glyphicon-trash"></span></button></p></td>';
            tr += wrapTag('td', parseJsonDate(oAdjustment.StartDate));
            tr += wrapTag('td', oAdjustment.AdjustmentType);
            tr += wrapTag('td', oAdjustment.Team);
            tr += wrapTag('td', oAdjustment.AdjustmentAmount);
            tr += wrapTag('td', oAdjustment.Player);
            tr += wrapTag('td', oAdjustment.Description);
            tr += wrapTag('td', oAdjustment.AdjustmentID);

            return tr;
        }

        function hideButton() {
            var a = document.getElementById(TB)
        }

        function greyText() {

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
function InsertAdjustment() {
    let oAdjustment = {};
    oAdjustment.Description = $Scope.Description;

    // Ajax call POST
}