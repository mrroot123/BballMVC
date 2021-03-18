using System.Collections.Generic;

using BballMVC.IDTOs;


namespace BballMVC.DTOs
{
   public class BballDataDTO : IBballDataDTO 
   {
     // public IGetDataConstants DataConstants { get; set; }
      public string  Message { get; set; }
      public int     MessageNumber { get; set; }
      public string  BaseDir { get; set; }
      public IList<IAdjustmentDTO>        ocAdjustments        { get; set; }     // Adj
      public IList<IDropDown>             ocAdjustmentNames    { get; set; }     // Adj
      public IList<IDropDown>             ocTeams              { get; set; }     // Lg
      public IList<IDropDown>             ocLeagueNames        { get; set; }     // Init
      public IList<ITodaysMatchupsDTO>    ocTodaysMatchupsDTO  { get; set; }     // TM
      public IList<IBoxScoresSeedsDTO>    ocBoxScoresSeedsDTO  { get; set; }     // BSS
      public IList<IvPostGameAnalysisDTO> ocPostGameAnalysisDTO { get; set; }    // PGA

      public IDailySummaryDTO oDailySummaryDTO  { get; set; }                    // TM
      public ISeasonInfoDTO   oSeasonInfoDTO    { get; set; }                    // Lg
      public ILeagueDTO oLeagueDTO { get; set; }                                 // Lg
      public IUserLeagueParmsDTO oUserLeagueParmsDTO { get; set; }               // Lg

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
         oLeagueDTO = new LeagueDTO();
         oUserLeagueParmsDTO = new UserLeagueParmsDTO();

         DataConstants = new System.Dynamic.ExpandoObject();
      }
   }
   public class DropDown : IDropDown
   {
      public string Value { get; set; }
      public string Text { get; set; }
   }
}
