using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class BballInfoDTO : IBballInfoDTO
   {
      public string UserName { get; set; }
      public DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public string ConnectionString { get; set; }
      public ISeasonInfoDTO oSeasonInfoDTO { get; set; }

   }
}
