using System;

namespace BballMVC.DTOs
{
   public class BoxScoresLast5MinDTO
   {
      public string LeagueName { get; set; }
      public System.DateTime GameDate { get; set; }
      public int RotNum { get; set; }
      public string Team { get; set; }
      public string Opp { get; set; }
      public string Venue { get; set; }
      public double Q4Last5MinScore { get; set; }
      public double Q4Last1MinScore { get; set; }
      public double Q4Score { get; set; }
      public double Q4Last1MinScoreUs { get; set; }
      public double Q4Last1MinScoreOp { get; set; }
      public string Q4Last1MinWinningTeam { get; set; }
      public double Q4Last1MinUsPt1 { get; set; }
      public double Q4Last1MinUsPt2 { get; set; }
      public double Q4Last1MinUsPt3 { get; set; }
      public double Q4Last1MinOpPt1 { get; set; }
      public double Q4Last1MinOpPt2 { get; set; }
      public double Q4Last1MinOpPt3 { get; set; }
      public string Source { get; set; }
      public System.DateTime LoadDate { get; set; }

   }
}
