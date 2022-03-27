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
         oSeasonInfoDTO = new SeasonInfoDTO();
         oBballDataDTO = new BballDataDTO();
      }

      public string UserName { get; set; }
      public DateTime GameDate { get; set; }
      public DateTime FromDate { get; set; }
      public DateTime ToDate { get; set; }
      public DateTime TS { get; set; }
      public string LeagueName { get; set; }
      public string CollectionType { get; set; }

      public string ConnectionString { get; set; }
      public string BaseDirectory { get; set; }      //System.AppDomain.CurrentDomain.BaseDirectory
      public string LogName { get; set; }
      public string LogFileNameCsvName { get; set; }
      public string sJsonString { get; set; }
      public string LoadDateTime { get; set; } = DateTime.Now.ToLongDateString();

      public System.Object oObject { get; set; }
      public JObject oJObject { get; set; }
      public ISeasonInfoDTO oSeasonInfoDTO { get; set; }
      public IBballDataDTO oBballDataDTO { get; set; }

      

      public void CloneBballDataDTO(IBballInfoDTO c)
      {
         c.UserName = this.UserName;
         c.GameDate = this.GameDate;
         c.TS = this.TS;
         c.LeagueName = this.LeagueName;
         c.CollectionType = this.CollectionType;

         c.ConnectionString = this.ConnectionString;
         c.LogName = this.LogName;
         c.sJsonString = this.sJsonString;
         c.LoadDateTime = this.LoadDateTime;
      }

   }
   public class JsonString
   {
      public string sJsonString { get; set; }
   }

}
