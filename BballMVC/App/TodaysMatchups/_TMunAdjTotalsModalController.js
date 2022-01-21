'use strict';
angular.module('app').controller('TMunAdjTotalsModalController', function ($rootScope, $scope, f, ajx, url, JsonToHtml) {

   $scope.$on('eventOpenTMunAdjTotalsModal', function (e, arObj) {
      $scope.OpenTMunAdjTotalsModal(arObj);
   });
          
   $scope.OpenTMunAdjTotalsModal = function (arObj) {
      let item = arObj.item;
      let id = "#trTM_" + arObj.$index;

      //let html = newbuildHtml(item, id);
      let html = buildHtml(item, id);

      //$(id).closest('tr').after(html);
   };
   function buildHtml(item, id) {
      let arData = [];
      buildData(item, arData);  

      let html = "";

      html += buildTeamHtmlTRs(item, arData, 0)      // Build Away TMunAdjTotals html TRs and append
      html += `<tr id ="${item.TeamAway.trim()}"><td></td></tr>`;

      html += buildTeamHtmlTRs(item, arData, 1)      // Build Home TMunAdjTotals html TRs and append
      html += `<tr id ="${item.TeamHome.trim()}"><td></td></tr>`;

      $(id).closest('tr').after(html);

     // buildTeamHistory(item, "Away")      // Build Away Team History  html TRs and append
      //buildTeamHistory(item, "Home")      // Build Home Team History  html TRs and append

      return html;
   };
   function xbuildHtml(item, id) {
      let arData = [];
      buildData(item, arData);  // pass item, return arData

      let html = "";
      
      html = buildTeamHistory(item, "Home")      // Build Home Team History  html TRs and append
      $(id).closest('tr').after(html);
     
      html = buildTeamHtmlTRs(item, arData, 1)      // Build Home TMunAdjTotals html TRs and append
      $(id).closest('tr').after(html);

      html = buildTeamHistory(item,  "Away")      // Build Away Team History  html TRs and append
      $(id).closest('tr').after(html);

      html = buildTeamHtmlTRs(item, arData, 0)      // Build Away TMunAdjTotals html TRs and append
      $(id).closest('tr').after(html);

      return html;
   };

   function newbuildHtml(item) {
      let arData = [];
      buildData(item, arData);  // pass item, return arData

      let html = "";
      html += buildTeamHtmlTRs(item, arData, 0)      // Build Away TMunAdjTotals html TRs and append
      html += buildTeamHistory(item, arData, "Away")      // Build Away Team History  html TRs and append
      
      html += buildTeamHtmlTRs(item, arData, 1)      // Build Home TMunAdjTotals html TRs and append
      html += buildTeamHistory(item, arData, "Home")      // Build Home Team History  html TRs and append

      return html;
   };



   function buildTeamHistory(item, Venue) {
      /*
         0, @LeagueName char(4) = 'NBA'
      1, @StartDate Date = '12/19/2021'
      2, @Team char(4) = 'NY'
      3, @Venue char(4) = 'Away'		--'Home'  --'Away'
      4, @Season char(4) = '2122'
      ,5 @GB int = 10
      */

      let Team = Venue === "Away" ? item.TeamAway.trim() : item.TeamHome.trim();

      let parms = `${item.LeagueName},${item.GameDate},${Team},${Venue},${item.Season},${item.GB3}`;

      SqlToJson(requestType, parms, appendTeamHistory);
      
      // string RequestType, List<string> Parms)
      //ajx.AjaxGet(url.UrlSqlToJson, {
      //   RequestType: "TeamHistory"
      //   , Parms: parms
      //}, noAsync)   // Get data from server
      //   .then(json => {
      //      let table = JsonToHtml.jsonToHtmlTable(JSON.parse(json));      // Call jsonToHtmlTable
      //      table.setAttribute("class", "unAdjTotals");
      //      table = `<div>${table.outerHTML}</div>`;
      //      $("#" + Team).closest('tr').after(table);
      //   })
      //   .catch(error => {
      //      f.DisplayErrorMessage(f.FormatResponse(error));
      //   });
      appendTeamHistory = function (json) {
            let table = JsonToHtml.jsonToHtmlTable(JSON.parse(json));      // Call jsonToHtmlTable
            table.setAttribute("class", "unAdjTotals");
            table = `<div>${table.outerHTML}</div>`;
            $("#" + Team).closest('tr').after(table);
         };
   };

   function SqlToJson(requestType, parms, callBackFunction) {
      ajx.AjaxGet(url.UrlSqlToJson, {
         RequestType: requestType
         , Parms: parms
      })   // Get data from server
         .then(json => {
            callBackFunction(json);
         })
         .catch(error => {
            f.DisplayErrorMessage(f.FormatResponse(error));
         });
   }

   function buildTeamHtmlTRs(item, arData, ixVenue) {
      //let arData = [];
      //buildData(item, arData, Venue);  // pass item, return arData

      let arRows = buildRows(item, arData, ixVenue);

      let r = 0;
      let html = "";
      const cs = 'colspan="9"';
      // wrapTag - tag, data, arAttrs
      for (r = 0; r < arRows.length; r++) {
         let rowTDs;
         if (Array.isArray(arRows[r])) {
            rowTDs
               = f.wrapTag("td", arRows[r][0], [cs])
               + f.wrapTag("td", arRows[r][1], ['class="text-primary"', cs])  // make middle col different color
               + f.wrapTag("td", arRows[r][2], [cs]);
         } else {
               rowTDs = f.wrapTag("td", arRows[r], [cs]);
         }

         html += f.wrapTag("tr", rowTDs, ['class="unAdjTotals"']);
      }
      return html;
   }   // buildHtml

   function buildData(item, arData) {  // arData is Built & returned
      let ixVenue = 0;

      for (ixVenue = 1; ixVenue <= 2; ixVenue++) {
         let Venue = ixVenue === 1 ? "Away" : "Home";
         let oppVenue = Venue === "Away" ? "Home" : "Away";

         let GB;
         let arGB = [];
         for (GB = 1; GB <= 3; GB++) {

            let PtValue;
            let arPtValue = [];
            for (PtValue = 1; PtValue <= 3; PtValue++) {

               //@Pt1 * tAwayGB1.AverageMadeUsPt1 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) - 1.0 ) * @TMoppAdjPct) )   as CalcAwayGB1Pt1
               // 1) AwayGB1Pt1  2) PtValue  3) AverageMadeAwayGB1Pt1   4) HomeAverageAllowedPt1   5) LgAvgShotsMadeHomePt1   6) TMoppAdjPct
               let r = formatPointRow(
                  item[Venue + 'GB' + GB + 'Pt' + PtValue],                   // 1 - AwayGB1Pt1
                  PtValue,                                                    // 2 - PtValue
                  item['AverageMade' + Venue + 'GB' + GB + 'Pt' + PtValue],   // 3 - AverageMadeAwayGB1Pt1
                  item[oppVenue + 'AverageAllowedPt' + PtValue],              // 4 - HomeAverageAllowedPt1
                  item['LgAvgShotsMade' + oppVenue + 'Pt' + PtValue],         // 5 - LgAvgShotsMadeHomePt1
                  item.LgParms['TodaysMUPsOppAdjPctPt' + PtValue]);   // 6
                  //item['TMoppAdjPct']);   // 6
               arPtValue.push(r);
            }  // PtValue loop
            arGB.push(arPtValue);
         }  // GB loop
         arData.push(arGB);   // build arData for return
      }  // Venue loop

      // Local Function
      function formatPointRow(TotPts, PtValue, Pt, oppPt, LgAvg, TMoppAdjPct) {
         let calcShots = (
               Pt * (1.0 + ((oppPt / LgAvg) - 1.0) * TMoppAdjPct)
                          );
         const numLen = 5;
         let dec = numLen - 3;
         TotPts = formatNum(TotPts, numLen, dec);
         calcShots = formatNum(calcShots, numLen, dec);
         Pt = formatNum(Pt, numLen, dec);
         let oppAdj = Pt * ((oppPt / LgAvg) - 1) * TMoppAdjPct;
         let sign = "+ ";
         if (oppAdj < 0) {
            sign = "- ";
            oppAdj *= -1;
         }
         let strOppAdj = sign + formatNum(oppAdj, 4, dec);
         oppPt = formatNum(oppPt, numLen, dec);
         LgAvg = formatNum(LgAvg, numLen, dec);
         TMoppAdjPct = formatNum(TMoppAdjPct * 100, 3, 0);
                                                 //  PtValue  *     Pt * ( 1+ (( (oppPt / LgAvg) - 1 ) * TMoppAdjPct) )
                           // 2 -         56.84 / 29.0          = 28.62 * (1+( 28.44   / 28.64)-1)    * 100%)
         //    Points   Shots   Team    OpAdj    Opp  LgAvg   OpAdj %
         // 1 - 14.45 / 14.45 = 14.26 + 0.19 | (15.61 / 15.27) * 61 %
                       //      1    -    14.45  /     14.45    = 14.26    + 0.19    |   (15.61 / 15.27) * 61 %
         let template = `${PtValue} - ${TotPts} / ${calcShots} = ${Pt} ${strOppAdj} | (${oppPt} / ${LgAvg}) * ${TMoppAdjPct}% `;
        // let template = `${PtValue} - ${TotPts} / ${calcShots} = ${Pt} * (${oppPt} / ${LgAvg}) * ${TMoppAdjPct}%)`;
        // let template = `${TotPts} = ${PtValue} * ${Pt} * (1+(${oppPt} / ${LgAvg})-1) * ${TMoppAdjPct}%)`;
         return convertSpaces(template);

         function formatNum(num, len, dec) {
            if (num === null) {
               num = 1;
            }
            let n = num.toFixed(dec).toString();
            while (n.length < len) {
               n = " " + n;
            }
            return n;
         }
      }

   }   // buildData

   function convertSpaces(str) {
      const regex = / /g;
      return str.replace(regex, '&nbsp;');
   }
   function NewbuildRows(item, arData, Venue) {
      let arRows = [];  // 3 cols of Data for GB 1-3
      let arRow;
      const regex = / /g;
      //   const statHeaderWspaces = "   Points   Shots   Team          Opp    LgAvg     OpAdj%";
      const statHeaderWspaces = "   Points   Shots   Team   OpAdj     Opp    LgAvg  OpAdj%";
      let statHeader = convertSpaces(statHeaderWspaces);
      const jQ = "$('.unAdjTotals').remove();";
      const btClose = `<input type="button" class="btn btn-danger" value="Close" onclick="${jQ}" />`;
      arRows.push(btClose);  // Push "Close" button

      // GBn  WeightGBn
      // Game Back 3 - Weight: 1
      let i = 0;
      arRow = []; // tag, data, arAttrs
      for (i = 1; i <= 3; i++) { // 3 Accross - ex: Game Back 3  - Weight: 1
         let gbTemplate = `Games Back: ${item['GB' + i]} - Weight: ${item['WeightGB' + i]}`;
         arRow.push(gbTemplate);
      }
      arRows.push(arRow); // Line 1 - Game Back 3 - Weight: 1     Game Back 5 - Weight: 1    Game Back 7 - Weight: 1

      arRows.push(["", "", ""]); // Blank line 2
      let ixVenue;

      let teamTemplate = `${Venue}: ${item['Team' + Venue]}   - Team Avg Actual Games Back: ${item[Venue + 'ActualGBTeam']}`;  //AwayActualGBTeam
      arRows.push([teamTemplate, "", ""]);      // ex: Away: DAL   AwayActualGBTeam: 15 
      arRows.push([statHeader, statHeader, statHeader]);
      let pt = 0;
      for (pt = 0; pt < 3; pt++) {  // for each PtValues 1,2,3 => 18.10 = 1 * ( 19.13 + ((15.01-17.19) * 100% )
        // arRows.push([arData[ixVenue][0][pt], arData[ixVenue][1][pt], arData[ixVenue][2][pt]]);
         arRows.push( [ arData[0][pt], arData[1][pt], arData[2][pt] ] );
      }
      arRows.push(["&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB1'].toFixed(2)
         , "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB2'].toFixed(2)
         , "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB3'].toFixed(2)]); // ex: AwayGB1

      arRows.push(["", "", ""]); // Blank line
      //}
      return arRows;
   }  // buildRows

   function buildRows(item, arData, ixVenue) {
      let arRows = [];  // 3 cols of Data for GB 1-3
      let arRow;
      const regex = / /g;
 //   const statHeaderWspaces = "   Points   Shots   Team          Opp    LgAvg     OpAdj%";
      const statHeaderWspaces = "   Points   Shots   Team   OpAdj     Opp    LgAvg  OpAdj%";
      let statHeader = convertSpaces(statHeaderWspaces);
      const jQ = "$('.unAdjTotals').remove();";
      const btClose = `<input type="button" class="btn btn-danger" value="Close" onclick="${jQ}" />`;
      arRows.push(btClose);  // Push "Close" button

      // GBn  WeightGBn
      // Game Back 3 - Weight: 1
      let i = 0;
      arRow = []; // tag, data, arAttrs
      for (i = 1; i <= 3; i++) { // 3 Accross - ex: Game Back 3  - Weight: 1
         let gbTemplate = `Games Back: ${item['GB' + i]} - Weight: ${item['WeightGB' + i]}`;
         arRow.push(gbTemplate);
      }
      arRows.push(arRow); // Line 1 - Game Back 3 - Weight: 1     Game Back 5 - Weight: 1    Game Back 7 - Weight: 1

      arRows.push(["", "", ""]); // Blank line 2
      
      //for (ixVenue = 0; ixVenue < 2; ixVenue++) {
         let Venue = ixVenue === 0 ? "Away" : "Home";

         let teamTemplate = `${Venue}: ${item['Team' + Venue]}   - Team Avg Actual Games Back: ${item[Venue + 'ActualGBTeam']}`;  //AwayActualGBTeam
         arRows.push([teamTemplate, "", ""]);      // ex: Away: DAL   AwayActualGBTeam: 15 
         arRows.push([statHeader, statHeader, statHeader]);
         let pt = 0;
         for (pt = 0; pt < 3; pt++) {  // for each PtValues 1,2,3 => 18.10 = 1 * ( 19.13 + ((15.01-17.19) * 100% )
            arRows.push([arData[ixVenue][0][pt], arData[ixVenue][1][pt], arData[ixVenue][2][ pt]]);
         }
         arRows.push(["&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB1'].toFixed(2)
            , "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB2'].toFixed(2)
            , "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB3'].toFixed(2)]); // ex: AwayGB1

         //// create Click for Team history games row
         //let parms = {};
         //parms.LeagueName = item.LeagueName;
         //parms.GameDate = item.GameDate;
         //if (ixVenue == 0) {
         //   parms.Team = item.TeamAway
         //   parms.Venue = "Away";
         //} else {
         //   parms.Team = item.TeamHome
         //   parms.Venue = "Home";
         //}
         //parms = JSON.stringify(parms);
         //let ngclk = `ng-click="OpenInlineModal('TeamHistory', '${parms}','ID?')"`;
         //let buttonHtml = `<input type="button" value="Team History" ${ngclk}>`;
         //arRows.push([buttonHtml, "", ""]);  // Push button
         // OpenInlineModal = function (modal, stringOfJsonParms, trID)
         // <td colspan="9">
         // <input type="button" class="btn btn-danger" value="Close"  ng-click="OpenTMunAdjTotalsModal(this)" ">


         arRows.push(["", "", ""]); // Blank line
      //}
      return arRows;
   }  // buildRows

   //function xxxwrapTag(tag, data, arAttrs) {
   //   let attrsLit = "";
   //   if (arAttrs) {
   //      for (const attr of arAttrs) {
   //         attrsLit += " " + attr;
   //      }
   //   }
   //   return "<" + tag + attrsLit + ">" + data + "</" + tag + ">"
   //}



}); // Adjustments Modal controller
