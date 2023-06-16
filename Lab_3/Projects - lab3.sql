/* Delete procedure*/
DROP PROCEDURE IF EXISTS [ProjectsImplementation].[Salary_for_person];
GO

/* Procedure */
CREATE PROCEDURE [ProjectsImplementation].[Salary_for_person] @Person_id int, @Month int
AS
--Ïðèéìàþòüñÿ àðãóìåíòè 
--@Person_id òèïó int– id ïðàö³âíèêà, äëÿ ÿêîãî ïîòð³áíî ðîçðàõóâàòè çàðïëàòó; 
--@Month òèïó int– íîìåð ì³ñÿö³, çà ÿêèé ïîòð³áíî ðîçðàõóâàòè çàðïëàòó ïðàö³âíèêó â ïåðøîìó àðãóìåíò³
DECLARE 
	@salary_coefficient AS decimal(10,5),
	@salary_for_hours_of_work AS decimal(10,5)
--Â ò³ë³ ñòâîðþþòüñÿ çì³íí³: @salary_coefficient( êîåô³ö³ºíòè çàðïëàòè ïðàö³âíèêà çà ïîñàäîþ); 
--@salary_for_hours_of_work(îá÷èñëþºòüñÿ ÿê ñóìà ê³ëüêîñò³ ãîäèí âèêîíàííÿ ïðîåêòó â óìîâàõ ïåâíî¿ ðîë³, çà ïåâíèé ì³ñÿöü)
SELECT @salary_coefficient = POS.salary_coefficient
FROM [ProjectsImplementation].[Person] PER
LEFT JOIN [ProjectsImplementation].[Position] POS ON POS.id=PER.position_id
WHERE PER.id=@Person_id

SELECT @salary_for_hours_of_work = SUM(Q.hourly_salary*CONVERT(decimal(5,2),CONVERT(DATETIME,R.hours_worked))*24)
FROM [ProjectsImplementation].[Person] P
LEFT JOIN [ProjectsImplementation].[Performer] PER ON PER.person_id=P.id
LEFT JOIN [ProjectsImplementation].[Qualification] Q ON Q.id=PER.qualification_id
LEFT JOIN [ProjectsImplementation].[Report] R ON R.performer_id=PER.id
--çàïèòàìè îá÷èñëþþòüñÿ çì³íí³ @salary_coefficient, @salary_for_hours_of_work
WHERE Month(R.reported_day) = @Month

GROUP BY P.id
HAVING P.id=@Person_id
--ðåçóëüòàòîì ïîâåðòàºòüñÿ òàáëèöÿ ç ³ì’ÿì ïðàö³âíèêà òà äîáóòêîì êîåô³ö³ºíòó çà ïîñàäó íà çàðïëàòó íà ð³çíèõ ïðîåêòàõ	
SELECT P.person_name AS 'Person Name', @salary_coefficient * @salary_for_hours_of_work AS 'Salary'
FROM [ProjectsImplementation].[Person] P
WHERE P.id=@Person_id
GO

DROP PROCEDURE IF EXISTS [ProjectsImplementation].[Salary];
GO

CREATE PROCEDURE [ProjectsImplementation].[Salary] @Month int
AS
--àðãóìåíò - íîìåð ì³ñÿöÿ, çà ÿêèé ïîòð³áíî ðîçðàõóâàòè çàðïëàòó ïðàö³âíèêàì, @Month òèïó int
DECLARE @Person_id AS int

DECLARE person_cursor CURSOR FOR
SELECT P.id
FROM [ProjectsImplementation].[Person] P
--äëÿ ïðîõîäæåííÿ ïî ñïèñêó ïðàö³âíèê³â âèêîðèñòîâóºòüñÿ êóðñîð person_cursor, 
--ÿêèé ïðèéìàº çíà÷åííÿ id êîæíîãî ïðàö³âíèêà ç òàáëèö³ [Person]
OPEN person_cursor
FETCH NEXT FROM person_cursor INTO @Person_id 

WHILE @@FETCH_STATUS = 0  
BEGIN  
	
	EXEC [ProjectsImplementation].[Salary_for_person] @Person_id, @Month
--çà äîïîìîãîþ êîìàíäè exec âèêëèêàºòüñÿ ïåðøà ïðîöåäóðà óæå ç ïðàâèëüíî âêàçàíèìè àðãóìåíòàìè
	FETCH NEXT FROM person_cursor INTO @Person_id 
END 

CLOSE person_cursor  
DEALLOCATE person_cursor 
GO
--êîìàíäîþ EXEC [ProjectsImplementation].[Salary] *ïîðÿäêîâèé íîìåð ì³ñÿöÿ* âèêëèêàºòüñÿ äðóãà ïðîöåäóðà
EXEC [ProjectsImplementation].[Salary] '4'
