using System;


namespace BballMVC.IDTOs
{
   public interface IAdjustmentDTO
   {
      double? AdjustmentAmount { get; set; }
      int AdjustmentID { get; set; }
      string AdjustmentType { get; set; }
      string Description { get; set; }
      DateTime? EndDate { get; set; }
      string LeagueName { get; set; }
      string Player { get; set; }
      DateTime StartDate { get; set; }
      string Team { get; set; }
      DateTime? TS { get; set; }
   }
}