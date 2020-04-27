using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Reflection;
using System.Text;

namespace SysDAL
{

   public static class DALfunctions
   {
      public delegate void PopulateDTOx(List<object> ocRows, object oRow, SqlDataReader rdr);
      public delegate void PopulateDTO(object oRow, SqlDataReader rdr);

      #region ExecuteSql
      public static int ExecuteSqlNonQuery(string ConnectionString, string strSql)
      {
         int rowsAffected = 0;
         try
         {
            //  1)  Get Conn     SqlConnection oSqlConnection 
            //  2)  Set Command  SqlCommand oSqlCommand = new SqlCommand(sql, oSqlConnection);
            //  3)  Exec         SqlDataReader rdr = oSqlCommand.ExecuteReader();

            using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString)) // 1) Get Conn
            {
               oSqlConnection.Open();                                            // 2) Get Conn
               SqlCommand oSqlCommand = new SqlCommand(strSql, oSqlConnection);        // 2)  Set Command
               rowsAffected = oSqlCommand.ExecuteNonQuery();                           // 3) Exec
            }  // using conn
         }
         catch (Exception ex)
         {
            var msg = ex.Message + $" - CallStack= {ex.StackTrace}";
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nSql: {strSql}\nConnectionString: {ConnectionString}\nError Message: {msg}");
         }
         return rowsAffected;
      }

      public static int ExecuteSqlQuery(string ConnectionString, string strSql,  object oRow, PopulateDTO delPopulateDTO)
      {
         int ctrRows = 0;
         try
         {
            //  1)  Get Conn     SqlConnection oSqlConnection 
            //  2)  Open DB      oSqlConnection.Open();
            //  3)  Set Command  SqlCommand oSqlCommand = new SqlCommand(sql, oSqlConnection);
            //  4)  Exec Sql / Read Rows    SqlDataReader rdr = oSqlCommand.ExecuteReader();

            using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString)) // 1) Get Conn
            {
               oSqlConnection.Open();                                            // 2) Get Conn
               SqlCommand oSqlCommand = new SqlCommand(strSql, oSqlConnection);  // 3) Set Command
               using (SqlDataReader rdr = oSqlCommand.ExecuteReader())           // 4) Exec Sql / Read Rows
               {
                  while (rdr.Read())
                  {
                     ctrRows++;
                     delPopulateDTO( oRow, rdr);
                  }
               }
            }  // using conn
         }
         catch (Exception ex)
         {
            var msg = ex.Message + "\n" + StackTraceParse(ex.StackTrace);
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nError Message: {msg}\nSql: {strSql}\nConnectionString: {ConnectionString}");
         }
         return ctrRows;
      }
      public static object ExecuteSqlQueryReturnSingleParm(string ConnectionString, string strSql, string ParmName)
      {
         object parmValue = null;
         try
         {
            //  1)  Get Conn     SqlConnection oSqlConnection 
            //  2)  Open DB      oSqlConnection.Open();
            //  3)  Set Command  SqlCommand oSqlCommand = new SqlCommand(sql, oSqlConnection);
            //  4)  Exec Sql / Read Rows    SqlDataReader rdr = oSqlCommand.ExecuteReader();

            using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString)) // 1) Get Conn
            {
               oSqlConnection.Open();                                            // 2) Get Conn
               SqlCommand oSqlCommand = new SqlCommand(strSql, oSqlConnection);  // 3) Set Command
               
               using (SqlDataReader rdr = oSqlCommand.ExecuteReader())           // 4) Exec Sql / Read Rows
               {
                  int ctrRows = 0;
                  while (rdr.Read())
                  {
                     parmValue = rdr[ParmName];
                     ctrRows++;
                  }
                  if (ctrRows != 1)
                  {
                     string msg;
                     if (ctrRows == 0)
                        msg = $"Parm {ParmName} Not Found";
                     else
                        msg = "Multiple Rows Returned";

                     throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nError Message: {msg}\nSql: {strSql}\nConnectionString: {ConnectionString}");
                  }
               }
            }  // using conn
         }
         catch (Exception ex)
         {
            var msg = ex.Message + "\n" + StackTraceParse(ex.StackTrace);
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nError Message: {msg}\nSql: {strSql}\nConnectionString: {ConnectionString}");
         }
         return parmValue;
      }
      #endregion ExecuteSql

      #region StoredProcs
      public static string ExecuteStoredProcedureQuery(string ConnectionString, string StoredProcedureName
                              , List<string> SqlParmNames, List<object> SqlParmValues, object oRow, PopulateDTO delegatePopulateDTO)
      {
         string s = "";
         try
         {
               using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
               {
                  oSqlConnection.Open();

                  // 1.  create a command object identifying the stored procedure
                  SqlCommand oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);

                  // 2. set the command object so it knows to execute a stored procedure
                  oSqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

                  // 3. add parameter to command, which will be passed to the stored procedure
                  // SqlParmNames, SqlParmValues
                  for (int i = 0; i < SqlParmNames.Count; i++)
                     oSqlCommand.Parameters.Add(new SqlParameter(SqlParmNames[i], SqlParmValues[i]));

                  // execute the command
                  using (SqlDataReader rdr = oSqlCommand.ExecuteReader())
                  {

                     while (rdr.Read())
                     {
                           delegatePopulateDTO(oRow, rdr);
                     }
                  }
               }  // using conn
         }
         catch (Exception ex)
         {
               var msg = ex.Message.IndexOf("CallStack=") > -1 ? ex.Message : ex.Message + $" - CallStack= {ex.StackTrace}";
               throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nStored Procedure: {StoredProcedureName}\nConnectionString: {ConnectionString}\nError Message: {msg}");
         }
         return s;
      }  // ExecuteStoredProcedureQuery

      public static string ExecuteStoredProcedureQueries(string ConnectionString, string StoredProcedureName
                              , List<string> SqlParmNames, List<object> SqlParmValues, List<object> oRows, List<PopulateDTO> delegatePopulateDTOs)
      {
         string s = "";
         try
         {
            using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
            {
               oSqlConnection.Open();

               // 1.  create a command object identifying the stored procedure
               SqlCommand oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);

               // 2. set the command object so it knows to execute a stored procedure
               oSqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

               // 3. add parameter to command, which will be passed to the stored procedure
               // SqlParmNames, SqlParmValues
               for (int i = 0; i < SqlParmNames.Count; i++)
                  oSqlCommand.Parameters.Add(new SqlParameter(SqlParmNames[i], SqlParmValues[i]));
               int ix = 0;
                  
               // execute the command
               using (SqlDataReader rdr = oSqlCommand.ExecuteReader())
               {
                  foreach (var oRow in oRows)
                  {
                     var delegatePopulateDTO = delegatePopulateDTOs[ix++];
                     while (rdr.Read())
                     {
                        delegatePopulateDTO(oRow, rdr);
                     }
                     rdr.NextResult();
                  }

               }  // rdr
            }  // using conn
         }
         catch (Exception ex)
         {
            var msg = ex.Message.IndexOf("CallStack=") > -1 ? ex.Message : ex.Message + $" - CallStack= {ex.StackTrace}";
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nStored Procedure: {StoredProcedureName}\nConnectionString: {ConnectionString}\nError Message: {msg}");
         }
         return s;
      }  // ExecuteStoredProcedureQuery



      public static string ExecuteStoredProcedureQueryReturnSingleParm(string ConnectionString, string StoredProcedureName
                             , List<string> SqlParmNames, List<object> SqlParmValues)
      {
         string s = "";
         try
         {
            using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
            {
               oSqlConnection.Open();

               // 1.  create a command object identifying the stored procedure
               SqlCommand oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);

               // 2. set the command object so it knows to execute a stored procedure
               oSqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

               // 3. add parameter to command, which will be passed to the stored procedure
               // SqlParmNames, SqlParmValues
               for (int i = 0; i < SqlParmNames.Count; i++)
                  oSqlCommand.Parameters.Add(new SqlParameter(SqlParmNames[i], SqlParmValues[i]));

               // execute the command
               using (SqlDataReader rdr = oSqlCommand.ExecuteReader())
               {
                  while (rdr.Read())
                  {
                     s = rdr.GetFieldValue<string>(0);
                  }
               }
            }  // using conn
         }
         catch (Exception ex)
         {
            var msg = ex.Message.IndexOf("CallStack=") > -1 ? ex.Message : ex.Message + $" - CallStack= {ex.StackTrace}";
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nStored Procedure: {StoredProcedureName}\nConnectionString: {ConnectionString}\nError Message: {msg}");
         }
         return s;
      }  // ExecuteStoredProcedureQuery

      public static int ExecuteStoredProcedureNonQuery(string ConnectionString, string StoredProcedureName
                             , List<string> SqlParmNames, List<object> SqlParmValues)
      {
         int rowsAffected = 0;
         try
         {
            using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
            {
               oSqlConnection.Open();

               // 1.  create a command object identifying the stored procedure
               SqlCommand oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);

               // 2. set the command object so it knows to execute a stored procedure
               oSqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

               // 3. add parameter to command, which will be passed to the stored procedure
               // SqlParmNames, SqlParmValues
               for (int i = 0; i < SqlParmNames.Count; i++)
                  oSqlCommand.Parameters.Add(new SqlParameter(SqlParmNames[i], SqlParmValues[i]));

               // execute the command
               rowsAffected = oSqlCommand.ExecuteNonQuery();

            }  // using conn
         }
         catch (SqlException ex)
         {
            if (ex.State == 0)
            {
               throw;
            }
            throw new Exception(StackTraceFormat(ex));
         }
         catch (Exception ex)
         {
            throw new Exception(StackTraceFormat(ex));
         }
         return rowsAffected;
      }  // ExecuteStoredProcedureNonQuery
      #endregion StoredProcs
      #region genSql
      public static string GenSql(string sqlString, List<string> ocColumnNames, List<string> ocColumnValues)
      {
         if (ocColumnNames.Count != ocColumnValues.Count)
         {
            var msg = $"ocColumnNames({ocColumnNames.Count}) & ocColumnValues({ocColumnNames.Count}) have different lengths - GenSql aborted";
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name} - Error Message: {msg} - Insert SQL: {sqlString}");
         }
         string Sql = sqlString;
         for (int i = 0; i < ocColumnNames.Count; i++)   // Add Col Names & Values
         {
            //                   @col1,  with               'col1Value',                     @col1)  with    'col1Value')
            Sql = Sql.Replace("@" + ocColumnNames[i] + ",", "'" + ocColumnValues[i] + "',")
                     .Replace("@" + ocColumnNames[i] + ")", "'" + ocColumnValues[i] + "')");
         }
         Sql = Sql.ToLower().Replace("'true'", "true").Replace("'false'", "false");
         return Sql;
      }  // GenSql
      public static string GenSql(string TableName, List<string> ocColumnNames)
      {
         StringBuilder columnNames = new StringBuilder();
         StringBuilder columnValues = new StringBuilder();
         string comma = "";
         // INSERT INTO table (col1, col2, col3) VALUES (@val1, @val2, @val3)"
         foreach (string columnName in ocColumnNames)
         {
            columnNames.Append(comma + columnName);
            columnValues.Append(comma + "@" + columnName);
            comma = ",";
         }
         string sql = $"INSERT INTO {TableName} ({columnNames.ToString()}) VALUES ({columnValues.ToString()})";
         return sql;
      }
      #endregion genSql
      public static string InsertRow(string ConnectionString, string sqlString, List<string> ocColumnNames, List<string> ocColumnValues)
      {
         //string sqlString = "INSERT INTO table (col1, col2, col3) VALUES (@val1, @val2, @val3)";
         //string sqlString = "INSERT INTO test  (Name, f2)         VALUES (@val1, @val2)";
         // comm.Parameters.AddWithValue("@val1", txtbox1.Text);

         if (ocColumnNames.Count != ocColumnValues.Count)
         {
            var msg = $"ocColumnNames({ocColumnNames.Count}) & ocColumnValues({ocColumnValues.Count}) have different lengths - InsertRow aborted";
            throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name} - Error Message: {msg} - ConnectionString: {ConnectionString} - Insert SQL: {sqlString}");
         }
         using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
         {
            using (SqlCommand oSqlCommand = new SqlCommand())
            {
               oSqlCommand.Connection = oSqlConnection;
               oSqlCommand.CommandText = sqlString;
               for (int i = 0; i < ocColumnNames.Count; i++)   // Add Col Names & Values
               {
                  oSqlCommand.Parameters.AddWithValue("@" + ocColumnNames[i], ocColumnValues[i]);
               }
               try
               {
                  oSqlConnection.Open();
                  oSqlCommand.ExecuteNonQuery();
               }
               catch(SqlException ex)
               {
                  if (ex.State == 0)
                  {
                     return $"-1,{ex.Message}";
                  }
                  var msg = StackTraceFormat(ex);
                  throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name} - ConnectionString: {ConnectionString} - Insert SQL: {sqlString} - Error Message: {msg}");
               }
            }  // using SqlCommand
         }  // using SqlConnection

         return "1";

      }  // InsertRow

      #region debuggingArea
      public static string StackTraceFormat(Exception ex) => StackTraceFormat("", ex, "");
      
      public static string StackTraceFormat(String PreMsg, Exception ex, string PostMsg)
      {
         PreMsg = string.IsNullOrEmpty(PreMsg) ? "" : PreMsg + "\n";
         PostMsg = string.IsNullOrEmpty(PostMsg) ? "" : PostMsg + "\n";
         if (ex.Message.IndexOf("= Stack Trace =") > -1)
            return PreMsg + ex.Message + PostMsg;

         StringBuilder msg = new StringBuilder();
         msg.Append(PreMsg);
         msg.Append("========================= Stack Trace ==================================" + "\n");
         msg.Append(ex.Message + "\n");
         msg.Append(SysDAL.DALfunctions.StackTraceParse(ex.StackTrace) + "\n");
         msg.Append("========================================================================" + "\n");
         msg.Append(PostMsg);
         return msg.ToString();
      }
      private static string StackTraceParse(string StackTrace)
      {
        // StackTrace = "   at Bball.VbClasses.Bball.VbClasses.BoxscoreParseStatsSummary.InitCoversBoxscore(String PeriodsHtml, DateTime GameDate, String LeagueName, Int32 Periods) in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\BoxscoreParseStatsSummary.vb:line 148\n   at Bball.VbClasses.Bball.VbClasses.BoxscoreParseStatsSummary.NewBoxscoreParseStatsSummary(String BoxScoreSource, String PeriodsHtml, DateTime GameDate, String LeagueName, Int32 Periods) in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\BoxscoreParseStatsSummary.vb:line 71\n   at Bball.VbClasses.Bball.VbClasses.CoversBoxscore.processPeriods(String BoxScoreUrl) in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\CoversBoxscore.vb:line 118\n   at Bball.VbClasses.Bball.VbClasses.CoversBoxscore.GetBoxscore() in D:\My Documents\wwwroot\BballMVC\Bball.VbClasses\CoversBoxscore.vb:line 98\n   at Bball.BAL.LoadBoxScores.Load(DateTime GameDate) in D:\My Documents\wwwroot\BballMVC\Bball.BAL\LoadBoxScores.cs:line 54\n   at Bball.BAL.LoadBoxScores.LoadBoxScoreRange(DateTime GameDate) in D:\My Documents\wwwroot\BballMVC\Bball.BAL\LoadBoxScores.cs:line 30\n   at UnitTestProject1.UnitTest1.TestGetBoxScores() in D:\My Documents\wwwroot\BballMVC\UnitTestProject1\UnitTest1.vb:line 46";

         StringBuilder sb = new StringBuilder();
         // string[] arLines = StackTrace.Split(new string[] { @"\n" }, StringSplitOptions.None);     // }, StringSplitOptions.None);
         string[] arLines = StackTrace.Split('\n');  
         foreach (string line in arLines)
         {
            if (line.Trim() != "")
            {
               string s;
               if (line.IndexOf(" in ") > -1)
               {
                  // Line format:  at .... in .... :line ###
                  string[] arLine = line.Split(new string[] { " in " }, StringSplitOptions.None);
                  // [0] = atParm  [1] = inParm & Line Number
                  string[] arAtParm = arLine[0].Split('.');

                  string[] inParms = arLine[1].Split(new string[] { ":line " }, StringSplitOptions.None);
                  // [0] = inParm   [1] = Line Number
                  s = inParms[1].Replace("\r", "");
                  sb.Append("\n" + s.PadLeft(4) + " - ");

                  // inParm = "C:\...\...\ProgName.cs
                  string[] arProg = inParms[0].Split('\\');
                  s = arProg[arProg.Length - 1];
                  sb.Append(s + " - " + arAtParm[arAtParm.Length - 1]);
               }
            }
         }

         return sb.ToString();
      }
      #endregion debuggingArea
   }  // class

}  // namespace

//public static string xExecuteStoredProcedureQuery(string ConnectionString, string StoredProcedureName
//                       , List<string> SqlParmNames, List<object> SqlParmValues)
//{
//   string s = "";
//   try
//   {
//      //  1)  Get Conn     SqlConnection oSqlConnection 
//      //  2)  Open DB      oSqlConnection.Open();
//      //  3)  create Com obj  oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);
//      //  4) set the command object so it knows to execute a stored procedure
//      //  5) add parameters to command, which will be passed to the stored procedure
//      //  6)  Read Rows    SqlDataReader rdr = oSqlCommand.ExecuteReader();
//      using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
//      {
//         oSqlConnection.Open();  //  2)  Open DB 
//         // 3)  create a command object identifying the stored procedure
//         SqlCommand oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);
//         // 4) set the command object so it knows to execute a stored procedure
//         oSqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

//         // 5) add parameter to command, which will be passed to the stored procedure
//         // SqlParmNames, SqlParmValues
//         for (int i = 0; i < SqlParmNames.Count; i++)
//            oSqlCommand.Parameters.Add(new SqlParameter(SqlParmNames[i], SqlParmValues[i]));

//         // 6) execute the command to Read Rows
//         using (SqlDataReader rdr = oSqlCommand.ExecuteReader())
//         {
//            var sch = rdr.GetSchemaTable();

//            // rdr.MetaData.metaDataArray[0].column
//            // iterate through results, printing each to console
//            while (rdr.Read())
//            {
//               s = rdr.GetFieldValue<string>(0);
//            }
//         }
//      }  // using conn
//   }
//   catch (Exception ex)
//   {
//      var msg = ex.Message.IndexOf("CallStack=") > -1 ? ex.Message : ex.Message + $" - CallStack= {ex.StackTrace}";
//      throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nStored Procedure: {StoredProcedureName}\nConnectionString: {ConnectionString}\nError Message: {msg}");
//   }
//   return s;
//}  // ExecuteStoredProcedureQuery

//public static string xExecuteStoredProcedureQuery(string ConnectionString, string StoredProcedureName
//                       , List<string> SqlParmNames, List<object> SqlParmValues, List<object> ocRows, object oRow, PopulateDTO delegatePopulateDTO)
//{
//   string s = "";
//   try
//   {
//      using (SqlConnection oSqlConnection = new SqlConnection(ConnectionString))
//      {
//         oSqlConnection.Open();

//         // 1.  create a command object identifying the stored procedure
//         SqlCommand oSqlCommand = new SqlCommand(StoredProcedureName, oSqlConnection);

//         // 2. set the command object so it knows to execute a stored procedure
//         oSqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

//         // 3. add parameter to command, which will be passed to the stored procedure
//         // SqlParmNames, SqlParmValues
//         for (int i = 0; i < SqlParmNames.Count; i++)
//            oSqlCommand.Parameters.Add(new SqlParameter(SqlParmNames[i], SqlParmValues[i]));

//         // execute the command
//         using (SqlDataReader rdr = oSqlCommand.ExecuteReader())
//         {
//            var sch = rdr.GetSchemaTable();

//            // rdr.MetaData.metaDataArray[0].column
//            // iterate through results, printing each to console
//            while (rdr.Read())
//            {
//               delegatePopulateDTO(ocRows, oRow, rdr);
//            }
//         }
//      }  // using conn
//   }
//   catch (Exception ex)
//   {
//      var msg = ex.Message.IndexOf("CallStack=") > -1 ? ex.Message : ex.Message + $" - CallStack= {ex.StackTrace}";
//      throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name}\nStored Procedure: {StoredProcedureName}\nConnectionString: {ConnectionString}\nError Message: {msg}");
//   }
//   return s;
//}  // ExecuteStoredProcedureQuery
