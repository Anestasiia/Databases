--ADDING COLUMNS TO TABLES
ALTER TABLE [ProjectsImplementation].[Project] ADD 
	[UCR] [nvarchar](max) NULL,--ім’я користувача, що створив запис
	[DCR] [datetime2] NULL,--дата та час створення даного запису
	[ULR] [nvarchar](max) NULL,--ім’я користувача, що останнім змінив  запис
	[DLC] [datetime2] NULL;--дата та час останньої модифікації  запису
GO

ALTER TABLE [ProjectsImplementation].[Monthly_Bill] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Report] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Contract] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Category] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Client] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Performer] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Person] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Position] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

ALTER TABLE [ProjectsImplementation].[Qualification] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
GO

--TRIGGERS
CREATE OR ALTER TRIGGER [ProjectsImplementation].[Person_insertion_trigger]
   ON  [ProjectsImplementation].[Person]
   INSTEAD OF INSERT
AS 
	INSERT INTO [ProjectsImplementation].[Person]([person_name], [position_id], UCR, DCR)
    SELECT person_name, position_id, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Person_update_trigger]
   ON  [ProjectsImplementation].[Person]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Person]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Project_insertion_trigger]
   ON  [ProjectsImplementation].[Project]
   INSTEAD OF INSERT
AS 	
	DECLARE @contract_id AS int, @months AS int

	SELECT @contract_id = i.contract_id FROM inserted i

	DECLARE @client_id AS int

	SELECT TOP 1 @client_id=RES.id
	FROM
	(
		SELECT CL.id
		FROM [ProjectsImplementation].[Contract] C
		LEFT JOIN [ProjectsImplementation].[Client] CL ON CL.id=C.client_id

		WHERE C.id=@contract_id
	) AS RES

	SELECT TOP 1 @months = DATEDIFF(MONTH, MB.payment_month, getdate())
	FROM [ProjectsImplementation].[Client] C
	LEFT JOIN [ProjectsImplementation].[Contract] CO ON CO.client_id=C.id
	LEFT JOIN [ProjectsImplementation].[Monthly_Bill] MB ON MB.contract_id=CO.id

	WHERE MB.payed=0 AND C.id=@client_id

	ORDER BY MB.payment_month ASC

	DECLARE 
		@planned_duration AS nvarchar(max),
		@project_manager_id AS int,
		@project_name AS nvarchar(MAX),
		@start_date AS date

	SELECT @planned_duration = i.planned_duration, @project_manager_id=I.project_manager_id, @project_name=i.project_name, @start_date=i.start_date  FROM inserted i

	IF @months >= 3
		BEGIN 
			PRINT 'Cannot create project with client unpaid bills' 
		END
	ELSE 
		BEGIN 
			INSERT INTO [ProjectsImplementation].[Project]([contract_id], [planned_duration], [project_manager_id], [project_name], [start_date], UCR, DCR)
			VALUES (@contract_id, @planned_duration, @project_manager_id, @project_name, @start_date, USER_NAME(), GETDATE())
		END
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Project_update_trigger]
   ON  [ProjectsImplementation].[Project]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Project]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Monthly_Bill_insertion_trigger]
   ON  [ProjectsImplementation].[Monthly_Bill]
   INSTEAD OF INSERT
AS
	INSERT INTO [ProjectsImplementation].[Monthly_Bill]([id], [contract_id], [payed], [payment], [payment_month], UCR, DCR)
    SELECT NEWID(), contract_id, payed, payment, payment_month, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Monthly_Bill_update_trigger]
   ON  [ProjectsImplementation].[Monthly_Bill]
   AFTER UPDATE
AS	
	DECLARE @id AS uniqueidentifier

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Monthly_Bill]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Report_insertion_trigger]
   ON  [ProjectsImplementation].[Report]
   INSTEAD OF INSERT
AS
	DECLARE @time_worked AS time(7)

	SELECT @time_worked=i.hours_worked FROM inserted i

	IF CAST(CONVERT(decimal(5,2),CONVERT(DATETIME,@time_worked))*24 AS float) > 10
		BEGIN 
			PRINT 'Cannot report over 10 hours of work' 
		END
	ELSE 
		BEGIN 
			INSERT INTO [ProjectsImplementation].[Report]([daily_task], [hours_worked], [reported_day], [project_id], [performer_id], UCR, DCR)
			SELECT daily_task, hours_worked, reported_day, project_id, performer_id, USER_NAME(), GETDATE() FROM inserted;
		END
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Report_update_trigger]
   ON  [ProjectsImplementation].[Report]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Report]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Category_insertion_trigger]
   ON  [ProjectsImplementation].[Category]
   INSTEAD OF INSERT
AS 
	INSERT INTO [ProjectsImplementation].[Category]([category_price], UCR, DCR)
	SELECT category_price, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Category_update_trigger]
   ON  [ProjectsImplementation].[Category]
   AFTER UPDATE
AS
BEGIN
	
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Category]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id

END
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Client_insertion_trigger]
   ON  [ProjectsImplementation].[Client]
   INSTEAD OF INSERT
AS 
	INSERT INTO [ProjectsImplementation].[Client]([client_name], UCR, DCR)
	SELECT client_name, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Client_update_trigger]
   ON  [ProjectsImplementation].[Client]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Client]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Performer_insertion_trigger]
   ON  [ProjectsImplementation].[Performer]
   INSTEAD OF INSERT
AS 
	INSERT INTO [ProjectsImplementation].[Performer]([person_id], [qualification_id], UCR, DCR)
	SELECT person_id, qualification_id, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Performer_update_trigger]
   ON  [ProjectsImplementation].[Performer]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Performer]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Position_insertion_trigger]
   ON  [ProjectsImplementation].[Position]
   INSTEAD OF INSERT
AS 
	INSERT INTO [ProjectsImplementation].[Position]([position_name], [salary_coefficient], UCR, DCR)
	SELECT position_name, salary_coefficient, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Position_update_trigger]
   ON  [ProjectsImplementation].[Position]
   AFTER UPDATE
AS	
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Position]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Qualification_insertion_trigger]
   ON  [ProjectsImplementation].[Qualification]
   INSTEAD OF INSERT
AS
	INSERT INTO [ProjectsImplementation].[Qualification]([hourly_salary], [qualification_name], UCR, DCR)
	SELECT hourly_salary, qualification_name, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Qualification_update_trigger]
   ON  [ProjectsImplementation].[Qualification]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Qualification]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Contract_insertion_trigger]
   ON  [ProjectsImplementation].[Contract]
   INSTEAD OF INSERT
AS 
	INSERT INTO [ProjectsImplementation].[Contract]([category_id], [client_id], UCR, DCR)
	SELECT category_id, client_id, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [ProjectsImplementation].[Contract_update_trigger]
   ON  [ProjectsImplementation].[Contract]
   AFTER UPDATE
AS
	DECLARE @id AS int

	SELECT @id = i.id FROM inserted i

	UPDATE [ProjectsImplementation].[Contract]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

SELECT *
FROM [ProjectsImplementation].[Report] 

INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(1,2,'12:40:00','2023-04-18',N'done');

SELECT *
FROM [ProjectsImplementation].[Report] 

SELECT *
FROM [ProjectsImplementation].[Monthly_Bill] 

INSERT INTO [ProjectsImplementation].[Monthly_Bill]
	([contract_id],[payed],[payment],[payment_month])
VALUES(2,0,568.78272,'2023-01-01')

SELECT *
FROM [ProjectsImplementation].[Monthly_Bill] 

SELECT *
FROM [ProjectsImplementation].[Project] 

INSERT INTO [ProjectsImplementation].[Project] 
	([project_name],[contract_id],[planned_duration],[project_manager_id],[start_date])
VALUES 
 	(N'MobiVisual','3','43:00:00',1,'2023-03-05');

SELECT *
FROM [ProjectsImplementation].[Project] 
