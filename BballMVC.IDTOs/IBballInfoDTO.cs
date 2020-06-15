using System;


namespace BballMVC.IDTOs
{
   public interface IBballInfoDTO
   {
      string ConnectionString { get; set; }
      DateTime GameDate { get; set; }
      string LeagueName { get; set; }
      string UserName { get; set; }
      ISeasonInfoDTO oSeasonInfoDTO { get; set; }
   }
}
