IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = object_id('dbo.PurgeHistory'))
BEGIN
CREATE TABLE dbo.PurgeHistory(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[SchemaName] [nvarchar](128) NULL,
	[TableName] [nvarchar](128) NULL,
	[PurgedRows] [int] NULL,
	[Operation] [nvarchar](128) NULL,
	[RemainingRows] [bigint] NULL,
	[PurgeBefore] [date] NULL,
	[PurgeRunTimestamp] [datetime2](7) NULL,
	[PurgeOperationTimestamp] [datetime2](7) NULL
		CONSTRAINT [DF_PurgeHistory_PurgeOperationTimestamp] DEFAULT (GETDATE()),
	CONSTRAINT [PK_PurgeHistory_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
)
END
GO
