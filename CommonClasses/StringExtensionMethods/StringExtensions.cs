using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StringExtensionMethods
{
   public static class StringExtensions
   {
      public static string InnerContents(this string str)
      {
         return str.Substring(1, str.Length - 2);
      }

		public static string Pad(this string thisString, int padLeft, int padRight)
		{
			return thisString.PadLeft(padLeft).PadRight(padRight);
		}

		public static string ReplaceAll(this string thisString, string FromValue, string ToValue)
      {
			while (thisString.IndexOf(FromValue) != -1)
				thisString = thisString.Replace(FromValue, ToValue);
			return thisString;
		}

		public static string Right(this string sValue, int iMaxLength)
		{         //Check if the value is valid
			if (string.IsNullOrEmpty(sValue))
         {
            //Set valid empty string as string could be null
            sValue = string.Empty;
         }
         else if (sValue.Length > iMaxLength)
         {
            //Make the string no longer than the max length
            sValue = sValue.Substring(sValue.Length - iMaxLength, iMaxLength);
         }

         //Return the string
         return sValue;
      }

		public static string[] SplitByString(this string thisString, string SplitValue)
		{
			return thisString.ReplaceAll(SplitValue, ((char)0).ToString()).Split((char)0); 
		}


	}

}
