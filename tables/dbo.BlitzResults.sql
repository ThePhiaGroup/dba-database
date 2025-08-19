--this table will automatically be created by sp_blitz
--including it here for posterity

/*
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = object_id('dbo.BlitzResults'))
BEGIN
	CREATE TABLE dbo.BlitzResults(
		ID int IDENTITY(1,1) NOT NULL,
		ServerName nvarchar(128) NULL,
		CheckDate datetimeoffset(7) NULL,
		Priority tinyint NULL,
		FindingsGroup varchar(50) NULL,
		Finding varchar(200) NULL,
		DatabaseName nvarchar(128) NULL,
		URL varchar(200) NULL,
		Details nvarchar(4000) NULL,
		QueryPlan nvarchar(max) NULL,
		QueryPlanFiltered nvarchar(max) NULL,
		CheckID int NULL,
		CONSTRAINT PK_BlitzResults PRIMARY KEY CLUSTERED (ID ASC)
	) ON [DATA];
END
GO
*/