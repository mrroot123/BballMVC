angular.module('app').controller('TMunAdjTotalsModalController', function ($rootScope, $scope, f, ajx, url) {

   $scope.$on('eventOpenTMunAdjTotalsModal', function (e, arObj) {
      let [obj, Venue] = arObj;
      let item = obj.item;

      let ixVenue = 0;
      let arData = [];
      for (ixVenue = 1; ixVenue <= 2; ixVenue++) {
         let Venue = ixVenue === 1 ? "Away" : "Home";
         let oppVenue = ixVenue === 1 ? "Home" : "Away";

         let PtValue;
         let arPtValue = [];
         for (PtValue = 1; PtValue <= 3; PtValue++) {
            let GB;
            let arGB = [];
            for (GB = 1; GB <= 3; GB++) {
               //@Pt1 * tAwayGB1.AverageMadeUsPt1 * ( 1.0 + (( (tHomeGB10.AverageMadeOpPt1 / @LgAvgShotsMadeHomePt1) - 1.0 ) * @TMoppAdjPct) )   as CalcAwayGB1Pt1
               // 1) AwayGB1Pt1  2) PtValue  3) AwayAverageMadePt1   4) HomeAverageAllowedPt1   5) LgAvgShotsMadeHomePt1   6) TMoppAdjPct
               let r = formatPointRow(
                  item[Venue + 'GB' + GB + 'Pt' + PtValue],             // 1 - AwayGB1Pt1
                  PtValue,                                              // 2 - PtValue
                  item[Venue + 'AverageMadePt' + PtValue],              // 3 - AwayAverageMadePt1
                  item[oppVenue + 'AverageAllowedPt' + PtValue],        // 4 - HomeAverageAllowedPt1
                  item['LgAvgShotsMade' + oppVenue + 'Pt' + PtValue],   // 5 - LgAvgShotsMadeHomePt1
                  item['TMoppAdjPct']);   // 6
               arGB.push(r);
            }  // GB loop
            arPtValue.push(arGB);
         }  // PtValue loop
         arData.push(arPtValue);
      }  // Venue loop

      let arRows = buildRows(item, arData);


      let r = 0;
      let html = "";
      for (r = 0; r < arRows.length; r++) {
         let rowTDs = wrapTag("td", arRows[r][0]) + wrapTag("td", arRows[r][1], "text-primary") + wrapTag("td", arRows[r][ 2]);
         html += wrapTag("tr", rowTDs);
      }
      $("#TMunAdjTotals_TableData").html(html);

   });   // on

   function buildData(item) {
   }   // buildData

   function buildRows(item, arData) {
      let arRows = [];
      let arRow;
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

      for (ixVenue = 0; ixVenue < 2; ixVenue++) {
         const statHeader = "Points&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Team&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Opp&nbsp;&nbsp;LgAvg&nbsp;&nbsp;&nbsp;OpAdj%";
         let Venue = ixVenue === 0 ? "Away" : "Home";

         let teamTemplate = `${Venue}: ${item['Team' + Venue]}`;
         arRows.push([teamTemplate, "", ""]);      // ex: Away: DAL
         arRows.push([statHeader, statHeader, statHeader]);
         let pt = 0;
         for (pt = 0; pt < 3; pt++) {  // for each PtValues 1,2,3 => 18.10 = 1 * ( 19.13 + ((15.01-17.19) * 100% )
            arRows.push([arData[ixVenue][0][pt], arData[ixVenue][1][pt], arData[ixVenue][2][ pt]]);
         }
         arRows.push([(item[Venue + 'GB1']).toFixed(1), (item[Venue + 'GB2']).toFixed(1), (item[Venue + 'GB3']).toFixed(1) ]); // ex: AwayGB1
         arRows.push(["", "", ""]); // Blank line
      }
      return arRows;
   }  // buildRows

   function wrapTag(tag, data, classNames) {
      let classLit = "";
      if (classNames) {
         classLit = ` class="${classNames}"`;
      }
      return "<" + tag + classLit + ">" + data + "</" + tag + ">"
   }

   function formatPointRow(TotPts, PtValue, Pt, oppPt, LgAvg, TMoppAdjPct) {
      const numLen = 5;
      let dec = numLen - 3;
      TotPts = formatNum(TotPts, numLen+1, dec);
      Pt = formatNum(Pt, numLen, dec);
      oppPt = formatNum(oppPt, numLen, dec);
      LgAvg = formatNum(LgAvg, numLen, dec);
      TMoppAdjPct = formatNum(TMoppAdjPct * 100, 3, 0);

      let template = `${TotPts} = ${PtValue} * ( ${Pt} + ((${oppPt}-${LgAvg}) * ${TMoppAdjPct}%) ) `;
      return template;

      function formatNum(num, len, dec) {
         let n = num.toFixed(dec).toString();
         while (n.length < len) {
            n = " " + n;
         }
         return n;
      }
   }



   $scope.$on('eventCloseTMunAdjTotalsModal', function (e, objAdj) {
      // Optional do closing logic modal
   });

}); // Adjustments Modal controller
