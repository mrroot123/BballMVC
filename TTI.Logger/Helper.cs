using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http.Filters;
using BballMVC.IDTOs;
using Bball.DataBaseFunctions;
using DF = SysDAL.Functions.DALfunctions;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace TTI.Logger
{
    public class Helper
   {
      const string TTILog = "TTILog";

      public static void Log(IBballInfoDTO oBballInfoDTO,  string Message)
      {
         logIt(oBballInfoDTO, "Log", Message, "");

      }
      public static void LogMessage(IBballInfoDTO oBballInfoDTO, Exception ex, string Message)
      {
         logIt(oBballInfoDTO, "Error", Message, ex.StackTrace);
      }
      public static void LogError(string Message)
      {
         logIt(null, "Error", Message, "");
      }
      private static void logIt(IBballInfoDTO oBballInfoDTO, string MessageType, string Message, string StackTrace)
      {
         TTILogMessage oTTILogMessage = new TTILogMessage()
         {
            TS = oBballInfoDTO.TS,
            UserName = oBballInfoDTO.UserName,
            ApplicationName = "Bball",
            MessageNum = 0,
            MessageType = MessageType,
            MessageText = Message,
            CallStack = StackTrace
         };

         LogMessage(oTTILogMessage, oBballInfoDTO.ConnectionString, oBballInfoDTO.LogName);
      }
      public static void LogMessage(HttpActionExecutedContext context)
      {
         TTILogMessage oTTILogMessage = new TTILogMessage()
         {
            TS = DateTime.Now,
            UserName = "Test",
            ApplicationName = "Bball",
            MessageNum = 0,
            MessageType = "Error",
            MessageText = context.Exception.Message, 
            CallStack = context.Exception.StackTrace
         };

         LogMessage(oTTILogMessage, DF.GetConnectionString(), TTILog);
      }
      //public static string LogMessage(TTILogMessage oTTILogMessage, string ConnectionString, string TTILogTable)
      //{ }

      public static string LogMessage(TTILogMessage oTTILogMessage
         , string ConnectionString = null, string TTILogTable = TTILog)
      {
         if (ConnectionString == null)
            ConnectionString = DF.GetConnectionString();

         const string ColumnNames = "TS,UserName,ApplicationName,MessageNum,MessageType,MessageText,CallStack";
         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();
         List<string> ocValues = new List<string>()
         {
            oTTILogMessage.TS == null ? DateTime.Now.ToLongTimeString() : oTTILogMessage.TS.ToString(),
            oTTILogMessage.UserName ?? "",
            oTTILogMessage.ApplicationName,
            oTTILogMessage.MessageNum.ToString(),
            oTTILogMessage.MessageType ?? "Error",
            oTTILogMessage.MessageText,
            oTTILogMessage.CallStack ?? ""
         };

         // insert row
         string rc = "";
         try
         {
            rc = write2Log(ConnectionString, TTILogTable, ocColumns, ocValues);
            
         }
         catch (Exception ex)
         {
            return "Exception - TTILog row not inserted - Exception Message: " + ex.Message;
         }
         if (rc == "1")
            return "success - TTILog row inserted";
         if (rc == "0")
            return "error - TTILog row not inserted";

         return $"Unknown SQL Insert Retruncode: {rc}";
      }  // LogMessage
      private static string write2Log(string ConnectionString, string TTILogTable, List<string> ocColumns, List<string> ocValues)
      {
         string rc = "";
         string CsvFile = Path.Combine(new string[] { System.AppDomain.CurrentDomain.BaseDirectory, "App_Data", TTILog + ".csv"});

         string msg = "";
         if (!File.Exists(CsvFile))
         {
            msg = genCsvMsg(ocColumns);
         }

         msg = msg + genCsvMsg(ocValues);

         File.AppendAllText(CsvFile, msg);
         rc = SysDAL.Functions.DALfunctions.InsertTableRow(ConnectionString, TTILogTable, ocColumns, ocValues);

         return "1";
      }
      private static string genCsvMsg(List<string> ocValues)
      {
         string comma = "";
         StringBuilder sb = new StringBuilder("");
         foreach (var s in ocValues)
         {
            sb.Append(comma + wrap(s));
            comma = ", ";
         }

         return sb.ToString() + ";";
      }
      static string wrap(string s)
      {
         s = Regex.Replace(s, "\"", "'");
         return "\"" + s + "\"";
      }
   }  // class
}  // nameSpace