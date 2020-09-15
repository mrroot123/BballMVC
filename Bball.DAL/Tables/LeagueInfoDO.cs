﻿using System;
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
     // static LeagueDTO NbaDTO = new LeagueDTO { LeagueName = "NBA", Periods = 4, MinutesPerPeriod = 12, OverTimeMinutes = 5, MultiYearLeague = true };

      public LeagueInfoDO(string LeagueName, ILeagueDTO oLeagueDTO, string ConnectionString)
      {
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(ConnectionString, getRowSql(LeagueName), oLeagueDTO, PopulateDTO);
         if (rows == 0)  throw new Exception($"LeagueInfo row not found for League: {LeagueName}");

      }
      static void PopulateDTO( object oRow, SqlDataReader rdr)
      {
         LeagueDTO o = (LeagueDTO)oRow;

         o.BoxScoresL5MinURL = rdr["BoxScoresL5MinURL"] == DBNull.Value ? null : (string)rdr["BoxScoresL5MinURL"];
         o.DefaultOTamt = (double)rdr["DefaultOTamt"];
         o.LeagueColor = rdr["LeagueColor"] == DBNull.Value ? null : (string)rdr["LeagueColor"];
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.MinutesPerPeriod = (int)rdr["MinutesPerPeriod"];
         o.MultiYearLeague = (bool)rdr["MultiYearLeague"];
         o.NumberOfTeams = (int)rdr["NumberOfTeams"];
         o.OverTimeMinutes = (int)rdr["OverTimeMinutes"];
         o.Periods = (int)rdr["Periods"];
         o.StartDate = (DateTime)rdr["StartDate"];

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
