using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TTI.Models
{
    public class TaskInfo
    {
      public string TaskID { get; set; }
      public string TaskType { get; set; }
      public string Message { get; set; }
      public int ReturnCode { get; set; }
      public long ElapsedTimeInMS { get; set; }

      public Stopwatch oStopwatch = Stopwatch.StartNew();
      public void EndTaskWithError(int returnCode, string message)
      {
         oStopwatch.Stop();
         ElapsedTimeInMS = oStopwatch.ElapsedMilliseconds;
         ReturnCode = returnCode;
         Message = message;
      }
      public void EndTask()
      {
         oStopwatch.Stop();
         ElapsedTimeInMS = oStopwatch.ElapsedMilliseconds;
      }
   }
}
