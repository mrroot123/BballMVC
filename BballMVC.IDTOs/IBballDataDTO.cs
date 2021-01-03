using System.Collections.Generic;
using BballMVC.IDTOs;

namespace BballMVC.IDTOs
{
   public interface IBballDataDTO
   {
      string Message { get; set; }
      int MessageNumber { get; set; }
      string BaseDir { get; set; }
      IList<IDropDown> ocAdjustmentNames { get; set; }
      IList<IAdjustmentDTO> ocAdjustments { get; set; }
      IList<IDropDown> ocLeagueNames { get; set; }
      IList<IDropDown> ocTeams { get; set; }
      IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO { get; set; }
      IList<IBoxScoresSeedsDTO> ocBoxScoresSeedsDTO { get; set; }
      IList<IvPostGameAnalysisDTO> ocPostGameAnalysisDTO { get; set; }
      IDailySummaryDTO oDailySummaryDTO { get; set; }
      ISeasonInfoDTO oSeasonInfoDTO { get; set; }
      IUserLeagueParmsDTO oUserLeagueParmsDTO { get; set; }
      dynamic DataConstants { get; set; }
   }
}