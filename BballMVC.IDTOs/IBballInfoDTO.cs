using System;


namespace BballMVC.IDTOs
{
   public interface IBballInfoDTO
   {
      string ConnectionString { get; set; }
      string CollectionType { get; set; }
      DateTime GameDate { get; set; }
      string LeagueName { get; set; }
      string UserName { get; set; }
      string LogName { get; set; }
      ISeasonInfoDTO oSeasonInfoDTO { get; set; }
      IBballDataDTO oBballDataDTO { get; set; }
      string LoadDateTime();
      void CloneBballDataDTO(IBballInfoDTO c);
   }
}
