using System;


namespace BballMVC.DTOs
{
   public class RotationDTO
   {
      public string LeagueName { get; set; }
      public System.DateTime GameDate { get; set; }
      public int RotNum { get; set; }
      public string Venue { get; set; }
      public string Team { get; set; }
      public string Opp { get; set; }
      public System.TimeSpan GameTime { get; set; }
      public string TV { get; set; }
      public double? SideLine { get; set; }
      public double? TotalLine { get; set; }
      public double? TotalLineTeam { get; set; }
      public double? TotalLineOpp { get; set; }
      public double? OpenTotalLine { get; set; }
      public string BoxScoreSource { get; set; }
      public string BoxScoreUrl { get; set; }
      public System.DateTime CreateDate { get; set; }
      public Nullable<System.DateTime> UpdateDate { get; set; }
   }
}
