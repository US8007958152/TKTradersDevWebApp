using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;
using TKTradersWebApp.Areas.Inventories.Models;
using TKTradersWebApp.Areas.Securities.Controllers;
using TKTradersWebApp.CommonServices;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.Models;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Inventories.Controllers
{
    [SessionTimeout]
    public class NewOrderController : Controller
    {
        private readonly IConfiguration configuration;
        private readonly TKTradersDBContext tKTradersDBContext;
        private Common common
        {
            get { return new Common(tKTradersDBContext); }
        }
        public NewOrderController(IConfiguration configuration, TKTradersDBContext tKTradersDBContext)
        {
            this.configuration = configuration;
            this.tKTradersDBContext = tKTradersDBContext;
        }
        public IActionResult GetOrders()
        {
            IEnumerable<Order> orders = getOrders();
            return View(orders);
        }
        public IActionResult Create()
        {
            loadDropdowns(0, 0);
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Order order)
        {
            try
            {
                var tuple = validate(order);
                if (!tuple.Item1)
                    return Json(new { statusCode = -101, statusMessage = tuple.Item2 });
                using (var transaction = tKTradersDBContext.Database.BeginTransaction())
                {
                    try
                    {

                        TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");

                        if (order.SupplierId == -999)
                        {
                            int supplierId = common.createUser(5, order.SupplierMobile, order.SupplierName, order.SupplierAddress, loggedUser.Id);
                            if (supplierId > 0)
                                order.SupplierId = supplierId;
                            else
                                order.SupplierId = 0;
                        }
                        if ((order.TransportTypeId == 5 || order.TransportTypeId == 6) && order.SupplierId == 0)
                            return Json(new { statusCode = -101, statusMessage = "Please select supplier" });

                        if (order.CustomerId == -999)
                        {
                            int customerId = common.createUser(2, order.CustomerMobile, order.CustomerName, order.CustomerAddress, loggedUser.Id);
                            if (customerId > 0)
                                order.CustomerId = customerId;
                            else
                                order.CustomerId = 0;

                        }
                        if ((order.TransportTypeId == 2 || order.TransportTypeId == 5 || order.TransportTypeId == 6) && order.CustomerId == 0)
                            return Json(new { statusCode = -101, statusMessage = "Please select customer" });

                        if ((order.TransportTypeId == 5 || order.TransportTypeId == 6) && order.SupplierId == order.CustomerId && order.SenderSiteId == order.ReceiverSiteId)
                            return Json(new { statusCode = -101, statusMessage = "Site can not be same" });
                        if (order.DriverId == -999)
                        {
                            int driverId = common.createUser(4, order.DriverMobile, order.DriverName, null, loggedUser.Id, false);
                            if (driverId > 0)
                                order.DriverId = driverId;
                            else
                                order.DriverId = 0;
                        }
                        else
                            order.IsInternalDriver = tKTradersDBContext.TUserMasters.Where(user => user.UserId == order.DriverId).Select(driver => driver.IsInternalDriver).FirstOrDefault(); ;
                        if (order.TransportTypeId != 4 && order.DriverId == 0)
                            return Json(new { statusCode = -101, statusMessage = "Please select driver" });

                        if (order.TruckId == -999)
                        {
                            var _tuple = common.createTruck(order.TruckNumber, order.TruckOwnerMobile, order.TruckOwnerName, null, loggedUser.Id, false);
                            if (_tuple.Item1 > 0)
                            {
                                order.TruckId = _tuple.Item1;
                                order.TOrderTruckDetail.TruckOwnerId = _tuple.Item2;
                            }
                            else
                                order.TruckId = 0;
                        }
                        else if (order.TransportTypeId != 4)
                        {
                            var _truckDetails = tKTradersDBContext.TTrucks.Where(truck => truck.Id == order.TruckId).Select(truck => new { IsInternalTruck = truck.IsInternalTruck, TruckOwnerId = truck.UserId }).FirstOrDefault();
                            order.IsInternalTruck = _truckDetails.IsInternalTruck;
                            order.TOrderTruckDetail.TruckOwnerId = _truckDetails.TruckOwnerId ?? 0;
                        }

                        if (order.TransportTypeId != 4 && order.TruckId == 0)
                            return Json(new { statusCode = -101, statusMessage = "Please select truck" });
                        if (order.OrderDate.Date == DateTime.MinValue.Date)
                        {
                            order.StatusTypeId = 2;
                            order.OrderDate = DateTime.Now;
                        }
                        else
                        {
                            if (order.OrderDate.Date == DateTime.Now.Date)
                                order.StatusTypeId = 2;
                            else
                                order.StatusTypeId = 1;
                        }

                        order.CreateDateTime = DateTime.Now;
                        order.CreatedBy = loggedUser.Id;
                        if (order.TransportTypeId == 4)
                        {
                            var fAmount = getAmounts(4, order.TOrderProductDetail.ProductTypeId, order.TOrderProductDetail.Quantity);
                            order.TOrderProductDetail.BuyAmount = fAmount.Item1;
                            order.TOrderProductDetail.SellAmount = fAmount.Item1;
                            order.TOrderProductDetail.SellPaidAmount = fAmount.Item1;
                            order.TOrderProductDetail.ReferredOrders = fAmount.Item2;
                        }
                        else if (order.TransportTypeId == 2)
                        {
                            var fAmount = getAmounts(2, order.TOrderProductDetail.ProductTypeId, order.TOrderProductDetail.Quantity);
                            order.TOrderProductDetail.BuyAmount = fAmount.Item1;
                            order.TOrderProductDetail.ReferredOrders = fAmount.Item2;
                        }

                        if (order.TOrderProductDetail.SellAmount == order.TOrderProductDetail.SellPaidAmount)
                            order.TOrderProductDetail.PaymentTypeId = 3;
                        else if (order.TOrderProductDetail.SellPaidAmount > 0 && order.TOrderProductDetail.SellAmount != order.TOrderProductDetail.SellPaidAmount)
                            order.TOrderProductDetail.PaymentTypeId = 2;
                        else
                            order.TOrderProductDetail.PaymentTypeId = 1;

                        if (order.TOrderTruckDetail.TruckRent == order.TOrderTruckDetail.PaidRent)
                            order.TOrderTruckDetail.PaymentTypeId = 3;
                        else if (order.TOrderTruckDetail.PaidRent > 0 && order.TOrderTruckDetail.TruckRent != order.TOrderTruckDetail.PaidRent)
                            order.TOrderTruckDetail.PaymentTypeId = 2;
                        else
                            order.TOrderTruckDetail.PaymentTypeId = 1;

                        if (order.TransportTypeId == 1)
                        {
                            order.TOrderProductDetail.RemainingQuantity = order.TOrderProductDetail.Quantity;
                            order.TOrderProductDetail.StockTypeId = 1;
                        }

                        tKTradersDBContext.TOrders.Add(order);

                        if (tKTradersDBContext.SaveChanges() > 0)
                        {
                            if (order.TransportTypeId != 5 && order.TransportTypeId != 6)
                            {
                                TStock stock = new TStock();
                                stock.OrderId = order.OrderId;
                                stock.TransportTypeId = order.TransportTypeId;
                                stock.ProductId = order.TOrderProductDetail.ProductId;
                                stock.ProductTypeId = order.TOrderProductDetail.ProductTypeId;
                                stock.Quantity = order.TOrderProductDetail.Quantity;
                                stock.CreatedDate = DateTime.Now;
                                stock.CreatedBy = loggedUser.Id;
                                if (order.StatusTypeId == 1)
                                    stock.IsObsolete = true;
                                tKTradersDBContext.TStocks.Add(stock);
                                tKTradersDBContext.SaveChanges();
                            }
                            sendSMS(order, loggedUser);
                            transaction.Commit();
                            return Json(new { statusCode = 1, statusMessage = "Order Created Successfully...!" });
                        }
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ViewData["ErrorMessage"] = "Something went wrong, Please contact to administrator";
                        throw;
                    }
                }
            }
            catch(Exception ex)
            {
                tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                tKTradersDBContext.SaveChanges();
                return Json(new { statusCode = -101, statusMessage = "Something went wrong, Please contact to administrator" });
            }
            return View();
        }

        public IActionResult Edit(int orderId)
        {

            Order order = new Order();
            TOrder torder = tKTradersDBContext.TOrders.Where(x => x.OrderId == orderId).FirstOrDefault();
            if (torder != null)
            {
                order.OrderDate=torder.OrderDate;
                order.StatusTypeId = torder.StatusTypeId;
                order.TransportTypeId = torder.TransportTypeId;
                order.SupplierId = torder.SupplierId;
                order.CustomerId = torder.CustomerId;
                order.ReceiverSiteId = torder.ReceiverSiteId;
                order.TruckId = torder.TruckId;
                order.DriverId = torder.DriverId;
                order.Comments = torder.Comments;
                order.TOrderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(product => product.OrderId == orderId).FirstOrDefault();
                order.TOrderTruckDetail = tKTradersDBContext.TOrderTruckDetails.Where(truck => truck.OrderId == orderId).FirstOrDefault();
                loadDropdowns(order.TOrderProductDetail.ProductId, order.CustomerId);
            }
            return View(order);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(Order _order)
        {
            using (var transaction = tKTradersDBContext.Database.BeginTransaction())
            {
                try
                {
                    if (_order.OrderDate.Date==DateTime.MinValue.Date)
                        return Json(new { statusCode = -101, statusMessage = "Please select order date" });
                    if (_order.StatusTypeId==0)
                        return Json(new { statusCode = -101, statusMessage = "Please select status type" });
                    if ((_order.OrderDate.Date < DateTime.Now.Date && _order.StatusTypeId == 1) || (_order?.OrderDate.Date > DateTime.Now.Date && _order.StatusTypeId == 2))
                        return Json(new { statusCode = -101, statusMessage = "Please select valid date and status type" });
                    
                    if (_order.TOrderProductDetail.Quantity == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please Enter Quantity" });
                    if ((_order.TransportTypeId == 2 || _order.TransportTypeId == 4) && getAvailableStock(_order.TOrderProductDetail.ProductId, _order.TOrderProductDetail.ProductTypeId, _order.OrderId) < _order.TOrderProductDetail.Quantity)
                        return Json(new { statusCode = -101, statusMessage = "Quantity can not be more than available stock." });
                    //if (_order.TransportTypeId == 2 && _order.TOrderProductDetail.BuyAmount == 0)
                    //    return Json(new { statusCode = -101, statusMessage = "Please Enter Invest Amount" });
                    if ((_order.TransportTypeId == 1 || _order.TransportTypeId == 5) && _order.TOrderProductDetail.BuyAmount == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please Enter Buy Amount" });
                    if (_order.TransportTypeId != 1 && _order.TransportTypeId != 6 && _order.TOrderProductDetail.SellAmount == 0)
                        return Json(new { statusCode = -101, statusMessage = "Please Enter Sell Amount" });
                    if (_order.TransportTypeId != 1 && _order.TransportTypeId != 6 && _order.TOrderProductDetail.SellAmount < _order.TOrderProductDetail.SellPaidAmount)
                        return Json(new { statusCode = -101, statusMessage = "Paid amount should not be more that total amount" });
                    TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                    TOrder torder = tKTradersDBContext.TOrders.Where(x => x.OrderId == _order.OrderId).FirstOrDefault();
                    if (torder != null)
                    {
                        torder.TOrderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(product => product.OrderId == torder.OrderId).FirstOrDefault();

                        if(torder.TOrderProductDetail.StockTypeId > 1)
                            return Json(new { statusCode = -101, statusMessage = "Order can not be edited as it is being used." });

                        if (torder.TOrderProductDetail != null)
                        {
                            torder.TOrderProductDetail.Quantity = _order.TOrderProductDetail.Quantity;
                            torder.TOrderProductDetail.RemainingQuantity = _order.TOrderProductDetail.Quantity;
                            torder.TOrderProductDetail.BuyAmount = _order.TOrderProductDetail.BuyAmount;
                            torder.TOrderProductDetail.SellAmount = _order.TOrderProductDetail.SellAmount;
                            torder.TOrderProductDetail.SellPaidAmount = _order.TOrderProductDetail.SellPaidAmount;

                            torder.TOrderTruckDetail = tKTradersDBContext.TOrderTruckDetails.Where(product => product.OrderId == torder.OrderId).FirstOrDefault();

                            torder.OrderDate = _order.OrderDate;
                            torder.StatusTypeId = _order.StatusTypeId;
                            torder.UpdatedBy = loggedUser.Id;
                            torder.Comments = _order.Comments;
                            if (_order.TransportTypeId == 4)
                            {
                                var fAmount = getAmounts(4, _order.TOrderProductDetail.ProductTypeId, _order.TOrderProductDetail.Quantity);
                                torder.TOrderProductDetail.BuyAmount = fAmount.Item1;
                                torder.TOrderProductDetail.SellAmount = fAmount.Item1;
                                torder.TOrderProductDetail.SellPaidAmount = fAmount.Item1;
                                torder.TOrderProductDetail.ReferredOrders = fAmount.Item2;
                            }
                            else if (_order.TransportTypeId == 2)
                            {
                                var fAmount = getAmounts(2, _order.TOrderProductDetail.ProductTypeId, _order.TOrderProductDetail.Quantity);
                                torder.TOrderProductDetail.BuyAmount = fAmount.Item1;
                                torder.TOrderProductDetail.ReferredOrders = fAmount.Item2;
                            }
                            tKTradersDBContext.TOrders.Update(torder);
                            if (tKTradersDBContext.SaveChanges() > 0)
                            {
                                if (torder.TransportTypeId != 5 && torder.TransportTypeId != 6)
                                {
                                    TStock stock = tKTradersDBContext.TStocks.Where(_stock => _stock.OrderId == torder.OrderId).FirstOrDefault();
                                    if (stock == null)
                                    {
                                        stock = new TStock();
                                        stock.OrderId = torder.OrderId;
                                        stock.TransportTypeId = torder.TransportTypeId;
                                        stock.ProductId = torder.TOrderProductDetail.ProductId;
                                        stock.ProductTypeId = torder.TOrderProductDetail.ProductTypeId;
                                        stock.Quantity = torder.TOrderProductDetail.Quantity;
                                        stock.CreatedDate = DateTime.Now;
                                        stock.CreatedBy = loggedUser.Id;
                                        if (torder.StatusTypeId == 1)
                                            stock.IsObsolete = true;
                                        tKTradersDBContext.TStocks.Add(stock);
                                    }
                                    else
                                    {
                                        stock.Quantity = torder.TOrderProductDetail.Quantity;
                                        if (torder.StatusTypeId == 1)
                                            stock.IsObsolete = true;
                                        else
                                            stock.IsObsolete = false;
                                        tKTradersDBContext.TStocks.Update(stock);
                                    }
                                    tKTradersDBContext.SaveChanges();
                                }
                                transaction.Commit();
                                return Json(new { statusCode = 1, statusMessage = "Order Updated Successfully...!" });
                            }
                            else
                                return Json(new { statusCode = -101, statusMessage = "Error in updating" });
                        }
                        else
                            return Json(new { statusCode = -101, statusMessage = "Error in product details" });
                    }
                    else
                        return Json(new { statusCode = -101, statusMessage = "Invalid order details" });
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                    tKTradersDBContext.SaveChanges();
                    return Json(new { statusCode = -101, statusMessage = "Something went wrong, Please contact to administrator" });
                }
            }
        }
        public IActionResult View(int orderId)
        {

            ViewOrder viewOrder = new ViewOrder();
            TOrder torder = tKTradersDBContext.TOrders.Where(x => x.OrderId == orderId).FirstOrDefault();
            if (torder != null)
            {
                viewOrder.OrderId = torder.OrderId;
                viewOrder.OrderDate = torder.OrderDate;
                var transportTypeMaster = tKTradersDBContext.TStaticTransportTypes.Where(transport => transport.Id == torder.TransportTypeId).FirstOrDefault();
                viewOrder.TransportTypeId = transportTypeMaster.Id;
                viewOrder.TransportType = transportTypeMaster.Title;
                if (torder.SupplierId > 0)
                {
                    viewOrder.Supplier = tKTradersDBContext.TUserMasters.Where(userMaster => userMaster.UserId == torder.SupplierId).FirstOrDefault();
                    if (torder.SenderSiteId > 0)
                        viewOrder.PickupLocation = tKTradersDBContext.TUserSites.Where(userSite => userSite.UserId == torder.SupplierId && userSite.SiteId == torder.SenderSiteId).Select(userSite => userSite.SiteAddress).FirstOrDefault();
                    else
                        viewOrder.PickupLocation = tKTradersDBContext.TUserMasters.Where(userMaster => userMaster.UserId == torder.SupplierId).Select(userMaster => userMaster.Address).FirstOrDefault();
                    viewOrder.PickupLocation = viewOrder.PickupLocation + ", " + getAddress(viewOrder.Supplier.CityId, viewOrder.Supplier.DistrictId, viewOrder.Supplier.StateId);
                }
                if (torder.CustomerId > 0)
                {
                    viewOrder.Customer = tKTradersDBContext.TUserMasters.Where(userMaster => userMaster.UserId == torder.CustomerId).FirstOrDefault();
                    if (torder.ReceiverSiteId > 0)
                        viewOrder.DropLocation = tKTradersDBContext.TUserSites.Where(userSite => userSite.UserId == torder.CustomerId && userSite.SiteId == torder.ReceiverSiteId).Select(userSite => userSite.SiteAddress).FirstOrDefault();
                    else
                        viewOrder.DropLocation = tKTradersDBContext.TUserMasters.Where(userMaster => userMaster.UserId == torder.CustomerId).Select(userMaster => userMaster.Address).FirstOrDefault();
                    viewOrder.DropLocation = viewOrder.DropLocation + ", " + getAddress(viewOrder.Customer.CityId, viewOrder.Customer.DistrictId, viewOrder.Customer.StateId);
                }
                if (torder.DriverId > 0)
                {
                    viewOrder.Driver = tKTradersDBContext.TUserMasters.Where(userMaster => userMaster.UserId == torder.DriverId).FirstOrDefault();
                }
                TOrderTruckDetail orderTruck = tKTradersDBContext.TOrderTruckDetails.Where(x => x.OrderId == orderId).FirstOrDefault();
                if (orderTruck != null)
                {
                    viewOrder.TruckRent = orderTruck.TruckRent;
                    viewOrder.PaidRent = orderTruck.PaidRent;
                    viewOrder.TruckNumber = tKTradersDBContext.TTrucks.Where(truck => truck.Id == torder.TruckId).Select(truck => truck.TruckNumber).FirstOrDefault();
                    if (orderTruck.TruckOwnerId > 0)
                        viewOrder.TruckOwner = tKTradersDBContext.TUserMasters.Where(userMaster => userMaster.UserId == orderTruck.TruckOwnerId).FirstOrDefault();
                    else if (orderTruck.TruckOwnerId == -111)
                        viewOrder.TruckOwner = new TUserMaster { Name = "TK Traders", Address = "Internal Truck", MobileNumber = "8999470643", EmailId = "tktraders@gmail.com" };
                    //else if (orderTruck.TruckOwnerId > 0)
                    //{
                    //    viewOrder.TruckOwner =new TUserMaster { Name="TK Traders"}
                    //}
                }
                torder.TOrderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(x => x.OrderId == torder.OrderId).FirstOrDefault();
                if (torder.TOrderProductDetail != null)
                {
                    viewOrder.Product = tKTradersDBContext.TProductTypes.Where(productType => productType.ProductId == torder.TOrderProductDetail.ProductId && productType.Id == torder.TOrderProductDetail.ProductTypeId)
                        .Join(tKTradersDBContext.TProducts, productTypes => productTypes.ProductId, product => product.Id, (productTypes, product) => productTypes.Title + " " + product.Title).FirstOrDefault();
                    viewOrder.BuyAmount = torder.TOrderProductDetail.BuyAmount;
                    viewOrder.SellAmount = torder.TOrderProductDetail.SellAmount;
                    viewOrder.ReceivedAmount = torder.TOrderProductDetail.SellPaidAmount;
                    viewOrder.Quantity = torder.TOrderProductDetail.Quantity;
                }
                if (viewOrder.TransportTypeId == 6)
                    viewOrder.Profit = viewOrder.TruckRent;
                else
                    viewOrder.Profit = viewOrder.SellAmount - (viewOrder.BuyAmount + viewOrder.TruckRent);
            }
            return View(viewOrder);
        }
        public IActionResult Delete(int orderId)
        {
            if (orderId > 0)
            {
                TOrderProductDetail orderProduct = tKTradersDBContext.TOrderProductDetails.Where(orderProduct => orderProduct.OrderId == orderId).FirstOrDefault();
                if(orderProduct.StockTypeId>1)
                {
                    TempData["ErrorMessage"] = "Stock is being used. Order can't be deleted.";
                    return RedirectToAction("GetOrders");
                }
                using (var transaction = tKTradersDBContext.Database.BeginTransaction())
                {
                    try
                    {
                        TOrder order = tKTradersDBContext.TOrders.Where(order => order.OrderId == orderId).FirstOrDefault();

                        if (order.TransportTypeId != 5 && order.TransportTypeId != 6 && orderProduct.ReferredOrders!=null)
                        {
                            List<ReferredOrders> fReferredOrders = JsonConvert.DeserializeObject<List<ReferredOrders>>(orderProduct.ReferredOrders);
                            List<TOrderProductDetail> fTOrderProductDetails = new List<TOrderProductDetail>();

                            if (fReferredOrders!=null && fReferredOrders.Count > 0)
                            {
                                foreach(ReferredOrders referredOrder in fReferredOrders)
                                {
                                    TOrderProductDetail fTOrderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(x => x.OrderId == referredOrder.OrderId).FirstOrDefault();
                                    if(fTOrderProductDetail!=null)
                                    {
                                        fTOrderProductDetail.RemainingQuantity = fTOrderProductDetail.RemainingQuantity + referredOrder.Quantity;
                                        fTOrderProductDetail.StockTypeId = 2;
                                        fTOrderProductDetails.Add(fTOrderProductDetail);
                                    }
                                }
                            }
                            if (fTOrderProductDetails.Count > 0)
                                tKTradersDBContext.TOrderProductDetails.UpdateRange(fTOrderProductDetails);
                        }

                        if (order.TransportTypeId!=5 && order.TransportTypeId != 6)
                        {
                            TStock stock = tKTradersDBContext.TStocks.Where(stock => stock.OrderId == orderId).FirstOrDefault();
                            if (stock != null)
                                tKTradersDBContext.TStocks.Remove(stock);
                        }
                        
                        TOrderTruckDetail truckDetail = tKTradersDBContext.TOrderTruckDetails.Where(truckDetail => truckDetail.OrderId == orderId).FirstOrDefault();
                        if (truckDetail != null)
                            tKTradersDBContext.TOrderTruckDetails.Remove(truckDetail);
                        
                        if (orderProduct != null)
                            tKTradersDBContext.TOrderProductDetails.Remove(orderProduct);
                       
                        if (order != null)
                            tKTradersDBContext.TOrders.Remove(order);
                        tKTradersDBContext.SaveChanges();
                        transaction.Commit();
                        TempData["SuccessMessage"] = "Order Deleted Successfully..!";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        TempData["ErrorMessage"] = "Error in deleting data";
                        tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                        tKTradersDBContext.SaveChanges();
                    }
                }
            }
            else
                TempData["ErrorMessage"] = "Error in deleting data";
            return RedirectToAction("GetOrders");
        }
        private Tuple<bool, string> validate(Order order)
        {
            if (order.TransportTypeId == 0)
                return new Tuple<bool, string>(false, "Please Select Transport Type");
            if (order.TransportTypeId != 2 && order.TransportTypeId != 4 && order.SupplierId == 0)
                return new Tuple<bool, string>(false, "Please Select Supplier");
            if (order.TransportTypeId != 2 && order.TransportTypeId != 4 && order.SenderSiteId == 0)
                return new Tuple<bool, string>(false, "Please Select Supplier Site");
            if (order.TransportTypeId != 2 && order.TransportTypeId != 4 && order.SupplierId != -999 && order.SupplierId == order.CustomerId && order.SenderSiteId == order.ReceiverSiteId)
                return new Tuple<bool, string>(false, "Site can not be same");
            if (order.TransportTypeId != 2 && order.TransportTypeId != 4 && order.SupplierId == -999)
            {
                if (string.IsNullOrEmpty(order.SupplierMobile))
                    return new Tuple<bool, string>(false, "Please Enter Supplier Mobile");
                else if (string.IsNullOrEmpty(order.SupplierName))
                    return new Tuple<bool, string>(false, "Please Enter Supplier Name");
                else if (string.IsNullOrEmpty(order.SupplierAddress))
                    return new Tuple<bool, string>(false, "Please Enter Supplier Address");
            }
            if (order.TransportTypeId > 1 && order.TransportTypeId != 4 && order.CustomerId == 0)
                return new Tuple<bool, string>(false, "Please Select Customer");
            if (order.TransportTypeId > 1 && order.TransportTypeId != 4 && order.CustomerId == -999)
            {
                if (string.IsNullOrEmpty(order.CustomerMobile))
                    return new Tuple<bool, string>(false, "Please Enter Customer Mobile");
                else if (string.IsNullOrEmpty(order.CustomerName))
                    return new Tuple<bool, string>(false, "Please Enter Customer Name");
                else if (string.IsNullOrEmpty(order.CustomerAddress))
                    return new Tuple<bool, string>(false, "Please Enter Customer Address");
            }
            if (order.OrderDate.Date == DateTime.MinValue.Date)
                return new Tuple<bool, string>(false, "Please select order date");           
            if ((order.OrderDate.Date < DateTime.Now.Date && order.StatusTypeId == 1) || (order?.OrderDate.Date > DateTime.Now.Date && order.StatusTypeId == 2))
                return new Tuple<bool, string>(false, "Please select valid date and status type" );

            if (tKTradersDBContext.TUserMasters.Where(user => user.UserId == order.CustomerId && (user.UserTypeId == 3 || user.UserTypeId == 5)).Any() && order.ReceiverSiteId == 0)
                return new Tuple<bool, string>(false, "Please select customer site");

            if (order.TOrderProductDetail == null)
                return new Tuple<bool, string>(false, "Please Provide Product Details");
            if (order.TOrderProductDetail.ProductId == 0)
                return new Tuple<bool, string>(false, "Please Select Product");
            if (order.TOrderProductDetail.ProductTypeId == 0)
                return new Tuple<bool, string>(false, "Please Select Product Type");
            if (order.TOrderProductDetail.Quantity == 0)
                return new Tuple<bool, string>(false, "Please Enter Quantity");
            if ((order.TransportTypeId == 2 || order.TransportTypeId == 4) && getAvailableStock(order.TOrderProductDetail.ProductId, order.TOrderProductDetail.ProductTypeId, order.OrderId) < order.TOrderProductDetail.Quantity)
                return new Tuple<bool, string>(false, "Quantity can not be more than available stock.");
            //if ((order.TransportTypeId == 2) && order.TOrderProductDetail.BuyAmount == 0)
            //    return new Tuple<bool, string>(false, "Please Enter Invest Amount");
            if ((order.TransportTypeId == 1 || order.TransportTypeId == 5) && order.TOrderProductDetail.BuyAmount == 0)
                return new Tuple<bool, string>(false, "Please Enter Buy Amount");
            if ((order.TransportTypeId == 2 || order.TransportTypeId == 5) && order.TOrderProductDetail.SellAmount == 0)
                return new Tuple<bool, string>(false, "Please Enter Sell Amount");
            if (order.TransportTypeId != 1 && order.TransportTypeId != 6 && order.TOrderProductDetail.SellAmount < order.TOrderProductDetail.SellPaidAmount)
                return new Tuple<bool, string>(false, "Paid amount should not be more that total amount");

            if (order.TransportTypeId != 4 && order.TruckId == 0)
                return new Tuple<bool, string>(false, "Please Select Truck");
            if (order.TransportTypeId != 4 && order.TruckId == -999)
            {
                if (string.IsNullOrEmpty(order.TruckNumber))
                    return new Tuple<bool, string>(false, "Please Enter Truck Number");
                else if (string.IsNullOrEmpty(order.TruckOwnerMobile))
                    return new Tuple<bool, string>(false, "Please Enter Truck Owner Mobile");
                else if (string.IsNullOrEmpty(order.TruckOwnerName))
                    return new Tuple<bool, string>(false, "Please Enter Truck Owner Name");
            }
            if (order.TOrderTruckDetail == null)
                return new Tuple<bool, string>(false, "Please Provide Truck Details");
            if (order.TOrderTruckDetail.TruckRent == 0)
                return new Tuple<bool, string>(false, "Please Enter Truck Rent");
            //if (order.TransportTypeId != 4 && order.TruckId == -999 && order.TOrderTruckDetail.TruckRent < order.TOrderTruckDetail.PaidRent)
            //    return new Tuple<bool, string>(false, "Paid rent should not be more that truck rent");
            //if (order.TransportTypeId != 4 && order.TransportTypeId == 6 && order.TOrderTruckDetail.TruckRent < order.TOrderTruckDetail.PaidRent)
            //    return new Tuple<bool, string>(false, "Paid rent should not be more that truck rent");
            //if (order.TransportTypeId != 4 && order.TruckId > 0)
            //{
            //    if (order.TOrderTruckDetail.TruckRent == 0)
            //        return new Tuple<bool, string>(false, "Please Enter Truck Rent");
               
            //}


            if (order.TransportTypeId != 4 && order.DriverId == 0)
                return new Tuple<bool, string>(false, "Please Select Driver");
            if (order.TransportTypeId != 4 && order.DriverId == -999)
            {
                if (string.IsNullOrEmpty(order.DriverMobile))
                    return new Tuple<bool, string>(false, "Please Enter Driver Mobile");
                else if (string.IsNullOrEmpty(order.DriverName))
                    return new Tuple<bool, string>(false, "Please Enter Driver Name");
            }

            return new Tuple<bool, string>(true, "Success");
        }
        private int getAvailableStock(int productId, int productTypeId, int transportId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "[sInventory].[usp_GetAvailableStock]";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@rProductId", productId);
                        cmd.Parameters.AddWithValue("@rProductTypeId", productTypeId);
                        cmd.Parameters.AddWithValue("@rTransportTypeId", transportId);
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataSet ds = new DataSet();
                            sda.Fill(ds);
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                                return Convert.ToInt32(ds.Tables[0].Rows[0]["Stock"]);
                            else
                                return 0;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       

        private void loadDropdowns(int productId, int customerId)
        {
            CommonController commonController = new CommonController(tKTradersDBContext);
            ViewBag.ddlCustomer = commonController.GetCustomers();
            ViewBag.ddlCustomerSite = commonController.GetSitesByUser(customerId);
            ViewBag.ddlSupplier = commonController.GetSuppliers();
            ViewBag.ddlProduct = commonController.GetProducts();
            ViewBag.ddlProductType = commonController.GetProductTypes(productId);
            ViewBag.ddlTruck = commonController.GetTrucks();
            ViewBag.ddlDriver = commonController.GetDrivers();
        }
        private IEnumerable<Order> getOrders()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(configuration.GetConnectionString("TKTradersDB")))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "[sInventory].[usp_GetOrders]";
                        cmd.CommandType = CommandType.StoredProcedure;
                        // cmd.Parameters.AddWithValue("@rType", 1);
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
                                    Amount = _order.Field<decimal>("Amount"),
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
        private void sendSMS(TOrder order, TUser loggedUser)
        {
            try
            {
                //--------Send SMS 
                OrderMessage orderMessage = new OrderMessage();
                orderMessage.OrderDate = order.OrderDate.ToString("dd-MMM-yyyy");
                orderMessage.Quantity = order.TOrderProductDetail.Quantity;
                orderMessage.BuyAmount = order.TOrderProductDetail.BuyAmount;
                orderMessage.SellAmount = order.TOrderProductDetail.SellAmount;
                orderMessage.SellPaidAmount = order.TOrderProductDetail.SellPaidAmount;
                orderMessage.Product = tKTradersDBContext.TProducts.Where(product => product.Id == order.TOrderProductDetail.ProductId).Select(product => product.Title).FirstOrDefault();
                orderMessage.ProductType = tKTradersDBContext.TProductTypes.Where(productType => productType.ProductId == order.TOrderProductDetail.ProductId && productType.Id == order.TOrderProductDetail.ProductTypeId).Select(product => product.Title).FirstOrDefault();
                var customerProfile = tKTradersDBContext.TUserMasters.Where(user => user.UserId == order.CustomerId).FirstOrDefault();
                SMSRequest sMSRequest = new SMSRequest();
                SendSMS sendSMS = new SendSMS(configuration);
                if (order.TransportTypeId == 2)
                {
                    orderMessage.SupplierName = loggedUser.Name;
                    orderMessage.CustomerName = customerProfile.Name;

                    sMSRequest.MessageBody = sendSMS.getReceiverOrderMessage(orderMessage);
                    sMSRequest.MobileNumber = customerProfile.MobileNumber;
                    var resultCustomer = sendSMS.send(sMSRequest);
                    TNotification customerNotification = new TNotification();
                    customerNotification.Message = resultCustomer;
                    customerNotification.UserId = order.CustomerId;
                    customerNotification.MobileNumber = sMSRequest.MobileNumber;
                    customerNotification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(customerNotification);

                    sMSRequest.MessageBody = sendSMS.getSupplierOrderMessage(orderMessage);
                    sMSRequest.MobileNumber = loggedUser.MobileNumber;
                    var resultSupplier = sendSMS.send(sMSRequest);
                    TNotification supplierNotification = new TNotification();
                    supplierNotification.Message = resultSupplier;
                    supplierNotification.UserId = loggedUser.Id;
                    supplierNotification.MobileNumber = sMSRequest.MobileNumber;
                    supplierNotification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(supplierNotification);
                    tKTradersDBContext.SaveChanges();
                }
                else if (order.TransportTypeId == 3)
                {
                    var supplierProfile = tKTradersDBContext.TUserMasters.Where(user => user.UserId == order.SupplierId).FirstOrDefault();
                    orderMessage.SupplierName = supplierProfile.Name;
                    orderMessage.CustomerName = "TK Traders";
                    orderMessage.SellAmount = order.TOrderProductDetail.BuyAmount;

                    sMSRequest.MessageBody = sendSMS.getSupplierOrderMessage(orderMessage);
                    sMSRequest.MobileNumber = supplierProfile.MobileNumber;
                    var resultSupplier = sendSMS.send(sMSRequest);
                    TNotification supplierNotification = new TNotification();
                    supplierNotification.Message = resultSupplier;
                    supplierNotification.UserId = supplierProfile.UserId;
                    supplierNotification.MobileNumber = sMSRequest.MobileNumber;
                    supplierNotification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(supplierNotification);


                    sMSRequest.MessageBody = sendSMS.getReceiverOrderMessage(orderMessage);
                    sMSRequest.MobileNumber = customerProfile.MobileNumber;
                    var resultCustomer = sendSMS.send(sMSRequest);
                    TNotification customerNotification = new TNotification();
                    customerNotification.Message = resultCustomer;
                    customerNotification.UserId = order.CustomerId;
                    customerNotification.MobileNumber = sMSRequest.MobileNumber;
                    customerNotification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(customerNotification);

                    /*******************TK Traders Notification*************************/
                    orderMessage.SupplierName = loggedUser.Name;
                    orderMessage.CustomerName = customerProfile.Name;


                    sMSRequest.MessageBody = sendSMS.getSupplierOrderMessage(orderMessage);
                    sMSRequest.MobileNumber = loggedUser.MobileNumber;
                    var tkTradersSupplier = sendSMS.send(sMSRequest);
                    TNotification tkTradersNotification = new TNotification();
                    tkTradersNotification.Message = resultSupplier;
                    tkTradersNotification.UserId = supplierProfile.UserId;
                    tkTradersNotification.MobileNumber = sMSRequest.MobileNumber;
                    tkTradersNotification.CreatedDateTime = DateTime.Now;
                    tKTradersDBContext.TNotifications.Add(tkTradersNotification);


                    tKTradersDBContext.SaveChanges();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }


        }
        private string getAddress(int cityId, int districtId, int stateId)
        {
            string address = string.Empty;
            address = tKTradersDBContext.TCities.Where(city => city.Id == cityId).Join(tKTradersDBContext.TDistricts.Where(district => district.Id == districtId), city => city.DistrictId, district => district.Id, (city, district) => city.Name + ", " + district.Name).FirstOrDefault();
            address = address + " - Maharashtra";
            return address;
        }
        private Tuple<decimal,string> getAmounts(int transportTypeId, int productTypeId, decimal quantity)
        {
            decimal SellAmount = 0;
            decimal FinalSellAmount = 0;
            List<ReferredOrders> fReferredOrders = new List<ReferredOrders>();
            if (transportTypeId == 2 || transportTypeId == 4 || transportTypeId == 6)
            {
                try
                {
                    var orderProductDetail = tKTradersDBContext.TOrders.Where(order =>order.StatusTypeId==2 && order.TransportTypeId == 1).Join(tKTradersDBContext.TOrderProductDetails.Where(productDetails => productDetails.ProductTypeId == productTypeId && productDetails.RemainingQuantity > 0), order => order.OrderId, orderProduct => orderProduct.OrderId, (order, orderProduct) => orderProduct);
                    foreach (var orderProduct in orderProductDetail)
                    {
                        if (quantity == orderProduct.RemainingQuantity)
                        {
                            orderProduct.StockTypeId = 3;
                            SellAmount = (orderProduct.BuyAmount * quantity) / orderProduct.Quantity;
                            orderProduct.RemainingQuantity = 0;
                            fReferredOrders.Add(new ReferredOrders { OrderId = orderProduct.OrderId, Quantity = quantity, Amount = SellAmount });
                            tKTradersDBContext.TOrderProductDetails.Update(orderProduct);
                            FinalSellAmount = FinalSellAmount + SellAmount;
                            //tKTradersDBContext.SaveChanges();
                            return new Tuple<decimal, string>(FinalSellAmount,JsonConvert.SerializeObject(fReferredOrders));
                        }
                        else if (quantity < orderProduct.RemainingQuantity)
                        {
                            orderProduct.StockTypeId = 2;
                            SellAmount = (orderProduct.BuyAmount * quantity) / orderProduct.Quantity;
                            fReferredOrders.Add(new ReferredOrders { OrderId = orderProduct.OrderId, Quantity = quantity, Amount = SellAmount });
                            orderProduct.RemainingQuantity = orderProduct.RemainingQuantity - quantity;                            
                            tKTradersDBContext.TOrderProductDetails.Update(orderProduct);
                            FinalSellAmount = FinalSellAmount + SellAmount;
                            //tKTradersDBContext.SaveChanges();
                            return new Tuple<decimal, string>(FinalSellAmount, JsonConvert.SerializeObject(fReferredOrders));
                        }
                        else if (quantity > orderProduct.RemainingQuantity)
                        {                            
                            SellAmount = (orderProduct.BuyAmount * orderProduct.RemainingQuantity) / orderProduct.Quantity;
                            fReferredOrders.Add(new ReferredOrders { OrderId = orderProduct.OrderId, Quantity = orderProduct.RemainingQuantity, Amount = SellAmount });
                            quantity = quantity - orderProduct.RemainingQuantity;
                            orderProduct.RemainingQuantity = 0;
                            orderProduct.StockTypeId = 3;                            
                            tKTradersDBContext.TOrderProductDetails.Update(orderProduct);
                            FinalSellAmount = FinalSellAmount + SellAmount;
                            //tKTradersDBContext.SaveChanges();                        
                        }

                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            return new Tuple<decimal, string>(FinalSellAmount, JsonConvert.SerializeObject(fReferredOrders));
        }

    }

}

