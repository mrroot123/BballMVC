
using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public  class TodaysMatchupsDTO : ITodaysMatchupsDTO  
   {
      public int TodaysMatchupsID { get; set; }
      public string UserName { get; set; }
      public string LeagueName { get; set; }
      public System.DateTime GameDate { get; set; }
      public string Season { get; set; }
      public string SubSeason { get; set; }
      public string TeamAway { get; set; }
      public string TeamHome { get; set; }
      public int RotNum { get; set; }
      public string GameTime { get; set; }
      public string TV { get; set; }
      public Nullable<double> TmStrAway { get; set; }
      public Nullable<double> TmStrHome { get; set; }
      public double UnAdjTotalAway { get; set; }
      public double UnAdjTotalHome { get; set; }
      public double UnAdjTotal { get; set; }
      public double AdjAmtAway { get; set; }
      public double AdjAmtHome { get; set; }
      public double AdjAmt { get; set; }
      public Nullable<double> AdjOTwithSide { get; set; }
      public double OurTotalLineAway { get; set; }
      public double OurTotalLineHome { get; set; }
      public double OurTotalLine { get; set; }
      public Nullable<double> SideLine { get; set; }
      public Nullable<double> TotalLine { get; set; }
      public Nullable<double> OpenTotalLine { get; set; }
      public string Play { get; set; }
      public Nullable<double> LineDiff { get; set; }
      public Nullable<double> OpenLineDiff { get; set; }
      public Nullable<double> AdjustedDiff { get; set; }
      public double BxScLinePct { get; set; }
      public double TmStrAdjPct { get; set; }
      public int GB1 { get; set; }
      public int GB2 { get; set; }
      public int GB3 { get; set; }
      public int WeightGB1 { get; set; }
      public int WeightGB2 { get; set; }
      public int WeightGB3 { get; set; }
      public Nullable<double> AwayGB1 { get; set; }
      public Nullable<double> AwayGB2 { get; set; }
      public Nullable<double> AwayGB3 { get; set; }
      public Nullable<double> HomeGB1 { get; set; }
      public Nullable<double> HomeGB2 { get; set; }
      public Nullable<double> HomeGB3 { get; set; }
      public Nullable<double> AwayGB1Pt1 { get; set; }
      public Nullable<double> AwayGB1Pt2 { get; set; }
      public Nullable<double> AwayGB1Pt3 { get; set; }
      public Nullable<double> AwayGB2Pt1 { get; set; }
      public Nullable<double> AwayGB2Pt2 { get; set; }
      public Nullable<double> AwayGB2Pt3 { get; set; }
      public Nullable<double> AwayGB3Pt1 { get; set; }
      public Nullable<double> AwayGB3Pt2 { get; set; }
      public Nullable<double> AwayGB3Pt3 { get; set; }
      public Nullable<double> HomeGB1Pt1 { get; set; }
      public Nullable<double> HomeGB1Pt2 { get; set; }
      public Nullable<double> HomeGB1Pt3 { get; set; }
      public Nullable<double> HomeGB2Pt1 { get; set; }
      public Nullable<double> HomeGB2Pt2 { get; set; }
      public Nullable<double> HomeGB2Pt3 { get; set; }
      public Nullable<double> HomeGB3Pt1 { get; set; }
      public Nullable<double> HomeGB3Pt2 { get; set; }
      public Nullable<double> HomeGB3Pt3 { get; set; }
      public Nullable<double> TotalBubbleAway { get; set; }
      public Nullable<double> TotalBubbleHome { get; set; }
   }
}
