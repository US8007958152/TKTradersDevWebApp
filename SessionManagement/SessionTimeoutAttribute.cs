using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using TKTradersWebApp.EFServices;

namespace TKTradersWebApp.SessionManagement
{
    public class SessionTimeoutAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            TUser user = SessionHelper.GetObjectFromJson<TUser>(filterContext.HttpContext.Session, "UserProfile");
            if (user == null)
            {
                filterContext.Result = new RedirectResult("/Securities/Authenticate/Login" );
                return;
            }
            base.OnActionExecuting(filterContext);
        }
    }
}
