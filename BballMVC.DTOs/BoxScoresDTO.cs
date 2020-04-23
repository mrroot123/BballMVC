﻿using System;
using BballMVC.IDTOs;



namespace BballMVC.DTOs
{
    public class BoxScoresDTO : IBoxScoresDTO
   {
      public bool Exclude { get; set; }
      public string LeagueName { get; set; }
      public System.DateTime GameDate { get; set; }
      public int RotNum { get; set; }
      public string Team { get; set; }
      public string Opp { get; set; }
      public string Venue { get; set; }
      public string GameTime { get; set; }
      public string Season { get; set; }
      public string SubSeason { get; set; }
      public int MinutesPlayed { get; set; }
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
      public string Source { get; set; }
      public System.DateTime LoadDate { get; set; }
      public int LoadTimeSeconds { get; set; }

   }
}