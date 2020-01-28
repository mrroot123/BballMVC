using System;

namespace BballMVC.DTOs
{
   public class AdjustmentDTO
   {
      public int AdjustmentID { get; set; }
      public string LeagueName { get; set; }
      public System.DateTime StartDate { get; set; }
      public Nullable<System.DateTime> EndDate { get; set; }
      public string Team { get; set; }
      public string AdjustmentType { get; set; }
      public float AdjustmentAmount { get; set; }
      public string Player { get; set; }
      public string Description { get; set; }
      public Nullable<System.DateTime> TS { get; set; }
   }
}
