IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = object_id('dbo.PurgeHistory'))
BEGIN
CREATE TABLE dbo.PurgeHistory(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PurgeControlID] [int] NOT NULL
		CONSTRAINT [FK_PurgeHistory_PurgeControl] FOREIGN KEY ([PurgeControlID]) REFERENCES [dbo].[PurgeControl]([ID]),
	[PurgedRows] [int] NULL,
	[Operation] [nvarchar](128) NULL,
	[PurgeRunTimestamp] [datetime2](7) NULL,
	[PurgeOperationTimestamp] [datetime2](7) NULL
		CONSTRAINT [DF_PurgeHistory_PurgeOperationTimestamp] DEFAULT (GETDATE()),
	CONSTRAINT [PK_PurgeHistory_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
)
END
GO
