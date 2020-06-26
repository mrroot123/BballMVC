using System;
using System.Collections.Generic;

namespace BballMVC.IDTOs
{
   public interface xIAdjustmentInitDataDTO
   {
      List<IDropDown> ocAdjustmentNames { get; set; }
      List<IAdjustmentDTO> ocAdjustments { get; set; }
      List<IDropDown> ocTeams { get; set; }
      List<IDropDown> ocLeagueNames { get; set; }
   }
   public interface IDropDown
   {
      string Value { get; set; }
      string Text { get; set; }
   }
}
