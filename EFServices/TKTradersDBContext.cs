using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using TKTradersWebApp.Areas.Securities.Models;

namespace TKTradersWebApp.EFServices
{
    public partial class TKTradersDBContext : DbContext
    {
        public TKTradersDBContext()
        {
        }

        public TKTradersDBContext(DbContextOptions<TKTradersDBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<TCity> TCities { get; set; } = null!;
        public virtual DbSet<TDistrict> TDistricts { get; set; } = null!;
        public virtual DbSet<TLogError> TLogErrors { get; set; } = null!;
        public virtual DbSet<TNotification> TNotifications { get; set; } = null!;
        public virtual DbSet<TOrder> TOrders { get; set; } = null!;
        public virtual DbSet<TOrderProductDetail> TOrderProductDetails { get; set; } = null!;
        public virtual DbSet<TOrderTruckDetail> TOrderTruckDetails { get; set; } = null!;
        public virtual DbSet<TProduct> TProducts { get; set; } = null!;
        public virtual DbSet<TProductType> TProductTypes { get; set; } = null!;
        public virtual DbSet<TState> TStates { get; set; } = null!;
        public virtual DbSet<TStaticFuelType> TStaticFuelTypes { get; set; } = null!;
        public virtual DbSet<TStaticPaymentType> TStaticPaymentTypes { get; set; } = null!;
        public virtual DbSet<TStaticStatusType> TStaticStatusTypes { get; set; } = null!;
        public virtual DbSet<TStaticStockType> TStaticStockTypes { get; set; } = null!;
        public virtual DbSet<TStaticTransportType> TStaticTransportTypes { get; set; } = null!;
        public virtual DbSet<TStaticUserType> TStaticUserTypes { get; set; } = null!;
        public virtual DbSet<TStaticView> TStaticViews { get; set; } = null!;
        public virtual DbSet<TStock> TStocks { get; set; } = null!;
        public virtual DbSet<TStockInvestment> TStockInvestments { get; set; } = null!;
        public virtual DbSet<TTransport> TTransports { get; set; } = null!;
        public virtual DbSet<TTransportProductDetail> TTransportProductDetails { get; set; } = null!;
        public virtual DbSet<TTransportTruckDetail> TTransportTruckDetails { get; set; } = null!;
        public virtual DbSet<TTruck> TTrucks { get; set; } = null!;
        public virtual DbSet<TTruckFuel> TTruckFuels { get; set; } = null!;
        public virtual DbSet<TUser> TUsers { get; set; } = null!;
        public virtual DbSet<TUserCredential> TUserCredentials { get; set; } = null!;
        public virtual DbSet<TUserMaster> TUserMasters { get; set; } = null!;
        public virtual DbSet<TUserSite> TUserSites { get; set; } = null!;
        public virtual DbSet<TUserTransaction> TUserTransactions { get; set; } = null!;
        public virtual DbSet<TView> TViews { get; set; } = null!;
        public virtual DbSet<TcityTemp> TcityTemps { get; set; } = null!;
        public virtual DbSet<TdistrictTemp> TdistrictTemps { get; set; } = null!;
        public virtual DbSet<TstateTemp> TstateTemps { get; set; } = null!;

        public virtual DbSet<USPGetInvoiceByUserId> USPGetInvoiceByUserIds { get; set; } = null!;
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                //optionsBuilder.UseSqlServer("Server=.\\SQLExpress;Database=TKTradersDB;Trusted_Connection=True;");
                optionsBuilder.UseSqlServer("Data Source=SQL5110.site4now.net;Initial Catalog=db_a9c1f5_admin;User Id=db_a9c1f5_admin_admin;Password=Admin123;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TCity>(entity =>
            {
                entity.ToTable("tCity", "sSecurity");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<TDistrict>(entity =>
            {
                entity.ToTable("tDistrict", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<TLogError>(entity =>
            {
                entity.ToTable("tLogError", "sSecurity");

                entity.Property(e => e.CreateDate).HasColumnType("datetime");
            });

            modelBuilder.Entity<TNotification>(entity =>
            {
                entity.ToTable("tNotification", "sSecurity");

                entity.Property(e => e.CreatedDateTime).HasColumnType("datetime");

                entity.Property(e => e.MobileNumber).HasMaxLength(10);
            });

            modelBuilder.Entity<TOrder>(entity =>
            {
                entity.HasKey(e => e.OrderId)
                    .HasName("PK__tOrder__C3905BCF281A6AEC");

                entity.ToTable("tOrder", "sInventory");

                entity.Property(e => e.Comments).HasMaxLength(4000);

                entity.Property(e => e.CreateDateTime).HasColumnType("datetime");

                entity.Property(e => e.OrderDate).HasColumnType("datetime");

                entity.Property(e => e.UpdatedDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<TOrderProductDetail>(entity =>
            {
                entity.HasKey(e => e.OrderId)
                    .HasName("PK__tOrderPr__C3905BCFCC023509");

                entity.ToTable("tOrderProductDetails", "sInventory");

                entity.Property(e => e.OrderId).ValueGeneratedNever();

                entity.Property(e => e.BuyAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.InvestmenOrderIds)
                    .IsUnicode(false)
                    .HasColumnName("InvestmenOrderIDs");

                entity.Property(e => e.Quantity).HasColumnType("decimal(18, 0)");

                entity.Property(e => e.ReferredOrders).IsUnicode(false);

                entity.Property(e => e.RemainingQuantity).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.SellAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.SellPaidAmount).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Order)
                    .WithOne(p => p.TOrderProductDetail)
                    .HasForeignKey<TOrderProductDetail>(d => d.OrderId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ProductDetails_Order");
            });

            modelBuilder.Entity<TOrderTruckDetail>(entity =>
            {
                entity.HasKey(e => e.OrderId)
                    .HasName("PK__tOrderTr__C3905BCFE019173D");

                entity.ToTable("tOrderTruckDetails", "sInventory");

                entity.Property(e => e.OrderId).ValueGeneratedNever();

                entity.Property(e => e.PaidRent).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.TruckRent).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Order)
                    .WithOne(p => p.TOrderTruckDetail)
                    .HasForeignKey<TOrderTruckDetail>(d => d.OrderId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_TruckDetails_Order");
            });

            modelBuilder.Entity<TProduct>(entity =>
            {
                entity.ToTable("tProduct", "sInventory");

                entity.Property(e => e.CreatedBy).HasMaxLength(50);

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.Title).HasMaxLength(50);

                entity.Property(e => e.UpdateBy).HasMaxLength(50);

                entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            });

            modelBuilder.Entity<TProductType>(entity =>
            {
                entity.ToTable("tProductType", "sInventory");

                entity.Property(e => e.ColorCode).HasMaxLength(50);

                entity.Property(e => e.CreatedBy).HasMaxLength(50);

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.ImagePath).HasMaxLength(100);

                entity.Property(e => e.Title).HasMaxLength(50);

                entity.Property(e => e.UpdateBy).HasMaxLength(50);

                entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.TProductTypes)
                    .HasForeignKey(d => d.ProductId)
                    .HasConstraintName("FK_Product");
            });

            modelBuilder.Entity<TState>(entity =>
            {
                entity.ToTable("tState", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<TStaticFuelType>(entity =>
            {
                entity.ToTable("tStaticFuelType", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TStaticPaymentType>(entity =>
            {
                entity.ToTable("tStaticPaymentType", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TStaticStatusType>(entity =>
            {
                entity.ToTable("tStaticStatusType", "sInventory");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TStaticStockType>(entity =>
            {
                entity.ToTable("tStaticStockType", "sInventory");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Title).HasMaxLength(20);
            });

            modelBuilder.Entity<TStaticTransportType>(entity =>
            {
                entity.ToTable("tStaticTransportType", "sInventory");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CreatedDateTime).HasColumnType("datetime");

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TStaticUserType>(entity =>
            {
                entity.ToTable("tStaticUserType", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CreateDate).HasColumnType("datetime");

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TStaticView>(entity =>
            {
                entity.ToTable("tStaticView", "sInventory");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TStock>(entity =>
            {
                entity.ToTable("tStock", "sInventory");

                entity.HasIndex(e => e.OrderId, "UQ__tStock__C3905BCE35A9007A")
                    .IsUnique();

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.Quantity).HasColumnType("decimal(18, 0)");

                entity.Property(e => e.StockTypeId).HasDefaultValueSql("((1))");

                entity.Property(e => e.Title).HasMaxLength(150);

                entity.HasOne(d => d.Order)
                    .WithOne(p => p.TStock)
                    .HasForeignKey<TStock>(d => d.OrderId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__tStock__OrderId__25518C17");
            });

            modelBuilder.Entity<TStockInvestment>(entity =>
            {
                entity.ToTable("tStockInvestment", "sInventory");

                entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Quantity).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Stock)
                    .WithMany(p => p.TStockInvestments)
                    .HasForeignKey(d => d.StockId)
                    .HasConstraintName("FK__tStockInv__Stock__0880433F");
            });

            modelBuilder.Entity<TTransport>(entity =>
            {
                entity.HasKey(e => e.TransportId)
                    .HasName("PK__tTranspo__19E9A11D8E391A4C");

                entity.ToTable("tTransport", "sTransport");

                entity.Property(e => e.Comments).HasMaxLength(4000);

                entity.Property(e => e.CreateDateTime).HasColumnType("datetime");

                entity.Property(e => e.TransportDate).HasColumnType("datetime");

                entity.Property(e => e.UpdatedDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<TTransportProductDetail>(entity =>
            {
                entity.HasKey(e => e.TransportId)
                    .HasName("PK__tTranspo__19E9A11DC7C1E198");

                entity.ToTable("tTransportProductDetails", "sTransport");

                entity.Property(e => e.TransportId).ValueGeneratedNever();

                entity.Property(e => e.PaidAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Quantity).HasColumnType("decimal(18, 0)");

                entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Transport)
                    .WithOne(p => p.TTransportProductDetail)
                    .HasForeignKey<TTransportProductDetail>(d => d.TransportId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ProductDetails_Transport");
            });

            modelBuilder.Entity<TTransportTruckDetail>(entity =>
            {
                entity.HasKey(e => e.TransportId)
                    .HasName("PK__tTranspo__19E9A11DC1DD66F8");

                entity.ToTable("tTransportTruckDetails", "sTransport");

                entity.Property(e => e.TransportId).ValueGeneratedNever();

                entity.Property(e => e.PaidAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Transport)
                    .WithOne(p => p.TTransportTruckDetail)
                    .HasForeignKey<TTransportTruckDetail>(d => d.TransportId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_TruckDetails_Transport");
            });

            modelBuilder.Entity<TTruck>(entity =>
            {
                entity.ToTable("tTruck", "sSecurity");

                entity.HasIndex(e => e.TruckNumber, "UK_Unique_Truck_Number")
                    .IsUnique();

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.TruckNumber)
                    .HasMaxLength(20)
                    .HasColumnName("Truck_Number");

                entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            });

            modelBuilder.Entity<TTruckFuel>(entity =>
            {
                entity.ToTable("tTruckFuel", "sSecurity");

                entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Comments).HasMaxLength(4000);

                entity.Property(e => e.CreatedDateTime).HasColumnType("datetime");

                entity.Property(e => e.CurrentReading).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Quantity).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Rate).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.UpdatedDateTime).HasColumnType("datetime");

                entity.HasOne(d => d.PetrolPumpUser)
                    .WithMany(p => p.TTruckFuels)
                    .HasForeignKey(d => d.PetrolPumpUserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__tTruckFue__Petro__6477ECF3");

                entity.HasOne(d => d.Truck)
                    .WithMany(p => p.TTruckFuels)
                    .HasForeignKey(d => d.TruckId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__tTruckFue__Truck__656C112C");
            });

            modelBuilder.Entity<TUser>(entity =>
            {
                entity.ToTable("tUser", "sSecurity");

                entity.HasIndex(e => e.MobileNumber, "UQ__tUser__250375B1F0AF9BC8")
                    .IsUnique();

                entity.Property(e => e.CreatedDateTime).HasColumnType("datetime");

                entity.Property(e => e.EmailId).HasMaxLength(100);

                entity.Property(e => e.MobileNumber).HasMaxLength(12);

                entity.Property(e => e.Name).HasMaxLength(200);

                entity.Property(e => e.UpdatedDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<TUserCredential>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PK__tUserCre__1788CC4CE71BD53A");

                entity.ToTable("tUserCredentials", "sSecurity");

                entity.Property(e => e.UserId).ValueGeneratedNever();

                entity.Property(e => e.LoginAttempts).HasDefaultValueSql("((5))");

                entity.Property(e => e.NewPassword).HasMaxLength(12);

                entity.Property(e => e.OldPassword).HasMaxLength(12);

                entity.HasOne(d => d.User)
                    .WithOne(p => p.TUserCredential)
                    .HasForeignKey<TUserCredential>(d => d.UserId)
                    .HasConstraintName("FK_UserCredential_User");
            });

            modelBuilder.Entity<TUserMaster>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PK__tUserMas__1788CC4C86BB011B");

                entity.ToTable("tUserMaster", "sSecurity");

                entity.HasIndex(e => e.MobileNumber, "UQ__tUserMas__250375B1A76CE69D")
                    .IsUnique();

                entity.Property(e => e.Address).HasMaxLength(4000);

                entity.Property(e => e.Company).HasMaxLength(500);

                entity.Property(e => e.CreatedDateTime).HasColumnType("datetime");

                entity.Property(e => e.EmailId).HasMaxLength(50);

                entity.Property(e => e.MobileNumber).HasMaxLength(10);

                entity.Property(e => e.Name).HasMaxLength(200);

                entity.Property(e => e.Password).HasMaxLength(12);

                entity.Property(e => e.UpdateDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<TUserSite>(entity =>
            {
                entity.HasKey(e => e.SiteId)
                    .HasName("PK__tUserSit__B9DCB963A78DE148");

                entity.ToTable("tUserSite", "sSecurity");

                entity.Property(e => e.SiteAddress).HasMaxLength(2000);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.TUserSites)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK__tUserSite__UserI__6754599E");
            });

            modelBuilder.Entity<TUserTransaction>(entity =>
            {
                entity.HasKey(e => e.TransactionId)
                    .HasName("PK__tUserTra__55433A6B0EC31A53");

                entity.ToTable("tUserTransaction", "sSecurity");

                entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Comments).HasMaxLength(4000);

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            });

            modelBuilder.Entity<TView>(entity =>
            {
                entity.ToTable("tView", "sInventory");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Title).HasMaxLength(50);
            });

            modelBuilder.Entity<TcityTemp>(entity =>
            {
                entity.ToTable("TCity_temp", "sSecurity");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<TdistrictTemp>(entity =>
            {
                entity.ToTable("TDistrict_temp", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<TstateTemp>(entity =>
            {
                entity.ToTable("TState_temp", "sSecurity");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
