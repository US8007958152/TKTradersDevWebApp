USE [master]
GO
/****** Object:  Database [TKTradersDB]    Script Date: 26/01/2023 4:45:43 pm ******/
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
/****** Object:  Schema [sInventory]    Script Date: 26/01/2023 4:45:44 pm ******/
CREATE SCHEMA [sInventory]
GO
/****** Object:  Schema [sSecurity]    Script Date: 26/01/2023 4:45:44 pm ******/
CREATE SCHEMA [sSecurity]
GO
/****** Object:  Schema [sTransport]    Script Date: 26/01/2023 4:45:44 pm ******/
CREATE SCHEMA [sTransport]
GO
/****** Object:  Table [sInventory].[tOrder]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tOrderProductDetails]    Script Date: 26/01/2023 4:45:44 pm ******/
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
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tOrderTruckDetails]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tProduct]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tProductType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tStaticStatusType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tStaticStockType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tStaticTransportType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tStaticView]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tStock]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sInventory].[tStockInvestment]    Script Date: 26/01/2023 4:45:44 pm ******/
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
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [sInventory].[tView]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tCity]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[TCity_temp]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tDistrict]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[TDistrict_temp]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tLogError]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tNotification]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tState]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[TState_temp]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tStaticFuelType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tStaticPaymentType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tStaticUserType]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tTruck]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tTruckFuel]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tUser]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tUserCredentials]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tUserMaster]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tUserSite]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sSecurity].[tUserTransaction]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sTransport].[tTransport]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sTransport].[tTransportProductDetails]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  Table [sTransport].[tTransportTruckDetails]    Script Date: 26/01/2023 4:45:44 pm ******/
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
SET IDENTITY_INSERT [sInventory].[tOrder] ON 

INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1005060, 1, 100005, 0, CAST(N'2023-01-26T00:00:00.000' AS DateTime), 2, 2, 100003, 1, 0, 0, NULL, CAST(N'2023-01-26T13:14:17.013' AS DateTime), 102, NULL, NULL, 10003, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1005061, 1, 100006, 0, CAST(N'2023-01-26T00:00:00.000' AS DateTime), 2, 1, 100003, 0, 0, 0, N'dfssfdhfdh', CAST(N'2023-01-26T13:15:33.383' AS DateTime), 102, NULL, NULL, 10006, 0)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1005062, 2, 0, 100001, CAST(N'2023-01-26T00:00:00.000' AS DateTime), 2, 2, 100003, 1, 0, 0, N'ewfewg', CAST(N'2023-01-26T13:34:25.533' AS DateTime), 102, NULL, NULL, 0, 10001)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1005063, 2, 0, 100001, CAST(N'2023-01-26T00:00:00.000' AS DateTime), 2, 3, 100003, 1, 0, 0, N'retertrey', CAST(N'2023-01-26T13:47:53.980' AS DateTime), 102, NULL, NULL, 0, 10001)
INSERT [sInventory].[tOrder] ([OrderId], [TransportTypeId], [SupplierId], [CustomerId], [OrderDate], [StatusTypeId], [TruckId], [DriverId], [IsInternalTruck], [IsInternalDriver], [IsObsolete], [Comments], [CreateDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [SenderSiteId], [ReceiverSiteId]) VALUES (1005064, 2, 0, 100001, CAST(N'2023-01-26T00:00:00.000' AS DateTime), 2, 3, 100003, 1, 0, 0, N'dfsfsg', CAST(N'2023-01-26T14:16:03.703' AS DateTime), 102, NULL, NULL, 0, 10001)
SET IDENTITY_INSERT [sInventory].[tOrder] OFF
GO
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders]) VALUES (1005060, 1, 1, CAST(5000 AS Decimal(18, 0)), 3, CAST(40000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 3, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders]) VALUES (1005061, 1, 1, CAST(5000 AS Decimal(18, 0)), 3, CAST(40000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 3, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders]) VALUES (1005062, 1, 1, CAST(2000 AS Decimal(18, 0)), 1, CAST(16000.00 AS Decimal(18, 2)), CAST(18000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), N'[{"OrderId":1005060,"Quantity":2000.0,"Amount":16000.00}]')
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders]) VALUES (1005063, 1, 1, CAST(4000 AS Decimal(18, 0)), 1, CAST(32000.00 AS Decimal(18, 2)), CAST(36000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), N'[{"OrderId":1005060,"Quantity":3000.00,"Amount":24000.0000},{"OrderId":1005061,"Quantity":1000.00,"Amount":8000.0000}]')
INSERT [sInventory].[tOrderProductDetails] ([OrderId], [ProductId], [ProductTypeId], [Quantity], [PaymentTypeId], [BuyAmount], [SellAmount], [SellPaidAmount], [StockTypeId], [RemainingQuantity], [ReferredOrders]) VALUES (1005064, 1, 1, CAST(4000 AS Decimal(18, 0)), 1, CAST(32000.00 AS Decimal(18, 2)), CAST(34000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), N'[{"OrderId":1005061,"Quantity":4000.0,"Amount":32000.00}]')
GO
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1005060, -111, 3, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1005061, 100004, 1, CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1005062, -111, 1, CAST(234.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1005063, -111, 1, CAST(450.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [sInventory].[tOrderTruckDetails] ([OrderId], [TruckOwnerId], [PaymentTypeId], [TruckRent], [PaidRent]) VALUES (1005064, -111, 1, CAST(410.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
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

INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (4029, 1005060, 1, 1, 1, CAST(5000 AS Decimal(18, 0)), 0, CAST(N'2023-01-26T13:14:17.547' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (4030, 1005061, 1, 1, 1, CAST(5000 AS Decimal(18, 0)), 0, CAST(N'2023-01-26T13:15:33.420' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (4031, 1005062, 1, 1, 2, CAST(2000 AS Decimal(18, 0)), 0, CAST(N'2023-01-26T13:34:32.107' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (4032, 1005063, 1, 1, 2, CAST(4000 AS Decimal(18, 0)), 0, CAST(N'2023-01-26T13:47:54.517' AS DateTime), 102, 1, NULL)
INSERT [sInventory].[tStock] ([Id], [OrderId], [ProductId], [ProductTypeId], [TransportTypeId], [Quantity], [IsObsolete], [CreatedDate], [CreatedBy], [StockTypeId], [Title]) VALUES (4033, 1005064, 1, 1, 2, CAST(4000 AS Decimal(18, 0)), 0, CAST(N'2023-01-26T14:16:03.763' AS DateTime), 102, 1, NULL)
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
SET IDENTITY_INSERT [sSecurity].[tNotification] ON 

INSERT [sSecurity].[tNotification] ([Id], [UserId], [UserTypeId], [StatusTypeId], [MobileNumber], [Message], [CreatedDateTime]) VALUES (1, 100001, 0, 0, N'6548454545', N'The From phone number +12342616718 is not a valid, SMS-capable inbound phone number or short code for your account.', CAST(N'2023-01-26T13:34:36.133' AS DateTime))
INSERT [sSecurity].[tNotification] ([Id], [UserId], [UserTypeId], [StatusTypeId], [MobileNumber], [Message], [CreatedDateTime]) VALUES (2, 102, 0, 0, N'8007958152', N'The From phone number +12342616718 is not a valid, SMS-capable inbound phone number or short code for your account.', CAST(N'2023-01-26T13:34:36.777' AS DateTime))
INSERT [sSecurity].[tNotification] ([Id], [UserId], [UserTypeId], [StatusTypeId], [MobileNumber], [Message], [CreatedDateTime]) VALUES (3, 100001, 0, 0, N'6548454545', N'The From phone number +12342616718 is not a valid, SMS-capable inbound phone number or short code for your account.', CAST(N'2023-01-26T13:47:59.347' AS DateTime))
INSERT [sSecurity].[tNotification] ([Id], [UserId], [UserTypeId], [StatusTypeId], [MobileNumber], [Message], [CreatedDateTime]) VALUES (4, 102, 0, 0, N'8007958152', N'The From phone number +12342616718 is not a valid, SMS-capable inbound phone number or short code for your account.', CAST(N'2023-01-26T13:48:00.340' AS DateTime))
INSERT [sSecurity].[tNotification] ([Id], [UserId], [UserTypeId], [StatusTypeId], [MobileNumber], [Message], [CreatedDateTime]) VALUES (5, 100001, 0, 0, N'6548454545', N'The From phone number +12342616718 is not a valid, SMS-capable inbound phone number or short code for your account.', CAST(N'2023-01-26T14:16:08.420' AS DateTime))
INSERT [sSecurity].[tNotification] ([Id], [UserId], [UserTypeId], [StatusTypeId], [MobileNumber], [Message], [CreatedDateTime]) VALUES (6, 102, 0, 0, N'8007958152', N'The From phone number +12342616718 is not a valid, SMS-capable inbound phone number or short code for your account.', CAST(N'2023-01-26T14:16:10.153' AS DateTime))
SET IDENTITY_INSERT [sSecurity].[tNotification] OFF
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

INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (1, 100004, N'545645', 0, 0, CAST(N'2022-09-03T11:14:31.893' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (2, -111, N'TK Truck 1', 1, 0, CAST(N'2022-09-18T10:53:03.240' AS DateTime), 102, NULL, NULL)
INSERT [sSecurity].[tTruck] ([Id], [UserId], [Truck_Number], [IsInternalTruck], [IsObsolete], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy]) VALUES (3, -111, N'TK Truck 2', 1, 0, CAST(N'2022-09-18T10:53:12.187' AS DateTime), 102, NULL, NULL)
SET IDENTITY_INSERT [sSecurity].[tTruck] OFF
GO
SET IDENTITY_INSERT [sSecurity].[tUser] ON 

INSERT [sSecurity].[tUser] ([Id], [Name], [MobileNumber], [EmailId], [UserTypeId], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [IsObsolete]) VALUES (101, N'Sumit Khaparde', N'7066766702', N'sumit@gmail.com', 1, CAST(N'2022-09-03T10:07:34.470' AS DateTime), -99, NULL, NULL, 0)
INSERT [sSecurity].[tUser] ([Id], [Name], [MobileNumber], [EmailId], [UserTypeId], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [IsObsolete]) VALUES (102, N'Sainath Landge', N'8007958152', N'sai@gmail.com', 1, CAST(N'2022-09-03T10:07:55.110' AS DateTime), -99, NULL, NULL, 0)
SET IDENTITY_INSERT [sSecurity].[tUser] OFF
GO
INSERT [sSecurity].[tUserCredentials] ([UserId], [OldPassword], [NewPassword], [LoginAttempts]) VALUES (101, NULL, N'test@123', 10)
INSERT [sSecurity].[tUserCredentials] ([UserId], [OldPassword], [NewPassword], [LoginAttempts]) VALUES (102, NULL, N'test@123', 10)
GO
SET IDENTITY_INSERT [sSecurity].[tUserMaster] ON 

INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (100001, 5, N'Supplier', N'6548454545', NULL, N'hjgj', NULL, 3, 1720, 22, NULL, 0, CAST(N'2022-09-03T10:52:46.523' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (100002, 2, N'customer', N'5445445454', NULL, N'grhdhgfj', NULL, 16, 1679, 22, NULL, 0, CAST(N'2022-09-03T10:53:03.377' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (100003, 4, N'test driver', N'8741654156', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2022-09-03T11:14:31.643' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (100004, 6, N'test owner', N'5454654654', NULL, NULL, NULL, 0, 0, 0, NULL, 0, CAST(N'2022-09-03T11:14:31.887' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (100005, 3, N'Dealer 1', N'8955354445', N'dealer@gmail.com', N'address', N'company testing', 3, 1720, 22, NULL, 0, CAST(N'2022-09-18T09:41:04.067' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (100006, 3, N'dealer 2', N'8595554455', N'test@gmail.com', N'test address', N'company name 2', 2, 1720, 22, NULL, 0, CAST(N'2022-09-18T09:42:18.610' AS DateTime), 102, NULL, NULL, 0)
INSERT [sSecurity].[tUserMaster] ([UserId], [UserTypeId], [Name], [MobileNumber], [EmailId], [Address], [Company], [CityId], [DistrictId], [StateId], [Password], [IsObsolete], [CreatedDateTime], [CreatedBy], [UpdateDateTime], [UpdatedBy], [IsInternalDriver]) VALUES (101005, 7, N'Test Petrol Pump', N'5847854544', N'test@gmail.com', N'test address', NULL, 3, 1720, 22, NULL, 0, CAST(N'2022-09-25T08:21:03.960' AS DateTime), 102, NULL, NULL, 0)
SET IDENTITY_INSERT [sSecurity].[tUserMaster] OFF
GO
SET IDENTITY_INSERT [sSecurity].[tUserSite] ON 

INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10001, 100001, N'test site address')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10002, 100002, NULL)
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10003, 100005, N'site 1 address')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10004, 100005, N'site 2 address')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10005, 100006, N'dealer 2 site 1')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (10006, 100006, N'dealer 2 site 2')
INSERT [sSecurity].[tUserSite] ([SiteId], [UserId], [SiteAddress]) VALUES (11003, 101005, NULL)
SET IDENTITY_INSERT [sSecurity].[tUserSite] OFF
GO
/****** Object:  Index [UQ__tStock__C3905BCE35A9007A]    Script Date: 26/01/2023 4:45:44 pm ******/
ALTER TABLE [sInventory].[tStock] ADD UNIQUE NONCLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_Unique_Truck_Number]    Script Date: 26/01/2023 4:45:44 pm ******/
ALTER TABLE [sSecurity].[tTruck] ADD  CONSTRAINT [UK_Unique_Truck_Number] UNIQUE NONCLUSTERED 
(
	[Truck_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__tUser__250375B1F0AF9BC8]    Script Date: 26/01/2023 4:45:44 pm ******/
ALTER TABLE [sSecurity].[tUser] ADD UNIQUE NONCLUSTERED 
(
	[MobileNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__tUserMas__250375B1A76CE69D]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sInventory].[usp_GetAvailableStock]    Script Date: 26/01/2023 4:45:44 pm ******/
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
	select product.Id as ProductId,productType.Id as ProductTypeId,productType.Title+' '+product.Title as ProductName,productType.ImagePath,SUM(case when stock.TransportTypeId=1 OR stock.TransportTypeId=6  then stock.Quantity when stock.TransportTypeId=2 or stock.TransportTypeId=5 then stock.Quantity*(-1) else 0 end )+ISNULL(productDetails.Quantity,0) as Stock 
	  from sInventory.tProduct product 
	inner join	sInventory.tProductType productType on product.Id=productType.ProductId
	left join	sInventory.tStock stock on stock.IsObsolete=0 and stock.TransportTypeId in(1,2,5,6) and product.Id=stock.ProductId and productType.Id=stock.ProductTypeId
	left join sInventory.tOrderProductDetails productDetails on productDetails.OrderId=@rTransportTypeId and productDetails.ProductId=stock.ProductId and productDetails.ProductTypeId=stock.ProductTypeId
	where (product.Id=@rProductId or ISNULL(@rProductId,0)=0) and (productType.Id=@rProductTypeId or ISNULL(@rProductTypeId,0)=0)
	group by product.Id,productType.Id,productType.Title,product.Title,productType.ImagePath,productDetails.Quantity
	order by product.Id,productType.Id

END
GO
/****** Object:  StoredProcedure [sInventory].[usp_GetAvailableStockbkp]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sInventory].[usp_GetOrders]    Script Date: 26/01/2023 4:45:44 pm ******/
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
where M1.IsObsolete=0 AND M1.TransportTypeId!=3 AND (ISNULL(@rUserId,0)=0 OR M1.CustomerId=@rUserId OR M1.SupplierId=@rUserId OR M3.TruckOwnerId=@rUserId)
order by M1.UpdatedDateTime,M1.CreateDateTime desc
END
GO
/****** Object:  StoredProcedure [sSecurity].[tUserDelete]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_CleanupData]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetDashBoard_Temp]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetInvoiceByUserId]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sSecurity].[usp_GetUserAmount]    Script Date: 26/01/2023 4:45:44 pm ******/
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
/****** Object:  StoredProcedure [sTransport].[usp_GetTransports]    Script Date: 26/01/2023 4:45:44 pm ******/
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
