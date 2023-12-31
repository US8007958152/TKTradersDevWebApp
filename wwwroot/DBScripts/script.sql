USE [master]
GO
/****** Object:  Database [TKTradersDB]    Script Date: 04/08/2023 1:59:35 pm ******/
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
/****** Object:  Schema [sInventory]    Script Date: 04/08/2023 1:59:36 pm ******/
CREATE SCHEMA [sInventory]
GO
/****** Object:  Schema [sSecurity]    Script Date: 04/08/2023 1:59:36 pm ******/
CREATE SCHEMA [sSecurity]
GO
/****** Object:  Schema [sTransport]    Script Date: 04/08/2023 1:59:36 pm ******/
CREATE SCHEMA [sTransport]
GO
/****** Object:  Table [dbo].[tblEmployee]    Script Date: 04/08/2023 1:59:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmployee](
	[Name] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tOrder]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tOrderProductDetails]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tOrderTruckDetails]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tProduct]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tProductType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tStaticStatusType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tStaticStockType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tStaticTransportType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tStaticView]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tStock]    Script Date: 04/08/2023 1:59:36 pm ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tStockInvestment]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sInventory].[tView]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tCity]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[TCity_temp]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tDistrict]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[TDistrict_temp]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tLogError]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tNotification]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tState]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[TState_temp]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tStaticFuelType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tStaticPaymentType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tStaticUserType]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tTruck]    Script Date: 04/08/2023 1:59:36 pm ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tTruckFuel]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tUser]    Script Date: 04/08/2023 1:59:36 pm ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUserCredentials]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tUserMaster]    Script Date: 04/08/2023 1:59:36 pm ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sSecurity].[tUserSite]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sSecurity].[tUserTransaction]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sTransport].[tTransport]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sTransport].[tTransportProductDetails]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  Table [sTransport].[tTransportTruckDetails]    Script Date: 04/08/2023 1:59:36 pm ******/
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
INSERT [dbo].[tblEmployee] ([Name]) VALUES (N'Mumbai')
INSERT [dbo].[tblEmployee] ([Name]) VALUES (N'Delhi')
INSERT [dbo].[tblEmployee] ([Name]) VALUES (N'Pune')
GO
SET IDENTITY_INSERT [sInventory].[tOrder] ON 

INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008102, 1, 102006, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2005, 104008, 0, 0, 0, N'cdvxb', CAST(N'2023-07-24T20:35:44.283' AS DateTime), 102, NULL, NULL, 10001, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008103, 1, 104011, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2005, 104008, 0, 0, 0, N'dfhjkklydgfskhml', CAST(N'2023-07-24T20:47:42.957' AS DateTime), 102, NULL, NULL, 12004, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008104, 1, 102006, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2006, 104012, 0, 0, 0, N'jyfmi9h jbuhi', CAST(N'2023-07-24T20:52:05.357' AS DateTime), 102, NULL, NULL, 10002, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008105, 1, 103009, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2007, 104014, 0, 0, 0, N'gfhghj rhtyuy uyuyt', CAST(N'2023-07-24T20:55:54.150' AS DateTime), 102, NULL, NULL, 11002, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008106, 1, 103009, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2006, 104008, 0, 0, 0, N'ogyfgvjhn', CAST(N'2023-07-24T20:58:34.583' AS DateTime), 102, NULL, NULL, 11003, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008107, 1, 104016, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2008, 104014, 0, 0, 0, N'srdgfhghnh trutjhn', CAST(N'2023-07-24T21:06:48.453' AS DateTime), 102, NULL, NULL, 12005, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008108, 1, 104018, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2008, 104008, 0, 0, 0, N'dfsgfhgf hjghjm', CAST(N'2023-07-24T21:11:03.260' AS DateTime), 102, NULL, NULL, 12006, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008109, 1, 104019, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2009, 104020, 0, 0, 0, N'jyfyvsdfgnku ytvfbgunkj', CAST(N'2023-07-24T21:17:09.713' AS DateTime), 102, NULL, NULL, 12007, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008110, 1, 104022, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2002, 104023, 1, 0, 0, N';ljrshdvhjbnmmfjvbk khbhfjgcjhknhnn hl,jh', CAST(N'2023-07-24T21:40:34.407' AS DateTime), 102, NULL, NULL, 12008, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008111, 1, 104024, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2010, 104025, 0, 0, 0, N'irfan sheikh
', CAST(N'2023-07-24T22:02:37.487' AS DateTime), 102, NULL, NULL, 12009, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008112, 1, 104010, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2003, 104020, 1, 0, 0, N'hugg', CAST(N'2023-07-24T22:04:27.313' AS DateTime), 102, NULL, NULL, 12002, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008113, 1, 104027, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2003, 104008, 1, 0, 0, N'test', CAST(N'2023-07-24T22:07:51.327' AS DateTime), 102, NULL, NULL, 12010, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008114, 1, 104028, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2002, 104014, 1, 0, 0, N'TEST', CAST(N'2023-07-24T22:11:38.267' AS DateTime), 102, NULL, NULL, 12011, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008115, 1, 104029, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2011, 104023, 0, 0, 0, N'scdv', CAST(N'2023-07-24T22:19:23.357' AS DateTime), 102, NULL, NULL, 12013, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008116, 1, 104030, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2012, 104012, 0, 0, 0, N'test', CAST(N'2023-07-24T22:22:00.600' AS DateTime), 102, NULL, NULL, 12015, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1008117, 1, 104031, 0, CAST(N'2023-07-24T00:00:00.000' AS DateTime), 2, 2002, 104014, 1, 0, 0, N'asfaf', CAST(N'2023-07-24T22:23:54.843' AS DateTime), 102, NULL, NULL, 12016, 0)
SET IDENTITY_INSERT [sInventory].[tOrder] OFF
GO
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008102, 1, 1, CAST(500 AS Decimal(18, 0)), 3, CAST(170000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(500.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008103, 1, 1, CAST(450 AS Decimal(18, 0)), 3, CAST(150000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(450.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008104, 1, 2, CAST(250 AS Decimal(18, 0)), 3, CAST(85000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(250.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008105, 4, 16, CAST(600 AS Decimal(18, 0)), 3, CAST(20000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008106, 4, 15, CAST(600 AS Decimal(18, 0)), 3, CAST(25000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008107, 3, 5, CAST(600 AS Decimal(18, 0)), 3, CAST(11000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008108, 3, 6, CAST(600 AS Decimal(18, 0)), 3, CAST(22000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008109, 1, 2, CAST(200 AS Decimal(18, 0)), 3, CAST(68000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(200.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008110, 1, 1, CAST(500 AS Decimal(18, 0)), 3, CAST(170000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(500.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008111, 1, 1022, CAST(250 AS Decimal(18, 0)), 3, CAST(85000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(250.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008112, 4, 15, CAST(600 AS Decimal(18, 0)), 3, CAST(23000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008113, 3, 5, CAST(600 AS Decimal(18, 0)), 3, CAST(25000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008114, 3, 6, CAST(500 AS Decimal(18, 0)), 3, CAST(22000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(500.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008115, 4, 19, CAST(600 AS Decimal(18, 0)), 3, CAST(17000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008116, 4, 21, CAST(600 AS Decimal(18, 0)), 3, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders], [InvestmenOrderIDs]) VALUES (1008117, 4, 21, CAST(600 AS Decimal(18, 0)), 3, CAST(15000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1, CAST(600.00 AS Decimal(18, 2)), NULL, NULL)
GO
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008102, 104009, 1, CAST(3450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008103, 104009, 1, CAST(3100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008104, 104013, 1, CAST(2900.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008105, 104015, 1, CAST(6000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008106, 104013, 1, CAST(3100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008107, 104017, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008108, 104017, 1, CAST(4000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008109, 104021, 1, CAST(4500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008110, -999, 1, CAST(5500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008111, 104026, 1, CAST(3500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008112, -999, 1, CAST(2500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008113, -999, 1, CAST(3000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008114, -999, 1, CAST(3000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008115, 104032, 1, CAST(3500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008116, 104033, 1, CAST(3000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1008117, -999, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [sInventory].[tProduct] ON 

INSERT [sInventory].[tProduct] ([Id], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy]) VALUES (1, N'Cements', 0, CAST(N'2022-04-02T21:46:50.183' AS DateTime), N'US10001', NULL, NULL)
INSERT [sInventory].[tProduct] ([Id], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy]) VALUES (2, N'Bricks', 0, CAST(N'2022-04-02T21:48:43.940' AS DateTime), N'US10001', NULL, NULL)
INSERT [sInventory].[tProduct] ([Id], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy]) VALUES (3, N'Sand', 0, CAST(N'2022-04-02T21:48:43.947' AS DateTime), N'US10001', NULL, NULL)
INSERT [sInventory].[tProduct] ([Id], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy]) VALUES (4, N'Metal (Gitti)', 0, CAST(N'2022-04-02T21:48:43.947' AS DateTime), N'US10001', NULL, NULL)
INSERT [sInventory].[tProduct] ([Id], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy]) VALUES (5, N'Husks', 0, CAST(N'2022-04-02T21:49:26.010' AS DateTime), N'US10001', NULL, NULL)
INSERT [sInventory].[tProduct] ([Id], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy]) VALUES (6, N'Fly Ash', 0, CAST(N'2022-09-24T16:29:33.703' AS DateTime), N'US10001', NULL, NULL)
SET IDENTITY_INSERT [sInventory].[tProduct] OFF
GO
SET IDENTITY_INSERT [sInventory].[tProductType] ON 

INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1, 1, N'ACC', 0, CAST(N'2022-04-10T00:32:28.443' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/ACC_Cements.jpg', N'rgb(255, 99, 132)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (2, 1, N'Ambuja', 0, CAST(N'2022-04-10T00:32:42.313' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/Ambuja_Cements.jpeg', N'rgb(0, 128, 255)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (3, 2, N'Red', 0, CAST(N'2022-04-10T00:33:50.420' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/Red_Bricks.png', N'rgb(255, 99, 132)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (4, 2, N'White', 0, CAST(N'2022-04-10T00:33:50.420' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/White_Bricks.png', N'rgb(224, 224, 224)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (5, 3, N'Concrete', 0, CAST(N'2022-04-10T00:34:45.927' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/Concrete_Sand.png', N'rgb(224, 224, 224)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (6, 3, N'Plaster', 0, CAST(N'2022-04-10T00:34:45.927' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/Plaster_Sand.jpg', N'rgb(255, 99, 132)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (11, 5, N'Husks', 0, CAST(N'2022-04-10T00:37:09.093' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/Husks_Husks.jpg', N'rgb(255, 178, 102)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (12, 1, N'UltraTech', 0, CAST(N'2022-04-16T13:38:47.427' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/UltraTech_Cements.jpg', N'rgb(255, 255, 102)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (13, 4, N'6 mm', 0, CAST(N'2022-04-16T13:42:39.637' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/6mm_Metals.jpg', N'rgb(255, 99, 132)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (14, 4, N'10 mm', 0, CAST(N'2022-04-16T13:42:39.640' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/10mm_Metals.jpg', N'rgb(255, 255, 102)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (15, 4, N'18 mm', 0, CAST(N'2022-04-16T13:42:39.640' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/18mm_Metals.png', N'rgb(224, 224, 224)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (16, 4, N'20 mm', 0, CAST(N'2022-04-16T13:42:39.640' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/20mm_Metals.jpg', N'rgb(54, 162, 235)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (17, 4, N'40 mm', 0, CAST(N'2022-04-16T13:42:39.643' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/40mm_Metals.jpg', N'rgb(0, 255, 0)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (18, 4, N'60 mm', 0, CAST(N'2022-04-16T13:42:39.643' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/60mm_Metals.jpg', N'rgb(192, 192, 192)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (19, 4, N'80 mm', 0, CAST(N'2022-04-16T13:42:39.643' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/80mm_Metals.jpg', N'rgb(96, 96, 96)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (20, 4, N'GSB', 0, CAST(N'2022-04-16T13:42:39.643' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/GSB_Metals.jpg', N'rgb(51, 25, 0)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (21, 4, N'Dust', 0, CAST(N'2022-04-16T13:42:39.643' AS DateTime), N'TKT100', NULL, NULL, N'/Admin/Images/Dust_Metals.jpg', N'rgb(0, 102, 51)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (22, 6, N'Fly Ash', 0, CAST(N'2022-09-24T16:31:10.360' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/ACC_Cements.jpg', N'rgb(255, 99, 132)', 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1022, 1, N'JK Laxmi ', 0, CAST(N'2022-09-25T07:20:08.513' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/jk_laxmi_cements.jpg', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1023, 1, N'Double Bull ', 0, CAST(N'2022-09-25T07:22:28.077' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/double_bull_cements.jpg', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1024, 1, N'Shree Jang Rodhak ', 0, CAST(N'2022-09-25T07:22:28.083' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/shree_jang_rodhak_cements.jpg', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1025, 1, N'Dalmia ', 0, CAST(N'2022-09-25T07:22:28.083' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/dalmia_cements.jpeg', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1026, 1, N'Banger ', 0, CAST(N'2022-09-25T07:22:28.083' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/banger_cements.jpg', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1027, 1, N'Birla A1 ', 0, CAST(N'2022-09-25T07:22:28.083' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/birla_a1_cements.png', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1028, 1, N'Birla Gold ', 0, CAST(N'2022-09-25T07:22:28.087' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/birla_gold_cements.jpg', NULL, 3)
INSERT [sInventory].[tProductType] ([Id], [ProductId], [Title], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdateBy], [ImagePath], [ColorCode], [ViewId]) VALUES (1029, 1, N'Jaypee ', 0, CAST(N'2022-09-25T07:22:28.087' AS DateTime), N'US1001', NULL, NULL, N'/Admin/Images/jaypee_cements.jpg', NULL, 3)
SET IDENTITY_INSERT [sInventory].[tProductType] OFF
GO
INSERT [sInventory].[tStaticStatusType] ([Id], [Title], [IsObsolete]) VALUES (1, N'Pending', 0)
INSERT [sInventory].[tStaticStatusType] ([Id], [Title], [IsObsolete]) VALUES (2, N'Delivered', 0)
GO
INSERT [sInventory].[tStaticTransportType] ([Id], [Title], [IsObsolete], [CreatedDateTime], [CreatedBy]) VALUES (1, N'Import', 0, CAST(N'2022-06-25T09:20:48.900' AS DateTime), 100001)
INSERT [sInventory].[tStaticTransportType] ([Id], [Title], [IsObsolete], [CreatedDateTime], [CreatedBy]) VALUES (2, N'Export', 0, CAST(N'2022-06-25T09:21:02.523' AS DateTime), 100001)
INSERT [sInventory].[tStaticTransportType] ([Id], [Title], [IsObsolete], [CreatedDateTime], [CreatedBy]) VALUES (3, N'Internal Stock', 0, CAST(N'2022-06-25T09:21:02.530' AS DateTime), 100001)
INSERT [sInventory].[tStaticTransportType] ([Id], [Title], [IsObsolete], [CreatedDateTime], [CreatedBy]) VALUES (4, N'Internal Use', 0, CAST(N'2022-06-26T20:39:38.493' AS DateTime), 100001)
INSERT [sInventory].[tStaticTransportType] ([Id], [Title], [IsObsolete], [CreatedDateTime], [CreatedBy]) VALUES (5, N'Transport', 0, CAST(N'2022-06-29T23:27:45.277' AS DateTime), 100001)
INSERT [sInventory].[tStaticTransportType] ([Id], [Title], [IsObsolete], [CreatedDateTime], [CreatedBy]) VALUES (6, N'Truck Service', 0, CAST(N'2022-07-06T13:23:28.977' AS DateTime), 100001)
GO
SET IDENTITY_INSERT [sInventory].[tStock] ON 

INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6082, 1008102, 1, 1, 1, CAST(500 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T20:35:44.623' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6083, 1008103, 1, 1, 1, CAST(450 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T20:47:42.987' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6084, 1008104, 1, 2, 1, CAST(250 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T20:52:05.383' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6085, 1008105, 4, 16, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T20:55:54.183' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6086, 1008106, 4, 15, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T20:58:34.613' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6087, 1008107, 3, 5, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T21:06:48.490' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6088, 1008108, 3, 6, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T21:11:03.297' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6089, 1008109, 1, 2, 1, CAST(200 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T21:17:09.757' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6090, 1008110, 1, 1, 1, CAST(500 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T21:40:34.447' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6091, 1008111, 1, 1022, 1, CAST(250 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:02:37.523' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6092, 1008112, 4, 15, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:04:27.340' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6093, 1008113, 3, 5, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:07:51.357' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6094, 1008114, 3, 6, 1, CAST(500 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:11:38.290' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6095, 1008115, 4, 19, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:19:23.377' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6096, 1008116, 4, 21, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:22:00.627' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (6097, 1008117, 4, 21, 1, CAST(600 AS Decimal(18, 0)), 0, CAST(N'2023-07-24T22:23:54.870' AS DateTime), 102, 1, NULL)
SET IDENTITY_INSERT [sInventory].[tStock] OFF
GO
INSERT [sInventory].[tView] ([Id], [Title]) VALUES (1, N'Import')
INSERT [sInventory].[tView] ([Id], [Title]) VALUES (2, N'Export')
INSERT [sInventory].[tView] ([Id], [Title]) VALUES (4, N'Invest')
GO
SET IDENTITY_INSERT [sSecurity].[tCity] ON 

INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (1, N'Bhandara', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (2, N'Tumsar', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (3, N'Pauni', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (4, N'Mohadi', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (5, N'Sakoli', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (6, N'Lakhani', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (7, N'Lakhandur', 21, 1720, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (8, N'Bhiwapur', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (9, N'Hingna', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (10, N'Kalameshwar', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (11, N'Kamptee', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (12, N'Katol', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (13, N'Kuhi', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (14, N'Mauda', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (15, N'Nagpur Rural', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (16, N'Nagpur Urban', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (17, N'Narkhed', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (18, N'Parseoni', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (19, N'Ramtek', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (20, N'Savner', 21, 1679, 0)
INSERT [sSecurity].[tCity] ([Id], [Name], [StateId], [DistrictId], [IsObsolete]) VALUES (21, N'Umred', 21, 1679, 0)
SET IDENTITY_INSERT [sSecurity].[tCity] OFF
GO
INSERT [sSecurity].[tDistrict] ([Id], [Name], [StateId], [IsObsolete]) VALUES (1679, N'Nagpur', 21, 0)
INSERT [sSecurity].[tDistrict] ([Id], [Name], [StateId], [IsObsolete]) VALUES (1720, N'Bhandara', 21, 0)
GO
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (1, N'ANDAMAN AND NICOBAR ISLANDS', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (2, N'ANDHRA PRADESH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (3, N'ARUNACHAL PRADESH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (4, N'ASSAM', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (5, N'BIHAR', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (6, N'CHATTISGARH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (7, N'CHANDIGARH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (8, N'DAMAN AND DIU', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (9, N'DELHI', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (10, N'DADRA AND NAGAR HAVELI', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (11, N'GOA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (12, N'GUJARAT', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (13, N'HIMACHAL PRADESH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (14, N'HARYANA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (15, N'JAMMU AND KASHMIR', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (16, N'JHARKHAND', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (17, N'KERALA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (18, N'KARNATAKA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (19, N'LAKSHADWEEP', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (20, N'MEGHALAYA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (21, N'MAHARASHTRA', 15, 0)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (22, N'MANIPUR', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (23, N'MADHYA PRADESH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (24, N'MIZORAM', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (25, N'NAGALAND', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (26, N'ORISSA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (27, N'PUNJAB', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (28, N'PONDICHERRY', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (29, N'RAJASTHAN', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (30, N'SIKKIM', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (31, N'TAMIL NADU', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (32, N'TRIPURA', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (33, N'UTTARAKHAND', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (34, N'UTTAR PRADESH', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (35, N'WEST BENGAL', 15, 1)
INSERT [sSecurity].[tState] ([Id], [Name], [CountryId], [IsObsolete]) VALUES (36, N'TELANGANA', 15, 1)
GO
INSERT [sSecurity].[tStaticFuelType] ([Id], [Title], [IsObsolete]) VALUES (1, N'Diesel', 0)
INSERT [sSecurity].[tStaticFuelType] ([Id], [Title], [IsObsolete]) VALUES (2, N'Petrol', 0)
GO
INSERT [sSecurity].[tStaticPaymentType] ([Id], [Title], [IsObsolete]) VALUES (1, N'Unpaid', 0)
INSERT [sSecurity].[tStaticPaymentType] ([Id], [Title], [IsObsolete]) VALUES (2, N'Partial Paid', 0)
INSERT [sSecurity].[tStaticPaymentType] ([Id], [Title], [IsObsolete]) VALUES (3, N'Paid', 0)
GO
INSERT [sSecurity].[tStaticUserType] ([Id], [Title], [IsObsolete], [CreateDate]) VALUES (1, N'Admin', 0, CAST(N'2022-06-22T02:15:16.493' AS DateTime))
INSERT [sSecurity].[tStaticUserType] ([Id], [Title], [IsObsolete], [CreateDate]) VALUES (2, N'Customer', 0, CAST(N'2022-06-22T02:15:16.497' AS DateTime))
INSERT [sSecurity].[tStaticUserType] ([Id], [Title], [IsObsolete], [CreateDate]) VALUES (3, N'Dealer', 0, CAST(N'2022-06-22T02:15:16.497' AS DateTime))
INSERT [sSecurity].[tStaticUserType] ([Id], [Title], [IsObsolete], [CreateDate]) VALUES (4, N'Driver', 0, CAST(N'2022-06-22T02:15:16.497' AS DateTime))
INSERT [sSecurity].[tStaticUserType] ([Id], [Title], [IsObsolete], [CreateDate]) VALUES (5, N'Supplier', 0, CAST(N'2022-06-22T02:15:16.500' AS DateTime))
INSERT [sSecurity].[tStaticUserType] ([Id], [Title], [IsObsolete], [CreateDate]) VALUES (6, N'Truck Owner', 0, CAST(N'2022-06-30T10:18:58.817' AS DateTime))
GO
SET IDENTITY_INSERT [sSecurity].[tTruck] ON 

INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2002, -999, N'TK01 1101', 1, 0, CAST(N'2023-02-11T22:52:57.027' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2003, -999, N'TK01 1102', 1, 0, CAST(N'2023-02-11T22:53:11.843' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2004, 103007, N'OTHER02 2201', 0, 0, CAST(N'2023-02-11T23:03:23.870' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2005, 104009, N'AB BQ1023', 0, 0, CAST(N'2023-07-24T20:35:44.243' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2006, 104013, N'PC PS2301', 0, 0, CAST(N'2023-07-24T20:52:05.350' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2007, 104015, N'CD WX8596', 0, 0, CAST(N'2023-07-24T20:55:54.140' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2008, 104017, N'mh 12 tj12354', 0, 0, CAST(N'2023-07-24T21:06:48.443' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2009, 104021, N'mh 24 us 3214', 0, 0, CAST(N'2023-07-24T21:17:09.697' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2010, 104026, N'mh87nm8976', 0, 0, CAST(N'2023-07-24T22:02:37.477' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2011, 104032, N'mh45lm9823', 0, 0, CAST(N'2023-07-24T22:19:23.350' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2012, 104033, N'mh 87 hg 7658', 0, 0, CAST(N'2023-07-24T22:22:00.590' AS DateTime), 102, NULL, NULL)
SET IDENTITY_INSERT [sSecurity].[tTruck] OFF
GO
SET IDENTITY_INSERT [sSecurity].[tUser] ON 

INSERT [sSecurity].[tUser] ([Id], [Name], [MobileNumber], [EmailId], [UserTypeId], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [IsObsolete]) VALUES (101, N'Sumit Khaparde', N'7066766702', N'sumit@gmail.com', 1, CAST(N'2022-09-03T10:07:34.470' AS DateTime), -99, NULL, NULL, 0)
INSERT [sSecurity].[tUser] ([Id], [Name], [MobileNumber], [EmailId], [UserTypeId], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [IsObsolete]) VALUES (102, N'Sainath Landge', N'8007958152', N'sai@gmail.com', 1, CAST(N'2022-09-03T10:07:55.110' AS DateTime), -99, NULL, NULL, 0)
SET IDENTITY_INSERT [sSecurity].[tUser] OFF
GO
INSERT [sSecurity].[tUserCredentials] ([UserId], [OldPassword], [NewPassword], [LoginAttempts]) VALUES (101, NULL, N'test@123', 10)
INSERT [sSecurity].[tUserCredentials] ([UserId], [OldPassword], [NewPassword], [LoginAttempts]) VALUES (102, NULL, N'test@123', 8)
GO
SET IDENTITY_INSERT [sSecurity].[tUserMaster] ON 

INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (102006, 5, N'Virat Supplier', N'8254454848', N'virat@gmail.com', N'Address', NULL, 2, 1720, 22, NULL, 0, CAST(N'2023-02-01T09:06:17.187' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (102007, 3, N'Rohit Dealer', N'8965235545', N'rohit@gmail.com', N'Address', N'Rohit Private Limited', 4, 1720, 22, NULL, 0, CAST(N'2023-02-01T09:07:33.290' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (102008, 2, N'Dhawan Customer', N'5745645454', N'dhawan@gmail.com', N'Customer Address', NULL, 11, 1679, 22, NULL, 0, CAST(N'2023-02-01T09:09:02.143' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (102009, 4, N'Javed Ali', N'8478784654', NULL, N'Pune', NULL, 17, 1679, 22, NULL, 0, CAST(N'2023-02-01T09:18:36.587' AS DateTime), 102, CAST(N'2023-07-21T23:19:30.233' AS DateTime), 102, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (103007, 6, N'Wasim Jafer', N'8956741235', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-02-11T23:03:23.647' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (103008, 4, N'Imran Khan ', N'8956321452', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-22T08:44:43.933' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (103009, 3, N'Narendra Modi', N'7485968545', N'narendra@gmail.com', N'Paldi', N'India Private Limited, Gujrat', 16, 1679, 22, NULL, 0, CAST(N'2023-07-22T08:46:56.810' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (103010, 4, N'TK Driver 1', N'2584546464', NULL, N'Hinjewadi, Pune', NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-22T08:52:47.823' AS DateTime), 102, NULL, NULL, 1)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (103011, 5, N'Amit Shah', N'5646386786', N'amit@gmail.com', N'Ambedkar Nagar Delhi', NULL, 12, 1679, 22, NULL, 0, CAST(N'2023-07-22T09:53:34.183' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104008, 4, N'Salim SHaikh', N'6545545415', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T20:35:43.747' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104009, 6, N'AB BQ1023', N'8745455455', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T20:35:44.227' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104010, 5, N'suraj sune', N'8748454545', N'suraj@gmai.com', N'Test address', NULL, 3, 1720, 22, NULL, 0, CAST(N'2023-07-24T20:37:25.797' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104011, 5, N'Rohit Sharma', N'5645589552', N'rohit@gmail.com', N'test address', NULL, 16, 1679, 22, NULL, 0, CAST(N'2023-07-24T20:43:42.883' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104012, 4, N'Wasim Akram', N'3265413214', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T20:52:05.313' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104013, 6, N'Vishal Dhawale', N'5431489161', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T20:52:05.340' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104014, 4, N'Ahmed Shaikh', N'6517987146', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T20:55:54.097' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104015, 6, N'Yukesh Bansod', N'2350925498', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T20:55:54.130' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104016, 5, N'sumit khaparde', N'6352990265', N'sk@gmail.com', N'test1', NULL, 6, 1720, 22, NULL, 0, CAST(N'2023-07-24T21:00:47.917' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104017, 6, N'Rohit Mahto', N'0329562306', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T21:06:48.423' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104018, 5, N'aniket pawar', N'6523256233', N'ap@gmail.com', N'test1', NULL, 17, 1679, 22, NULL, 0, CAST(N'2023-07-24T21:08:52.623' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104019, 5, N'shubham pawar', N'3520165346', N'Sp@gmail.com', N'test1', NULL, 14, 1679, 22, NULL, 0, CAST(N'2023-07-24T21:13:16.833' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104020, 4, N'shubham charde', N'4986430532', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T21:17:09.650' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104021, 6, N'Dipak Mokashe', N'5340894198', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T21:17:09.683' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104022, 5, N'shubham pal', N'3540654816', N'SPal@gmail.com', N'test1', NULL, 2, 1720, 22, NULL, 0, CAST(N'2023-07-24T21:37:52.970' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104023, 4, N'nilesh kumre', N'9879685465', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T21:40:34.387' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104024, 5, N'shubham karkade', N'8476742486', N'Shubham@gmail.com', N'test1', NULL, 17, 1679, 22, NULL, 0, CAST(N'2023-07-24T21:42:17.793' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104025, 4, N'irfan sheikh', N'5487897974', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T22:02:37.447' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104026, 6, N'mh87nm8976', N'8978646545', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T22:02:37.470' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104027, 3, N'rahul avhad', N'8374684946', N'rahul@gmail.com', N'Address', N'Rahul Company', 11, 1679, 22, NULL, 0, CAST(N'2023-07-24T22:05:52.003' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104028, 3, N'rahul bhonge', N'6867869445', N'rahul@gmail.com', N'test', N'rahul bhonge', 15, 1679, 22, NULL, 0, CAST(N'2023-07-24T22:09:34.143' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104029, 3, N'ganesh akare', N'8748647848', N'ganesh@gmail.com', N'Ganesh address', N'ganesh akare company', 1, 1720, 22, NULL, 0, CAST(N'2023-07-24T22:15:23.847' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104030, 3, N'pratik sakhare', N'8248646526', N'pratik@gmail.com', N'Address', N'Azure Company', 4, 1720, 22, NULL, 0, CAST(N'2023-07-24T22:16:43.510' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104031, 5, N'chetan dhoke', N'9842978487', N'test@gmail.com', N'chetan dhoke address', NULL, 3, 1720, 22, NULL, 0, CAST(N'2023-07-24T22:17:43.457' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104032, 6, N'Ganesh', N'5448948945', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T22:19:23.343' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (104033, 6, N'mh 87 hg 7658 owner', N'8959464646', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2023-07-24T22:22:00.583' AS DateTime), 102, NULL, NULL, 0)
SET IDENTITY_INSERT [sSecurity].[tUserMaster] OFF
GO
SET IDENTITY_INSERT [sSecurity].[tUserSite] ON 

INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10001, 102006, N'Virat Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10002, 102006, N'Virat Site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10003, 102007, N'Rohit Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10004, 102007, N'Rohit Site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10005, 102008, NULL)
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (11002, 103009, N'Ahmedabad site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (11003, 103009, N'Gandhinagar site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (11004, 103011, N'Delhi')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12002, 104010, N'Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12003, 104010, N'Site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12004, 104011, N'site1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12005, 104016, N'site1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12006, 104018, N'site1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12007, 104019, N'site1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12008, 104022, N'site1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12009, 104024, N'site1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12010, 104027, N'Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12011, 104028, N'Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12012, 104029, N'Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12013, 104029, N'Site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12014, 104030, N'Site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12015, 104030, N'Site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (12016, 104031, N'chetan dhoke site')
SET IDENTITY_INSERT [sSecurity].[tUserSite] OFF
GO
/****** Object:  Index [UQ__tStock__C3905BCE35A9007A]    Script Date: 04/08/2023 1:59:36 pm ******/
ALTER TABLE [sInventory].[tStock] ADD UNIQUE NONCLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_Unique_Truck_Number]    Script Date: 04/08/2023 1:59:36 pm ******/
ALTER TABLE [sSecurity].[tTruck] ADD  CONSTRAINT [UK_Unique_Truck_Number] UNIQUE NONCLUSTERED 
(
	[Truck_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__tUser__250375B1F0AF9BC8]    Script Date: 04/08/2023 1:59:36 pm ******/
ALTER TABLE [sSecurity].[tUser] ADD UNIQUE NONCLUSTERED 
(
	[MobileNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__tUserMas__250375B1A76CE69D]    Script Date: 04/08/2023 1:59:36 pm ******/
ALTER TABLE [sSecurity].[tUserMaster] ADD UNIQUE NONCLUSTERED 
(
	[MobileNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
/****** Object:  StoredProcedure [sInventory].[usp_GetAvailableStock]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sInventory].[usp_GetAvailableStockbkp]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sInventory].[usp_GetOrders]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[tUserDelete]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_CleanupData]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard]    Script Date: 04/08/2023 1:59:36 pm ******/
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
 @exportProfit = SUM(t2.SellAmount - t2.BuyAmount) 
from sInventory.tOrder t1
			INNER JOIN sInventory.tOrderProductDetails t2 on t1.OrderId=t2.OrderId
			WHERE t1.TransportTypeId = 2 and t2.SellAmount >= t2.BuyAmount
			
SELECT 
 @overallLoss = @overallLoss + ISNULL(SUM(t2.BuyAmount-t2.SellAmount),0) 
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
 @overallLoss = @overallLoss + ISNULL(SUM(t2.BuyAmount-t2.SellAmount),0) 
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard_bkp]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard_Temp]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetInvoiceByUserId]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetUserAmount]    Script Date: 04/08/2023 1:59:36 pm ******/
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
/****** Object:  StoredProcedure [sTransport].[usp_GetTransports]    Script Date: 04/08/2023 1:59:36 pm ******/
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
