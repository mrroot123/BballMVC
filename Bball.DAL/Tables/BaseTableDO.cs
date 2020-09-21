using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TTI.Logger;

namespace Bball.DAL.Tables
{
   public class BaseTableDO
   {

      public void Log(string msg)
      {
         TTILogMessage oTTILogMessage = new TTILogMessage()
         {
            TS = DateTime.Now,
            UserName = "Test",
            ApplicationName = "Bball",
            MessageNum = 0,
            MessageType = "Log",
            MessageText = msg,
            CallStack = ""
         };
         Helper.LogMessage(oTTILogMessage);
      }
   }
}
