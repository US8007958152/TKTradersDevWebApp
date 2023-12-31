USE [master]
GO
/****** Object:  Database [TKTradersDB]    Script Date: 21/02/2023 9:20:47 am ******/
CREATE DATABASE [TKTradersDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TKTradersDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\TKTradersDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TKTradersDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\TKTradersDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [TKTradersDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TKTradersDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TKTradersDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TKTradersDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TKTradersDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TKTradersDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TKTradersDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TKTradersDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TKTradersDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TKTradersDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TKTradersDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TKTradersDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TKTradersDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TKTradersDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TKTradersDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TKTradersDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TKTradersDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TKTradersDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TKTradersDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TKTradersDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TKTradersDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TKTradersDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TKTradersDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TKTradersDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TKTradersDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TKTradersDB] SET  MULTI_USER 
GO
ALTER DATABASE [TKTradersDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TKTradersDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TKTradersDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TKTradersDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TKTradersDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TKTradersDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [TKTradersDB] SET QUERY_STORE = OFF
GO
USE [TKTradersDB]
GO
/****** Object:  Schema [sInventory]    Script Date: 21/02/2023 9:20:47 am ******/
CREATE SCHEMA [sInventory]
GO
/****** Object:  Schema [sSecurity]    Script Date: 21/02/2023 9:20:47 am ******/
CREATE SCHEMA [sSecurity]
GO
/****** Object:  Schema [sTransport]    Script Date: 21/02/2023 9:20:47 am ******/
CREATE SCHEMA [sTransport]
GO
/****** Object:  Table [sInventory].[tOrder]    Script Date: 21/02/2023 9:20:47 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tOrder](
	[OrderId] [int] IDENTITY(1000001,1) NOT NULL,
	[TransportTypeId] [int] NOT NULL,
	[SupplierId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[StatusTypeId] [int] NOT NULL,
	[TruckId] [int] NOT NULL,
	[DriverId] [int] NOT NULL,
	[IsInternalTruck] [bit] NOT NULL,
	[IsInternalDriver] [bit] NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[Comments] [nvarchar](4000) NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[SenderSiteId] [int] NOT NULL,
	[ReceiverSiteId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tOrderProductDetails]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tOrderProductDetails](
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductTypeId] [int] NOT NULL,
	[Quantity] [decimal](18, 0) NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[BuyAmount] [decimal](18, 2) NOT NULL,
	[SellAmount] [decimal](18, 2) NOT NULL,
	[SellPaidAmount] [decimal](18, 2) NOT NULL,
	[StockTypeId] [int] NULL,
	[RemainingQuantity] [decimal](18, 2) NOT NULL,
	[ReferredOrders] [varchar](max) NULL,
	[InvestmenOrderIDs] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tOrderTruckDetails]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tOrderTruckDetails](
	[OrderId] [int] NOT NULL,
	[TruckOwnerId] [int] NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[TruckRent] [decimal](18, 2) NOT NULL,
	[PaidRent] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tProduct]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tProduct](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tProductType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tProductType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdateBy] [nvarchar](50) NULL,
	[ImagePath] [nvarchar](100) NULL,
	[ColorCode] [nvarchar](50) NULL,
	[ViewId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStaticStatusType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tStaticStatusType](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStaticStockType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tStaticStockType](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](20) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStaticTransportType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tStaticTransportType](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStaticView]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tStaticView](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStock]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tStock](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductTypeId] [int] NOT NULL,
	[TransportTypeId] [int] NOT NULL,
	[Quantity] [decimal](18, 0) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[StockTypeId] [int] NULL,
	[Title] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStockInvestment]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tStockInvestment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockId] [int] NOT NULL,
	[ProductTypeId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[ReferredOrders] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tView]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sInventory].[tView](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tCity]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tCity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[IsObsolete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[TCity_temp]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[TCity_temp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[IsObsolete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tDistrict]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tDistrict](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
	[IsObsolete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[TDistrict_temp]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[TDistrict_temp](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
	[IsObsolete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tLogError]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tLogError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[StackTrace] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tNotification]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tNotification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[StatusTypeId] [int] NOT NULL,
	[MobileNumber] [nvarchar](10) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tState]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tState](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[CountryId] [int] NULL,
	[IsObsolete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[TState_temp]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[TState_temp](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[CountryId] [int] NULL,
	[IsObsolete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tStaticFuelType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tStaticFuelType](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tStaticPaymentType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tStaticPaymentType](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tStaticUserType]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tStaticUserType](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tTruck]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tTruck](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Truck_Number] [nvarchar](20) NOT NULL,
	[IsInternalTruck] [bit] NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Unique_Truck_Number] UNIQUE NONCLUSTERED 
(
	[Truck_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tTruckFuel]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tTruckFuel](
	[Id] [int] IDENTITY(10001,1) NOT NULL,
	[FuelTypeId] [int] NOT NULL,
	[PetrolPumpUserId] [int] NOT NULL,
	[TruckId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[CurrentReading] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Comments] [nvarchar](4000) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUser]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tUser](
	[Id] [int] IDENTITY(101,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[MobileNumber] [nvarchar](12) NOT NULL,
	[EmailId] [nvarchar](100) NULL,
	[UserTypeId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[IsObsolete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MobileNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUserCredentials]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tUserCredentials](
	[UserId] [int] NOT NULL,
	[OldPassword] [nvarchar](12) NULL,
	[NewPassword] [nvarchar](12) NOT NULL,
	[LoginAttempts] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUserMaster]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tUserMaster](
	[UserId] [int] IDENTITY(100001,1) NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[MobileNumber] [nvarchar](10) NOT NULL,
	[EmailId] [nvarchar](50) NULL,
	[Address] [nvarchar](4000) NULL,
	[Company] [nvarchar](500) NULL,
	[CityId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[StateId] [int] NOT NULL,
	[Password] [nvarchar](12) NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdateDateTime] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[IsInternalDriver] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MobileNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUserSite]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tUserSite](
	[SiteId] [int] IDENTITY(10001,1) NOT NULL,
	[UserId] [int] NULL,
	[SiteAddress] [nvarchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUserTransaction]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sSecurity].[tUserTransaction](
	[TransactionId] [int] IDENTITY(1015220001,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[TransactionTypeId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[Comments] [nvarchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sTransport].[tTransport]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sTransport].[tTransport](
	[TransportId] [int] IDENTITY(1000001,1) NOT NULL,
	[SupplierId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[TransportDate] [datetime] NOT NULL,
	[StatusTypeId] [int] NOT NULL,
	[TransportTypeId] [int] NOT NULL,
	[TruckId] [int] NOT NULL,
	[DriverId] [int] NOT NULL,
	[IsInternalTruck] [bit] NOT NULL,
	[IsInternalDriver] [bit] NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[Comments] [nvarchar](4000) NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TransportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sTransport].[tTransportProductDetails]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sTransport].[tTransportProductDetails](
	[TransportId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductTypeId] [int] NOT NULL,
	[Quantity] [decimal](18, 0) NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[PaidAmount] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sTransport].[tTransportTruckDetails]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sTransport].[tTransportTruckDetails](
	[TransportId] [int] NOT NULL,
	[TruckOwnerId] [int] NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[PaidAmount] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [sInventory].[tStock] ADD  DEFAULT ((1)) FOR [StockTypeId]
GO
ALTER TABLE [sSecurity].[tUserCredentials] ADD  DEFAULT ((5)) FOR [LoginAttempts]
GO
ALTER TABLE [sInventory].[tOrderProductDetails]  WITH CHECK ADD  CONSTRAINT [FK_ProductDetails_Order] FOREIGN KEY([OrderId])
REFERENCES [sInventory].[tOrder] ([OrderId])
GO
ALTER TABLE [sInventory].[tOrderProductDetails] CHECK CONSTRAINT [FK_ProductDetails_Order]
GO
ALTER TABLE [sInventory].[tOrderTruckDetails]  WITH CHECK ADD  CONSTRAINT [FK_TruckDetails_Order] FOREIGN KEY([OrderId])
REFERENCES [sInventory].[tOrder] ([OrderId])
GO
ALTER TABLE [sInventory].[tOrderTruckDetails] CHECK CONSTRAINT [FK_TruckDetails_Order]
GO
ALTER TABLE [sInventory].[tProductType]  WITH CHECK ADD  CONSTRAINT [FK_Product] FOREIGN KEY([ProductId])
REFERENCES [sInventory].[tProduct] ([Id])
GO
ALTER TABLE [sInventory].[tProductType] CHECK CONSTRAINT [FK_Product]
GO
ALTER TABLE [sInventory].[tProductType]  WITH CHECK ADD  CONSTRAINT [FK_tProductType_tProductType] FOREIGN KEY([Id])
REFERENCES [sInventory].[tProductType] ([Id])
GO
ALTER TABLE [sInventory].[tProductType] CHECK CONSTRAINT [FK_tProductType_tProductType]
GO
ALTER TABLE [sInventory].[tStock]  WITH CHECK ADD FOREIGN KEY([OrderId])
REFERENCES [sInventory].[tOrder] ([OrderId])
GO
ALTER TABLE [sInventory].[tStockInvestment]  WITH CHECK ADD FOREIGN KEY([StockId])
REFERENCES [sInventory].[tStock] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [sSecurity].[tTruckFuel]  WITH CHECK ADD FOREIGN KEY([PetrolPumpUserId])
REFERENCES [sSecurity].[tUserMaster] ([UserId])
GO
ALTER TABLE [sSecurity].[tTruckFuel]  WITH CHECK ADD FOREIGN KEY([TruckId])
REFERENCES [sSecurity].[tTruck] ([Id])
GO
ALTER TABLE [sSecurity].[tUserCredentials]  WITH CHECK ADD  CONSTRAINT [FK_UserCredential_User] FOREIGN KEY([UserId])
REFERENCES [sSecurity].[tUser] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [sSecurity].[tUserCredentials] CHECK CONSTRAINT [FK_UserCredential_User]
GO
ALTER TABLE [sSecurity].[tUserSite]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [sSecurity].[tUserMaster] ([UserId])
GO
ALTER TABLE [sTransport].[tTransportProductDetails]  WITH CHECK ADD  CONSTRAINT [FK_ProductDetails_Transport] FOREIGN KEY([TransportId])
REFERENCES [sTransport].[tTransport] ([TransportId])
GO
ALTER TABLE [sTransport].[tTransportProductDetails] CHECK CONSTRAINT [FK_ProductDetails_Transport]
GO
ALTER TABLE [sTransport].[tTransportTruckDetails]  WITH CHECK ADD  CONSTRAINT [FK_TruckDetails_Transport] FOREIGN KEY([TransportId])
REFERENCES [sTransport].[tTransport] ([TransportId])
GO
ALTER TABLE [sTransport].[tTransportTruckDetails] CHECK CONSTRAINT [FK_TruckDetails_Transport]
GO
/****** Object:  StoredProcedure [sInventory].[usp_GetAvailableStock]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sInventory].[usp_GetAvailableStock] 
@rProductId int=0,
@rProductTypeId int=0,
@rTransportTypeId int=0
AS
BEGIN	
	select product.Id as ProductId,productType.Id as ProductTypeId,
	productType.Title+' '+product.Title as ProductName,productType.ImagePath,
	SUM(case when stock.TransportTypeId=1 OR stock.TransportTypeId=3  then stock.Quantity when stock.TransportTypeId=2 or stock.TransportTypeId=4 then stock.Quantity*(-1) else 0 end )+ISNULL(productDetails.Quantity,0) as Stock,
	COUNT(case when stock.TransportTypeId=1 OR stock.TransportTypeId=3 or stock.TransportTypeId=2 or stock.TransportTypeId=4 then 1 end ) as ItemCount
	  from sInventory.tProduct product 
	inner join	sInventory.tProductType productType on product.Id=productType.ProductId
	left join	sInventory.tStock stock on stock.IsObsolete=0 and stock.TransportTypeId in(1,2,3,4) and product.Id=stock.ProductId and productType.Id=stock.ProductTypeId
	left join sInventory.tOrderProductDetails productDetails on productDetails.OrderId=@rTransportTypeId and productDetails.ProductId=stock.ProductId and productDetails.ProductTypeId=stock.ProductTypeId
	where (product.Id=@rProductId or ISNULL(@rProductId,0)=0) and (productType.Id=@rProductTypeId or ISNULL(@rProductTypeId,0)=0)
	group by product.Id,productType.Id,productType.Title,product.Title,productType.ImagePath,productDetails.Quantity
	order by product.Id,productType.Id

END
GO
/****** Object:  StoredProcedure [sInventory].[usp_GetAvailableStockbkp]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sInventory].[usp_GetAvailableStockbkp] 
@rProductId int=0,
@rProductTypeId int=0,
@rTransportTypeId int=0
AS
BEGIN	

		select 
		product.Id as ProductId,
		productType.Id as ProductTypeId,
		productType.Title+' '+product.Title as ProductName,
		productType.ImagePath,
		SUM(
		case 
			when stock.TransportTypeId=1 OR stock.TransportTypeId=3  
			then stock.Quantity
			when stock.TransportTypeId=2 or stock.TransportTypeId=4 
			then stock.Quantity*(-1) else 0 end )+ISNULL(productDetails.Quantity,0) 
		as Stock 
	  from sInventory.tProduct product 
	inner join	sInventory.tProductType productType on product.Id=productType.ProductId
	left join	sInventory.tStock stock on (stock.IsObsolete=0 OR (@rTransportTypeId>0 AND @rTransportTypeId!=2)) and stock.TransportTypeId!=5 and product.Id=stock.ProductId and productType.Id=stock.ProductTypeId
	left join sInventory.tOrderProductDetails productDetails on productDetails.OrderId=@rTransportTypeId and productDetails.ProductId=stock.ProductId and productDetails.ProductTypeId=stock.ProductTypeId
	
	where (product.Id=@rProductId or ISNULL(@rProductId,0)=0) and (productType.Id=@rProductTypeId or ISNULL(@rProductTypeId,0)=0)
	group by product.Id,productType.Id,productType.Title,product.Title,productType.ImagePath,productDetails.Quantity
	order by product.Id,productType.Id


	
END
GO
/****** Object:  StoredProcedure [sInventory].[usp_GetOrders]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sInventory].[usp_GetOrders]
	@rUserId int=0
AS
BEGIN
	select M1.OrderId as OrderId, M5.Title as TransportType,case when M1.SupplierId is null or M1.SupplierId<=0 then '-' else (select top 1 Name from sSecurity.tUserMaster where UserId=M1.SupplierId) end as SupplierName
	,case when M1.CustomerId is null or M1.CustomerId<=0 then '-' else (select top 1 Name from sSecurity.tUserMaster where UserId=M1.CustomerId) end as CustomerName, M8.Title+' '+M7.Title as 'ProductName',M2.Quantity,case when M1.TransportTypeId=1 then M2.BuyAmount when M1.TransportTypeId=1 OR M1.TransportTypeId=6 then M2.BuyAmount when M1.TransportTypeId=4 then M3.TruckRent else  M2.SellAmount end As Amount,OrderDate 
	
	from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M1.OrderId=M3.OrderId
inner join sInventory.tProduct M7 on M7.Id=M2.ProductId
inner join sInventory.tProductType M8 on M8.ProductId=M7.Id and M8.Id=M2.ProductTypeId
inner join sInventory.tStaticTransportType M5 on M5.Id=M1.TransportTypeId
where M1.IsObsolete=0 AND M1.TransportTypeId not in(3,4) AND (ISNULL(@rUserId,0)=0 OR M1.CustomerId=@rUserId OR M1.SupplierId=@rUserId OR M3.TruckOwnerId=@rUserId)
order by M1.UpdatedDateTime,M1.CreateDateTime desc
END
GO
/****** Object:  StoredProcedure [sSecurity].[tUserDelete]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[tUserDelete] 
	-- Add the parameters for the stored procedure here
	@rUserId int,
	@rUserTypeId int
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY		
		  IF @rUserTypeId=1 
			   BEGIN
			     IF NOT EXISTS(SELECT 1 FROM sSecurity.tUser WHERE Id=@rUserId)
				 BEGIN
				    SELECT -102 AS STATUSCODE
					RETURN
				 END
				  

				 IF EXISTS(SELECT 1 FROM sSecurity.tUserCredentials WHERE UserId=@rUserId)
				 BEGIN
				   DELETE FROM sSecurity.tUserCredentials WHERE UserId=@rUserId
				 END
				 
				 DELETE FROM sSecurity.tUser WHERE Id=@rUserId
			   END
          ELSE
			   BEGIN
			    IF NOT EXISTS(SELECT 1 FROM sSecurity.tUserMaster WHERE UserId=@rUserId)
				 BEGIN
				    SELECT -102 AS STATUSCODE
					RETURN
				 END
				 
				 DELETE FROM sSecurity.tUserMaster WHERE UserId=@rUserId
			   END
		
		IF EXISTS(SELECT 1 FROM sSecurity.tUserTransaction WHERE UserId=@rUserId)
				   DELETE FROM sSecurity.tUserTransaction WHERE UserId=@rUserId

		IF EXISTS(SELECT 1 FROM sSecurity.tTruck WHERE UserId=@rUserId)
				   DELETE FROM sSecurity.tTruck WHERE UserId=@rUserId


		IF EXISTS(SELECT 1 FROM sTransport.tTransport WHERE SupplierId=@rUserId OR CustomerId=@rUserId)
			BEGIN
				    DELETE FROM sInventory.tStock WHERE OrderId IN(SELECT TransportId FROM sTransport.tTransport WHERE SupplierId=@rUserId OR CustomerId=@rUserId) 
				    DELETE FROM sTransport.tTransportTruckDetails WHERE TransportId IN(SELECT TransportId FROM sTransport.tTransport WHERE SupplierId=@rUserId OR CustomerId=@rUserId)
				    DELETE FROM sTransport.tTransportProductDetails WHERE TransportId IN(SELECT TransportId FROM sTransport.tTransport WHERE SupplierId=@rUserId OR CustomerId=@rUserId)
				    DELETE FROM sTransport.tTransport WHERE SupplierId=@rUserId OR CustomerId=@rUserId				  
			END
		COMMIT TRANSACTION
		SELECT 1 AS STATUSCODE
		 
	END TRY
	BEGIN CATCH
	  BEGIN
	     ROLLBACK TRANSACTION
		 SELECT -101 AS STATUSCODE
	  END
   END CATCH

END
GO
/****** Object:  StoredProcedure [sSecurity].[usp_CleanupData]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[usp_CleanupData]
AS
BEGIN
truncate table sSecurity.tUserTransaction
--truncate table sSecurity.tUserSite
--delete from sSecurity.tUserMaster
--truncate table sSecurity.tTruck
truncate table sSecurity.tTruckFuel
truncate table sSecurity.tLogError
truncate table sSecurity.tNotification
truncate table sInventory.tStockInvestment
delete from sInventory.tStock
truncate table sInventory.tOrderProductDetails
truncate table sInventory.tOrderTruckDetails
delete from sInventory.tOrder



END
GO
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[usp_GetDashBoard] 
	
AS
BEGIN
declare @overallLoss decimal(18,2)=0;

--Start Export Profit
declare @exportProfit decimal(18,2)=0;
SELECT 
 @exportProfit = SUM(t2.SellAmount-t2.BuyAmount) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 2 and t2.SellAmount >= t2.BuyAmount

SELECT 
 @overallLoss = @overallLoss + SUM(t2.BuyAmount-t2.SellAmount) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 2 and t2.SellAmount < t2.BuyAmount
--End Export Profit

--Start Transport Profit
declare @transportProfit decimal(18,2)=0;
SELECT 
 @transportProfit = SUM(t2.SellAmount-t2.BuyAmount) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 5 and t2.SellAmount >= t2.BuyAmount

SELECT 
 @overallLoss = @overallLoss + SUM(t2.BuyAmount-t2.SellAmount) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 5 and t2.SellAmount < t2.BuyAmount
--End Transport Profit

--Start TruckService Profit
declare @truckServiceProfit decimal(18,2)=0;
SELECT 
 @truckServiceProfit = SUM(t2.TruckRent) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderTruckDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 6 

--End TruckService Profit

--Start Export Count
declare @exportOrderCount int=0;
SELECT 
 @exportOrderCount = COUNT(1) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 2 

--End Export Count

--Start Transport Count
declare @transportOrderCount int=0;
SELECT 
 @transportOrderCount = COUNT(1) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 5 
--End Transport Count

--Start TruckService Profit
declare @truckServiceOrderCount int=0;
SELECT 
  @truckServiceOrderCount = COUNT(1) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderTruckDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 6 
--End TruckService Profit


SELECT 
		ISNULL(@exportProfit,0) as ExportProfit,
		ISNULL(@transportProfit,0) as TransportProfit, 
		ISNULL(@overallLoss,0) as OverallLoss,
		ISNULL(@truckServiceProfit,0) as TruckServiceProfit,
		ISNULL(@exportOrderCount,0) as ExportOrderCount, 
		ISNULL(@transportOrderCount,0) as TransportOrderCount,
		ISNULL(@truckServiceOrderCount,0) as TruckServiceOrderCount


--Product wise profit

select product.Id,product.Title,ISNULL(SUM(temp.SellAmount - temp.BuyAmount),0) as ProductProfit from sInventory.tProduct product 
left join
(
 SELECT productDetails.ProductId, productDetails.SellAmount , productDetails.BuyAmount from sInventory.tOrder [order]
INNER JOIN  sInventory.tOrderProductDetails productDetails  on [order].TransportTypeId=2 and productDetails.OrderId = [order].OrderId and productDetails.BuyAmount <= productDetails.SellAmount
) as temp on product.Id=temp.ProductId
group by product.Id,product.Title
 
 select sum(case when M1.IsInternalTruck=1 then M3.TruckRent else 0 end) as InternalTruck, 
sum(case when M1.IsInternalTruck=0 then M3.TruckRent else 0 end) as ExternalTruck
from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0
END
GO
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard_bkp]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[usp_GetDashBoard_bkp] 
	
AS
BEGIN

declare @table table(ExportBuyAmount decimal(18,2) not null,ExportSellAmount decimal(18,2) not null,ExportTruckRent decimal(18,2)  not null,
TransportBuyAmount decimal(18,2) not null,TransportSellAmount decimal(18,2) not null,TransportTruckRent decimal(18,2) not null,
TruckServiceRent decimal(18,2) not null,ExportOrder int,TransportOrder int not null,TruckServiceOrder int not null,TransportTypeId int not null
)
declare @tableProduct table(ProductId int,BuyAmount decimal(18,2),SellAmount decimal(18,2),TruckRent decimal(18,2))
declare @overallLoss decimal(18,0)

insert into @table
	select 
ISNULL((select 
sum(M2.BuyAmount) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=2),0) as ExportBuyAmount,
ISNULL((select 
sum(M2.SellAmount) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=2),0) as ExportSellAmount,
ISNULL((select 
sum(M3.TruckRent) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=2 AND IsInternalTruck=0),0) as ExportTruckRent,
ISNULL((select 
sum(M2.BuyAmount) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=3),0) as TransportBuyAmount,
ISNULL((select 
sum(M2.SellAmount) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=3),0) as TransportSellAmount,
ISNULL((select 
sum(M3.TruckRent) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=3 AND IsInternalTruck=0),0) as TransportTruckRent,
ISNULL((select 
sum(M3.TruckRent) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=4 AND IsInternalTruck=1),0) as TruckServiceRent,
ISNULL((select 
count(M1.OrderId) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=2),0) as ExportOrder,
ISNULL((select 
count(M1.OrderId) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=3),0) as TransportOrder,
ISNULL((select 
count(M1.OrderId) from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 AND M1.TransportTypeId=4),0) as TruckServiceOrder,1

select @overallLoss=
sum(case when M2.BuyAmount>(M2.SellAmount+M3.TruckRent) then M2.BuyAmount-(M2.SellAmount+M3.TruckRent) else 0 end)  from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 

select (ExportSellAmount-(ExportBuyAmount+ExportTruckRent)) as ExportProfit,(TransportSellAmount-(TransportBuyAmount+TransportTruckRent)) as TransportProfit,
 TruckServiceRent as TruckServiceProfit,@overallLoss as OverallLoss,ExportOrder as ExportOrderCount,TransportOrder as TransportOrderCount,TruckServiceOrder as TruckServiceOrderCount  from @table

 insert into @tableProduct
select M2.ProductId,Sum(M2.BuyAmount) as BuyAmount,SUM(M2.SellAmount) as SellAmount,SUM(case when M1.IsInternalTruck=0 then M3.TruckRent else 0 end) as TruckRent

from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0 and M1.TransportTypeId=2 group by M2.ProductId

select M1.Id,M1.Title,(ISNULL(M2.SellAmount,0)-(ISNULL(M2.TruckRent,0)+ISNULL(M2.BuyAmount,0)))as ProductProfit from sInventory.tProduct M1
left join @tableProduct M2 on M1.Id=M2.ProductId 
order by M1.Id

select sum(case when M1.IsInternalTruck=1 then M3.TruckRent else 0 end) as InternalTruck, 
sum(case when M1.IsInternalTruck=0 then M3.TruckRent else 0 end) as ExternalTruck
from sInventory.tOrder M1
inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
inner join sInventory.tOrderTruckDetails M3 on M3.OrderId=M1.OrderId
where M1.IsObsolete=0



END
GO
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard_Temp]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[usp_GetDashBoard_Temp] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @tempUserTransaction table(UserId int,TransactionTypeId int,Amount decimal(18,2))
    declare @tempPaidAmount table(SupplierId int not null,TotalAmount decimal(18,2) not null,TotalPaidAmount decimal(18,2) not null)
	declare @tempReceivedAmount table(SupplierId int not null,TotalAmount decimal(18,2) not null,TotalReceivedAmount decimal(18,2) not null)
	declare @tempPaidAmountFinal table(SupplierId int not null,TotalAmount decimal(18,2) not null,TotalPaidAmount decimal(18,2) not null,Amount decimal(18,2) not null,AdvancedPayment decimal(18,2) not null)
	declare @tempReceivedAmountFinal table(SupplierId int not null,TotalAmount decimal(18,2) not null,TotalReceivedAmount decimal(18,2) not null,Amount decimal(18,2) not null,AdvancedPayment decimal(18,2) not null)
	declare @tempAdvancedPayment1 table(UserId int not null,AdvancedAmount decimal(18,2) not null )
	declare @tempAdvancedPayment2 table(UserId int not null,AdvancedAmount decimal(18,2) not null )
	declare @paidWithAdvanceAmount decimal(18,2) =0
	declare @receivedWithAdvanceAmount decimal(18,2) =0
	declare @advancedAmount1 decimal(18,2)=0
	declare @advancedAmount2 decimal(18,2)=0
	declare @totalAmount1 decimal(18,2)=0
	declare @totalAmount2 decimal(18,2)=0
  insert into @tempUserTransaction
  select UserId,TransactionTypeId,Sum(Amount) from sSecurity.tUserTransaction
where IsObsolete=0
group by UserId,TransactionTypeId order by UserId

insert into @tempPaidAmount
select SupplierId,Sum(TotalAmount) as TotalAmount,Sum(PaidAmount) as PaidAmount from sTransport.tTransport M1
inner join sTransport.tTransportProductDetails M2 on M1.TransportId=M2.TransportId
where M1.IsObsolete=0 and M1.TransportTypeId in(1,3)
group by SupplierId

insert into @tempReceivedAmount
select CustomerId,Sum(TotalAmount) as TotalAmount,Sum(PaidAmount) as PaidAmount from sTransport.tTransport M1
inner join sTransport.tTransportProductDetails M2 on M1.TransportId=M2.TransportId
where M1.IsObsolete=0 and M1.TransportTypeId in(2,4,6)
group by CustomerId


insert into @tempPaidAmountFinal
select M1.*,ISNULL(M2.Amount,0) as Amount,M1.TotalAmount-(M1.TotalPaidAmount+isnull(M2.Amount,0)) as AdvancedPayment from @tempPaidAmount M1
left join @tempUserTransaction M2 on M1.SupplierId=m2.UserId and M2.TransactionTypeId=1

insert into @tempReceivedAmountFinal
select M1.*,ISNULL(M2.Amount,0) as Amount,M1.TotalAmount-(M1.TotalPaidAmount+isnull(M2.Amount,0)) as AdvancedPayment from @tempPaidAmount M1
left join @tempUserTransaction M2 on M1.SupplierId=m2.UserId and M2.TransactionTypeId=2

insert into @tempAdvancedPayment1 
select SupplierId,Amount from @tempPaidAmountFinal where AdvancedPayment<0

insert into @tempAdvancedPayment2 
select SupplierId,Amount from @tempReceivedAmountFinal where AdvancedPayment<0


select @paidWithAdvanceAmount= SUM(TotalPaidAmount+Amount)  from @tempPaidAmountFinal
select @receivedWithAdvanceAmount= SUM(TotalReceivedAmount+Amount)  from @tempReceivedAmountFinal

select @advancedAmount1= SUM(AdvancedAmount)  from @tempAdvancedPayment1
select @advancedAmount2= SUM(AdvancedAmount)  from @tempAdvancedPayment2

select @totalAmount1=SUM(TotalAmount) from @tempPaidAmountFinal
select @totalAmount2=SUM(TotalAmount) from @tempReceivedAmountFinal

select @advancedAmount1 as PaidAdvanced,@advancedAmount2 as ReceivedAdvanced,
(@paidWithAdvanceAmount-@advancedAmount1) as FinalPaidAmount,
(@receivedWithAdvanceAmount-@advancedAmount2) as FinalReceivedAmount,
@totalAmount1-((@paidWithAdvanceAmount-@advancedAmount1)) as UnpaidAmount,
@totalAmount2-((@receivedWithAdvanceAmount-@advancedAmount2)) as RemainingAmount



END
GO
/****** Object:  StoredProcedure [sSecurity].[usp_GetInvoiceByUserId]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[usp_GetInvoiceByUserId]
	-- Add the parameters for the stored procedure here
	@rUserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select 
		M1.OrderId as OrderId,
		M1.SupplierId as UserId,
		M1.SupplierId as SupplierId,
		0 as CustomerId,
		0 as TruckOwnerId,
		M1.OrderDate,M4.Title+' '+m3.Title as ProductName,
		M5.Id as TransportTypeId,
		M5.Title as TransportType,
		M2.Quantity as Quantity,
		case 
			when M1.TransportTypeId=1 or M1.TransportTypeId=3 then M2.BuyAmount
			when M1.TransportTypeId=4 then M6.TruckRent
		else 
			0 
		end as TotalAmount
	from sInventory.tOrder M1
		inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
		inner join sInventory.tOrderTruckDetails M6 on M1.OrderId=M6.OrderId
		inner join sInventory.tProduct M3 on M3.Id=M2.ProductId
		inner join sInventory.tProductType M4 on M4.ProductId=M3.Id and M4.Id=M2.ProductTypeId
		inner join sInventory.tStaticTransportType M5 on M5.Id=M1.TransportTypeId
	where 
		M1.IsObsolete=0  and M1.SupplierId=@rUserId
UNION ALL
	select 
		M1.OrderId as OrderId,
		M1.CustomerId as UserId,
		0 as SupplierId,
		M1.CustomerId as CustomerId,
		0 as TruckOwnerId,
		M1.OrderDate,M4.Title+' '+m3.Title as ProductName,
		M5.Id as TransportTypeId,
		M5.Title as TransportType,
		M2.Quantity as Quantity,
		M2.SellAmount as TotalAmount
	from sInventory.tOrder M1
		inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
		inner join sInventory.tOrderTruckDetails M6 on M1.OrderId=M6.OrderId
		inner join sInventory.tProduct M3 on M3.Id=M2.ProductId
		inner join sInventory.tProductType M4 on M4.ProductId=M3.Id and M4.Id=M2.ProductTypeId
		inner join sInventory.tStaticTransportType M5 on M5.Id=M1.TransportTypeId
	where 
		M1.IsObsolete=0  and M1.CustomerId=@rUserId

UNION ALL
	select 
		M1.OrderId as OrderId,
		M6.TruckOwnerId as UserId,
		0 as SupplierId,
		0 as CustomerId,
		M6.TruckOwnerId as TruckOwnerId,
		M1.OrderDate,M4.Title+' '+m3.Title as ProductName,
		M5.Id as TransportTypeId,
		M5.Title as TransportType,
		M2.Quantity as Quantity,
		M6.TruckRent as TotalAmount
	from sInventory.tOrder M1
		inner join sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
		inner join sInventory.tOrderTruckDetails M6 on M1.OrderId=M6.OrderId
		inner join sInventory.tProduct M3 on M3.Id=M2.ProductId
		inner join sInventory.tProductType M4 on M4.ProductId=M3.Id and M4.Id=M2.ProductTypeId
		inner join sInventory.tStaticTransportType M5 on M5.Id=M1.TransportTypeId
	where 
		M1.IsObsolete=0  and M6.TruckOwnerId=@rUserId

	order by M1.OrderDate
END
GO
/****** Object:  StoredProcedure [sSecurity].[usp_GetUserAmount]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sSecurity].[usp_GetUserAmount]
	@rUserId int
AS
BEGIN
declare @BuyAmount decimal(18,2)
declare @SellAmount decimal(18,2)
declare @HireTruckRent decimal(18,2)
declare @ProvideTruckRent decimal(18,2)
declare @ReceivedAmount decimal(18,2)
declare @SentAmount decimal(18,2)

	select @SellAmount=ISNULL(SUM(ISNULL(M2.SellAmount,0)),0),
	@ReceivedAmount=ISNULL(SUM(ISNULL(M2.SellPaidAmount,0)),0) from sInventory.tOrder M1
INNER JOIN sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
WHERE M1.CustomerId=@rUserId and TransportTypeId in(2,3)

select @BuyAmount=ISNULL(SUM(ISNULL(M2.BuyAmount,0)),0) from sInventory.tOrder M1
INNER JOIN sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
WHERE M1.SupplierId=@rUserId and TransportTypeId=3


SELECT @HireTruckRent=ISNULL(SUM(ISNULL(M3.TruckRent,0)),0) from sInventory.tOrder M1
INNER JOIN sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
INNER JOIN sInventory.tOrderTruckDetails M3 on M1.OrderId=M3.OrderId
WHERE M1.IsInternalTruck=0 and M3.TruckOwnerId=@rUserId 

SELECT @ProvideTruckRent=ISNULL(SUM(ISNULL(M3.TruckRent,0)),0),@ReceivedAmount=@ReceivedAmount+ISNULL(SUM(ISNULL(M3.PaidRent,0)),0) from sInventory.tOrder M1
INNER JOIN sInventory.tOrderProductDetails M2 on M1.OrderId=M2.OrderId
INNER JOIN sInventory.tOrderTruckDetails M3 on M1.OrderId=M3.OrderId
WHERE M1.IsInternalTruck=1 and M1.TransportTypeId=4 and M1.SupplierId=@rUserId

SELECT @SentAmount=ISNULL(SUM(ISNULL(Amount,0)),0) FROM sSecurity.tUserTransaction
WHERE UserId=@rUserId AND TransactionTypeId=1
SELECT @ReceivedAmount=@ReceivedAmount+ISNULL(SUM(ISNULL(Amount,0)),0) FROM sSecurity.tUserTransaction
WHERE UserId=@rUserId AND TransactionTypeId=2



SELECT ISNULL(@BuyAmount,0) AS BuyAmount,
ISNULL(@SellAmount,0) AS SellAmount,
ISNULL(@HireTruckRent,0) AS HireTruckRent,
ISNULL(@ProvideTruckRent,0) AS ProvideTruckRent,
ISNULL(@ReceivedAmount,0) AS ReceivedAmount,
ISNULL(@SentAmount,0) AS SentAmount,
ISNULL((@SellAmount+@ProvideTruckRent+@SentAmount)-(@BuyAmount+@HireTruckRent+@ReceivedAmount),0) AS FinalPay




END				  
GO
/****** Object:  StoredProcedure [sTransport].[usp_GetTransports]    Script Date: 21/02/2023 9:20:48 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sTransport].[usp_GetTransports] 
@rType int=2--1. Order 2. Transport
AS
BEGIN
if @rType=1
	select M1.TransportId,case when M1.SupplierId=-111 then 'Self' else isnull((select top 1 Name from sSecurity.tUserMaster where UserId=M1.SupplierId),'') end as SupplierName
,case when M1.CustomerId=-111 then 'Self' else isnull((select top 1 Name from sSecurity.tUserMaster where UserId=M1.CustomerId),'') end as CustomerName,M4.Title+' '+M3.Title as ProductName,
M1.TransportTypeId,M1.TransportDate 
from sTransport.tTransport M1
inner join sTransport.tTransportProductDetails M2 on M1.TransportId=M2.TransportId
inner join sInventory.tProduct M3 on M3.Id=M2.ProductId
inner join sInventory.tProductType M4 on M4.ProductId=M3.Id and M4.Id=M2.ProductTypeId
where M1.IsObsolete=0 and M1.TransportTypeId in(1,2)
else
	select M1.TransportId,case when M1.SupplierId=-111 then 'Self' else isnull((select top 1 Name from sSecurity.tUserMaster where UserId=M1.SupplierId),'') end as SupplierName
,case when M1.CustomerId=-111 then 'Self' else isnull((select top 1 Name from sSecurity.tUserMaster where UserId=M1.CustomerId),'') end as CustomerName,M4.Title+' '+M3.Title as ProductName,
M1.TransportTypeId,M1.TransportDate 
from sTransport.tTransport M1
inner join sTransport.tTransportProductDetails M2 on M1.TransportId=M2.TransportId
inner join sInventory.tProduct M3 on M3.Id=M2.ProductId
inner join sInventory.tProductType M4 on M4.ProductId=M3.Id and M4.Id=M2.ProductTypeId
where M1.IsObsolete=0 and M1.TransportTypeId in(5,6)
END
GO
USE [master]
GO
ALTER DATABASE [TKTradersDB] SET  READ_WRITE 
GO
