/* Delete procedure*/
DROP PROCEDURE IF EXISTS [ProjectsImplementation].[Salary_for_person];
GO

/* Procedure */
CREATE PROCEDURE [ProjectsImplementation].[Salary_for_person] @Person_id int, @Month int
AS
--����������� ��������� 
--@Person_id ���� int� id ����������, ��� ����� ������� ����������� ��������; 
--@Month ���� int� ����� �����, �� ���� ������� ����������� �������� ���������� � ������� ��������
DECLARE 
	@salary_coefficient AS decimal(10,5),
	@salary_for_hours_of_work AS decimal(10,5)
--� �� ����������� ����: @salary_coefficient( ����������� �������� ���������� �� �������); 
--@salary_for_hours_of_work(������������ �� ���� ������� ����� ��������� ������� � ������ ����� ���, �� ������ �����)
SELECT @salary_coefficient = POS.salary_coefficient
FROM [ProjectsImplementation].[Person] PER
LEFT JOIN [ProjectsImplementation].[Position] POS ON POS.id=PER.position_id
WHERE PER.id=@Person_id

SELECT @salary_for_hours_of_work = SUM(Q.hourly_salary*CONVERT(decimal(5,2),CONVERT(DATETIME,R.hours_worked))*24)
FROM [ProjectsImplementation].[Person] P
LEFT JOIN [ProjectsImplementation].[Performer] PER ON PER.person_id=P.id
LEFT JOIN [ProjectsImplementation].[Qualification] Q ON Q.id=PER.qualification_id
LEFT JOIN [ProjectsImplementation].[Report] R ON R.performer_id=PER.id
--�������� ������������ ���� @salary_coefficient, @salary_for_hours_of_work
WHERE Month(R.reported_day) = @Month

GROUP BY P.id
HAVING P.id=@Person_id
--����������� ����������� ������� � ���� ���������� �� �������� ����������� �� ������ �� �������� �� ����� ��������	
SELECT P.person_name AS 'Person Name', @salary_coefficient * @salary_for_hours_of_work AS 'Salary'
FROM [ProjectsImplementation].[Person] P
WHERE P.id=@Person_id
GO

DROP PROCEDURE IF EXISTS [ProjectsImplementation].[Salary];
GO

CREATE PROCEDURE [ProjectsImplementation].[Salary] @Month int
AS
--�������� - ����� �����, �� ���� ������� ����������� �������� �����������, @Month ���� int
DECLARE @Person_id AS int

DECLARE person_cursor CURSOR FOR
SELECT P.id
FROM [ProjectsImplementation].[Person] P
--��� ����������� �� ������ ���������� ��������������� ������ person_cursor, 
--���� ������ �������� id ������� ���������� � ������� [Person]
OPEN person_cursor
FETCH NEXT FROM person_cursor INTO @Person_id 

WHILE @@FETCH_STATUS = 0  
BEGIN  
	
	EXEC [ProjectsImplementation].[Salary_for_person] @Person_id, @Month
--�� ��������� ������� exec ����������� ����� ��������� ��� � ��������� ��������� �����������
	FETCH NEXT FROM person_cursor INTO @Person_id 
END 

CLOSE person_cursor  
DEALLOCATE person_cursor 
GO
--�������� EXEC [ProjectsImplementation].[Salary] *���������� ����� �����* ����������� ����� ���������
EXEC [ProjectsImplementation].[Salary] '4'