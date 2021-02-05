use [00TTI_LeagueScores]
Select 'BEFORE', * from ParmTable	Where ParmName = 'LastInstallDate'
Update ParmTable
	Set ParmValue   = GetDate()
	Where ParmName = 'LastInstallDate'

Select * from ParmTable	Where ParmName = 'LastInstallDate'

