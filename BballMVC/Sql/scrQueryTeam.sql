
select Distinct TeamNameInDatabase
from Team 
--Join Team
where LeagueName = 'NBA'
 and EndDate is null
 order by TeamNameInDatabase
