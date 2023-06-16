/* Delete procedure*/
DROP PROCEDURE IF EXISTS [ProjectsImplementation].[Salary_for_person];
GO

/* Procedure */
CREATE PROCEDURE [ProjectsImplementation].[Salary_for_person] @Person_id int, @Month int
AS
--ѕриймаютьс€ аргументи 
--@Person_id типу intЦ id прац≥вника, дл€ €кого потр≥бно розрахувати зарплату; 
--@Month типу intЦ номер м≥с€ц≥, за €кий потр≥бно розрахувати зарплату прац≥внику в першому аргумент≥
DECLARE 
	@salary_coefficient AS decimal(10,5),
	@salary_for_hours_of_work AS decimal(10,5)
--¬ т≥л≥ створюютьс€ зм≥нн≥: @salary_coefficient( коеф≥ц≥Їнти зарплати прац≥вника за посадою); 
--@salary_for_hours_of_work(обчислюЇтьс€ €к сума к≥лькост≥ годин виконанн€ проекту в умовах певноњ рол≥, за певний м≥с€ць)
SELECT @salary_coefficient = POS.salary_coefficient
FROM [ProjectsImplementation].[Person] PER
LEFT JOIN [ProjectsImplementation].[Position] POS ON POS.id=PER.position_id
WHERE PER.id=@Person_id

SELECT @salary_for_hours_of_work = SUM(Q.hourly_salary*CONVERT(decimal(5,2),CONVERT(DATETIME,R.hours_worked))*24)
FROM [ProjectsImplementation].[Person] P
LEFT JOIN [ProjectsImplementation].[Performer] PER ON PER.person_id=P.id
LEFT JOIN [ProjectsImplementation].[Qualification] Q ON Q.id=PER.qualification_id
LEFT JOIN [ProjectsImplementation].[Report] R ON R.performer_id=PER.id
--запитами обчислюютьс€ зм≥нн≥ @salary_coefficient, @salary_for_hours_of_work
WHERE Month(R.reported_day) = @Month

GROUP BY P.id
HAVING P.id=@Person_id
--результатом повертаЇтьс€ таблиц€ з ≥мТ€м прац≥вника та добутком коеф≥ц≥Їнту за посаду на зарплату на р≥зних проектах	
SELECT P.person_name AS 'Person Name', @salary_coefficient * @salary_for_hours_of_work AS 'Salary'
FROM [ProjectsImplementation].[Person] P
WHERE P.id=@Person_id
GO

DROP PROCEDURE IF EXISTS [ProjectsImplementation].[Salary];
GO

CREATE PROCEDURE [ProjectsImplementation].[Salary] @Month int
AS
--аргумент - номер м≥с€ц€, за €кий потр≥бно розрахувати зарплату прац≥вникам, @Month типу int
DECLARE @Person_id AS int

DECLARE person_cursor CURSOR FOR
SELECT P.id
FROM [ProjectsImplementation].[Person] P
--дл€ проходженн€ по списку прац≥вник≥в використовуЇтьс€ курсор person_cursor, 
--€кий приймаЇ значенн€ id кожного прац≥вника з таблиц≥ [Person]
OPEN person_cursor
FETCH NEXT FROM person_cursor INTO @Person_id 

WHILE @@FETCH_STATUS = 0  
BEGIN  
	
	EXEC [ProjectsImplementation].[Salary_for_person] @Person_id, @Month
--за допомогою команди exec викликаЇтьс€ перша процедура уже з правильно вказаними аргументами
	FETCH NEXT FROM person_cursor INTO @Person_id 
END 

CLOSE person_cursor  
DEALLOCATE person_cursor 
GO
--командою EXEC [ProjectsImplementation].[Salary] *пор€дковий номер м≥с€ц€* викликаЇтьс€ друга процедура
EXEC [ProjectsImplementation].[Salary] '4'