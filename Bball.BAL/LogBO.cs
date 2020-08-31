using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TTI.Logger;

namespace Bball.BAL
{
   public class LogBO
   {
      public string LogMessage(TTILogMessage oTTILogMessage, string ConnectionString, string TTILogTable)
      {
         return Helper.LogMessage(oTTILogMessage, ConnectionString, TTILogTable);
      }
   }
}
