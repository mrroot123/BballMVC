using System;
using System.Linq;
using System.Collections.Generic;
using SysDAL.Functions;


namespace Bball.DataBaseFunctions
{
   public static class SqlFunctions
   {
      //const string BballConnectionStringName = "BballEntities";  todo delete commented code 10/3/2020
      //  const string SqlServerConnectionStringKeith =
      //     @"Data Source=Localhost\Bball;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";
      //  const string SqlServerConnectionStringTest =
      //   @"Data Source=Localhost\SQLEXPRESS;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";
      //const string SqlServerConnectionStringArvixe =
      //   @"Data Source=Localhost\;   Initial Catalog=00TTI_LeagueScores;Integrated Security=false;User ID=theroot;Password=788788kd";

      public static int CalcSubSeasonPeriod(string ConnectionString, DateTime GameDate, string LeagueName)
      {
         // All ints
         // Get TotalDays rounded down to mul of 4
         // DaysPerPeriod DPP - TD / 4
         // Day in Season DIS - GameDate - StartDate
         // Period = Floor{ [ (DIS + DPP-1) / DPP ], 1}

         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
         List<object> SqlParmValues = new List<object>() { GameDate, LeagueName };
         var SubSeasonPeriod =
            SysDAL.Functions.DALfunctions.ExecuteUDF(
               ConnectionString, "dbo.udfCalcSubSeasonPeriod", SqlParmNames, SqlParmValues);

         return Int32.Parse(SubSeasonPeriod);
      }

      public static DateTime GetNextGameDate(string ConnectionString, DateTime GameDate, string LeagueName)
      {
         List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
         List<object> SqlParmValues = new List<object>() { GameDate, LeagueName };
         var NextGameDate =
            SysDAL.Functions.DALfunctions.ExecuteUDF(
               ConnectionString, "dbo.udfQueryGetNextGameDate", SqlParmNames, SqlParmValues);
         var d = NextGameDate.Split();
         return  DateTime.Parse(d[0]);
      }

      public static int ExecSql(string strSql, string ConnectionString)
      {
         return SysDAL.Functions.DALfunctions.ExecuteSqlNonQuery(ConnectionString, strSql);
      }

      public static string GetConnectionString()
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

      public static DateTime GetMaxGameDate(string ConnectionString, string LeagueName, string TableName, DateTime DefaultDate)
      {
         string strSql = $"Select IsNull( Max(GameDate), '{DefaultDate}') AS GameDate From {TableName}  Where LeagueName = '{LeagueName}'";
         DateTime GameDate = (DateTime)DALfunctions.ExecuteSqlQueryReturnSingleParm(ConnectionString, strSql, "GameDate");

         return GameDate;
      }
      public static string TeamLookup(DateTime StartDate, string LeagueName, string TeamSource, string TeamName)
      {
         List<string> SqlParmNames = new List<string>();
         List<object> SqlParmValues = new List<object>();

         SqlParmNames.Add("@StartDate");
         SqlParmValues.Add(StartDate);

         SqlParmNames.Add("@LeagueName");
         SqlParmValues.Add(LeagueName);

         SqlParmNames.Add("@TeamSource");
         SqlParmValues.Add(TeamSource);

         SqlParmNames.Add("@TeamName");
         SqlParmValues.Add(TeamName);

         string StoredProcedureName = "TeamLookup";
         string ConnectionString = GetConnectionString();

         string s = DALfunctions.ExecuteStoredProcedureQueryReturnSingleParm(ConnectionString, StoredProcedureName, SqlParmNames, SqlParmValues);
         if (String.IsNullOrEmpty(s))
            throw new Exception($"TeamLoop Exception - {StartDate} - {LeagueName} - TeamSource: {TeamSource} - Team: {TeamName}");

         return s;
      }
      public static string TeamLookupTeamNameByTeamNameInDatabase(DateTime StartDate, string LeagueName, string TeamSource, string TeamNameInDatabase)
      {
         List<string> SqlParmNames = new List<string>();
         List<object> SqlParmValues = new List<object>();

         SqlParmNames.Add("@StartDate");
         SqlParmValues.Add(StartDate);

         SqlParmNames.Add("@LeagueName");
         SqlParmValues.Add(LeagueName);

         SqlParmNames.Add("@TeamSource");
         SqlParmValues.Add(TeamSource);

         SqlParmNames.Add("@TeamNameInDatabase");
         SqlParmValues.Add(TeamNameInDatabase);

         string StoredProcedureName = "TeamLookupTeamNameByTeamNameInDatabase";
         string ConnectionString = GetConnectionString(
            );

         string s = DALfunctions.ExecuteStoredProcedureQueryReturnSingleParm(ConnectionString, StoredProcedureName, SqlParmNames, SqlParmValues);
         if (String.IsNullOrEmpty(s))
            throw new Exception($"TeamLoop Exception - {StartDate} - {LeagueName} - TeamSource: {TeamSource} - Team: {TeamNameInDatabase}");

         return s;
      }
      public static string TeamLookupSourceToSource(DateTime StartDate, string LeagueName, string TeamSourceFrom, string TeamSourceTo, string TeamName)
      {
         List<string> SqlParmNames = new List<string>();
         List<object> SqlParmValues = new List<object>();

         SqlParmNames.Add("@StartDate");
         SqlParmValues.Add(StartDate);

         SqlParmNames.Add("@LeagueName");
         SqlParmValues.Add(LeagueName);

         SqlParmNames.Add("@TeamSourceFrom");
         SqlParmValues.Add(TeamSourceFrom);

         SqlParmNames.Add("@TeamSourceTo");
         SqlParmValues.Add(TeamSourceTo);

         SqlParmNames.Add("@TeamName");
         SqlParmValues.Add(TeamName);

         string StoredProcedureName = "TeamLookupSourceToSource";
         string ConnectionString = GetConnectionString();

         string s = DALfunctions.ExecuteStoredProcedureQueryReturnSingleParm(ConnectionString, StoredProcedureName, SqlParmNames, SqlParmValues);
         return s;
      }

      public delegate  void PopulateDTOValues(List<string> ocValues, object DTO);
      public static string DALInsertRow(string TableName, string ColumnNames, object DTO, PopulateDTOValues delegatePopulateDTOValues, string ConnectionString)
      {
         //List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();
         //List<string> ocValues = new List<string>();
         //delegatePopulateDTOValues(ocValues, DTO);   // Execute Delegate to Populate ocValues from DTO
         //string SQL = SysDAL.Functions.DALfunctions.GenSql(TableName, ocColumns);    // Gen INSERT SQL from 
         //string rc = SysDAL.Functions.DALfunctions.InsertRow(ConnectionString, SQL, ocColumns, ocValues);
         //return rc;

         List<string> ocValues = new List<string>();
         delegatePopulateDTOValues(ocValues, DTO);   // Execute Delegate to Populate ocValues from DTO
         return DALInsertRow(TableName, ColumnNames, ocValues, ConnectionString);
      }
      // DALInsertRow - Ver 2 with ocValues already populated
      public static string DALInsertRow(string TableName, string ColumnNames, List<string> ocValues, string ConnectionString)
      {
         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();
         string SQL = SysDAL.Functions.DALfunctions.GenSql(TableName, ocColumns);    // Gen INSERT SQL from 
         string rc = SysDAL.Functions.DALfunctions.InsertRow(ConnectionString, SQL, ocColumns, ocValues);
         return rc;
      }
      #region parmTable
      public static string ParmTableParmValueQuery(string ConnectionString, string ParmName)
      {
         string strSql = $"Select ParmValue From ParmTable Where ParmName = '{ParmName}'";
         return SysDAL.Functions.DALfunctions.ExecuteSqlQueryReturnSingleParm(ConnectionString, strSql, "ParmValue").ToString();
      }
      //public static object ParmTableParmValueQuery(string ParmName)
      //{
      //   string strSql = "Select ParmValue From ParmTable Where ParmName = '{ParmName}'";
      //   return SysDAL.Functions.DALfunctions.ExecuteSqlQueryReturnSingleParm(GetConnectionString(), strSql, "ParmValue");
      //}
      public static int ParmTableParmValueUpdate(string ConnectionString, string ParmName, string ParmValue, string UserName = "default")
      {
         string strSql = $"Update ParmTable "
                     + $"SET ParmValue = '{ParmValue}', UpdateUser = '{UserName}', UpdateDate = '{DateTime.Now}' "
                     + $"Where ParmName = '{ParmName}' ";
         return SysDAL.Functions.DALfunctions.ExecuteSqlNonQuery(ConnectionString, strSql);
      }
      //public static int ParmTableParmValueUpdate(string ParmName, string ParmValue, string UserName = "default")
      //{
      //   string strSql = $"Update ParmTable "
      //               + $"SET ParmValue = '{ParmValue}', UpdateUser = '{UserName}', UpdateDate = '{DateTime.Now}' "
      //               + $"Where ParmName = '{ParmName}' ";
      //   return SysDAL.Functions.DALfunctions.ExecuteSqlNonQuery(GetConnectionString(), strSql);
      //}
      #endregion parmTable
   }  // class SqlFunctions

}
