'use strict';
angular.module('app').controller('TMunAdjTotalsModalController', function ($rootScope, $scope, f, ajx, url) {

   $scope.$on('eventOpenTMunAdjTotalsModal', function (e, arObj) {
      $scope.OpenTMunAdjTotalsModal(arObj);
   });
          
   $scope.OpenTMunAdjTotalsModal = function (arObj) {
      let item = arObj.item;

      let html = buildHtml(item);
      $("#trTM_" + arObj.$index).closest('tr').after(html);

   };   // on

   function buildHtml(item) {
      let arData = [];
      buildData(item, arData);  // pass item, return arData

      let arRows = buildRows(item, arData);

      let r = 0;
      let html = "";
      const cs = 'colspan="9"';
      for (r = 0; r < arRows.length; r++) {
         let rowTDs
            = f.wrapTag("td", arRows[r][0], [cs])
            + f.wrapTag("td", arRows[r][1], ['class="text-primary"', cs])
            + f.wrapTag("td", arRows[r][2], [cs]);
         html += f.wrapTag("tr", rowTDs, ['class="unAdjTotals"']);
      }
      return html;
   }   // buildHtml

   function buildData(item, arData) {  // arData is Built & returned
      let ixVenue = 0;

      for (ixVenue = 1; ixVenue <= 2; ixVenue++) {
         let Venue = ixVenue === 1 ? "Away" : "Home";
         let oppVenue = ixVenue === 1 ? "Home" : "Away";

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
                  item['TMoppAdjPct']);   // 6
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
 //                         PtValue * Pt *  ( 1  + ( (oppPt / LgAvg) - 1  ) * TMoppAdjPct) 
// PtValue * Pt * ( 1.0 + (( (oppPt / LgAvg) - 1.0 ) * TMoppAdjPct) )

         const numLen = 5;
         let dec = numLen - 3;
         TotPts = formatNum(TotPts, numLen, dec);
         calcShots = formatNum(calcShots, numLen, dec);
         Pt = formatNum(Pt, numLen, dec);
         oppPt = formatNum(oppPt, numLen, dec);
         LgAvg = formatNum(LgAvg, numLen, dec);
         TMoppAdjPct = formatNum(TMoppAdjPct * 100, 3, 0);
                                                 //  PtValue  *     Pt * ( 1+ (( (oppPt / LgAvg) - 1 ) * TMoppAdjPct) )
                           // 2 -         56.84 / 29.0          = 28.62 * (1+( 28.44   / 28.64)-1)    * 100%)
         let template = `${PtValue} - ${TotPts} / ${calcShots} = ${Pt} * (1+(${oppPt} / ${LgAvg})-1) * ${TMoppAdjPct}%)`;
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
   function buildRows(item, arData) {
      let arRows = [];
      let arRow;
      const regex = / /g;
      const statHeaderWspaces = "   Points   Shots   Team          Opp    LgAvg     OpAdj%";
      let statHeader = convertSpaces(statHeaderWspaces);
      const jQ = "$('.unAdjTotals').remove();";
      const btClose = `<input type="button" class="btn btn-danger" value="Close" onclick="${jQ}" />`;
      arRows.push([btClose, "", ""]);

      // GBn  WeightGBn
      // Game Back 3 - Weight: 1
      let i = 0;
      arRow = [];
      for (i = 1; i <= 3; i++) { // 3 Accross - ex: Game Back 3  - Weight: 1
         let gbTemplate = `Games Back: ${item['GB' + i]} - Weight: ${item['WeightGB' + i]}`;
         arRow.push(gbTemplate);
      }
      arRows.push(arRow); // Line 1 - Game Back 3 - Weight: 1     Game Back 5 - Weight: 1    Game Back 7 - Weight: 1

      arRows.push(["", "", ""]); // Blank line 2
      let ixVenue;
      for (ixVenue = 0; ixVenue < 2; ixVenue++) {
         let Venue = ixVenue === 0 ? "Away" : "Home";

         let teamTemplate = `${Venue}: ${item['Team' + Venue]}   - Team Avg Actual Games Back: ${item[Venue + 'ActualGBTeam']}`;  //AwayActualGBTeam
         arRows.push([teamTemplate, "", ""]);      // ex: Away: DAL   AwayActualGBTeam: 15 
         arRows.push([statHeader, statHeader, statHeader]);
         let pt = 0;
         for (pt = 0; pt < 3; pt++) {  // for each PtValues 1,2,3 => 18.10 = 1 * ( 19.13 + ((15.01-17.19) * 100% )
            arRows.push([arData[ixVenue][0][pt], arData[ixVenue][1][pt], arData[ixVenue][2][ pt]]);
         }
         arRows.push([ "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB1'].toFixed(2), "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB2'].toFixed(2), "&nbsp;&nbsp;&nbsp;" + item[Venue + 'GB3'].toFixed(2) ]); // ex: AwayGB1
         arRows.push(["", "", ""]); // Blank line
      }
      return arRows;
   }  // buildRows

   function xxxwrapTag(tag, data, arAttrs) {
      let attrsLit = "";
      if (arAttrs) {
         for (const attr of arAttrs) {
            attrsLit += " " + attr;
         }
      }
      return "<" + tag + attrsLit + ">" + data + "</" + tag + ">"
   }



}); // Adjustments Modal controller
