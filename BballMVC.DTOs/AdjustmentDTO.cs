using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class AdjustmentDTO : IAdjustmentDTO
   {
      public int AdjustmentID { get; set; }
      public string LeagueName { get; set; }
      public DateTime StartDate { get; set; }
      public DateTime? EndDate { get; set; }
      public string Team { get; set; }
      public string AdjustmentType { get; set; }
      public double AdjustmentAmount { get; set; }
      public string Player { get; set; }
      public string Description { get; set; }
      public DateTime? TS { get; set; }

      public AdjustmentDTO ShallowCopy()
      {
         return (AdjustmentDTO)this.MemberwiseClone();
      }
   }
}
