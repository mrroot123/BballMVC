using System;

namespace BballMVC.IDTOs
{
   public interface ISeasonInfoDTO
   {
      string BoxscoreSource { get; set; }
      bool Bypass { get; set; }
      DateTime EndDate { get; set; }
      bool IncludePost { get; set; }
      bool IncludePre { get; set; }
      string LeagueName { get; set; }
      string Season { get; set; }
      DateTime StartDate { get; set; }
      string SubSeason { get; set; }
   }
}