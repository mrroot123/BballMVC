using System;

namespace BballMVC.IDTOs
{
   public interface IAdjustmentsDailyDTO
   {
      double AdjustmentAmount { get; set; }
      int AdjustmentsDailyID { get; set; }
      DateTime GameDate { get; set; }
      string LeagueName { get; set; }
      int RotNum { get; set; }
      string Team { get; set; }
   }
}
