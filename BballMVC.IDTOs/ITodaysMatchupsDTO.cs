using System;

namespace BballMVC.IDTOs
{
   public interface ITodaysMatchupsDTO
   {
      double AdjAmt { get; set; }
      double AdjAmtAway { get; set; }
      double AdjAmtHome { get; set; }
      double? AdjOTwithSide { get; set; }
      double? AdjustedDiff { get; set; }
      double? AwayGB1 { get; set; }
      double? AwayGB1Pt1 { get; set; }
      double? AwayGB1Pt2 { get; set; }
      double? AwayGB1Pt3 { get; set; }
      double? AwayGB2 { get; set; }
      double? AwayGB2Pt1 { get; set; }
      double? AwayGB2Pt2 { get; set; }
      double? AwayGB2Pt3 { get; set; }
      double? AwayGB3 { get; set; }
      double? AwayGB3Pt1 { get; set; }
      double? AwayGB3Pt2 { get; set; }
      double? AwayGB3Pt3 { get; set; }
      double BxScLinePct { get; set; }
      DateTime GameDate { get; set; }
      int GB1 { get; set; }
      int GB2 { get; set; }
      int GB3 { get; set; }
      double? HomeGB1 { get; set; }
      double? HomeGB1Pt1 { get; set; }
      double? HomeGB1Pt2 { get; set; }
      double? HomeGB1Pt3 { get; set; }
      double? HomeGB2 { get; set; }
      double? HomeGB2Pt1 { get; set; }
      double? HomeGB2Pt2 { get; set; }
      double? HomeGB2Pt3 { get; set; }
      double? HomeGB3 { get; set; }
      double? HomeGB3Pt1 { get; set; }
      double? HomeGB3Pt2 { get; set; }
      double? HomeGB3Pt3 { get; set; }
      string LeagueName { get; set; }
      double? LineDiff { get; set; }
      double? OpenLineDiff { get; set; }
      double? OpenTotalLine { get; set; }
      double OurTotalLine { get; set; }
      double OurTotalLineAway { get; set; }
      double OurTotalLineHome { get; set; }
      string Play { get; set; }
      int RotNum { get; set; }
      string Season { get; set; }
      double? SideLine { get; set; }
      string SubSeason { get; set; }
      string TeamAway { get; set; }
      string TeamHome { get; set; }
      string GameTime { get; set; }
      double TmStrAdjPct { get; set; }
      double? TmStrAway { get; set; }
      double? TmStrHome { get; set; }
      int TodaysMatchupsID { get; set; }
      double? TotalBubbleAway { get; set; }
      double? TotalBubbleHome { get; set; }
      double? TotalLine { get; set; }
      string TV { get; set; }
      double UnAdjTotal { get; set; }
      double UnAdjTotalAway { get; set; }
      double UnAdjTotalHome { get; set; }
      string UserName { get; set; }
      int WeightGB1 { get; set; }
      int WeightGB2 { get; set; }
      int WeightGB3 { get; set; }
   }
}