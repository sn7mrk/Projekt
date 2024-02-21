USE master;
GO
ALTER DATABASE [Project] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE [Project];

GO

CREATE DATABASE [Project]

GO

USE [Project]

SET NOCOUNT ON

:setvar ScriptPath "C:\Users\sn11m\Downloads\Projekt-Bazy-Danych-main\Projekt-Bazy-Danych-main\Projekt\"

:r $(ScriptPath)"Create\Tables.sql"
:r $(ScriptPath)"Create\ForeignKeys.sql"
:r $(ScriptPath)"Create\Functions.sql"
:r $(ScriptPath)"Create\Constraints.sql"
:r $(ScriptPath)"Create\Views.sql"
:r $(ScriptPath)"Create\Procedures.sql"
:r $(ScriptPath)"Create\Triggers.sql"
:r $(ScriptPath)"Insert\Users.sql"
:r $(ScriptPath)"Insert\Terrain.sql"
:r $(ScriptPath)"Insert\Map.sql"
:r $(ScriptPath)"Insert\MilitaryUnitTypes.sql"
:r $(ScriptPath)"Insert\CulturalUnit.sql"
:r $(ScriptPath)"Insert\Masterpiece.sql"
:r $(ScriptPath)"Insert\Resources.sql"