using System;

namespace BballMVC.DTOs
{
   public interface IBoxScoresDTO
   {
      double AssistsOp { get; set; }
      double AssistsUs { get; set; }
      bool Exclude { get; set; }
      DateTime GameDate { get; set; }
      string GameTime { get; set; }
      string LeagueName { get; set; }
      DateTime LoadDate { get; set; }
      int LoadTimeSeconds { get; set; }
      int MinutesPlayed { get; set; }
      double OffRBOp { get; set; }
      double OffRBUs { get; set; }
      string Opp { get; set; }
      int OtPeriods { get; set; }
      int RotNum { get; set; }
      double ScoreOT { get; set; }
      double ScoreOTOp { get; set; }
      double ScoreOTUs { get; set; }
      double ScoreQ1Op { get; set; }
      double ScoreQ1Us { get; set; }
      double ScoreQ2Op { get; set; }
      double ScoreQ2Us { get; set; }
      double ScoreQ3Op { get; set; }
      double ScoreQ3Us { get; set; }
      double ScoreQ4Op { get; set; }
      double ScoreQ4Us { get; set; }
      double ScoreReg { get; set; }
      double ScoreRegOp { get; set; }
      double ScoreRegUs { get; set; }
      string Season { get; set; }
      double ShotsActualAttemptedOpPt1 { get; set; }
      double ShotsActualAttemptedOpPt2 { get; set; }
      double ShotsActualAttemptedOpPt3 { get; set; }
      double ShotsActualAttemptedUsPt1 { get; set; }
      double ShotsActualAttemptedUsPt2 { get; set; }
      double ShotsActualAttemptedUsPt3 { get; set; }
      double ShotsActualMadeOpPt1 { get; set; }
      double ShotsActualMadeOpPt2 { get; set; }
      double ShotsActualMadeOpPt3 { get; set; }
      double ShotsActualMadeUsPt1 { get; set; }
      double ShotsActualMadeUsPt2 { get; set; }
      double ShotsActualMadeUsPt3 { get; set; }
      double ShotsAttemptedOpRegPt1 { get; set; }
      double ShotsAttemptedOpRegPt2 { get; set; }
      double ShotsAttemptedOpRegPt3 { get; set; }
      double ShotsAttemptedUsRegPt1 { get; set; }
      double ShotsAttemptedUsRegPt2 { get; set; }
      double ShotsAttemptedUsRegPt3 { get; set; }
      double ShotsMadeOpRegPt1 { get; set; }
      double ShotsMadeOpRegPt2 { get; set; }
      double ShotsMadeOpRegPt3 { get; set; }
      double ShotsMadeUsRegPt1 { get; set; }
      double ShotsMadeUsRegPt2 { get; set; }
      double ShotsMadeUsRegPt3 { get; set; }
      string Source { get; set; }
      string SubSeason { get; set; }
      string Team { get; set; }
      double TurnOversOp { get; set; }
      double TurnOversUs { get; set; }
      string Venue { get; set; }
   }
}