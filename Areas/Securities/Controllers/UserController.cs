using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;
using TKTradersWebApp.Areas.Inventories.Models;
using TKTradersWebApp.Areas.Securities.Models;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Securities.Controllers
{
    [SessionTimeout]
    public class UserController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;
        private readonly IConfiguration configuration;
        public UserController(TKTradersDBContext tKTradersDBContext, IConfiguration configuration)
        {
            this.tKTradersDBContext = tKTradersDBContext;
            this.configuration = configuration;
        }
        // GET: UserController
        public ActionResult GetUsers()
        {
            List<TUser> users = tKTradersDBContext.TUsers.Where(user => user.IsObsolete == false).ToList();
            List<TUser> _users = tKTradersDBContext.TUserMasters.Where(user => user.IsObsolete == false).Select(_user => new TUser { Id = _user.UserId, Name = _user.Name, MobileNumber = _user.MobileNumber, UserTypeId = _user.UserTypeId,CreatedDateTime=_user.CreatedDateTime }).ToList();
            if (users != null)
            {
                users.AddRange(_users);
                users = users.OrderByDescending(user => user.CreatedDateTime).ToList();
                return View(users);
            }
            else
                return View(_users);
        }

        //// GET: UserController/Details/5
        //public ActionResult ViewUser(int id)
        //{
        //    TUser user = tKTradersDBContext.TUsers.Where(user => user.Id == id).FirstOrDefault();
        //    if (user != null)
        //    {
        //        user.TUserCredential = tKTradersDBContext.TUserCredentials.Where(usercredential => usercredential.UserId == id).FirstOrDefault();
        //        user.TUserDetail = tKTradersDBContext.TUserDetails.Where(usercredential => usercredential.UserId == id).FirstOrDefault();
        //    }
        //    return View(user);
        //}

        // GET: UserController/Create
        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }

        public ActionResult ViewUser(int userId)
        {
            if (userId > 0)
            {
                ViewUser viewUser = tKTradersDBContext.TUserMasters.Where(user => user.UserId == userId)
                    .Join(tKTradersDBContext.TStaticUserTypes, userMaster => userMaster.UserTypeId, staticUserType => staticUserType.Id, (userMaster, staticUserType) => new ViewUser {UserTypeId=userMaster.UserTypeId,Name=userMaster.Name,MobileNumber=userMaster.MobileNumber,EmailId=userMaster.EmailId,UserType=staticUserType.Title,Company=userMaster.Company,Address=userMaster.Address,CityId=userMaster.CityId,DistrictId=userMaster.DistrictId,StateId=userMaster.StateId }).FirstOrDefault();
                if(viewUser!=null)
                {
                    viewUser.UserSites = tKTradersDBContext.TUserSites.Where(userSite => userSite.UserId == userId);
                    viewUser.UserOrders = getOrders(userId);
                    ViewUser viewUser1 = getUserAmount(userId);
                    viewUser.SellAmount = viewUser1.SellAmount;
                    viewUser.BuyAmount = viewUser1.BuyAmount;
                    viewUser.HireTruckRent = viewUser1.HireTruckRent;
                    viewUser.ProvideTruckRent = viewUser1.ProvideTruckRent;
                    viewUser.ReceivedAmount = viewUser1.ReceivedAmount;
                    viewUser.SentAmount = viewUser1.SentAmount;
                    viewUser.State = "Maharashtra";
                    viewUser.District = tKTradersDBContext.TDistricts.Where(district => district.Id == viewUser.DistrictId).Select(district=>district.Name).FirstOrDefault()??"";
                    viewUser.City = tKTradersDBContext.TCities.Where(city => city.Id == viewUser.CityId && city.DistrictId==viewUser.DistrictId ).Select(district => district.Name).FirstOrDefault()??"";
                    if (viewUser1.FinalPay>=0)
                    {
                        viewUser.IsUserPay = true;
                        viewUser.FinalPay = viewUser1.FinalPay * -1;
                    }
                    else                        
                    viewUser.FinalPay = viewUser1.FinalPay;
                    
                    viewUser.UserPayments = tKTradersDBContext.TUserTransactions.Where(userTransaction => userTransaction.IsObsolete == false && userTransaction.UserId == userId)
                    .Select(transaction => new Payment { TransactionId = transaction.TransactionId, UserId = transaction.UserId, TransactionTypeId = transaction.TransactionTypeId, Amount = transaction.Amount, CreatedDate = transaction.UpdatedDate ?? transaction.CreatedDate, Comments = transaction.Comments });
                }
               
                return View(viewUser);
            }
            else
                return View();
        }

        // POST: UserController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(TUserMaster userMaster)
        {
            try
            {
                var tuple = validate(userMaster);
                if (!tuple.Item1)
                   return Json(new { statusCode = -101, statusMessage =tuple.Item2});
                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                if(mobileNumberExist(userMaster.MobileNumber,userMaster.UserId))
                    return Json(new { statusCode = -101, statusMessage = "Mobile number is already exist." });
               else if (userMaster.UserTypeId == 1)
                {
                    
                        TUser user = new TUser();
                        user.Name = userMaster.Name;
                        user.EmailId = userMaster.EmailId;
                        user.UserTypeId = userMaster.UserTypeId;
                        user.MobileNumber = userMaster.MobileNumber;
                        user.CreatedDateTime = DateTime.Now;
                        user.CreatedBy = loggedUser.Id;
                        user.TUserCredential = new TUserCredential();
                        user.TUserCredential.NewPassword = userMaster.Password;
                        tKTradersDBContext.TUsers.Add(user);
                        if (tKTradersDBContext.SaveChanges() > 0)
                        {
                            TempData["SuccessMessage"] = "User saved successfully..!";
                            return Json(new { statusCode =1});
                        }
                        else
                        return Json(new { statusCode = -101, statusMessage = "Error in data" });

                }
                else if (userMaster.UserTypeId > 1)
                {
                    
                        userMaster.CreatedDateTime = DateTime.Now;
                        userMaster.CreatedBy = loggedUser.Id;
                        tKTradersDBContext.TUserMasters.Add(userMaster);
                        if (tKTradersDBContext.SaveChanges() > 0)
                        {
                            TempData["SuccessMessage"] = "User saved successfully..!";
                        return Json(new { statusCode = 1 });
                    }
                        else
                        return Json(new { statusCode = -101, statusMessage = "Error in data" });
                    //TempData["ErrorMessage"] = "Error in data";
                }
            }
            catch
            {
               return Json(new { statusCode = -101, statusMessage= "Error in saving, Please contact to administrator" });
                //TempData["ErrorMessage"] = "Error in saving, Please contact to administrator";
            }
            return Json(new { statusCode = -101, statusMessage = "Error in data" });
        }

        [HttpGet]
        public ActionResult Edit(int userTypeId, int id)
        {
            try
            {

                TUserMaster userMaster = null;
                if (userTypeId == 1)
                {
                    TUser _user = tKTradersDBContext.TUsers.Where(user => user.Id == id).FirstOrDefault();
                    if (_user != null)
                    {
                        userMaster = new TUserMaster();
                        userMaster.UserId = _user.Id;
                        userMaster.Name = _user.Name;
                        userMaster.EmailId = _user.EmailId;
                        userMaster.UserTypeId = _user.UserTypeId;
                        userMaster.MobileNumber = _user.MobileNumber;
                        userMaster.UserTypeId = _user.UserTypeId;

                        _user.TUserCredential = tKTradersDBContext.TUserCredentials.Where(user => user.UserId == _user.Id).FirstOrDefault();
                        
                        userMaster.Password = _user.TUserCredential?.NewPassword;
                        return View(userMaster);

                    }

                }
                else
                {
                    userMaster = tKTradersDBContext.TUserMasters.Where(user => user.UserId == id).First();
                    CommonController commonController = new CommonController(tKTradersDBContext);
                    ViewBag.ddlCity = commonController.GetCity(userMaster.DistrictId);
                    if (userMaster != null)
                    {
                        userMaster.TUserSites=tKTradersDBContext.TUserSites.Where(user => user.UserId == id).ToList();
                             return View(userMaster);
                    }                       
                    else
                        TempData["ErrorMessage"] = "Error in data";
                }

            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error in updating, Please contact to administrator";
            }
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, TUserMaster userMaster)
        {
            try
            {

                var tuple = validate(userMaster);
                if (!tuple.Item1)
                {
                    TempData["ErrorMessage"] = tuple.Item2;
                    return View(userMaster);
                }

                if (mobileNumberExist(userMaster.MobileNumber, userMaster.UserId))
                {
                    TempData["ErrorMessage"] = "Mobile number is already exist.";
                    return View(userMaster);
                }
                TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                if (userMaster.UserTypeId == 1)
                {
                    
                        TUser user = tKTradersDBContext.TUsers.Where(_user => _user.Id == userMaster.UserId).FirstOrDefault();
                        if (user != null)
                        {
                            user.Name = userMaster.Name;
                            user.EmailId = userMaster.EmailId;
                            user.UserTypeId = userMaster.UserTypeId;
                            user.MobileNumber = userMaster.MobileNumber;
                            user.UpdatedDateTime = DateTime.Now;
                            user.UpdatedBy = loggedUser.Id;
                            user.TUserCredential = tKTradersDBContext.TUserCredentials.Where(_user => _user.UserId == user.Id).FirstOrDefault();
                            user.TUserCredential.OldPassword = user.TUserCredential?.NewPassword;
                            user.TUserCredential.NewPassword = userMaster?.Password;
                            tKTradersDBContext.TUsers.Update(user);
                            if (tKTradersDBContext.SaveChanges() > 0)
                            {
                                TempData["SuccessMessage"] = "User updated successfully..!";
                            return Json(new { statusCode = 1 });
                        }
                            else
                                TempData["ErrorMessage"] = "Error in data";
                        }
                        else
                            TempData["ErrorMessage"] = "Error in data";
                   
                }
                else if (userMaster.UserTypeId > 1)
                {
                    
                        TUserMaster _userMaster = tKTradersDBContext.TUserMasters.Where(_user => _user.UserId == userMaster.UserId).FirstOrDefault();
                        _userMaster.Name = userMaster.Name;
                        _userMaster.EmailId = userMaster.EmailId;
                        _userMaster.UserTypeId = userMaster.UserTypeId;
                        _userMaster.MobileNumber = userMaster.MobileNumber;
                    _userMaster.Address= userMaster.Address;
                    _userMaster.Company = userMaster.Company;
                    _userMaster.CityId = userMaster.CityId;
                    _userMaster.DistrictId = userMaster.DistrictId;
                    _userMaster.StateId = userMaster.StateId;
                        _userMaster.UpdateDateTime = DateTime.Now;
                        _userMaster.UpdatedBy = loggedUser.Id;
                    _userMaster.TUserSites = userMaster.TUserSites;
                    //_userMaster.TUserSites.ToList().ForEach(site=>site.User= _userMaster);
                        tKTradersDBContext.TUserMasters.Update(_userMaster);
                        if (tKTradersDBContext.SaveChanges() > 0)
                        {
                            TempData["SuccessMessage"] = "User updated successfully..!";
                        return Json(new { statusCode = 1 });
                    }
                        else
                            TempData["ErrorMessage"] = "Error in data";
                }
            }
            catch
            {
                //TempData["ErrorMessage"] = "Error in saving, Please contact to administrator";
                return Json(new { statusCode = -101, statusMessage = "Error in saving, Please contact to administrator" });
            }
            return Json(new { statusCode = -101, statusMessage = "Error in data" });
        }

        public IActionResult GetInvoice(int id)
        {
            try
            {
                Invoice invoice = new Invoice();
                TUserMaster userMaster = tKTradersDBContext.TUserMasters.Where(user => user.UserId == id).FirstOrDefault();
                if (userMaster != null)
                {

                    UserDetails userDetails = new UserDetails();
                    userDetails.UserName = userMaster.Name;
                    userDetails.UserType = tKTradersDBContext.TStaticUserTypes.Where(x => x.IsObsolete == false && x.Id == userMaster.UserTypeId).Select(x => x.Title).FirstOrDefault();
                    userDetails.Address = userMaster.Address;
                    userDetails.MobileNumber = userMaster.MobileNumber;
                    userDetails.EmailId = userMaster.EmailId;
                    userDetails.OtherAddress = getAddress(userMaster.CityId, userMaster.DistrictId, userMaster.StateId);
                    invoice._UserDetails = userDetails;
                    invoice._USPGetInvoiceByUserId = tKTradersDBContext.USPGetInvoiceByUserIds.FromSqlRaw("EXEC sSecurity.usp_GetInvoiceByUserId {0}", userMaster.UserId).AsQueryable();
                    var fUSPGetInvoiceByUserId=invoice._USPGetInvoiceByUserId.ToList();
                    var fImportedAmount = fUSPGetInvoiceByUserId.Where(x => x.SupplierId == id).Sum(x => x.TotalAmount);
                    var fExportedAmount = fUSPGetInvoiceByUserId.Where(x => x.CustomerId == id).Sum(x => x.TotalAmount);
                    var fSendAmount = tKTradersDBContext.TUserMasters.Where(x => x.UserId == id).Join(tKTradersDBContext.TUserTransactions.Where(x => x.TransactionTypeId == 1), x => x.UserId, y => y.UserId, (x, y) => y).Sum(x => x.Amount);
                    var fReceivedAmount = tKTradersDBContext.TUserMasters.Where(x => x.UserId == id).Join(tKTradersDBContext.TUserTransactions.Where(x => x.TransactionTypeId == 2), x => x.UserId, y => y.UserId, (x, y) => y).Sum(x => x.Amount);
                    var fTotalAmount = fImportedAmount - fExportedAmount;
                    userDetails.TotalAmount = fTotalAmount;
                    var fFinalAmount = fSendAmount - fReceivedAmount + fTotalAmount;
                    userDetails.FinalAmount = fFinalAmount;                 

                    userDetails.SendAmount = fSendAmount;
                    userDetails.ReceivedAmount = fReceivedAmount;

                }
                return View(invoice);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
        public ActionResult Delete(int userTypeId, int id)
        {
            TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
            if (id > 0 && userTypeId > 0 && id == loggedUser.Id)
            {
                TempData["ErrorMessage"] = "Logged in user can not be deleted";
                return RedirectToAction("GetUsers");
            }
            if (id > 0 && userTypeId >0)
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    if (conn.State == ConnectionState.Closed)
                        conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "sSecurity.tUserDelete";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@rUserId",id);
                        cmd.Parameters.AddWithValue("@rUserTypeId", userTypeId);
                        using (SqlDataReader sda = cmd.ExecuteReader())
                        {
                            sda.Read();
                            int statusCode = Convert.ToInt32(sda.GetValue(0));
                            if(statusCode==1)
                            {
                                TempData["SuccessMessage"] = "User deleted successfully..!";
                                return RedirectToAction("GetUsers");
                            }
                            else if (statusCode == -102)
                            {
                                TempData["ErrorMessage"] = "User does not exist";
                                return RedirectToAction("GetUsers");
                            }
                        }
                    }
                }
            }
            TempData["ErrorMessage"] = "Error in user deleting.";
            return RedirectToAction("GetUsers");
        }

        private Tuple<bool, string> validate(TUserMaster userMaster)
        {
            if (string.IsNullOrEmpty(userMaster.Name))
                return new Tuple<bool, string>(false, "Please Enter Full Name");
            //if (string.IsNullOrEmpty(userMaster.EmailId))
            //    return new Tuple<bool, string>(false, "Please enter valid email");
            if (string.IsNullOrEmpty(userMaster.MobileNumber) || userMaster.MobileNumber.Length != 10)
                return new Tuple<bool, string>(false, "Please enter valid mobile number");
            if (userMaster.UserTypeId == 0)
                return new Tuple<bool, string>(false, "Please select user type");
            if (userMaster.UserTypeId == 1 && string.IsNullOrEmpty(userMaster.Password))
                return new Tuple<bool, string>(false, "Please enter password");
            //if (userTypeId == 1 && string.IsNullOrEmpty(Convert.ToString(collection["ConfirmPassword"])))
            //    return new Tuple<bool, string>(false, "Please enter confirm password");
            //if (userTypeId == 1 && Convert.ToString(collection["Password"])!=Convert.ToString(collection["ConfirmPassword"]))
            //    return new Tuple<bool, string>(false, "Confirm password is not matched with password");
            if (userMaster.UserTypeId > 1 && string.IsNullOrEmpty(userMaster.Address))
                return new Tuple<bool, string>(false, "Please enter address");
            if (userMaster.UserTypeId > 1 && userMaster.CityId == 0)
                return new Tuple<bool, string>(false, "Please select city");
            if (userMaster.UserTypeId > 1 && userMaster.DistrictId == 0)
                return new Tuple<bool, string>(false, "Please select district");
            if (userMaster.UserTypeId > 1 && userMaster.StateId == 0)
                return new Tuple<bool, string>(false, "Please select state");
            if ((userMaster.UserTypeId==3 || userMaster.UserTypeId == 5) && userMaster.TUserSites==null)
                return new Tuple<bool, string>(false, "Please add site details");
            if((userMaster.UserTypeId == 3 || userMaster.UserTypeId == 5) && userMaster.TUserSites.GroupBy(site=>site.SiteAddress.Trim()).Where(key=>key.Count()>1).Any())
                return new Tuple<bool, string>(false, "Please enter unique site name");
            return new Tuple<bool, string>(true, "Success");
        }
        private bool mobileNumberExist(string mobileNumber,int userId)
        {
            if (!tKTradersDBContext.TUsers.Where(_user => _user.MobileNumber == mobileNumber && _user.Id != userId).Any())
                return tKTradersDBContext.TUserMasters.Where(_user => _user.MobileNumber == mobileNumber && _user.UserId != userId).Any();
            else
                return true;
        }

        [HttpGet]
        public ActionResult DeleteSite(int siteId)
        {
            try
            { 
                if(siteId>0)
                {
                    if (tKTradersDBContext.TOrders.Where(oreder => oreder.SupplierId == siteId || oreder.CustomerId == siteId).Any())
                        return Json(new { statusCode = -101, statusMessage = "Referred site can't be deleted" });
                    else
                    {
                        TUserSite userSite = tKTradersDBContext.TUserSites.Where(userSite => userSite.SiteId == siteId).FirstOrDefault();
                        if (userSite != null)
                        {
                            tKTradersDBContext.TUserSites.Remove(userSite);
                            tKTradersDBContext.SaveChanges();
                        }
                        return Json(new { statusCode = 1, statusMessage = "Site deleted successfully...!" });
                    }
                }
                else
                    return Json(new { statusCode = -101, statusMessage = "Invalid site id" });

            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -101, statusMessage = "Error in updating, Please contact to administrator" });
            }
        }

        private IEnumerable<Order> getOrders(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "[sInventory].[usp_GetOrders]";
                        cmd.CommandType = CommandType.StoredProcedure;
                         cmd.Parameters.AddWithValue("@rUserId", userId);
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataSet ds = new DataSet();
                            sda.Fill(ds);
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                                return ds.Tables[0].AsEnumerable().Select(_order => new Order
                                {
                                    OrderId = _order.Field<Int32>("OrderId"),
                                    SupplierName = _order.Field<string>("SupplierName"),
                                    CustomerName = _order.Field<string>("CustomerName"),
                                    ProductName = _order.Field<string>("ProductName"),
                                    TransportType = _order.Field<string>("TransportType"),
                                    Quantity = _order.Field<decimal>("Quantity"),
                                    OrderDate = _order.Field<DateTime>("OrderDate")
                                });
                            else
                                return new List<Order>();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private ViewUser getUserAmount(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    if (conn.State == ConnectionState.Closed)
                        conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "sSecurity.usp_GetUserAmount";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@rUserId", userId);
                        using (SqlDataReader sda = cmd.ExecuteReader())
                        {
                           while(sda.Read())
                            {
                                return new ViewUser
                                {
                                    BuyAmount = Convert.ToDecimal(sda.GetValue(0)),
                                    SellAmount = Convert.ToDecimal(sda.GetValue(1)),
                                    HireTruckRent = Convert.ToDecimal(sda.GetValue(2)),
                                    ProvideTruckRent = Convert.ToDecimal(sda.GetValue(3)),
                                    ReceivedAmount = Convert.ToDecimal(sda.GetValue(4)),
                                    SentAmount = Convert.ToDecimal(sda.GetValue(5)),
                                    FinalPay = Convert.ToDecimal(sda.GetValue(6)),
                                };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return new ViewUser();
        }
        public enum City
        {
            Bhandara = 1,
            Tumsar,
            Pauni,
            Mohadi,
            Sakoli,
            Lakhani,
            Lakhandur,
            Gondia,
            Tirora,
            Arjuni_Morgaon,
            Amgaon,
            Goregaon,
            Sadak_Arjuni,
            Deori,
            Salekasa
        }
        private string getAddress(int cityId, int districtId, int stateId)
        {
            string address = string.Empty;
            address = tKTradersDBContext.TCities.Where(city => city.Id == cityId).Join(tKTradersDBContext.TDistricts.Where(district => district.Id == districtId), city => city.DistrictId, district => district.Id, (city, district) => city.Name + ", " + district.Name).FirstOrDefault();
            address = address + ", Maharashtra";
            return address;
        }
    }

}
