using TKTradersWebApp.Areas.Inventories.Models;
using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Securities.Models
{

    public class ViewUser : TUserMaster
    {
        public string UserType { get; set; } = "";
        public decimal ProductAmount { get; set; } = 0;
        public decimal BuyAmount { get; set; } = 0;
        public decimal SellAmount { get; set; } = 0;
        public decimal HireTruckRent { get; set; } = 0;
        public decimal ProvideTruckRent { get; set; } = 0;
        public decimal ReceivedAmount { get; set; } = 0;
        public decimal SentAmount { get; set; } = 0;
        public decimal FinalPay { get; set; } = 0;
        public bool IsUserPay { get; set; } = false;
        public string City { get; set; }
        public string District { get; set; }
        public string State { get; set; }

        public IQueryable<TUserSite> UserSites { get; set; }
        public IEnumerable<Order> UserOrders { get; set; }
        public IQueryable<Payment> UserPayments {get; set;}
    }
}
