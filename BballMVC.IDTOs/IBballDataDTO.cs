using System.Collections.Generic;
using BballMVC.IDTOs;

namespace BballMVC.IDTOs
{
   public interface IBballDataDTO
   {
      IList<IDropDown> ocAdjustmentNames { get; set; }
      IList<IAdjustmentDTO> ocAdjustments { get; set; }
      IList<IDropDown> ocLeagueNames { get; set; }
      IList<IDropDown> ocTeams { get; set; }
      IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO { get; set; }
   }
}