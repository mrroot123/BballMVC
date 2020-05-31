﻿using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class BoxScoresSeedsDTO : IBoxScoresSeedsDTO 
   {
      public int BoxScoresSeedID { get; set; }
      public string UserName { get; set; }
      public string LeagueName { get; set; }
      public string Season { get; set; }
      public int GamesBack { get; set; }
      public string Team { get; set; }
      public double AdjustmentAmountScored { get; set; }
      public double AdjustmentAmountAllowed { get; set; }
      public double AwayShotsScoredPt1 { get; set; }
      public double AwayShotsScoredPt2 { get; set; }
      public double AwayShotsScoredPt3 { get; set; }
      public double AwayShotsAllowedPt1 { get; set; }
      public double AwayShotsAllowedPt2 { get; set; }
      public double AwayShotsAllowedPt3 { get; set; }
      public double AwayShotsAdjustedScoredPt1 { get; set; }
      public double AwayShotsAdjustedScoredPt2 { get; set; }
      public double AwayShotsAdjustedScoredPt3 { get; set; }
      public double AwayShotsAdjustedAllowedPt1 { get; set; }
      public double AwayShotsAdjustedAllowedPt2 { get; set; }
      public double AwayShotsAdjustedAllowedPt3 { get; set; }
      public double HomeShotsScoredPt1 { get; set; }
      public double HomeShotsScoredPt2 { get; set; }
      public double HomeShotsScoredPt3 { get; set; }
      public double HomeShotsAllowedPt1 { get; set; }
      public double HomeShotsAllowedPt2 { get; set; }
      public double HomeShotsAllowedPt3 { get; set; }
      public double HomeShotsAdjustedScoredPt1 { get; set; }
      public double HomeShotsAdjustedScoredPt2 { get; set; }
      public double HomeShotsAdjustedScoredPt3 { get; set; }
      public double HomeShotsAdjustedAllowedPt1 { get; set; }
      public double HomeShotsAdjustedAllowedPt2 { get; set; }
      public double HomeShotsAdjustedAllowedPt3 { get; set; }
      public System.DateTime CreateDate { get; set; }
      public System.DateTime UpdateDate { get; set; }
   }
}
