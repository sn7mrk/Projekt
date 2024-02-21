USE [Project]

GO

CREATE OR ALTER TRIGGER dbo.[CreateMutableProvinces] ON [Project].dbo.[Game Session]
AFTER INSERT
AS
	INSERT INTO [Project].dbo.[Player]([UserID], [SessionID], [CivilizationID])
	SELECT [CreatorID], [SessionID], NULL
	FROM INSERTED

	INSERT INTO [Project].dbo.[MutableProvinces]([ProvinceID], [RegionID], [GameSessionID], [CityID])
	SELECT 
		[Province].[ProvinceID],
		[Province].[DefaultRegionID],
		inserted.[SessionID],
		[Province].[DefaultCityID]
	FROM inserted
	LEFT JOIN [Project].dbo.[Province] ON inserted.[MapID] = [Province].[MapID]
GO

CREATE OR ALTER TRIGGER dbo.[RecreateRegionAndCivilization] ON [Project].dbo.[MutableProvinces]
AFTER INSERT
AS
	DECLARE @City TABLE (
		[CityID] INT,
		[CityName] VARCHAR(255)
	)

	DECLARE @MyTable TABLE (
		[RegionID] INT,
		[RegionName] VARCHAR(255),
		[CivilizationID] INT
	)

	DECLARE @SecondTable TABLE (
		[CivilizationID] INT,
		[CivilizationName] VARCHAR(255)
	)

	-- Creating New Cities
	INSERT INTO [Project].dbo.[City]([Name], [Population], [Water], [FarmAmount], [MaxPopulation], [IsCapital])
	OUTPUT inserted.[CityID], inserted.[Name] INTO @City
	SELECT [Name], [Population], [Water], [FarmAmount], [MaxPopulation], [IsCapital]
	FROM [Project].dbo.[City]
	WHERE EXISTS (
		SELECT *
		FROM inserted
		WHERE inserted.[CityID] = [City].[CityID]
	)

	-- Updating New Provinces with new cities
	UPDATE [Project].dbo.[MutableProvinces]
	SET [CityID] = [NewCity].[CityID]
	FROM inserted
	LEFT JOIN [Project].dbo.[MutableProvinces] ON inserted.[ID] = [MutableProvinces].[ID]
	LEFT JOIN [Project].dbo.[City] ON [MutableProvinces].[CityID] = [City].[CityID]
	LEFT JOIN @City AS [NewCity] ON [NewCity].[CityName] = [City].[Name]

	-- Creating new Civilizations
	INSERT INTO [Project].dbo.[Civilization]([CapitalCityID], [Name], [RGBA])
	OUTPUT inserted.[CivilizationID], inserted.[Name] INTO @SecondTable
	SELECT [NewCity].[CityID], [Civilization].[Name], [RGBA]
	FROM [Project].dbo.[Civilization]
	LEFT JOIN [Project].dbo.[City] ON [Civilization].[CapitalCityID] = [City].[CityID]
	LEFT JOIN @City AS [NewCity] ON [NewCity].[CityName] = [City].[Name]
	WHERE EXISTS (
		SELECT *
		FROM inserted
		LEFT JOIN [Project].dbo.[Region] ON inserted.[RegionID] = [Region].[RegionID]
		WHERE [Region].[CivilizationID] = [Civilization].[CivilizationID]
	)

	-- Creating New Regions
	INSERT INTO [Project].dbo.[Region]([Name], [MainCityID], [CivilizationID], [RGBA])
	OUTPUT inserted.[RegionID], inserted.[Name], inserted.[CivilizationID] INTO @MyTable
	SELECT [Region].[Name], [NewCity].[CityID], [NewCivilizations].[CivilizationID], [Region].[RGBA]
	FROM [Project].dbo.[Region]
	LEFT JOIN [Project].dbo.[City] ON [Region].[MainCityID] = [City].[CityID]
	LEFT JOIN @City AS [NewCity] ON [NewCity].[CityName] = [City].[Name]
	LEFT JOIN [Project].dbo.[Civilization] ON [Civilization].[CivilizationID] = [Region].[CivilizationID]
	LEFT JOIN @SecondTable AS [NewCivilizations] ON [Civilization].[Name] = [NewCivilizations].[CivilizationName]
	WHERE EXISTS (
		SELECT *
		FROM inserted
		WHERE inserted.[RegionID] = [Region].[RegionID]
	)

	-- Updating New Regions
	UPDATE [Project].dbo.[MutableProvinces]
	SET [RegionID] = [Created].[RegionID]
	FROM inserted
	LEFT JOIN [Project].dbo.[MutableProvinces] ON inserted.[ID] = [MutableProvinces].[ID]
	LEFT JOIN [Project].dbo.[Region] ON [Region].[RegionID] = [MutableProvinces].[RegionID]
	LEFT JOIN @MyTable AS [Created] ON [Created].[RegionName] = [Region].[Name]
GO

USE [master]