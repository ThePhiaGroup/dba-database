CREATE OR ALTER PROCEDURE [dbo].[PurgeTableByDate]
@DatabaseName NVARCHAR(128) = NULL, @TableName NVARCHAR(128) = NULL, @SchemaName NVARCHAR(128) = 'dbo', @DateColumn NVARCHAR(128) = NULL, @PurgeBefore DATE = NULL, @BatchSize INT = 50000, @MaxIterations INT = NULL, @Interactive BIT = 0, @Command NVARCHAR(500) = NULL
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @Iteration INT = 0, @TotalRows INT = 0, @RemainingRows INT = 0, @Message VARCHAR(500), @PurgeRunTimestamp DATETIME2 = GETDATE();

IF (COALESCE(@DatabaseName, '' ) = '')
    THROW 99999, 'MISSING @DatabaseName', 1

IF (COALESCE(@TableName, '' ) = '')
    THROW 99999, 'MISSING @TableName', 1

IF (COALESCE(@DateColumn, '' ) = '')
    THROW 99999, 'MISSING @DateColumn', 1

IF (COALESCE(@PurgeBefore, '' ) = '')
    THROW 99999, 'MISSING @PurgeBefore', 1

SET @Command = 'SELECT @Output = COUNT(*) FROM [' + @DatabaseName + '].[' + @SchemaName + '].[' + @TableName + '] WHERE ' + @DateColumn + ' < ''' + CAST(@PurgeBefore AS nvarchar(128)) + ''''
--EXEC sp_executesql @Command, N'@Output INT OUTPUT', @Output = @RemainingRows OUTPUT

/*
IF @@SERVERNAME = 'phia22uatsql01'
    INSERT INTO [dba].[dbo].[PurgeHistory] ([ServerName], [DatabaseName], [TableName], [SchemaName], [PurgedRows], [Operation], [RemainingRows], [PurgeBefore], [PurgeRunTimestamp])
    VALUES (@@SERVERNAME, @DatabaseName, @TableName, @SchemaName, @BatchSize, 'INIT', @RemainingRows, @PurgeBefore, @PurgeRunTimestamp)
ELSE
    INSERT INTO [phia22uatsql01_purge].[dba].[dbo].[PurgeHistory] ([ServerName], [DatabaseName], [TableName], [SchemaName], [PurgedRows], [Operation], [RemainingRows], [PurgeBefore], [PurgeRunTimestamp])
    VALUES (@@SERVERNAME, @DatabaseName, @TableName, @SchemaName, @BatchSize, 'INIT', @RemainingRows, @PurgeBefore, @PurgeRunTimestamp)
*/
WHILE (@BatchSize > 0 AND (@MaxIterations IS NULL OR @Iteration < @MaxIterations))
    BEGIN
    IF @@SERVERNAME = 'phia22uatsql01'
        INSERT INTO [dba].[dbo].[PurgeHistory] ([ServerName], [DatabaseName], [TableName], [SchemaName], [PurgedRows], [Operation], [RemainingRows], [PurgeBefore], [PurgeRunTimestamp])
        VALUES (@@SERVERNAME, @DatabaseName, @TableName, @SchemaName, @BatchSize, 'START', @RemainingRows, @PurgeBefore, @PurgeRunTimestamp)
    ELSE
        INSERT INTO [phia22uatsql01_purge].[dba].[dbo].[PurgeHistory] ([ServerName], [DatabaseName], [TableName], [SchemaName], [PurgedRows], [Operation], [RemainingRows], [PurgeBefore], [PurgeRunTimestamp])
        VALUES (@@SERVERNAME, @DatabaseName, @TableName, @SchemaName, @BatchSize, 'START', @RemainingRows, @PurgeBefore, @PurgeRunTimestamp)

    SET @Command = 'DELETE TOP(' + CAST(@BatchSize AS varchar(1000)) + ') FROM [' + @DatabaseName + '].[' + @SchemaName + '].[' + @TableName + '] WHERE ' + @DateColumn + ' < ''' + CAST(@PurgeBefore AS varchar(1000)) + ''''
    EXEC sp_executesql @Command
            
    SET @BatchSize = @@ROWCOUNT
    SET @Iteration = @Iteration + 1
    SET @TotalRows = @TotalRows + @BatchSize
    SET @RemainingRows = @RemainingRows - @BatchSize
    IF @Interactive = 1
        BEGIN
        SET @Message = CAST(GETDATE() AS VARCHAR) + ': Iteration: ' + CAST(@Iteration AS VARCHAR) + ' Total deletes:' + CAST(@TotalRows AS VARCHAR)
        RAISERROR (@Message, 0, 1) WITH NOWAIT
        END

    IF @@SERVERNAME = 'phia22uatsql01'
        INSERT INTO [dba].[dbo].[PurgeHistory] ([ServerName], [DatabaseName], [TableName], [SchemaName], [PurgedRows], [Operation], [RemainingRows], [PurgeBefore], [PurgeRunTimestamp])
        VALUES (@@SERVERNAME, @DatabaseName, @TableName, @SchemaName, @BatchSize, 'END', @RemainingRows, @PurgeBefore, @PurgeRunTimestamp)
    ELSE
        INSERT INTO [phia22uatsql01_purge].[dba].[dbo].[PurgeHistory] ([ServerName], [DatabaseName], [TableName], [SchemaName], [PurgedRows], [Operation], [RemainingRows], [PurgeBefore], [PurgeRunTimestamp])
        VALUES (@@SERVERNAME, @DatabaseName, @TableName, @SchemaName, @BatchSize, 'END', @RemainingRows, @PurgeBefore, @PurgeRunTimestamp)
        
    END  
END