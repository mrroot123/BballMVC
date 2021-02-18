using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Filters;
using BballMVC.IDTOs;


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

         LogMessage(oTTILogMessage, GetConnectionString(), TTILog);
      }
      //public static string LogMessage(TTILogMessage oTTILogMessage, string ConnectionString, string TTILogTable)
      //{ }

      public static string LogMessage(TTILogMessage oTTILogMessage
         , string ConnectionString = null, string TTILogTable = TTILog)
      {
         if (ConnectionString == null)
            ConnectionString = GetConnectionString();

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
         //try
         //{
            rc = SysDAL.Functions.DALfunctions.InsertTableRow(ConnectionString, TTILogTable, ocColumns, ocValues);
         //}
         //catch (Exception ex)
         //{
         //   throw new Exception("Invalid TTILogTable Insert/n" + ex.Message);
         //}
         if (rc == "1")
            return "success - TTILog row inserted";
         if (rc == "0")
            return "error - TTILog row not inserted";

         return $"Unknown SQL Insert Retruncode: {rc}";
      }


      static string GetConnectionString()
      {
         const string SqlServerConnectionStringLOCAL =
            @"Data Source=Localhost\Bball;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";

         const string SqlServerConnectionStringBballPROD =
            @"Data Source=Localhost\BballPROD;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";

         const string SqlServerConnectionStringARVIXE =
            @"Data Source=Localhost\;     Initial Catalog=00TTI_LeagueScores;Integrated Security=false;User ID=theroot;Password=788788kd";

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"T:\BballMVC") >= 0)
            return SqlServerConnectionStringBballPROD;

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"\HostingSpaces\") >= 0)
            return SqlServerConnectionStringARVIXE;

         return SqlServerConnectionStringLOCAL;
      }
   }
}