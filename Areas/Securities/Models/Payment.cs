using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Securities.Models
{
    public class Payment:TUserTransaction
    {
        public string UserName { get; set; }
        public int UserTypeId { get; set; } = 0;
        public string UserMobile { get; set; }
        public string UserAddress { get; set; }
    }
}
