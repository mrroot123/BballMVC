
Declare @UserName varchar(10) = 'TEST', @LeagueName varchar(4) = 'NBA', @GameDate Date = '2021/11/11'
  
	IF EXISTS(SELECT *  FROM UserLeagueParms  
			Where UserName = @UserName and  LeagueName = @LeagueName and TempRow = 1)
	BEGIN
		SELECT *  FROM UserLeagueParms  
			Where UserName = @UserName and  LeagueName = @LeagueName and TempRow = 1

		Delete FROM UserLeagueParms  
			Where UserName = @UserName and  LeagueName = @LeagueName and TempRow = 1	
		Return	
	END

	SELECT Top 1 *  
		FROM UserLeagueParms u 
		Where UserName = @UserName and  LeagueName = @LeagueName AND StartDate <= @GameDate
		Order By u.StartDate Desc
