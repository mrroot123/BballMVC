
using System;

using System.Reflection;
using System.Data.OleDb;

namespace Bball.DataBaseFunctions
{
   public static class MSaccessDB
   {
      // static string DBname = @"D:\My Documents\nba\Dev_2\LeagueScores_2.mdb";

      public static void MSaccessExecuteNonQuery(string strSql, string ConnectionString)
      {
         // strSql =
         //    "Insert Into z_hVersion( Version, VerDate, Modified, Num ) Values  ('8.0', '12/8/2019', true, '6')";

         OleDbConnection oOleDbConnection = new OleDbConnection(ConnectionString);
         //"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + DBname);

         OleDbCommand oOleDbCommand = oOleDbConnection.CreateCommand();
         // NOTE kdtodo - add try catch AND USING
         oOleDbConnection.Open();
         oOleDbCommand.CommandText = strSql;
         oOleDbCommand.Connection = oOleDbConnection;
         oOleDbCommand.ExecuteNonQuery();
         oOleDbConnection.Close();
      }

      public static void MSaccessQuery(string strSql, string ConnectionString)
      {
         using (OleDbConnection oOleDbConnection = new OleDbConnection(ConnectionString))
         {
            // Create a command and set its connection  
            OleDbCommand command = new OleDbCommand(strSql, oOleDbConnection);
            // Open the connection and execute the select command.  
            try
            {
               // Open connecton  
               oOleDbConnection.Open();
               // Execute command  
               using (OleDbDataReader reader = command.ExecuteReader())
               {
                  Console.WriteLine("------------Original data----------------");
                  while (reader.Read())
                  {
                     // reader["Name"].ToString()
                     // Use Delegate to populate Collection of read rows
                  }
               }
            }
            catch (Exception ex)
            {
               throw new Exception($"Method: {MethodBase.GetCurrentMethod().Name} - ConnectionString: {ConnectionString} - Sql: {strSql} - Error Message: {ex.Message}");
            }
            // The connection is automatically closed becasuse of using block.  
         }
      }


   }
}
