using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class DailySummaryDTO : IDailySummaryDTO 
   {
      public int DailySummaryID { get; set; }
      public System.DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public string Season { get; set; }
      public string SubSeason { get; set; }
      public int SubSeasonPeriod { get; set; }
      public int NumOfMatchups { get; set; }
      public Nullable<System.DateTime> LgAvgStartDate { get; set; }
      public Nullable<System.DateTime> LgAvgStartDateActual { get; set; }
      public int LgAvgGamesBack { get; set; }
      public Nullable<int> LgAvgGamesBackActual { get; set; }
      public double LgAvgScoreAway { get; set; }
      public double LgAvgScoreHome { get; set; }
      public double LgAvgScoreFinal { get; set; }
      public Nullable<double> LgAvgTotalLine { get; set; }
      public double LgAvgShotsMadeAwayPt1 { get; set; }
      public double LgAvgShotsMadeAwayPt2 { get; set; }
      public double LgAvgShotsMadeAwayPt3 { get; set; }
      public double LgAvgShotsMadeHomePt1 { get; set; }
      public Nullable<double> LgAvgShotsMadeHomePt2 { get; set; }
      public Nullable<double> LgAvgShotsMadeHomePt3 { get; set; }
      public Nullable<double> LgAvgLastMinPts { get; set; }
      public Nullable<double> LgAvgLastMinPt1 { get; set; }
      public Nullable<double> LgAvgLastMinPt2 { get; set; }
      public Nullable<double> LgAvgLastMinPt3 { get; set; }
      public Nullable<double> LgAvgTurnOversAway { get; set; }
      public Nullable<double> LgAvgTurnOversHome { get; set; }
      public Nullable<double> LgAvgOffRBAway { get; set; }
      public Nullable<double> LgAvgOffRBHome { get; set; }
      public Nullable<double> LgAvgAssistsAway { get; set; }
      public Nullable<double> LgAvgAssistsHome { get; set; }
      public Nullable<double> LgAvgPace { get; set; }
      public Nullable<double> LgAvgVolatilityTeam { get; set; }
      public Nullable<double> LgAvgVolatilityGame { get; set; }
      public Nullable<double> AdjRecentLeagueHistory { get; set; }
      public Nullable<System.DateTime> TS { get; set; }
   }
}