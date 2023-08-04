using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using TKTradersWebApp.Areas.Securities.Models;
using TKTradersWebApp.CommonServices;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.Models;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Securities.Controllers
{
    [SessionTimeout]
    public class PaymentController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;
        private readonly IConfiguration configuration;
        public PaymentController(TKTradersDBContext tKTradersDBContext, IConfiguration configuration)
        {
            this.tKTradersDBContext = tKTradersDBContext;
            this.configuration = configuration;
        }
        private Common common
        {
            get { return new Common(tKTradersDBContext); }
        }

        public ActionResult GetPayments()
        {
            IQueryable<Payment> payments = tKTradersDBContext.TUserTransactions.Where(userTransaction => userTransaction.IsObsolete == false)
                .Join(tKTradersDBContext.TUserMasters, transaction => transaction.UserId, user => user.UserId, 
                (transaction, user) => new Payment{ TransactionId = transaction.TransactionId, UserId = transaction.UserId, UserName = user.Name, TransactionTypeId = transaction.TransactionTypeId, Amount = transaction.Amount, CreatedDate = transaction.UpdatedDate ?? transaction.CreatedDate,Comments=transaction.Comments });
            return View(payments);
        }
        public ActionResult AddPayment()
        {
            loadDropdown();
            return View();
        }

        // POST: UserController/Create
        [HttpPost]

        public ActionResult AddPayment(Payment userTransaction)
        {
            try
            {
                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                userTransaction.CreatedDate = DateTime.Now;
                if (userTransaction.UserId == -999)
                {
                    int _userId = common.createUser(userTransaction.UserTypeId, userTransaction.UserMobile, userTransaction.UserName, userTransaction.UserAddress, loggedUser.Id);
                    if (_userId > 0)
                        userTransaction.UserId = _userId;
                }
                if (userTransaction.UserId == 0)
                    return Json(new { statusCode = -101, statusMessage = "Please select supplier" });
                tKTradersDBContext.TUserTransactions.Add(userTransaction);
                if (tKTradersDBContext.SaveChanges() > 0)
                {
                    SendSMS sendSMS = new SendSMS(configuration);
                    SMSRequest sMSRequest = new SMSRequest();
                    var user = tKTradersDBContext.TUserMasters.Where(user => user.UserId == userTransaction.UserId).Select(user => new { MobileNumber = user.MobileNumber, UserName = user.Name }).FirstOrDefault();
                    if (userTransaction.TransactionTypeId == 1)
                        sMSRequest.MessageBody = "Hi " + user?.UserName + ",\n You have received amount of Rs." + userTransaction.Amount + "/- from TK Traders. Your Transaction Id is : "+userTransaction.TransactionId+". \n Thank you for choosing TK Traders.";
                    else
                        sMSRequest.MessageBody = "Hi " + user?.UserName + ",\n You have sent amount of Rs." + userTransaction.Amount + "/- to TK Traders. Your Transaction Id is : " + userTransaction.TransactionId + ". \n Thank you for choosing TK Traders.";
                    sMSRequest.MobileNumber = user.MobileNumber;

                    var result= sendSMS.send(sMSRequest);
                    TNotification notification = new TNotification();
                    notification.Message = result;
                    notification.UserId = userTransaction.UserId;
                    notification.MobileNumber = sMSRequest.MobileNumber;
                    notification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(notification);
                    tKTradersDBContext.SaveChanges();
                    sMSRequest = new SMSRequest();
                    if (userTransaction.TransactionTypeId == 1)
                        sMSRequest.MessageBody = "Hi " + loggedUser.Name + ",\n You have sent amount of Rs." + userTransaction.Amount + "/- to " + user?.UserName + ". Your Transaction Id is : " + userTransaction.TransactionId + ". \n Thank you for choosing TK Traders.";
                    else
                        sMSRequest.MessageBody = "Hi " + loggedUser.Name + ",\n You have received amount of Rs." + userTransaction.Amount + "/- from " + user?.UserName + ". Your Transaction Id is : " + userTransaction.TransactionId + ". \n Thank you for choosing TK Traders.";
                    sMSRequest.MobileNumber = loggedUser.MobileNumber;

                    var result1 = sendSMS.send(sMSRequest);
                    TNotification _notification = new TNotification();
                    _notification.Message = result1;
                    _notification.UserId = loggedUser.Id;
                    _notification.MobileNumber = sMSRequest.MobileNumber;
                    _notification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(_notification);
                    tKTradersDBContext.SaveChanges();

                    return Json(new { statusCode = 1, statusMessage = "Transaction Saved Successfully..!" });   
                }
                   
                else
                    return Json(new { statusCode = -102, statusMessage = "Error in saving" });
            }
            catch(Exception ex)
            {
                return Json(new { statusCode = -101, statusMessage = "Error in saving, Please contact to administrator" });
            }
        }
        
        public ActionResult EditPayment(int transactionId)
        {
            try
            { 
                loadDropdown();
                TUserTransaction userTransaction = tKTradersDBContext.TUserTransactions.Where(transaction => transaction.TransactionId == transactionId).FirstOrDefault();
                return View(userTransaction);
            }
            catch
            {
                return View(null);
            }

        }
        [HttpPost]
        public ActionResult EditPayment(TUserTransaction userTransaction)
        {
            try
            {
                TUserTransaction _userTransaction = tKTradersDBContext.TUserTransactions.Where(transaction => transaction.TransactionId == userTransaction.TransactionId).FirstOrDefault();
                if (_userTransaction != null)
                {
                    _userTransaction.TransactionTypeId = userTransaction.TransactionTypeId;
                    _userTransaction.Amount = userTransaction.Amount;
                    _userTransaction.UpdatedDate = DateTime.Now;

                    tKTradersDBContext.TUserTransactions.Update(_userTransaction);
                    if (tKTradersDBContext.SaveChanges() > 0)
                        return Json(new { statusCode = 1, statusMessage = "Transaction Updated Successfully..!" });
                    else
                        return Json(new { statusCode = -102, statusMessage = "Error in updating" });
                }
                else
                    return Json(new { statusCode = -102, statusMessage = "Invalid Transaction" });
            }
            catch
            {
                return Json(new { statusCode = -101, statusMessage = "Error in updating, Please contact to administrator" });
            }
        }
        [HttpPost]

        public ActionResult DeletePayment(int transactionId)
        {
            try
            {
                TUserTransaction userTransaction = tKTradersDBContext.TUserTransactions.Where(transaction => transaction.TransactionId == transactionId).FirstOrDefault();
                if (userTransaction != null)
                {
                    userTransaction.IsObsolete = true;
                    tKTradersDBContext.TUserTransactions.Add(userTransaction);
                    if (tKTradersDBContext.SaveChanges() > 0)
                        TempData["SuccessMessage"] = "Transaction Deleted Successfully..!";
                    else
                        TempData["ErrorMessage"] = "Error in deleting";
                }
                else
                    TempData["ErrorMessage"] ="Invalid Transaction" ;
            }
            catch
            {
                TempData["ErrorMessage"] = "Error in deleting, Please contact to administrator" ;
            }
            return RedirectToAction("GetPayments");
        }

        private void loadDropdown()
        {
            ViewBag.ddlUser = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false && (user.UserTypeId!=1 && user.UserTypeId != 4)).Select(user => new SelectListItem { Value = user.UserId.ToString(), Text = user.Name });
        }
    }
}
