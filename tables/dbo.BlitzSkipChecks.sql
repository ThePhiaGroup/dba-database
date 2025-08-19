IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = object_id('dbo.BlitzSkipChecks'))
BEGIN
	CREATE TABLE dbo.BlitzSkipChecks(
		ID int IDENTITY(1,1) NOT NULL,
		ServerName nvarchar(128) NULL,
		DatabaseName nvarchar(128) NULL,
		CheckID int NULL,
		CONSTRAINT PK_BlitzSkipChecks PRIMARY KEY CLUSTERED (ID ASC)
	) ON [DATA];
END
GO
