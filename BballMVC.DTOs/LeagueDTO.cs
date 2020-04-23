using System;
using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class LeagueDTO : ILeagueDTO
   {
      public string LeagueName { get; set; }
      public int Periods {get; set;}
      public int MinutesPerPeriod {get; set;}
      public int OverTimeMinutes {get; set;}
      public bool MultiYearLeague {get; set;}
   }
}
