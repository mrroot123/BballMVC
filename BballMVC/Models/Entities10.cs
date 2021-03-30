using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BballMVC.Models
{
   using System.Data.Entity;

   public partial class Entities2 : DbContext
   {
      public Entities2(string connName)   : base(connName)
      {
      }
   }
}