using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class UserLeagueParmsDTO : IUserLeagueParmsDTO  
   {
      public int UserLeagueParmsID { get; set; }
      public string UserName { get; set; }
      public string LeagueName { get; set; }
      public System.DateTime StartDate { get; set; }
      public System.DateTime LgAvgStartDate { get; set; }
      public int LgAvgGamesBack { get; set; }
      public int TeamAvgGamesBack { get; set; }
      public int TeamPaceGamesBack { get; set; }
      public int TeamSeedGames { get; set; }
      public int LoadRotationDaysAhead { get; set; }
      public int GB1 { get; set; }
      public int GB2 { get; set; }
      public int GB3 { get; set; }
      public double WeightGB1 { get; set; }
      public double WeightGB2 { get; set; }
      public double WeightGB3 { get; set; }
      public double Threshold { get; set; }
      public double BxScLinePct { get; set; }
      public double BxScTmStrPct { get; set; }
      public double TmStrAdjPct { get; set; }
      public double RecentLgHistoryAdjPct { get; set; }
      public bool BothHome_Away { get; set; }
      public Nullable<bool> BoxscoresSpanSeasons { get; set; }
   }
}
