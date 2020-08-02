using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.IDTOs
{

   public interface IBoxScoresSeedsDTO
   {
      double AdjustmentAmountAllowed { get; set; }
      double AdjustmentAmountMade { get; set; }
      double AwayShotsAdjustedAllowedPt1 { get; set; }
      double AwayShotsAdjustedAllowedPt2 { get; set; }
      double AwayShotsAdjustedAllowedPt3 { get; set; }
      double AwayShotsAdjustedMadePt1 { get; set; }
      double AwayShotsAdjustedMadePt2 { get; set; }
      double AwayShotsAdjustedMadePt3 { get; set; }
      double AwayShotsAllowedPt1 { get; set; }
      double AwayShotsAllowedPt2 { get; set; }
      double AwayShotsAllowedPt3 { get; set; }
      double AwayShotsMadePt1 { get; set; }
      double AwayShotsMadePt2 { get; set; }
      double AwayShotsMadePt3 { get; set; }
      int BoxScoresSeedID { get; set; }
      DateTime CreateDate { get; set; }
      int GamesBack { get; set; }
      double HomeShotsAdjustedAllowedPt1 { get; set; }
      double HomeShotsAdjustedAllowedPt2 { get; set; }
      double HomeShotsAdjustedAllowedPt3 { get; set; }
      double HomeShotsAdjustedMadePt1 { get; set; }
      double HomeShotsAdjustedMadePt2 { get; set; }
      double HomeShotsAdjustedMadePt3 { get; set; }
      double HomeShotsAllowedPt1 { get; set; }
      double HomeShotsAllowedPt2 { get; set; }
      double HomeShotsAllowedPt3 { get; set; }
      double HomeShotsMadePt1 { get; set; }
      double HomeShotsMadePt2 { get; set; }
      double HomeShotsMadePt3 { get; set; }
      string LeagueName { get; set; }
      string Season { get; set; }
      string Team { get; set; }
      DateTime UpdateDate { get; set; }
      string UserName { get; set; }
   }
}