using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.IDTOs
{
   public interface IJsonObjectDTO
   {
      string JsonString { get; set; }
      string ObjectName { get; set; }
   }
}
