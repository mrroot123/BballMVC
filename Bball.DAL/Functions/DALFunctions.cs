using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace Bball.DAL.Functions
{
   public static class DALFunctions
   {
      public static string StackTraceFormat(Exception ex) => StackTraceFormat("", ex, "");

      public static string StackTraceFormat(String PreMsg, Exception ex, string PostMsg)
      {
         return SysDAL.Functions.DALfunctions.StackTraceFormat(PreMsg, ex, PostMsg);
      }
      public static void PopulateDropDownDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         List<IDropDown> ocDD = (List<IDropDown>)oRow;
         ocDD.Add(new DropDown()
         {
            Value = (string)rdr.GetValue(0).ToString().Trim(),
            Text = (string)rdr.GetValue(1).ToString().Trim()
         });
      }
   }
}
