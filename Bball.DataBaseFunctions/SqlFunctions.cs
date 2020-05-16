using System;
using System.Linq;
using System.Collections.Generic;
using SysDAL;


namespace Bball.DataBaseFunctions
{
   public static class SqlFunctions
   {
      const string BballConnectionStringName = "BballEntities";
        const string SqlServerConnectionStringKeith =
           @"Data Source=Localhost\SQLEXPRESS2012;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";
        const string SqlServerConnectionStringTest =
         @"Data Source=Localhost\SQLEXPRESS;Initial Catalog=00TTI_LeagueScores;Integrated Security=SSPI";
      const string SqlServerConnectionStringArvixe =
         @"Data Source=Localhost\;   Initial Catalog=00TTI_LeagueScores;Integrated Security=false;User ID=theroot;Password=788788kd";


      public static string GetConnectionString()
      {
         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf(@"mrroot\") >= 0)
            return SqlServerConnectionStringArvixe;

         if (System.AppDomain.CurrentDomain.BaseDirectory.IndexOf("wwwroot") >= 0)
            return SqlServerConnectionStringKeith;

         return SqlServerConnectionStringTest;

         
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
         //string SQL = SysDAL.DALfunctions.GenSql(TableName, ocColumns);    // Gen INSERT SQL from 
         //string rc = SysDAL.DALfunctions.InsertRow(ConnectionString, SQL, ocColumns, ocValues);
         //return rc;

         List<string> ocValues = new List<string>();
         delegatePopulateDTOValues(ocValues, DTO);   // Execute Delegate to Populate ocValues from DTO
         return DALInsertRow(TableName, ColumnNames, ocValues, ConnectionString);
      }
      // DALInsertRow - Ver 2 with ocValues already populated
      public static string DALInsertRow(string TableName, string ColumnNames, List<string> ocValues, string ConnectionString)
      {
         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();
         string SQL = SysDAL.DALfunctions.GenSql(TableName, ocColumns);    // Gen INSERT SQL from 
         string rc = SysDAL.DALfunctions.InsertRow(ConnectionString, SQL, ocColumns, ocValues);
         return rc;
      }
      #region parmTable
      public static object ParmTableParmValueQuery(string ParmName)
      {
         string strSql = "Select ParmValue From ParmTable Where ParmName = '{ParmName}'";
         return SysDAL.DALfunctions.ExecuteSqlQueryReturnSingleParm(GetConnectionString(), strSql, "ParmValue");
      }
      public static int ParmTableParmValueUpdate(string ParmName, string ParmValue, string UserName = "default")
      {
         string strSql = $"Update ParmTable "
                     + $"SET ParmValue = '{ParmValue}', UpdateUser = '{UserName}', UpdateDate = '{DateTime.Now}' "
                     + $"Where ParmName = '{ParmName}' ";
         return SysDAL.DALfunctions.ExecuteSqlNonQuery(GetConnectionString(), strSql);
      }
      #endregion parmTable
   }  // class SqlFunctions

}
