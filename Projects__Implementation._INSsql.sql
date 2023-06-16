DELETE FROM [ProjectsImplementation].[Category];
DELETE FROM [ProjectsImplementation].[Project];
DELETE FROM [ProjectsImplementation].[Performer];
DELETE FROM [ProjectsImplementation].[Person];
DELETE FROM [ProjectsImplementation].[Position];
DELETE FROM [ProjectsImplementation].[Report];
DELETE FROM [ProjectsImplementation].[Qualification];
DELETE FROM [ProjectsImplementation].[Contract];
DELETE FROM [ProjectsImplementation].[Client];
DBCC CHECKIDENT ('ProjectsImplementation.Client', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Category', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Project', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Performer', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Person', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Position', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Report', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Qualification', RESEED, 0);
DBCC CHECKIDENT ('ProjectsImplementation.Contract', RESEED, 0);


INSERT INTO [ProjectsImplementation].[Client]
	([client_name])
VALUES 
	(N'Kane Carter');
INSERT INTO [ProjectsImplementation].[Client] 
	([client_name])
VALUES
	(N'Oskar James');
INSERT INTO [ProjectsImplementation].[Client] 
	([client_name])
VALUES
	(N'Isaak Phillips');

INSERT INTO [ProjectsImplementation].[Category]
	([category_price])
VALUES
	(0.1)
INSERT INTO [ProjectsImplementation].[Category]
	([category_price])
VALUES
	(0.2)
INSERT INTO [ProjectsImplementation].[Category]
	([category_price])
VALUES
	(0.5)

INSERT INTO [ProjectsImplementation].[Contract] 
	([client_id] ,[category_id])
VALUES 
	(1,3);
INSERT INTO [ProjectsImplementation].[Contract] 
	([client_id] ,[category_id])
VALUES
	(3,2);
INSERT INTO [ProjectsImplementation].[Contract] 
	([client_id],[category_id])
VALUES
	(3,3);

INSERT INTO [ProjectsImplementation].[Position] 
	([position_name],[salary_coefficient])
VALUES 
	(N'Team Lead','1.93');
INSERT INTO [ProjectsImplementation].[Position] 
	([position_name],[salary_coefficient])
VALUES
	(N'Manager','1.68');
INSERT INTO [ProjectsImplementation].[Position] 
	([position_name],[salary_coefficient])
VALUES
	(N'Designer','1.5');
INSERT INTO [ProjectsImplementation].[Position] 
	([position_name],[salary_coefficient])
VALUES
	(N'QA Ingener','1.25');
INSERT INTO [ProjectsImplementation].[Position] 
	([position_name],[salary_coefficient])
VALUES
	(N'Bussines Analyst','1.72');

INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 
	(N'Dean Collins','1');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 
	(N'Lilly Hughes','2');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 	
	(N'John Moore','3');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 
	(N'Patrick Adams','4');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 
	(N'Kevin Patterson','5');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 	
	(N'Tianna Lewis','2');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 
	(N'Kye Bennett','4');
INSERT INTO [ProjectsImplementation].[Person] 
	([person_name],[position_id])
VALUES 
	(N'Alexa Morris','3');

INSERT INTO [ProjectsImplementation].[Qualification] 
	([qualification_name],[hourly_salary])
VALUES 
 	(N'Trainee','15');
INSERT INTO [ProjectsImplementation].[Qualification] 
	([qualification_name],[hourly_salary])
VALUES 
	(N'Joniour','23');
INSERT INTO [ProjectsImplementation].[Qualification] 
	([qualification_name],[hourly_salary])
VALUES 
	(N'Middle','34');
INSERT INTO [ProjectsImplementation].[Qualification] 
	([qualification_name],[hourly_salary])
VALUES 
	(N'Senior','50');

INSERT INTO [ProjectsImplementation].[Performer] 
	([person_id],[qualification_id])
VALUES 
 	('1','3'),
	('2','4'),
	('3','2'),
	('4','1'),
	('5','3'),
	('6','2'),
	('7','2'),
	('8','4');

INSERT INTO [ProjectsImplementation].[Project] 
	([project_name],[contract_id],[planned_duration],[project_manager_id],[start_date])
VALUES 
 	(N'MobiVisual','1','43:00:00',1,'2023-03-05');
INSERT INTO [ProjectsImplementation].[Project] 
	([project_name],[contract_id],[planned_duration],[project_manager_id],[start_date])
VALUES 
	(N'Lipitor','3','17:00:00',3,'2023-04-06');
INSERT INTO [ProjectsImplementation].[Project] 
	([project_name],[contract_id],[planned_duration],[project_manager_id],[start_date])
VALUES 
	(N'GamerForce','2','29:00:00',5,'2023-03-27');

INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES 
 	(7,2,'05:30:00','2023-04-12',N'smth');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(4,3,'04:15:00','2023-04-12',N'task');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(1,2,'02:40:00','2023-04-18',N'done');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(6,1,'06:10:00','2023-04-19',N'workout');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(8,2,'05:30:00','2023-04-20',N'task 2.4');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(5,3,'06:50:00','2023-04-22',N'new idea');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
	(2,1,'4:50:00','2023-04-28',N'test 5-6');
INSERT INTO [ProjectsImplementation].[Report] 
	([performer_id],[project_id],[hours_worked],[reported_day],[daily_task])
VALUES
    (3,1,'03:45:00','2023-04-28',N'busy');
	
INSERT INTO [ProjectsImplementation].[Monthly_Bill]
	([contract_id],[payed],[payment],[payment_month])
VALUES(1,1,1165.1904,'2023-04-01')
INSERT INTO [ProjectsImplementation].[Monthly_Bill]
	([contract_id],[payed],[payment],[payment_month])
VALUES(3,0,1118.9052,'2023-04-01')
INSERT INTO [ProjectsImplementation].[Monthly_Bill]
	([contract_id],[payed],[payment],[payment_month])
VALUES(2,1,568.78272,'2023-04-01')