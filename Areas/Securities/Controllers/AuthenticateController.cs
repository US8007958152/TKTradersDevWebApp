using Microsoft.AspNetCore.Mvc;
using TKTradersWebApp.Areas.Securities.Models;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Securities.Controllers
{
    public class AuthenticateController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;

        public AuthenticateController(TKTradersDBContext tKTradersDBContext)
        {
            this.tKTradersDBContext = tKTradersDBContext;
        }
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Login()
        {
            LogIn logIn = new LogIn();
             HttpContext.Request.Cookies.TryGetValue("UserName", out string mobilenumber);
            HttpContext.Request.Cookies.TryGetValue("Password", out string password);
            HttpContext.Request.Cookies.TryGetValue("IsRememberMe", out string isremeber);
            logIn.MobileNumber = mobilenumber;
            logIn.Password = password;
            logIn.IsRememberMe = Convert.ToBoolean(isremeber);
            return View(logIn);
        }
        [HttpPost]
        public IActionResult Login(LogIn logIn)
        {
            if(string.IsNullOrEmpty(logIn.MobileNumber) && string.IsNullOrEmpty(logIn.Password))
            {
                TempData["ErrorMessage"] = "Please enter credential";
                return View(logIn);
            }
            if (string.IsNullOrEmpty(logIn.MobileNumber))
            {
                TempData["ErrorMessage"] = "Please enter userid or mobile number";
                return View(logIn);
            }
            if (logIn.MobileNumber.Trim().Length!=10)
            {
                TempData["ErrorMessage"] = "Please enter 10 digit mobile number";
                return View(logIn);
            }

            if (string.IsNullOrEmpty(logIn.Password))
            {
                TempData["ErrorMessage"] = "Please enter password";
                return View(logIn);
            }
           
            var isValidUserId = tKTradersDBContext.TUsers.Where(user=>user.IsObsolete==false).Any(user => user.MobileNumber == logIn.MobileNumber.Trim());
            if (isValidUserId)
            {
                var isAccountBlocked = tKTradersDBContext.TUsers.Where(user => user.IsObsolete == false && user.MobileNumber == logIn.MobileNumber.Trim()).Join(tKTradersDBContext.TUserCredentials, user => user.Id, usercredential => usercredential.UserId, (user, usercredential) => usercredential).Any(_usercredential => _usercredential.LoginAttempts > 0);
                if (!isAccountBlocked)
                {
                    TempData["ErrorMessage"] = "Your account has been blocked as you crossed 5 attempts";
                    return View();
                }
                var isValidPassword = tKTradersDBContext.TUsers.Where(user => user.IsObsolete == false && user.MobileNumber == logIn.MobileNumber.Trim()).Join(tKTradersDBContext.TUserCredentials, user => user.Id, usercredential => usercredential.UserId, (user, usercredential) => usercredential).Any(_usercredential => _usercredential.NewPassword == logIn.Password);
                if (isValidPassword)
                {
                  
                    if (logIn.IsRememberMe)
                    {
                        CookieOptions option = new CookieOptions();
                        option.Secure = true;
                        option.Expires = DateTime.Now.AddDays(365);
                        HttpContext.Response.Cookies.Append("UserName", logIn.MobileNumber, option);
                        HttpContext.Response.Cookies.Append("Password", logIn.Password, option);
                        HttpContext.Response.Cookies.Append("IsRememberMe", logIn.IsRememberMe.ToString(), option);
                    }
                    else
                    {
                        HttpContext.Response.Cookies.Delete("UserName");
                        HttpContext.Response.Cookies.Delete("Password");
                        HttpContext.Response.Cookies.Delete("IsRememberMe");
                    }
                    TUser userProfile = tKTradersDBContext.TUsers.Where(user => user.IsObsolete == false && user.MobileNumber == logIn.MobileNumber).FirstOrDefault();
                    SessionHelper.SetObjectAsJson(HttpContext.Session, "UserProfile", userProfile);
                    return RedirectToAction("Index", "Default", new { Area = "Dashboard" });
                }
                    
                else
                {
                    TempData["ErrorMessage"] = "Invalid password";

                    TUserCredential userCredential = tKTradersDBContext.TUserCredentials.Join(tKTradersDBContext.TUsers.Where(_user=>_user.IsObsolete==false && _user.MobileNumber==logIn.MobileNumber.Trim()),
                        credential => credential.UserId, user => user.Id, (credential, User) => credential).FirstOrDefault();
                    userCredential.LoginAttempts = userCredential.LoginAttempts - 1;
                    tKTradersDBContext.TUserCredentials.Update(userCredential);
                    tKTradersDBContext.SaveChanges();
                }
                    
            }
            else                 
                TempData["ErrorMessage"] = "Invalid userid or mobile number";

            return View(logIn);
        }

        public IActionResult ForgotPassword()
        {
            return View();
        }
        [HttpPost]
        public IActionResult ForgotPassword(ForgotPassword forgotPassword)
        {
            try
            {
                if (string.IsNullOrEmpty(forgotPassword.MobileNumber) && string.IsNullOrEmpty(forgotPassword.Password) && string.IsNullOrEmpty(forgotPassword.ConfirmPassword))
                {
                    TempData["ErrorMessage"] = "Please enter valid credential";
                    return View(forgotPassword);
                }
                if (string.IsNullOrEmpty(forgotPassword.MobileNumber))
                {
                    TempData["ErrorMessage"] = "Please enter mobile number";
                    return View(forgotPassword);
                }
                if (forgotPassword.MobileNumber.Trim().Length != 10)
                {
                    TempData["ErrorMessage"] = "Please enter 10 digit mobile number";
                    return View(forgotPassword);
                }
                if (string.IsNullOrEmpty(forgotPassword.Password))
                {
                    TempData["ErrorMessage"] = "Please enter password";
                    return View(forgotPassword);
                }
                if (string.IsNullOrEmpty(forgotPassword.ConfirmPassword))
                {
                    TempData["ErrorMessage"] = "Please enter confirm password";
                    return View(forgotPassword);
                }
                if (forgotPassword.Password != forgotPassword.ConfirmPassword)
                {
                    TempData["ErrorMessage"] = "Confirm password is not matched";
                    return View(forgotPassword);
                }
                TUserCredential userCredential = tKTradersDBContext.TUsers.Where(user => user.IsObsolete == false && user.MobileNumber == forgotPassword.MobileNumber).Join(tKTradersDBContext.TUserCredentials, user => user.Id, usercredential => usercredential.UserId, (user, usercredential) => usercredential).FirstOrDefault();
                if (userCredential != null)
                {
                    userCredential.OldPassword = userCredential.NewPassword;
                    userCredential.NewPassword = forgotPassword.Password;
                    tKTradersDBContext.TUserCredentials.Update(userCredential);
                    if (tKTradersDBContext.SaveChanges() > 0)
                        TempData["SuccessMessage"] = "Password changed successfully..!";
                    else
                        TempData["ErrorMessage"] = "Error in data";
                       
                }
                else
                    TempData["ErrorMessage"] = "User does not exist or inactive";

            }
            catch(Exception e)
            {
                TempData["ErrorMessage"] = "Something went wrong, Please contact to administrator";
            }
           
            return View();
        }

        public IActionResult Logout()
        {
            SessionHelper.RemoveObjectFromJson(HttpContext.Session, "UserProfile");
            return RedirectToAction("Login", "Authenticate", new { Area = "Securities" });
        }
    }
}
