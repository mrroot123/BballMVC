using System;


namespace BballMVC.DTOs
{
   public class LinesDTO
   {
      public long LineID { get; set; }
      public string LeagueName { get; set; }
      public System.DateTime GameDate { get; set; }
      public int RotNum { get; set; }
      public string TeamAway { get; set; }
      public string TeamHome { get; set; }
      public double Line { get; set; }
      public string PlayType { get; set; }
      public string PlayDuration { get; set; }
      public System.DateTime CreateDate { get; set; }
      public string LineSource { get; set; }
   }
}
