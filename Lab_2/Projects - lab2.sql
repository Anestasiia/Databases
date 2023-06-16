--TASK1 базі однієї таблиці з використанням сортування, накладенням умов зі зв’язками OR та AND
SELECT *
FROM [ProjectsImplementation].[Person] P
WHERE P.position_id=2 AND (P.person_name='Lilly Hughes' OR P.person_name='Tianna Lewis')
ORDER BY P.person_name DESC
GO

--TASK2 з виводом обчислюваних полів (виразів) в колонках результату
SELECT AVG(P.salary_coefficient) AS 'Avarage salary coefficient'
FROM [Projectsimplementation].[Position] P
GO

--TASK3 на базі кількох таблиць з використанням сортування, накладенням умов зі зв’язками OR та AND
SELECT PEN.person_name, POS.salary_coefficient, PER.qualification_id
FROM [Projectsimplementation].[Person] PEN
LEFT JOIN [Projectsimplementation].[Performer] PER on PER.person_id=PEN.id
LEFT JOIN [Projectsimplementation].[Position] POS ON POS.id=PEN.position_id
WHERE POS.salary_coefficient > 1.5 AND (PER.qualification_id=2 OR PER.qualification_id=3)
ORDER BY PEN.person_name
GO

--TASK4 на базі кількох таблиць з типом поєднання Outer Join
SELECT CLT.client_name, COT.id
FROM [Projectsimplementation].[Client] CLT
FULL OUTER JOIN [Projectsimplementation].[Contract] COT ON COT.client_id=CLT.id
GO

--TASK5 використанням операторів Like,  In, Exists, All, Any
--LIKE
SELECT PEN.person_name
FROM [Projectsimplementation].[Person] PEN
WHERE PEN.person_name LIKE 'K%'

--BETWEEN --
SELECT *
FROM [Projectsimplementation].[Position] PON
WHERE PON.salary_coefficient BETWEEN 1.25 AND 1.61

--IN
SELECT *
FROM [Projectsimplementation].[Position] PON
WHERE PON.salary_coefficient IN (1.25,1.5,1.68)

--EXISTS
SELECT CLT.client_name
FROM [Projectsimplementation].[Client] CLT
WHERE EXISTS
(
	SELECT *
	FROM [Projectsimplementation].[Contract] COT
	WHERE COT.client_id=CLT.id
)

--ANY
SELECT *
FROM [Projectsimplementation].[Client] CLT
WHERE CLT.id = ANY
(
	SELECT COT.client_id
	FROM [Projectsimplementation].[Contract] COT
)

--ALL
SELECT PEN.person_name, PON.position_name
FROM [Projectsimplementation].[Person] PEN
LEFT JOIN [Projectsimplementation].[Position] PON ON PON.id=PEN.position_id
WHERE PON.salary_coefficient < ALL 
(
	SELECT PON_SUB.salary_coefficient
	FROM [Projectsimplementation].[Position] PON_SUB
	WHERE PON_SUB.position_name IN ('Team Lead', 'Manager', 'Designer')
)
GO

--TASK6 з використанням підсумовування та групування.
SELECT PEN.id, SUM(QUN.hourly_salary) AS 'SALARY'
FROM [Projectsimplementation].[Person] PEN
LEFT JOIN [Projectsimplementation].[Performer] PER ON PER.person_id=PEN.id
LEFT JOIN [Projectsimplementation].[Qualification] QUN ON QUN.id=PER.qualification_id
GROUP BY PEN.id
GO

--TASK7 з використанням під-запитів в частині Where
SELECT CLT.client_name
FROM [Projectsimplementation].[Client] CLT
WHERE EXISTS
(
	SELECT *
	FROM [Projectsimplementation].[Contract] COT
	WHERE COT.client_id=CLT.id
)
GO

--TASK8 з використанням під-запитів в частині From
SELECT *
FROM 
(
	SELECT CLT.client_name, COT.category_id
	FROM [Projectsimplementation].[Client] CLT
	RIGHT JOIN [Projectsimplementation].[Contract] COT ON COT.client_id=CLT.id
) AS RES
GO

--TASK9 	ієрархічний SELECT запит
SELECT RES_PERFORMER.Person_name AS 'Worker name', RES_MANAGER.Manager_name AS 'Their manager name'
FROM
(
	SELECT PEN.person_name AS Person_name, PRT.id AS Project_id
	FROM [Projectsimplementation].[Person] PEN
	RIGHT JOIN [Projectsimplementation].[Performer] PER ON PER.person_id=PEN.id
	RIGHT JOIN [Projectsimplementation].[Report] RET ON RET.performer_id=PER.id
	INNER JOIN [Projectsimplementation].[Project] PRT ON PRT.id=RET.project_id

) AS RES_PERFORMER,
(
	SELECT PEN.person_name AS Manager_name, PRT.id AS Project_id 
	FROM [Projectsimplementation].[Person] PEN
	RIGHT JOIN [Projectsimplementation].[Project] PRT ON PRT.project_manager_id=PEN.id
) AS RES_MANAGER
WHERE RES_MANAGER.Project_id=RES_PERFORMER.Project_id
GO

--TASK10  SELECT запит типу CrossTab
SELECT 'Their seniors' AS Manager_id, [1] AS '1', [3] AS '3' ,[5] AS '5'
FROM
(

	SELECT RES_PERFORMER.Senior_id AS Senior_id, RES_MANAGER.Manager_id AS Manager_id
	FROM
	(
		SELECT PEN.id AS Senior_id, PRT.id AS Project_id
		FROM [Projectsimplementation].[Person] PEN
		RIGHT JOIN [Projectsimplementation].[Performer] PER ON PER.person_id=PEN.id
		RIGHT JOIN [Projectsimplementation].[Report] RET ON RET.performer_id=PER.id
		INNER JOIN [Projectsimplementation].[Project] PRT ON PRT.id=RET.project_id

	) AS RES_PERFORMER,
	(
		SELECT PEN.id AS Manager_id, PRT.id AS Project_id 
		FROM [Projectsimplementation].[Person] PEN
		RIGHT JOIN [Projectsimplementation].[Project] PRT ON PRT.project_manager_id=PEN.id
	) AS RES_MANAGER
	WHERE RES_MANAGER.Project_id=RES_PERFORMER.Project_id
) AS FromTable
PIVOT
(
	COUNT(Senior_id)
	FOR Manager_id IN ([1],[3],[5])
) AS PivotTable
GO

--TASK11  UPDATE на базі однієї таблиці

SELECT *
FROM [Projectsimplementation].[Category]

UPDATE [Projectsimplementation].[Category] 
SET category_price=0.6
WHERE category_price=0.5

SELECT *
FROM [Projectsimplementation].[Category]
GO

--TASK12  UPDATE на базі кількох таблиць
SELECT * 
FROM [Projectsimplementation].[Category]
GO

UPDATE CAY
SET CAY.category_price=0.5
FROM [Projectsimplementation].[Category] CAY
	JOIN [Projectsimplementation].[Contract] COT ON COT.category_id=CAY.id
WHERE COT.client_id=1 AND CAY.category_price=0.6
GO

SELECT *
FROM [Projectsimplementation].[Category]
GO

--TASK13  Append (INSERT) для додавання записів з явно вказаними значеннями
SELECT *
FROM [Projectsimplementation].[Category]
GO

INSERT INTO [Projectsimplementation].[Category]
	([category_price])
VALUES(0.8)
GO

SELECT *
FROM [Projectsimplementation].[Category]
GO

--TASK14  Append (INSERT) для додавання записів з інших таблиць.
DROP TABLE IF EXISTS [Temp]
GO

CREATE TABLE [Temp](
	[id] [int] NOT NULL,
	[category_price] [float] NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [Temp] 
	([id],[category_price]) 
VALUES 
	(1,0.9)
GO

SELECT * FROM [Temp]
GO

SELECT * FROM [Projectsimplementation].[Category]
GO

INSERT INTO [Projectsimplementation].[Category]
SELECT T.category_price FROM [Temp] T
GO

SELECT * FROM [Projectsimplementation].[Category]
GO

DROP TABLE IF EXISTS [Temp]
GO

--TASK15  DELETE для видалення всіх даних з таблиці.
DROP TABLE IF EXISTS [Temp]
GO

CREATE TABLE [Temp](
	[id] [int] NOT NULL,
	[category_price] [float] NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SELECT * FROM [Temp]
GO

INSERT INTO [Temp] 
	([id],[category_price]) 
VALUES 
	(1,0.9)
GO

SELECT * FROM [Temp]
GO

DELETE FROM [Temp]
GO

SELECT * FROM [Temp]
GO

DROP TABLE IF EXISTS [Temp]
GO
--TASK16  DELETE для видалення вибраних записів таблиці.
SELECT * FROM [Projectsimplementation].[Category]
GO

DELETE FROM [Projectsimplementation].[Category] WHERE [category_price]=0.9
GO

SELECT * FROM [Projectsimplementation].[Category]
GO
--REPOR1
SELECT RES.id, RES.payed, SUM(CAST(CONVERT(DATETIME, RES.hours_worked) AS decimal(10,2)) * 24 * RES.hourly_salary * RES.salary_coefficient * (1 + RES.category_price)) AS Payed_amount
FROM 
(

SELECT MOL.payed, CAY.id, RET.hours_worked, QUN.hourly_salary, PON.salary_coefficient, CAY.category_price
FROM [ProjectsImplementation].[Project] PRT
LEFT JOIN [ProjectsImplementation].[Report] RET ON RET.project_id=PRT.id
LEFT JOIN [ProjectsImplementation].[Performer] PER ON PER.id=RET.performer_id
LEFT JOIN [ProjectsImplementation].[Qualification] QUN ON QUN.id=PER.qualification_id
LEFT JOIN [ProjectsImplementation].[Person] PEN ON PEN.id=PER.person_id
LEFT JOIN [ProjectsImplementation].[Position] PON ON PON.id=PEN.position_id
LEFT JOIN [ProjectsImplementation].[Contract] COT ON COT.id=PRT.contract_id
LEFT JOIN [ProjectsImplementation].[Category] CAY ON CAY.id=COT.category_id
LEFT JOIN [ProjectsImplementation].[Monthly_Bill] MOL ON MOL.contract_id=COT.id

) AS RES

GROUP BY RES.id, RES.payed
GO

--REPORT2
SELECT RES.position_name, SUM(RES.hourly_salary * RES.time_worked * RES.salary_coefficient) AS 'Payment_to_position'
FROM
(
	SELECT PON.position_name, PEN.person_name, PON.salary_coefficient, QUN.hourly_salary, CAST(CONVERT(DATETIME, RET.hours_worked) AS decimal(10,2)) * 24 as time_worked

	FROM [ProjectsImplementation].[Person] PEN
	LEFT JOIN [ProjectsImplementation].[Position] PON ON PON.id=PEN.position_id
	LEFT JOIN [ProjectsImplementation].[Performer] PER ON PER.person_id=PEN.id
	LEFT JOIN [ProjectsImplementation].[Qualification] QUN ON QUN.id=PER.qualification_id
	LEFT JOIN [ProjectsImplementation].[Report] RET ON RET.performer_id=PER.id
	LEFT JOIN [ProjectsImplementation].[Project] PRT ON PRT.id=RET.project_id
	LEFT JOIN [ProjectsImplementation].[Contract] COT ON COT.id=PRT.contract_id
	LEFT JOIN [ProjectsImplementation].[Monthly_Bill] MOL ON MOL.contract_id=COT.id

	WHERE MOL.payed=1
) AS RES

GROUP BY RES.position_name

--TASK3
SELECT PRT.project_name, RET.daily_task
FROM [ProjectsImplementation].[Project] PRT
LEFT JOIN [ProjectsImplementation].[Report] RET ON RET.project_id=PRT.id
WHERE MONTH(RET.reported_day)=4
