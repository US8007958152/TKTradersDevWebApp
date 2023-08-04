using Microsoft.AspNetCore.Mvc;

namespace TKTradersWebApp.Areas.Securities.Models
{
    public class LogIn
    {
        
        public string MobileNumber { get; set; }
        
        public string Password { get; set; }
       
        public bool IsRememberMe { get; set; }
    }
    public class ForgotPassword
    {
       
        public string MobileNumber { get; set; }
       
        public string Password { get; set; }
       
        public string ConfirmPassword { get; set; }
    }
}
