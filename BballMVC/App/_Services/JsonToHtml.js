'use strict';
angular.module('app').service('JsonToHtml', function () {
   // https://www.geeksforgeeks.org/how-to-convert-json-data-to-a-html-table-using-javascript-jquery/

   // IP - Row / Column list
   // OP - Table
   this.jsonToHtmlTable = function (list) {
      if (!list) {   // Send empty list and return default for testing
         list = [
            { "col_1": "val_11", "col_2": "val_12", "col_3": "val_13" },
            { "col_1": "val_21", "col_2": "val_22", "col_3": "val_23" },
            { "col_1": "val_31", "col_2": "val_32", "col_3": "val_33" }
         ];
      };
      var colNames = [];

      for (var i = 0; i < list.length; i++) {
         for (var k in list[i]) {
            if (colNames.indexOf(k) === -1) {

               // Push all keys to the array
               colNames.push(k);
            }
         }
      }

      // Create a table element
      var table = document.createElement("table");

      // Create table row tr element of a table
      var tr = table.insertRow(-1);

      for (var i = 0; i < colNames.length; i++) {

         // Create the table header row - add each th element
         var theader = document.createElement("th");
         theader.innerHTML = colNames[i];

         // Append columnName to the table row
         tr.appendChild(theader);
      }

      // Adding the data to the table
      for (var i = 0; i < list.length; i++) {

         // Create a new rowo
         tr = table.insertRow(-1);
         for (var j = 0; j < colNames.length; j++) {
            var cell = tr.insertCell(-1);

            // Inserting the cell at particular place
            cell.innerHTML = list[i][colNames[j]];
         }
      }

      return table;
   }
});