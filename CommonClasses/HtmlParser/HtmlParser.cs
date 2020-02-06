using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using StringExtensionMethods;
using Microsoft.VisualBasic;

namespace HtmlParserNameSpace
{
	public class HtmlParser
	{
		/*
      Start Tag      <Tag …	
      End Tag        </tag>	
      LT / Tag Open  <	
      GT / Tag Close	>	
      Self Closing   <tag />	
      Self Closing tags w/o "/>"	br	hr
 
	   <tag>… </Tag>	   <tag attributes>	 Inner Html	</Tag> <tag>… </Tag>	
	   ^	               ^	  ^             ^	         ^	    ^	
	   ptrOuterPrevious	|	  ptrAttributes ptrInner	|	    ptrOuterNext	
		                  ptrOuter	                     ptrOuterEndTag			
             
   */
		public int ReturnCode { get; set; }    // -1 = error  1 = Info - like Tag/Attr not found
		public string Message { get; set; }
      public string Html { get; set; }
		public HtmlParser CurrentTag { get; set; }
		public bool FoundTag { get; set; }
		public bool SelfClosing { get; set; }
		public bool HtmlEnd { get; set; }
		public string HtmlOuter { get; set; }
		public string HtmlInner { get; set; }
		public string TagName { get; set; }
		public override string ToString()
		{
			return
				  "ReturnCode:\t " + ReturnCode.ToString()
				+ "\r" + "Message:\t" + Message
				+ "\r" + "FoundTag:\t" + FoundTag.ToString()
				+ "\r" + "SelfClosing:\t" + SelfClosing.ToString()
				+ "\r" + "HtmlEnd:\t" + HtmlEnd.ToString()
				+ "\r" + "TagName:\t" + TagName
				+ "\r" + "HtmlInner:\t" + HtmlInner
				+ "\r" + "HtmlOuter:\t" + HtmlOuter
				+ "\r" + "Html:\t" + Html
				+ "\r" + "SelfClosing:\t" + SelfClosing.ToString()
				;
		}
		ICollection<KeyValuePair<String, String>> ocAttributes;

		// int ptr;
		int ptrCurrent;
		//int ptrOuterPrevious;
		int ptrOuter;
		//'int ptrAttributes;
		int ptrInner;
		int ptrOuterEndTag;
		int ptrOuterNext;

		Regex regex;
		Match match;

		string[] selfClosingTags = { "br", "hr" };
		//
		// Constructor
		//
		public HtmlParser(string html)
		{
			Html = html;
			ptrCurrent = 0;
		}
		public string DisplayCurrentHtml()  => Html.Substring(ptrCurrent, 200); 

		public string DisplayCurrentHtml(int len) =>  Html.Substring(ptrCurrent, len);

      #region Find Methods
      public void FindTagByID(string IdName) =>  FindTagByAttribute("id", IdName);
		
		public void FindTagByAttribute(string AttrName, string AttrValue)
		{
			int _ptr = ptrCurrent;
			// Find --> AttrName='AttrValue'  then try Double Quotes (")
			if ((_ptr = Html.IndexOf(string.Format("{0}='{1}'", AttrName, AttrValue), ptrCurrent)) == -1)
			{
				if ((_ptr = Html.IndexOf(string.Format(@"{0}=""{1}""", AttrName, AttrValue), ptrCurrent)) == -1)
            {
               ReturnCode = 1;
               Message = "FindTagByAttribute: Attribute not found";
               return;
            }
         }

         // Point to Beginnging of Tag
         //  <Tag ... >
         //  ^
         if ((_ptr = Html.LastIndexOf("<", _ptr)) == -1)
         {
            ReturnCode = -1;
            Message = "FindTagByAttribute: Tag Open '<' not found";
            return;
         }

			findTag(_ptr);
		}
		public void FindTagByTagname(string Tagname)
		{
			FindTagByString("<" + Tagname);
		}
		public void FindTagByString(string StringName)
		{
			int _ptr = ptrCurrent;

			// Point to StringName
			if ((_ptr = Html.IndexOf(StringName, ptrCurrent)) == -1)
         {
            ReturnCode = 1;
            return;
         }

         // Point to Beginnging of Tag
         //  <Tag ... >
         //  ^
         if ((_ptr = Html.LastIndexOf("<", _ptr)) == -1)
         {
            ReturnCode = 1;
            return;
         }

         findTag(_ptr);
		}
      #endregion Find Methods

      public string GetAttribute(string AttributeName)
      {
         int ptr;
         int ptrValueStart;
         string delim;

         AttributeName = AttributeName.Trim();
         // Call SetOuterHtml
         // ptr = InStr(2, HtmlOuter, AttributeName, Constants.vbTextCompare);
         ptr = HtmlOuter.IndexOf(AttributeName, 1, StringComparison.OrdinalIgnoreCase);
         if (ptr == -1)
         {
           return "";   // AttributeName does not exist
         }

         // attr="value"
         // attr = "value"
         // attr=value
         // Find equal sign
         ptr = ptr + AttributeName.Length;  // sb pointing to = unless extraneous spaces
                                                  // attr=value
                                                  // ptr ^
         while (Mid(HtmlOuter, ptr, 1) != "=")
         {
            ptr = ptr + 1;  // bypass spaces
            if (ptr > HtmlOuter.Length)
            {
               Message = "1 - Equal sign not found for Attribute " + AttributeName;
               ReturnCode = -1;
               return null;
            }
         }
         ptr = ptr + 1;  // bypass equal
                         // Get Attr value delimiter
         while (Mid(HtmlOuter, ptr, 1) == " ")
         {
            ptr = ptr + 1;  // bypass spaces
            if (ptr > HtmlOuter.Length)
            {
               Message = "2 - Equal sign not found for Attribute " + AttributeName;
               ReturnCode = -1;
               return null;
            }
         }

         // Now pointing to attr delimeter - ie ' or " or none
         delim = Mid(HtmlOuter, ptr, 1);
         if (delim == "'" | delim == "\"")
            ptr = ptr + 1;  // point to 1st attr val char
         else
            delim = " ";// un-quoted value
         ptrValueStart = ptr;
         while (ptr <= HtmlOuter.Length)
         {
            if (Mid(HtmlOuter, ptr, 1) == delim)
            {
              // GetAttribute = Mid(HtmlOuter, ptrValueStart, ptr - ptrValueStart);
               return Mid(HtmlOuter, ptrValueStart, ptr - ptrValueStart);
            }
            ptr = ptr + 1;
         }
         return Mid(HtmlOuter, ptrValueStart, ptr - ptrValueStart);
      }
      /// <summary>
      /// Mimics VBs Mid method
      /// </summary>
      /// <param name="s"></param>
      /// <param name="start"></param>
      /// <param name="length"></param>
      /// <returns></returns>
      string Mid(string s, int start, int length = 0)
      {
         if (length == 0)  length = s.Length;

         string ss = s.Substring(start - 1, length);
         return ss;
      }
      public void GetNextTag() => 	findTag(ptrCurrent);
		

		//
		// private methods
		//
		private void initFindTag()
		{
			FoundTag = false;
			SelfClosing = false;
			HtmlInner = "";
			HtmlOuter = "";
			ocAttributes = new Dictionary<String, String>();
		}
      /// <summary>
      /// Will set HtmlOuter & HtmlInner
      /// </summary>
      /// <param name="_ptr"></param>
		private void findTag(int _ptr)
		{
			initFindTag();
			//
			// Get Outer Html
			//

			// Find next Tag & point to <Tag
			if ((_ptr = findLtOpen(_ptr)) == -1)
         {
            ReturnCode = 1;
            Message = "findTag: tag not found";
            return;
         }

         int ptrNextChar = getNextChar(_ptr);
			if (Html.Substring(_ptr, 1) == "/")  // Error:  Looking for Start Tag, Found End Tag
				throw new Exception("/");
			ptrOuter = _ptr;     // we are pointing to <Tag
			TagName = getNextWord(_ptr + 1);

			regex = new Regex(@"<(.*?)>");
			match = regex.Match(Html.Substring(_ptr));
			if (!match.Success)
			{
				ReturnCode = 1;
				Message = "findTag: tag not found - Regex";
				return;
			}
			HtmlOuter = match.Value.InnerContents().Trim();
			if (HtmlOuter.IndexOf("<") != -1) throw new Exception("Invalid Outer Html -" + HtmlOuter);

			ptrInner = Html.Substring(ptrOuter).IndexOf(">") + 1 + ptrOuter;
			// todo Put Outer Html attributes in a collection
			check4SelfClosing();
			if (SelfClosing)
			{
				ptrCurrent = ptrInner;
				return;
			}
			//
			// Get Inner Html
			//

			_ptr = ptrInner;

			int nestLevel = 1;
			int ptrEndTag;
			int ptrStartTag;

			while (nestLevel > 0)
			{
				if ((ptrEndTag = Html.IndexOf("</" + TagName, _ptr)) == -1)
					throw new Exception("findTag - End tag not found - Tag: " + TagName);

				ptrOuterEndTag = ptrEndTag;

				if ((ptrStartTag = Html.IndexOf("<" + TagName, _ptr)) == -1)
					ptrStartTag = Int32.MaxValue;

				if (ptrEndTag < ptrStartTag)
				{
					nestLevel--;
					_ptr = ptrEndTag + 1;
				}
				else
				{
					nestLevel++;
					_ptr = ptrStartTag + 1;
				}
			}

			// ptrOuterEndTag points to start of Outer End Tag - </tag>

			HtmlInner = Html.Substring(ptrInner, ptrOuterEndTag - ptrInner);

			ptrOuterNext = ptrOuterEndTag + TagName.Length + 3;   // </td>
			if (ptrOuterNext >= Html.Length)
			{
				ptrOuterNext = -1;
				HtmlEnd = true;
			}
			ptrCurrent = ptrOuterNext;
			FoundTag = true;
		}
		private void processNested(int ptr)
		{ throw new Exception("Nested Method not coded yet"); }
		private void check4SelfClosing()
		{
			if (SelfClosing = (HtmlOuter.Right(1) == "/")) { return; }
			SelfClosing = (selfClosingTags.SingleOrDefault(s => s == TagName) != null);
		}

		private string getNextWord(int ptr)
		{
			int ptrStart = ptr;
			while (Html.Substring(ptr, 1) != " " && Html.Substring(ptr, 1) != "<" && Html.Substring(ptr, 1) != ">")
				ptr++;
			return Html.Substring(ptrStart, ptr - ptrStart);
		}

		private int getNextChar(int ptr)
		{
			int _ptr = ptr + 1;
			while (Html.Substring(_ptr, 1) == " ")
				_ptr++;
			return _ptr;
		}
		private int findLtOpen(int ptr)
		{
			// Find Open Bracket "<"
			int _ptr = ptr;
			if ((_ptr = getNextBracket(ptr)) == -1) return -1;
			if (Html.Substring(_ptr, 1) == ">")
				throw new Exception("findLtOpen - Invalid Html - " + Html.Substring(_ptr));
			return _ptr;
		}
		private int getNextBracket(int ptr)
		{
			int ltOpen = Html.IndexOf("<", ptr);
			ltOpen = (ltOpen == -1) ? Html.Length + 1 : ltOpen;

			int gtClose = Html.IndexOf(">", ptr);
			gtClose = gtClose == -1 ? Html.Length + 1 : gtClose;

			return (ltOpen == gtClose) ? -1 : Math.Min(ltOpen, gtClose);
		}

	}
}
