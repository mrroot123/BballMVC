/****** Script for SelectTopNRows command from SSMS  ******/
use [00TTI_LeagueScores]

	Declare @LastInstallDate DateTime;
	set @LastInstallDate =  [dbo].[udfQueryParmValue]('LastInstallDate');
	--Select @LastInstallDate; return
	

SELECT
	IsNull(so.Name, 'NEW') as ServerObj
	  ,upd.[ServerName]
      ,upd.[type]
      ,upd.[ObjName]
      ,upd.[create_date]
      ,upd.[modify_date]
      ,upd.[type_desc]
  FROM [00TTI_LeagueScores].[dbo].[_UpdatedObjects] upd
  Left Join  sys.objects so On 
		-- so.type = upd.type  -- AND 
		 so.name = upd.objName
		  and so.type  collate SQL_Latin1_General_CP1_CI_AS  = upd.type collate SQL_Latin1_General_CP1_CI_AS 
   where upd.type <> 'U'  -- no Uset Tables
	  and upd.modify_date > @LastInstallDate
	  and upd.modify_date > IsNull(so.modify_date, '1/1/2020')
	order by 1, upd.type, upd.ObjName