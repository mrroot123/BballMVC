using System.Collections.Generic;

using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class AdjustmentInitDataDTO : IAdjustmentInitDataDTO
   {
      public List<IDTOs.IAdjustmentDTO> ocAdjustments { get; set; }
      public List<IDropDown> ocAdjustmentNames { get; set; }
      public List<IDropDown> ocTeams { get; set; }
      public List<IDropDown> ocLeagueNames { get; set; }
   }
   public class DropDown : IDropDown
   {
      public string Value { get; set; }
      public string Text { get; set; }
   }
}
