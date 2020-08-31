using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TTI.Logger
{
   public class TTILogMessage
   {
      public string UserName { get; set; }
      public string Password { get; set; }
      public string ApplicationName { get; set; }
      public DateTime TS { get; set; }
      public int MessageNum { get; set; }
      public string MessageType { get; set; }
      public string MessageText { get; set; }
      public string CallStack { get; set; }
   }
}