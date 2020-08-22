
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bball.DataBaseFunctions;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   // Change TodaysPlays --> TableName
   //public 
   class TodaysPlaysDO
   {
      const string TableName = "TodaysPlays";
      const string TableColumns = "GameDate,LeagueName,RotNum,GameTime,TeamAway,TeamHome,WeekEndDate,PlayLength,PlayType,Line,Info,PlayAmount,PlayWeight,Juice,Out,Author,Result,OT,Score,ResultAmount,CreateUser,CreateDate";

      BballInfoDTO _oBballInfoDTO;


      // Constructor
      public TodaysPlaysDO(BballInfoDTO oBballInfoDTO)
      {
         _oBballInfoDTO = oBballInfoDTO;
      }

      #region GetRows
      public int GetTodaysPlays(IList<ITodaysPlaysDTO>  ocTodaysPlaysDTO)
      {
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(_oBballInfoDTO.ConnectionString, getRowSql(), ocTodaysPlaysDTO, populateDTOFromRdr);
         return rows;
      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {

         ITodaysPlaysDTO o = new TodaysPlaysDTO();

         o.Author = rdr["Author"].ToString().Trim();
         o.CreateDate = (DateTime)rdr["CreateDate"];
         o.CreateUser = rdr["CreateUser"].ToString().Trim();
         o.GameDate = (DateTime)rdr["GameDate"];
         o.GameTime = rdr["GameTime"].ToString().Trim();
         o.Info = rdr["Info"].ToString().Trim();
         o.Juice = (double)rdr["Juice"];
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.Line = (double)rdr["Line"];
         o.OT = rdr["OT"] == DBNull.Value ? null : (bool?)rdr["OT"];
         o.Out = rdr["Out"].ToString().Trim();
         o.PlayAmount = (double)rdr["PlayAmount"];
         o.PlayLength = rdr["PlayLength"].ToString().Trim();
         o.PlayType = rdr["PlayType"].ToString().Trim();
         o.PlayWeight = (double)rdr["PlayWeight"];
         o.Result = rdr["Result"] == DBNull.Value ? null : (string)rdr["Result"];
         o.ResultAmount = rdr["ResultAmount"] == DBNull.Value ? null : (double?)rdr["ResultAmount"];
         o.RotNum = (int)rdr["RotNum"];
         o.Score = rdr["Score"] == DBNull.Value ? null : (int?)rdr["Score"];
         o.TeamAway = rdr["TeamAway"].ToString().Trim();
         o.TeamHome = rdr["TeamHome"].ToString().Trim();
         o.TodaysPlaysID = (int)rdr["TodaysPlaysID"];
         o.WeekEndDate = (DateTime)rdr["WeekEndDate"];

         ((List<ITodaysPlaysDTO>)oRow).Add(o);
      }
      private string getRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {TableName}  "
            + $"  Where LeagueName = '{_oBballInfoDTO.LeagueName}'  And GameDate = '{_oBballInfoDTO.GameDate}'"
            + "   Order By RotNum"
            ;
         return Sql;
      }
      #endregion GetRows

      #region InsertRow
      public void InsertRow()
      {
         TodaysPlaysDTO oThisDTO = populateDTO();
         //                        TableName  ColNames(csv)  DTO             Insert into DTO Method
         SqlFunctions.DALInsertRow(TableName, TableColumns, oThisDTO, populate_ocValuesForInsert, _oBballInfoDTO.ConnectionString);
      }
      private TodaysPlaysDTO populateDTO()
      {
         TodaysPlaysDTO oThisDTO = new TodaysPlaysDTO();
         oThisDTO.LeagueName = _oBballInfoDTO.LeagueName;
         // ...
         return oThisDTO;
      }
      static void populate_ocValuesForInsert(List<string> ocValues, object DTO)
      {
         TodaysPlaysDTO oTodaysPlaysDTO = (TodaysPlaysDTO)DTO;

         ocValues.Add(oTodaysPlaysDTO.GameDate.ToString());
         ocValues.Add(oTodaysPlaysDTO.LeagueName.ToString());
         ocValues.Add(oTodaysPlaysDTO.RotNum.ToString());
         ocValues.Add(oTodaysPlaysDTO.GameTime.ToString());
         ocValues.Add(oTodaysPlaysDTO.TeamAway.ToString());
         ocValues.Add(oTodaysPlaysDTO.TeamHome.ToString());
         ocValues.Add(oTodaysPlaysDTO.WeekEndDate.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayLength.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayType.ToString());
         ocValues.Add(oTodaysPlaysDTO.Line.ToString());
         ocValues.Add(oTodaysPlaysDTO.Info.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayAmount.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayWeight.ToString());
         ocValues.Add(oTodaysPlaysDTO.Juice.ToString());
         ocValues.Add(oTodaysPlaysDTO.Out.ToString());
         ocValues.Add(oTodaysPlaysDTO.Author.ToString());
         //ocValues.Add(oTodaysPlaysDTO.Result.ToString());
         //ocValues.Add(oTodaysPlaysDTO.OT.ToString());
         //ocValues.Add(oTodaysPlaysDTO.Score.ToString());
         //ocValues.Add(oTodaysPlaysDTO.ResultAmount.ToString());
         ocValues.Add(oTodaysPlaysDTO.CreateUser.ToString());
         ocValues.Add(oTodaysPlaysDTO.CreateDate.ToString());

      }
      #endregion InsertRow

   }  // class

}

