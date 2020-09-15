using System;
using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class LeagueDTO : ILeagueDTO 
   {
      public string LeagueName { get; set; }
      public System.DateTime StartDate { get; set; }
      public int NumberOfTeams { get; set; }
      public int Periods { get; set; }
      public int MinutesPerPeriod { get; set; }
      public int OverTimeMinutes { get; set; }
      public double DefaultOTamt { get; set; }
      public bool MultiYearLeague { get; set; }
      public string LeagueColor { get; set; }
      public string BoxScoresL5MinURL { get; set; }
   }
}
