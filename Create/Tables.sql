﻿USE [Project]

GO

CREATE TABLE [Project].dbo.[Game Session] (
    [SessionID] INT PRIMARY KEY IDENTITY(1, 1),
	[SaveName] VARCHAR(128),
	[CreatorID] INT,
	[MapID] INT,
    [CurrentDate] DATE,
);

CREATE TABLE [Project].dbo.[User] (
    [UserID] INT PRIMARY KEY IDENTITY(1, 1),
    [WinCount] INT DEFAULT 0,
    [LossCount] INT DEFAULT 0,
    [Login] VARCHAR(255),
    [Password] VARCHAR(255),
    [Email] VARCHAR(255)
);

CREATE TABLE [Project].dbo.[Player] (
    [PlayerID] INT PRIMARY KEY IDENTITY(1, 1),
    [UserID] INT,
    [SessionID] INT,
	[CivilizationID] INT NULL
);

-- Civilization
CREATE TABLE [Project].dbo.[Civilization] (
    [CivilizationID] INT PRIMARY KEY IDENTITY(1, 1),
	[CapitalCityID] INT,
    [Name] VARCHAR(255),
	[RGBA] INT,
	[Money] BIGINT
);

CREATE TABLE [Project].dbo.[DiplomaticStates] (
	[DiplomaticStateID] INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(255)
)

CREATE TABLE [Project].dbo.[Diplomacy] (
	[Civilization1ID] INT,
	[Civilization2ID] INT,
	[DiplomaticStateID] INT
)

CREATE TABLE [Project].dbo.[Province] (
	[ProvinceID] INT PRIMARY KEY IDENTITY(1, 1),
	[MapID] INT,
	[DefaultRegionID] INT DEFAULT NULL,
	[DefaultCityID] INT DEFAULT NULL,
	[TerrainID] INT,
	[CoordinateX] INT,
	[CoordinateY] INT
)

CREATE TABLE [Project].dbo.[Region] (
	[RegionID] INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(255),
	[MainCityID] INT,
	[CivilizationID] INT,
	[RGBA] INT
)

CREATE TABLE [Project].dbo.[MutableProvinces] (
	[ID] INT PRIMARY KEY IDENTITY(1, 1),
	[ProvinceID] INT,
	[RegionID] INT,
	[GameSessionID] INT,
	[CityID] INT DEFAULT NULL,
)

CREATE TABLE [Project].dbo.[Map] (
	[MapID] INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(255),
	[Width] INT,
	[Height] INT,
	[StartingDate] DATE
)

CREATE TABLE [Project].dbo.[Terrain] (
	[TerrainID] INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(255)
)

CREATE TABLE [Project].dbo.[River] (
	[RiverID] INT PRIMARY KEY,
	[ProvinceID] INT,
	[FromID] INT,
	[ToID] INT
)

-- City
CREATE TABLE [Project].dbo.[City] (
    [CityID] INT PRIMARY KEY IDENTITY(1, 1),
    [Name] VARCHAR(255),
    [Population] INT,
    [Water] BIT,
    [FarmAmount] INT,
    [MaxPopulation] INT,
    [IsCapital] BIT
);

-- Road
CREATE TABLE [Project].dbo.[Road] (
    [RoadID] INT PRIMARY KEY,
    [City1ID] INT,
    [City2ID] INT,
    [Length] INT
);

-- Barrack
CREATE TABLE [Project].dbo.[Barrack] (
    [BarrackID] INT PRIMARY KEY,
    [CityID] INT,
    [Protection] INT
);

-- Military_Unit_type
CREATE TABLE [Project].dbo.[Military_Unit_type] (
    [MilitaryUnitTypeID] INT PRIMARY KEY,
	[TypeName] VARCHAR(255),
    [Health] INT,
    [Damage] INT,
    [ProductionCost] INT,
    [PurchasePrice] INT,
    [AttackType] VARCHAR(255)
);

-- Military_Unit
CREATE TABLE [Project].dbo.[Military_Unit] (
    [MilitaryUnitID] INT PRIMARY KEY,
	[MilitaryUnitTypeID] INT,
    [CivilizationID] INT,
    [BarrackID] INT,
	[Level] INT,
    [Wait] INT
);

-- Building
CREATE TABLE [Project].dbo.[Building] (
    [BuildingID] INT PRIMARY KEY,
    [CityID] INT,
    [TypeName] VARCHAR(255),
    [Level] INT
);

CREATE TABLE [Project].dbo.[Resource] (
  [ResourceID] INT PRIMARY KEY,
  [Name] VARCHAR(255),
  [Type] VARCHAR(255),
  [Price] MONEY
)

CREATE TABLE [Project].dbo.[Storage] (
  [StorageID] INT PRIMARY KEY IDENTITY(1, 1),
  [CityID] INT,
  [ResourceID] INT,
  [Amount] INT,
)

-- Market
CREATE TABLE [Project].dbo.[Market] (
    [MarketID] INT PRIMARY KEY,
    [CityID] INT,
    [Gold] DECIMAL
);

-- Trader
CREATE TABLE [Project].dbo.[Trader] (
    [TraderID] INT PRIMARY KEY,
    [Market1ID] INT,
    [Market2ID] INT,
    [ResourceID] INT,
    [GoldBag] DECIMAL,
    [Amount] INT
);

-- Cultural_Unit
CREATE TABLE [Project].dbo.[Cultural_Unit] (
    [CulturalUnitID] INT PRIMARY KEY,
    [CivilizationID] INT,
    [Name] VARCHAR(255),
    [Type] VARCHAR(255)
);

-- Theatre_Square
CREATE TABLE [Project].dbo.[Theatre_Square] (
    [TheatreID] INT PRIMARY KEY,
    [CityID] INT,
    [CulturalPoint] INT,
    [Volume] INT
);

-- Masterpiece_Storage
CREATE TABLE [Project].dbo.[Masterpiece_Storage] (
    [Masterpiece_StorageID] INT PRIMARY KEY,
  [MasterpieceID] INT,
  [TheatreID] INT
);

-- Masterpiece
CREATE TABLE [Project].dbo.[Masterpiece] (
    [MasterpieceID] INT PRIMARY KEY,
  [CulturalUnitID] INT,
    [Name] VARCHAR(255),
  [Type] VARCHAR(255)
);

GO

USE [master]