/*
Select Table Name
Paste into CodeGeneration.xlsm - populateDTO sheet
*/

use [00TTI_LeagueScores]

SELECT  c.ORDINAL_POSITION as Seq , COLUMN_NAME, c.DATA_TYPE, IS_NULLABLE
	FROM  	INFORMATION_SCHEMA.COLUMNS c
	  Where c.TABLE_NAME = 'LeagueInfo' --	<===
--	   and COLUMN_NAME like '%proj%'
	  Order By COLUMN_NAME	-- c.DATA_TYPE