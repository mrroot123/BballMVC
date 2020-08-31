using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TTI.Logger
{
   public class Helper
   {
      public static string LogMessage(TTILogMessage oTTILogMessage, string ConnectionString, string TTILogTable)

      {

         const string ColumnNames = "TS,UserName,ApplicationName,MessageNum,MessageType,MessageText,CallStack";
         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();
         List<string> ocValues = new List<string>()
         {
            oTTILogMessage.TS == null ? DateTime.Now.ToLongTimeString() : oTTILogMessage.TS.ToString(),
            oTTILogMessage.UserName,
            oTTILogMessage.ApplicationName,
            oTTILogMessage.MessageNum.ToString(),
            oTTILogMessage.MessageType == null ? "Error" : oTTILogMessage.MessageType,
            oTTILogMessage.MessageText,
            oTTILogMessage.CallStack == null ? "" : oTTILogMessage.CallStack
         };

         // insert row
         string rc = SysDAL.Functions.DALfunctions.InsertTableRow(ConnectionString, TTILogTable, ocColumns, ocValues);
         if (rc == "1")
            return "success - TTILog row inserted";
         if (rc == "0")
            return "error - TTILog row not inserted";

         return $"Unknown SQL Insert Retruncode: {rc}";

      }
   }
}