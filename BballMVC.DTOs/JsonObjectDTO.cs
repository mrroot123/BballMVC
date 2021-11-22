using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class JsonObjectDTO : IJsonObjectDTO
   {
      public string ObjectName { get; set; }
      public string JsonString { get; set; }
   }
}
