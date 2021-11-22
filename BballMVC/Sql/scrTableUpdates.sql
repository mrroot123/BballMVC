use [db_a791d7_leaguescores]

ALTER TABLE UserLeagueParms ADD TodaysMUPsOppAdjPctPt1 float;
ALTER TABLE UserLeagueParms ADD TodaysMUPsOppAdjPctPt2 float;
ALTER TABLE UserLeagueParms ADD TodaysMUPsOppAdjPctPt3 float;

ALTER TABLE UserLeagueParms ADD TempRow bit;
go

  Update UserLeagueParms
		Set TodaysMUPsOppAdjPctPt1 = TmStrAdjPct
		  , TodaysMUPsOppAdjPctPt2 = TmStrAdjPct
		  , TodaysMUPsOppAdjPctPt3 = TmStrAdjPct
		  , TempRow = 0

Select * From UserLeagueParms
go