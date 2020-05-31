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
      double AdjustmentAmountScored { get; set; }
      double AwayShotsAdjustedAllowedPt1 { get; set; }
      double AwayShotsAdjustedAllowedPt2 { get; set; }
      double AwayShotsAdjustedAllowedPt3 { get; set; }
      double AwayShotsAdjustedScoredPt1 { get; set; }
      double AwayShotsAdjustedScoredPt2 { get; set; }
      double AwayShotsAdjustedScoredPt3 { get; set; }
      double AwayShotsAllowedPt1 { get; set; }
      double AwayShotsAllowedPt2 { get; set; }
      double AwayShotsAllowedPt3 { get; set; }
      double AwayShotsScoredPt1 { get; set; }
      double AwayShotsScoredPt2 { get; set; }
      double AwayShotsScoredPt3 { get; set; }
      int BoxScoresSeedID { get; set; }
      DateTime CreateDate { get; set; }
      int GamesBack { get; set; }
      double HomeShotsAdjustedAllowedPt1 { get; set; }
      double HomeShotsAdjustedAllowedPt2 { get; set; }
      double HomeShotsAdjustedAllowedPt3 { get; set; }
      double HomeShotsAdjustedScoredPt1 { get; set; }
      double HomeShotsAdjustedScoredPt2 { get; set; }
      double HomeShotsAdjustedScoredPt3 { get; set; }
      double HomeShotsAllowedPt1 { get; set; }
      double HomeShotsAllowedPt2 { get; set; }
      double HomeShotsAllowedPt3 { get; set; }
      double HomeShotsScoredPt1 { get; set; }
      double HomeShotsScoredPt2 { get; set; }
      double HomeShotsScoredPt3 { get; set; }
      string LeagueName { get; set; }
      string Season { get; set; }
      string Team { get; set; }
      DateTime UpdateDate { get; set; }
      string UserName { get; set; }
   }
}

