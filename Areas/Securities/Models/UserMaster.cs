using System.ComponentModel.DataAnnotations.Schema;
using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.Areas.Securities.Models
{
    public class UserMaster:TUserMaster
    {
        [NotMapped]
        public string _EmailId { get; set; }
        [NotMapped]
        public string _Password { get; set; }
    }
}
