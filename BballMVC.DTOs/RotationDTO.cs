using System;
using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class RotationDTO : IRotationDTO
   {
      public int RotationID { get; set; }
      public string LeagueName { get; set; }
      public string Season { get; set; }
      public string SubSeason { get; set; }
      public Nullable<int> SubSeasonPeriod { get; set; }
      public System.DateTime GameDate { get; set; }
      public int RotNum { get; set; }
      public string Venue { get; set; }
      public string Team { get; set; }
      public string Opp { get; set; }
      public string GameTime { get; set; }
      public string TV { get; set; }
      public Nullable<double> SideLine { get; set; }
      public Nullable<double> TotalLine { get; set; }
      public Nullable<double> TotalLineTeam { get; set; }
      public Nullable<double> TotalLineOpp { get; set; }
      public Nullable<double> OpenTotalLine { get; set; }
      public string BoxScoreSource { get; set; }
      public string BoxScoreUrl { get; set; }
      public System.DateTime CreateDate { get; set; }
      public Nullable<System.DateTime> UpdateDate { get; set; }
   }
}
