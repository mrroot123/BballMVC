//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BballMVC.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class vPostGameAnalysis
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
        public Nullable<bool> Canceled { get; set; }
        public string TV { get; set; }
        public double TmStrAway { get; set; }
        public Nullable<double> TmStrHome { get; set; }
        public string TeamRecordAway { get; set; }
        public string TeamRecordHome { get; set; }
        public Nullable<double> UnAdjTotalAway { get; set; }
        public double UnAdjTotalHome { get; set; }
        public double UnAdjTotal { get; set; }
        public Nullable<double> UnAdjTotalAwayPlanB { get; set; }
        public Nullable<double> UnAdjTotalHomePlanB { get; set; }
        public Nullable<double> UnAdjTotalPlanB { get; set; }
        public Nullable<double> CalcAwayGB1PlanB { get; set; }
        public Nullable<double> CalcAwayGB2PlanB { get; set; }
        public Nullable<double> CalcAwayGB3PlanB { get; set; }
        public Nullable<double> CalcHomeGB1PlanB { get; set; }
        public Nullable<double> CalcHomeGB2PlanB { get; set; }
        public Nullable<double> CalcHomeGB3PlanB { get; set; }
        public Nullable<double> AwayAveragePtsScored { get; set; }
        public Nullable<double> HomeAveragePtsScored { get; set; }
        public Nullable<double> AwayAveragePtsAllowed { get; set; }
        public Nullable<double> HomeAveragePtsAllowed { get; set; }
        public double AdjAmt { get; set; }
        public double AdjAmtAway { get; set; }
        public double AdjAmtHome { get; set; }
        public double AdjDbAway { get; set; }
        public double AdjDbHome { get; set; }
        public double AdjOTwithSide { get; set; }
        public double AdjTV { get; set; }
        public Nullable<double> AdjRecentLeagueHistory { get; set; }
        public Nullable<double> AdjPaceAway { get; set; }
        public Nullable<double> AdjPaceHome { get; set; }
        public Nullable<double> AdjTeamAway { get; set; }
        public Nullable<double> AdjTeamHome { get; set; }
        public double OurTotalLineAway { get; set; }
        public double OurTotalLineHome { get; set; }
        public double OurTotalLine { get; set; }
        public double SideLine { get; set; }
        public Nullable<double> TotalLine { get; set; }
        public Nullable<double> OpenTotalLine { get; set; }
        public string Play { get; set; }
        public string Played { get; set; }
        public Nullable<double> PlayDiff { get; set; }
        public Nullable<double> OpenPlayDiff { get; set; }
        public Nullable<double> AdjustedDiff { get; set; }
        public double BxScLinePct { get; set; }
        public double TmStrAdjPct { get; set; }
        public Nullable<double> VolatilityAway { get; set; }
        public Nullable<double> VolatilityHome { get; set; }
        public Nullable<double> Volatility { get; set; }
        public int Threshold { get; set; }
        public int GB1 { get; set; }
        public int GB2 { get; set; }
        public int GB3 { get; set; }
        public int WeightGB1 { get; set; }
        public int WeightGB2 { get; set; }
        public int WeightGB3 { get; set; }
        public double AwayProjectedPt1 { get; set; }
        public double AwayProjectedPt2 { get; set; }
        public double AwayProjectedPt3 { get; set; }
        public double HomeProjectedPt1 { get; set; }
        public double HomeProjectedPt2 { get; set; }
        public double HomeProjectedPt3 { get; set; }
        public Nullable<double> AwayProjectedAtmpPt1 { get; set; }
        public Nullable<double> AwayProjectedAtmpPt2 { get; set; }
        public Nullable<double> AwayProjectedAtmpPt3 { get; set; }
        public Nullable<double> HomeProjectedAtmpPt1 { get; set; }
        public Nullable<double> HomeProjectedAtmpPt2 { get; set; }
        public Nullable<double> HomeProjectedAtmpPt3 { get; set; }
        public double AwayAverageAtmpUsPt1 { get; set; }
        public double AwayAverageAtmpUsPt2 { get; set; }
        public double AwayAverageAtmpUsPt3 { get; set; }
        public double HomeAverageAtmpUsPt1 { get; set; }
        public double HomeAverageAtmpUsPt2 { get; set; }
        public double HomeAverageAtmpUsPt3 { get; set; }
        public double AwayGB1 { get; set; }
        public double AwayGB2 { get; set; }
        public double AwayGB3 { get; set; }
        public double HomeGB1 { get; set; }
        public double HomeGB2 { get; set; }
        public double HomeGB3 { get; set; }
        public double AwayGB1Pt1 { get; set; }
        public double AwayGB1Pt2 { get; set; }
        public double AwayGB1Pt3 { get; set; }
        public double AwayGB2Pt1 { get; set; }
        public double AwayGB2Pt2 { get; set; }
        public double AwayGB2Pt3 { get; set; }
        public double AwayGB3Pt1 { get; set; }
        public double AwayGB3Pt2 { get; set; }
        public double AwayGB3Pt3 { get; set; }
        public double HomeGB1Pt1 { get; set; }
        public double HomeGB1Pt2 { get; set; }
        public double HomeGB1Pt3 { get; set; }
        public double HomeGB2Pt1 { get; set; }
        public double HomeGB2Pt2 { get; set; }
        public double HomeGB2Pt3 { get; set; }
        public double HomeGB3Pt1 { get; set; }
        public double HomeGB3Pt2 { get; set; }
        public double HomeGB3Pt3 { get; set; }
        public Nullable<double> AwayAverageMadePt1 { get; set; }
        public Nullable<double> AwayAverageMadePt2 { get; set; }
        public Nullable<double> AwayAverageMadePt3 { get; set; }
        public Nullable<double> HomeAverageMadePt1 { get; set; }
        public Nullable<double> HomeAverageMadePt2 { get; set; }
        public Nullable<double> HomeAverageMadePt3 { get; set; }
        public Nullable<double> AwayAverageAllowedPt1 { get; set; }
        public Nullable<double> AwayAverageAllowedPt2 { get; set; }
        public Nullable<double> AwayAverageAllowedPt3 { get; set; }
        public Nullable<double> HomeAverageAllowedPt1 { get; set; }
        public Nullable<double> HomeAverageAllowedPt2 { get; set; }
        public Nullable<double> HomeAverageAllowedPt3 { get; set; }
        public Nullable<double> LgAvgShotsMadeAwayPt1 { get; set; }
        public Nullable<double> LgAvgShotsMadeAwayPt2 { get; set; }
        public Nullable<double> LgAvgShotsMadeAwayPt3 { get; set; }
        public Nullable<double> LgAvgShotsMadeHomePt1 { get; set; }
        public Nullable<double> LgAvgShotsMadeHomePt2 { get; set; }
        public Nullable<double> LgAvgShotsMadeHomePt3 { get; set; }
        public Nullable<double> AverageMadeAwayGB1Pt1 { get; set; }
        public Nullable<double> AverageMadeAwayGB1Pt2 { get; set; }
        public Nullable<double> AverageMadeAwayGB1Pt3 { get; set; }
        public Nullable<double> AverageMadeAwayGB2Pt1 { get; set; }
        public Nullable<double> AverageMadeAwayGB2Pt2 { get; set; }
        public Nullable<double> AverageMadeAwayGB2Pt3 { get; set; }
        public Nullable<double> AverageMadeAwayGB3Pt1 { get; set; }
        public Nullable<double> AverageMadeAwayGB3Pt2 { get; set; }
        public Nullable<double> AverageMadeAwayGB3Pt3 { get; set; }
        public Nullable<double> AverageMadeHomeGB1Pt1 { get; set; }
        public Nullable<double> AverageMadeHomeGB1Pt2 { get; set; }
        public Nullable<double> AverageMadeHomeGB1Pt3 { get; set; }
        public Nullable<double> AverageMadeHomeGB2Pt1 { get; set; }
        public Nullable<double> AverageMadeHomeGB2Pt2 { get; set; }
        public Nullable<double> AverageMadeHomeGB2Pt3 { get; set; }
        public Nullable<double> AverageMadeHomeGB3Pt1 { get; set; }
        public Nullable<double> AverageMadeHomeGB3Pt2 { get; set; }
        public Nullable<double> AverageMadeHomeGB3Pt3 { get; set; }
        public Nullable<double> TMoppAdjPct { get; set; }
        public Nullable<double> TotalBubbleAway { get; set; }
        public Nullable<double> TotalBubbleHome { get; set; }
        public Nullable<System.DateTime> TS { get; set; }
        public string AllAdjustmentLines { get; set; }
        public string PlayResult { get; set; }
        public int OtPeriods { get; set; }
        public double ScoreReg { get; set; }
        public double ScoreOT { get; set; }
        public double ScoreRegUs { get; set; }
        public double ScoreRegOp { get; set; }
        public double ScoreOTUs { get; set; }
        public double ScoreOTOp { get; set; }
        public double ScoreQ1Us { get; set; }
        public double ScoreQ1Op { get; set; }
        public double ScoreQ2Us { get; set; }
        public double ScoreQ2Op { get; set; }
        public double ScoreQ3Us { get; set; }
        public double ScoreQ3Op { get; set; }
        public double ScoreQ4Us { get; set; }
        public double ScoreQ4Op { get; set; }
        public double ShotsActualMadeUsPt1 { get; set; }
        public double ShotsActualMadeUsPt2 { get; set; }
        public double ShotsActualMadeUsPt3 { get; set; }
        public double ShotsActualMadeOpPt1 { get; set; }
        public double ShotsActualMadeOpPt2 { get; set; }
        public double ShotsActualMadeOpPt3 { get; set; }
        public double ShotsActualAttemptedUsPt1 { get; set; }
        public double ShotsActualAttemptedUsPt2 { get; set; }
        public double ShotsActualAttemptedUsPt3 { get; set; }
        public double ShotsActualAttemptedOpPt1 { get; set; }
        public double ShotsActualAttemptedOpPt2 { get; set; }
        public double ShotsActualAttemptedOpPt3 { get; set; }
        public double ShotsMadeUsRegPt1 { get; set; }
        public double ShotsMadeUsRegPt2 { get; set; }
        public double ShotsMadeUsRegPt3 { get; set; }
        public double ShotsMadeOpRegPt1 { get; set; }
        public double ShotsMadeOpRegPt2 { get; set; }
        public double ShotsMadeOpRegPt3 { get; set; }
        public double ShotsAttemptedUsRegPt1 { get; set; }
        public double ShotsAttemptedUsRegPt2 { get; set; }
        public double ShotsAttemptedUsRegPt3 { get; set; }
        public double ShotsAttemptedOpRegPt1 { get; set; }
        public double ShotsAttemptedOpRegPt2 { get; set; }
        public double ShotsAttemptedOpRegPt3 { get; set; }
        public double TurnOversUs { get; set; }
        public double TurnOversOp { get; set; }
        public double OffRBUs { get; set; }
        public double OffRBOp { get; set; }
        public double AssistsUs { get; set; }
        public double AssistsOp { get; set; }
        public Nullable<double> Pace { get; set; }
    }
}
