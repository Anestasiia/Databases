/* Drop on creation */

DROP TABLE IF EXISTS [ProjectsImplementation].[Report];
DROP TABLE IF EXISTS [ProjectsImplementation].[Monthly_Bill];
DROP TABLE IF EXISTS [ProjectsImplementation].[Project];
DROP TABLE IF EXISTS [ProjectsImplementation].[Contract];
DROP TABLE IF EXISTS [ProjectsImplementation].[Category];
DROP TABLE IF EXISTS [ProjectsImplementation].[Client];
DROP TABLE IF EXISTS [ProjectsImplementation].[Performer];
DROP TABLE IF EXISTS [ProjectsImplementation].[Person];
DROP TABLE IF EXISTS [ProjectsImplementation].[Position];
DROP TABLE IF EXISTS [ProjectsImplementation].[Qualification];

GO

/* Object:  Table [ProjectsImplementation].[Project]*/
CREATE TABLE [ProjectsImplementation].[Project](
	[id] [int] IDENTITY(1,1)  NOT NULL,
	[project_name] [nvarchar](max) NOT NULL,
	[contract_id] [int] NOT NULL,
	[planned_duration] [nvarchar](max) NOT NULL,
	[project_manager_id] [int] NULL,
	[start_date] [date] NOT NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Contract]*/
CREATE TABLE [ProjectsImplementation].[Contract](
	[id] [int] IDENTITY(1,1)  NOT NULL,
	[client_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
 CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ProjectsImplementation].[Category](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[category_price] [float] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Client]*/
CREATE TABLE [ProjectsImplementation].[Client](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Report]*/
CREATE TABLE [ProjectsImplementation].[Report](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[performer_id] [int] NOT NULL,
	[project_id] [int] NOT NULL,
	[hours_worked] [time] NOT NULL,
	[reported_day] [date] NOT NULL,
	[daily_task] [nvarchar](max) NULL,
 CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Performer]*/
CREATE TABLE [ProjectsImplementation].[Performer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[person_id] [int] NOT NULL,
	[qualification_id] [int] NOT NULL,
 CONSTRAINT [PK_Performer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX =OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Qualification]*/
CREATE TABLE [ProjectsImplementation].[Qualification](
	[id] [int]  IDENTITY(1,1)NOT NULL,
	[qualification_name] [nvarchar](30) NOT NULL,
	[hourly_salary] [float] NOT NULL,
 CONSTRAINT [PK_Qualification] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Person]*/
CREATE TABLE [ProjectsImplementation].[Person](
	[id] [int] IDENTITY(1,1)  NOT NULL,
	[person_name] [nvarchar](max) NOT NULL,
	[position_id] [int] NOT NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Position]*/
CREATE TABLE [ProjectsImplementation].[Position](
	[id] [int]  IDENTITY(1,1) NOT NULL,
	[position_name] [nvarchar](max) NOT NULL,
	[salary_coefficient] [float] NOT NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Object:  Table [ProjectsImplementation].[Monthly_Bill]*/
CREATE TABLE [ProjectsImplementation].[Monthly_Bill](
	[id] [uniqueidentifier] NOT NULL,
	[contract_id] [int] NOT NULL,
	[payment] [float] NOT NULL,
	[payment_month] [date] NOT NULL,
	[payed] [bit] NOT NULL,

 CONSTRAINT [PK_Monthly_Bill] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Connections */
ALTER TABLE [ProjectsImplementation].[Project] WITH CHECK ADD  CONSTRAINT [FK_Project_Contract] FOREIGN KEY([Contract_id])
REFERENCES [ProjectsImplementation].[Contract] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Report] WITH CHECK ADD  CONSTRAINT [FK_Report_Project] FOREIGN KEY([project_id])
REFERENCES [ProjectsImplementation].[Project] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Report] WITH CHECK ADD  CONSTRAINT [FK_Report_Performer] FOREIGN KEY([performer_id])
REFERENCES [ProjectsImplementation].[Performer] ([id])
ON DELETE CASCADE
GO


ALTER TABLE [ProjectsImplementation].[Performer] WITH CHECK ADD  CONSTRAINT [FK_Performer_Qualification] FOREIGN KEY([Qualification_id])
REFERENCES [ProjectsImplementation].[Qualification] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Performer] WITH CHECK ADD  CONSTRAINT [FK_Performer_Person] FOREIGN KEY([Person_id])
REFERENCES [ProjectsImplementation].[Person] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Person] WITH CHECK ADD  CONSTRAINT [FK_Person_Position] FOREIGN KEY([Position_id])
REFERENCES [ProjectsImplementation].[Position] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Monthly_Bill] WITH CHECK ADD  CONSTRAINT [FK_Monthly_Bill_Contract] FOREIGN KEY([contract_id])
REFERENCES [ProjectsImplementation].[Contract] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Contract] WITH CHECK ADD  CONSTRAINT [FK_Contract_Client] FOREIGN KEY([Client_id])
REFERENCES [ProjectsImplementation].[Client] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [ProjectsImplementation].[Project] WITH CHECK ADD  CONSTRAINT [FK_Project_Manager] FOREIGN KEY([project_manager_id])
REFERENCES [ProjectsImplementation].[Person] ([id])
ON DELETE NO ACTION
GO

ALTER TABLE [ProjectsImplementation].[Contract] WITH CHECK ADD  CONSTRAINT [FK_Conract_Category] FOREIGN KEY([category_id])
REFERENCES [ProjectsImplementation].[Category] ([id])
ON DELETE CASCADE
GO