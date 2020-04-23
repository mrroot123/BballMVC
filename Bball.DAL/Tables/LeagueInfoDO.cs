using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   public class LeagueInfoDO
   {
      public string LeagueInfoTable = "LeagueInfo";
      static LeagueDTO NbaDTO = new LeagueDTO { LeagueName = "NBA", Periods = 4, MinutesPerPeriod = 12, OverTimeMinutes = 5, MultiYearLeague = true };

      public LeagueInfoDO(string LeagueName, ILeagueDTO oLeagueDTO, string ConnectionString)
      {
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(ConnectionString, getRowSql(LeagueName), oLeagueDTO, PopulateDTO);
         if (rows == 0)  throw new Exception($"LeagueInfo row not found for League: {LeagueName}");

      }
      static void PopulateDTO( object oRow, SqlDataReader rdr)
      {
         LeagueDTO oLeagueDTO = (LeagueDTO)oRow;

         oLeagueDTO.LeagueName = rdr["LeagueName"].ToString().Trim();
         oLeagueDTO.Periods = (int)rdr["Periods"];
         oLeagueDTO.MinutesPerPeriod = (int)rdr["MinutesPerPeriod"];
         oLeagueDTO.OverTimeMinutes = (int)rdr["OverTimeMinutes"];
         oLeagueDTO.MultiYearLeague = (bool)rdr["MultiYearLeague"];
      }
      private string getRowSql(string LeagueName)
      {
         string Sql = ""
            + $"SELECT * FROM {LeagueInfoTable} l "
            + $"  Where l.LeagueName = '{LeagueName}'"
            ;
         return Sql;
      }
   }
}
