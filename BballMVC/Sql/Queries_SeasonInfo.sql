/****** Script for SelectTopNRows command from SSMS  ******/
SELECT*  FROM SeasonInfo s  
  Where s.LeagueName = 'NBA'  And GetDate() >= s.StartDate  And GetDate() <= s.EndDate
   	 Order By s.StartDate DESC

SELECT * FROM SeasonInfo s   Where s.LeagueName = 'NBA'  And '10/26/2019 12:00:00 AM' >= s.StartDate  And '10/26/2019 12:00:00 AM' <= s.EndDate   Order By s.StartDate DESC