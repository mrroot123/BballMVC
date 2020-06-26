using System.Collections.Generic;

using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class BballDataDTO : IBballDataDTO 
   {
      public IList<IAdjustmentDTO> ocAdjustments { get; set; }
      public IList<IDropDown> ocAdjustmentNames { get; set; }
      public IList<IDropDown> ocTeams { get; set; }
      public IList<IDropDown> ocLeagueNames { get; set; }
      public IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO { get; set; }

      public BballDataDTO()
      {
         ocAdjustments = new List<IAdjustmentDTO>();
         ocAdjustmentNames = new List<IDropDown>();
         ocTeams = new List<IDropDown>();
         ocLeagueNames = new List<IDropDown>();
         ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
      }
   }
   public class DropDown : IDropDown
   {
      public string Value { get; set; }
      public string Text { get; set; }
   }
}
