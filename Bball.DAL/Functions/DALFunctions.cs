using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bball.DAL.Functions
{
   public static class DALFunctions
   {
      public static string StackTraceFormat(Exception ex) => StackTraceFormat("", ex, "");

      public static string StackTraceFormat(String PreMsg, Exception ex, string PostMsg)
      {
         return SysDAL.DALfunctions.StackTraceFormat(PreMsg, ex, PostMsg);
      }

   }
}
