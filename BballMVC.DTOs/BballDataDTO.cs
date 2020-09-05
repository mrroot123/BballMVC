using System.Collections.Generic;

using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class BballDataDTO : IBballDataDTO 
   {
     // public IGetDataConstants DataConstants { get; set; }
      public string Message { get; set; }
      public int MessageNumber { get; set; }
      public string BaseDir { get; set; }
      public IList<IAdjustmentDTO> ocAdjustments { get; set; }
      public IList<IDropDown> ocAdjustmentNames { get; set; }
      public IList<IDropDown> ocTeams { get; set; }
      public IList<IDropDown> ocLeagueNames { get; set; }
      public IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO { get; set; }
      public IList<IBoxScoresSeedsDTO> ocBoxScoresSeedsDTO { get; set; }
      public IList<IvPostGameAnalysisDTO> ocPostGameAnalysisDTO { get; set; }

      public IDailySummaryDTO oDailySummaryDTO { get; set; }
      public ISeasonInfoDTO oSeasonInfoDTO { get; set; }

      public dynamic DataConstants { get; set; }


      // Constructor
      public BballDataDTO()
      {
         ocAdjustments = new List<IAdjustmentDTO>();
         ocAdjustmentNames = new List<IDropDown>();
         ocTeams = new List<IDropDown>();
         ocLeagueNames = new List<IDropDown>();
         ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
         ocBoxScoresSeedsDTO = new List<IBoxScoresSeedsDTO>();
         ocPostGameAnalysisDTO = new List<IvPostGameAnalysisDTO>();
         oDailySummaryDTO = new DailySummaryDTO();
         oSeasonInfoDTO = new SeasonInfoDTO();
      }
   }
   public class DropDown : IDropDown
   {
      public string Value { get; set; }
      public string Text { get; set; }
   }
}
