use [00TTI_LeagueScores]

Update ParmTable
	Set ParmValue   = GetDate()
	Where ParmName = 'LastInstallDate'

Select * from ParmTable	Where ParmName = 'LastInstallDate'

