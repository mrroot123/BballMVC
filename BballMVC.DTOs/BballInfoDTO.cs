using System;
using BballMVC.IDTOs;
using Newtonsoft.Json.Linq;

namespace BballMVC.DTOs
{
   public class BballInfoDTO : IBballInfoDTO
   {
      // Constructor
      public BballInfoDTO()
      {
         oBballDataDTO = new BballDataDTO();
      }

      public string UserName { get; set; }
      public DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public string CollectionType { get; set; }
      public string ConnectionString { get; set; }
      public string LogName { get; set; }
      public ISeasonInfoDTO oSeasonInfoDTO { get; set; }
      public JObject oJObject { get; set; }

      public IBballDataDTO oBballDataDTO { get; set; }

      public string LoadDateTime()=> GameDate.ToString();

      public void CloneBballDataDTO(IBballInfoDTO c)
      {
         c.UserName = this.UserName;
         c.GameDate = this.GameDate;
         c.LeagueName = this.LeagueName;
         c.ConnectionString = this.ConnectionString;
         c.CollectionType = this.CollectionType;
         c.LogName = this.LogName;
      }
   }

}
