using System;
using System.Collections.Generic;

namespace BballMVC.IDTOs
{
   public interface IAdjustmentInitDataDTO
   {
      List<string> ocAdjustmentNames { get; set; }
      List<IAdjustmentDTO> ocAdjustments { get; set; }
      List<string> ocTeams { get; set; }
   }
}
