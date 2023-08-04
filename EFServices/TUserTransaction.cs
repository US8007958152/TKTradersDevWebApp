using System;
using System.Collections.Generic;

namespace TKTradersWebApp.EFServices
{
    public partial class TUserTransaction
    {
        public int TransactionId { get; set; }
        public int UserId { get; set; }
        public int TransactionTypeId { get; set; }
        public decimal Amount { get; set; }
        public bool IsObsolete { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? Comments { get; set; }
    }
}
