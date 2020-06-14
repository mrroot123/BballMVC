/*
Create a backup of the database you want to copy using this script
right-click "Databases" and select "Restore Files and Filegroups"
Enter the name of the new database in the "To database" field. -- 00TTI_LeagueScores
Select "From device" and then select the file that you backuped in the first step
click "OK"
this will "clone" the Database with the correct table settings such as the "default value" and "auto increase" etc.
*/
Declare @Operation Varchar(2) = 'B'
	, @db_name varchar(300) = '00TTI_LeagueScores'
	, @new_db_name varchar(300) = ''
	, @backup_qualidied_dsn varchar(300) =	 'D:\BU\00TTI_LeagueScores.Bak' --	'D:\backup\OriginalDB_full.bak'
	, @new_db_folder varchar(300) = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\Backup'
	--'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\'

--SET @backup_qualidied_dsn  = 'C:\Program Files\Microsoft SQL Server\MSSQL14.BBALL\MSSQL\Backup';
--SET @db_name = '00TTI_Test';

if @new_db_name = ''
	SET @new_db_name = @db_name

Select @backup_qualidied_dsn as BackupName;  return

Declare
	 @new_FileName_mdf varchar(300)
	, @new_FileName_ldf varchar(300) 
	, @db_name_log varchar(300) 
	
	SET @db_name_log = @db_name + '_log'
	SET @new_FileName_mdf =  @new_db_folder + @new_db_name + '.mdf';
	SET @new_FileName_ldf =  @new_db_folder + @new_db_name + '.ldf';


IF @operation = 'B' OR  @operation = 'R'
BEGIN
	Select  @db_name as  BU_name,  @backup_qualidied_dsn as NameOnDisk
	BACKUP DATABASE  @db_name	to disk = @backup_qualidied_dsn
		with init, stats =10;
END

Declare @s  varchar(300) = Concat( @new_db_folder, '\', @db_name, '.bak');
RESTORE FILELISTONLY FROM DISK = @s; -- return;

IF @operation = 'R' OR  @operation = 'BR'
BEGIN
	RESTORE DATABASE @new_db_name	from disk = @backup_qualidied_dsn
		with stats =10
		, recovery
		, move @db_name		to @new_FileName_mdf			
		, move @db_name_log  to @new_FileName_ldf
END

Return

IF @operation = 'R' OR  @operation = 'BR'
BEGIN
	RESTORE DATABASE @new_db_name	from disk = @backup_qualidied_dsn
		with stats =10
		, recovery
		, move N'C:\C_Sandisk\Program Files\Microsoft SQL Server\MSSQL11.SS2012EXPRESS\MSSQL\DATA\LeagueScores.mdf'		to @new_FileName_mdf			
		, move N'C:\C_Sandisk\Program Files\Microsoft SQL Server\MSSQL11.SS2012EXPRESS\MSSQL\DATA\LeagueScores_log.ldf'  to @new_FileName_ldf
END

Return

--RESTORE HEADERONLY FROM DISK = 'D:\backup\OriginalDB_full.bak'
--GO

--RESTORE LABELONLY  FROM DISK = 'D:\backup\OriginalDB_full.bak'
--GO

--RESTORE FILELISTONLY   FROM DISK = 'D:\backup\OriginalDB_full.bak'
--GO

