using System.Collections.Generic;

using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class AdjustmentInitDataDTO : IAdjustmentInitDataDTO
   {
      public List<IDTOs.IAdjustmentDTO> ocAdjustments { get; set; }
      public List<string> ocTeams { get; set; }
      public List<string> ocAdjustmentNames { get; set; }
   }
}
