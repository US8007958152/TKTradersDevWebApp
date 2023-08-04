using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TStock
    {
        public TStock()
        {
            TStockInvestments = new HashSet<TStockInvestment>();
        }

        public int Id { get; set; }
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public int ProductTypeId { get; set; }
        public int TransportTypeId { get; set; }
        public decimal Quantity { get; set; }
        public bool IsObsolete { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public int? StockTypeId { get; set; }
        public string? Title { get; set; }

        public virtual TOrder Order { get; set; } = null!;
        public virtual ICollection<TStockInvestment> TStockInvestments { get; set; }
    }
}
