using System;
using Newtonsoft.Json.Linq;


namespace BballMVC.IDTOs
{
   public interface IBballInfoDTO
   {
      string ConnectionString { get; set; }
      string CollectionType { get; set; }
      DateTime GameDate { get; set; }
      DateTime TS { get; set; }
      string LeagueName { get; set; }
      string UserName { get; set; }
      string LogName { get; set; }
      ISeasonInfoDTO oSeasonInfoDTO { get; set; }
      System.Object oObject { get; set; }
      JObject oJObject { get; set; }
      string sJsonString { get; set; }
      IBballDataDTO oBballDataDTO { get; set; }
      string LoadDateTime { get; set; }
      void CloneBballDataDTO(IBballInfoDTO c);
     
   }
   //public interface JsonString
   //{
   //    string sJsonString { get; set; }
   //}
}
