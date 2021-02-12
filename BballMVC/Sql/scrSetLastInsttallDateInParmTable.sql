use [00TTI_LeagueScores]
Select @@SERVERNAME as Server, 'BEFORE', * from ParmTable	Where ParmName = 'LastInstallDate'
Update ParmTable
	Set ParmValue   = GetDate()
	Where ParmName = 'LastInstallDate'

Select @@SERVERNAME as Server,  * from ParmTable	Where ParmName = 'LastInstallDate'

