CREATE LOGIN client
WITH PASSWORD='client_password';
GO

CREATE LOGIN investor
WITH PASSWORD='investor_password';
GO

CREATE LOGIN worker
WITH PASSWORD='worker_password';
GO

CREATE USER client
FOR LOGIN client;
GO

CREATE USER investor
FOR LOGIN investor;
GO

CREATE USER worker
FOR LOGIN worker;
GO

GRANT SELECT
ON [ProjectsImplementation].[Monthly_Bill] TO client;
GO

GRANT SELECT
ON [ProjectsImplementation].[Contract] TO investor;
GO

GRANT SELECT
ON [ProjectsImplementation].[Position] TO worker;
GRANT SELECT
ON [ProjectsImplementation].[Qualification] TO worker;
GRANT SELECT
ON [ProjectsImplementation].[Person] TO worker;
GO

EXECUTE AS LOGIN = 'client';

SELECT *
FROM [ProjectsImplementation].[Monthly_Bill];

SELECT *
FROM [ProjectsImplementation].[Project];

REVERT;
GO

EXECUTE AS LOGIN = 'investor';

SELECT *
FROM [ProjectsImplementation].[Contract];

SELECT *
FROM [ProjectsImplementation].[Monthly_Bill];

REVERT;
GO

EXECUTE AS LOGIN = 'worker';

SELECT *
FROM [ProjectsImplementation].[Position];
SELECT *
FROM [ProjectsImplementation].[Qualification];
SELECT *
FROM [ProjectsImplementation].[Person];

SELECT *
FROM [ProjectsImplementation].[Project];

REVERT;
GO

CREATE ROLE investor_role;
CREATE ROLE client_role;
GO

GRANT SELECT
ON OBJECT::[ProjectsImplementation].[Project]
TO investor_role;
GRANT SELECT
ON OBJECT::[ProjectsImplementation].[Monthly_Bill]
TO investor_role;
GO

GRANT SELECT, UPDATE
ON OBJECT::[ProjectsImplementation].[Contract]
TO client_role;
GRANT SELECT
ON OBJECT::[ProjectsImplementation].[Client]
TO client_role;
GO

ALTER ROLE client_role
ADD MEMBER client;
ALTER ROLE investor_role
ADD MEMBER investor;
GO

EXECUTE AS LOGIN = 'client';

SELECT *
FROM [ProjectsImplementation].[Contract];
SELECT *
FROM [ProjectsImplementation].[Client];
SELECT *
FROM [ProjectsImplementation].[Monthly_Bill];

SELECT *
FROM [ProjectsImplementation].[Person];

REVERT;
GO

EXECUTE AS LOGIN = 'investor';

SELECT *
FROM [ProjectsImplementation].[Contract];
SELECT *
FROM [ProjectsImplementation].[Project];
SELECT *
FROM [ProjectsImplementation].[Monthly_Bill];

SELECT *
FROM [ProjectsImplementation].[Person];

REVERT;
GO

DENY SELECT
ON [ProjectsImplementation].[Monthly_Bill]
TO investor;
GO

EXECUTE AS LOGIN = 'investor';

SELECT *
FROM [ProjectsImplementation].[Contract];
SELECT *
FROM [ProjectsImplementation].[Project];

SELECT *
FROM [ProjectsImplementation].[Monthly_Bill];

REVERT;
GO

EXEC sp_droprolemember 'investor_role', 'investor';
GO

EXECUTE AS LOGIN = 'investor';

SELECT *
FROM [ProjectsImplementation].[Contract];

SELECT *
FROM [ProjectsImplementation].[Project];

REVERT;
GO

DROP USER investor;

DROP ROLE investor_role;