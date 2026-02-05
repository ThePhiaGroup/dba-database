IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = object_id('dbo.PurgeControl'))
BEGIN
CREATE TABLE dbo.PurgeControl(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[TableName] [nvarchar](128) NULL,
	[Active] [bit] NULL,
	CONSTRAINT [PK_PurgeControl_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
)
END
GO
