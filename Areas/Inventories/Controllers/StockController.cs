using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using TKTradersWebApp.Areas.Inventories.Models;
using TKTradersWebApp.Areas.Securities.Controllers;
using TKTradersWebApp.CommonModel;
using TKTradersWebApp.EFServices;
using TKTradersWebApp.SessionManagement;

namespace TKTradersWebApp.Areas.Inventories.Controllers
{
    [SessionTimeout]
    public class StockController : Controller
    {
        private readonly TKTradersDBContext tKTradersDBContext;
        private readonly IConfiguration configuration;
        private static decimal _TotalAmount = 0;
        public StockController(TKTradersDBContext tKTradersDBContext, IConfiguration configuration)
        {
            this.tKTradersDBContext = tKTradersDBContext;
            this.configuration = configuration;
        }
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult AddStock()
        {
            return View();
        }

        public IActionResult LoadStock(int productTypeId)
        {
            try
            {
                int productId = tKTradersDBContext.TProductTypes.Where(x => x.Id == productTypeId).Select(x => x.ProductId).First() ?? 0;
                DataSet dataSet = getAvailableStock(productId, productTypeId, 0);
                if (dataSet != null)
                {
                    return Json(new { statusCode = 1, data = Convert.ToDecimal(dataSet.Tables[0].Rows[0]["Stock"]) });
                }
            }
            catch (Exception ex)
            {

            }
            return Json(new { statusCode = -101, data = 0 });
        }
        public IActionResult ViewStock(int productId, int productTypeId)
        {
            IQueryable<ListCollection> listCollections = from m1 in tKTradersDBContext.TProducts.Where(product => product.IsObsolete == false && product.Id == productId)
                                                         join m2 in tKTradersDBContext.TProductTypes.Where(productType => productType.IsObsolete == false && productType.ProductId == productId && productType.Id == productTypeId)
                                                         on m1.Id equals m2.ProductId
                                                         select new { ProductId = m1.Id, ProductTypeId = m2.Id, ProductName = m2.Title + " " + m1.Title, ImagePath = m2.ImagePath } into intermediate1
                                                         join m3 in tKTradersDBContext.TStocks.Where(stock => stock.IsObsolete == false) on new { ProductId = intermediate1.ProductId, ProductTypeId = intermediate1.ProductTypeId } equals new { ProductId = m3.ProductId, ProductTypeId = m3.ProductTypeId }
                                                         join m4 in tKTradersDBContext.TStaticTransportTypes.Where(x => x.IsObsolete == false) on m3.TransportTypeId equals m4.Id
                                                         select new ListCollection { Id = Convert.ToInt32(m3.Id), ProductId = intermediate1.ProductId, ProductTypeId = intermediate1.ProductTypeId, ProductName = intermediate1.ProductName, TransportTypeId = m4.Id, TransportTypeName = m4.Title, Stock = m3.Quantity, ImagePath = intermediate1.ImagePath, CreatedDate = m3.CreatedDate, InvestedItemCount = tKTradersDBContext.TStockInvestments.Where(x => x.StockId == m3.Id).Count() };
            if (listCollections == null || listCollections.Count() == 0)
                TempData["ErrorMessage"] = "Stock is not available";

            return View(listCollections);
        }
        public IActionResult EditStock(int id)
        {
            AddStock addStock = new AddStock();
            var stock = tKTradersDBContext.TStocks.Where(stock => stock.IsObsolete == false && stock.Id == id).FirstOrDefault();
            if (stock != null)
            {
                var orderProduct = tKTradersDBContext.TOrderProductDetails.Where(x => x.OrderId == stock.OrderId).FirstOrDefault();
                if (orderProduct != null)
                {
                    addStock.Id = stock.Id;
                    addStock.Title = stock.Title;
                    addStock.OrderId = stock.OrderId;
                    addStock.ProductId = stock.ProductId;
                    addStock.ProductTypeId = stock.ProductTypeId;
                    addStock.Quantity = stock.Quantity;
                    addStock.TotalAmount = orderProduct.BuyAmount;
                    addStock.TStockInvestments = tKTradersDBContext.TStockInvestments.Where(x => x.StockId == id).ToList();
                }
            }
            GetDropdown(addStock.ProductId);
            return View(addStock);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult EditStock(AddStock addStock)
        {
            try
            {
                GetDropdown(addStock.ProductId);
                TStock stock1 = tKTradersDBContext.TStocks.Where(stock => stock.Id == addStock.Id).FirstOrDefault();
                if (tKTradersDBContext.TOrderProductDetails.Where(product => product.OrderId == stock1.OrderId && product.StockTypeId > 1).Any())
                {
                    TempData["ErrorMessage"] = "You can not reduce stock becasue it is already been used.";
                    return View(addStock);
                }
                if (addStock != null)
                {
                    var loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");

                    if (stock1 != null)
                    {
                        using (var transaction = tKTradersDBContext.Database.BeginTransaction())
                        {
                            try
                            {


                                TOrder order = tKTradersDBContext.TOrders.Where(x => x.OrderId == stock1.OrderId).FirstOrDefault();
                                order.UpdatedDateTime = DateTime.Now;
                                order.UpdatedBy = loggedUser.Id;
                                order.TOrderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(x => x.OrderId == stock1.OrderId).FirstOrDefault();

                                order.TStock = tKTradersDBContext.TStocks.Where(x => x.Id == stock1.Id).FirstOrDefault();
                                order.TStock.ProductId = addStock.ProductId;
                                order.TStock.ProductTypeId = addStock.ProductTypeId;
                                order.TStock.Quantity = addStock.Quantity;
                                order.TStock.TStockInvestments = addStock.TStockInvestments;

                                order.TOrderProductDetail.ProductId = addStock.ProductId;
                                order.TOrderProductDetail.ProductTypeId = addStock.ProductTypeId;
                                order.TOrderProductDetail.Quantity = addStock.Quantity;
                                order.TOrderProductDetail.RemainingQuantity = addStock.Quantity;
                                order.TOrderProductDetail.BuyAmount = addStock.TotalAmount;

                                tKTradersDBContext.TOrders.Update(order);

                                if (tKTradersDBContext.SaveChanges() > 0)
                                {
                                    //stock1.ProductId = addStock.ProductId;
                                    //stock1.ProductTypeId = addStock.ProductTypeId;
                                    //stock1.Quantity = addStock.Quantity;
                                    //tKTradersDBContext.TStocks.Update(stock1);
                                    //tKTradersDBContext.SaveChanges();
                                    transaction.Commit();
                                    TempData["SuccessMessage"] = "Stock updated successfully..!";
                                    return Json(new { statusCode = 1, statusMessage = "Stock updated successfully" });
                                }
                            }

                            catch (Exception ex)
                            {
                                transaction.Rollback();
                                TempData["SuccessMessage"] = "Something went to wrong, Please contact to administrator..!";
                                return Json(new { statusCode = -101, statusMessage = "Something went to wrong, Please contact to administrator..!" });
                            }
                        }
                    }
                    TempData["SuccessMessage"] = "Error in saving";
                    return Json(new { statusCode = -101, statusMessage = "Error in saving" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -101, statusMessage = "Something went to wrong, Please contact to administrator..!" });
            }
            return Json(new { statusCode = -102, statusMessage = "Error in data..!" });
            // return RedirectToAction("EditStock", new { id = addStock.Id });
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddStock(AddStock addStock)
        {
            if (addStock != null)
            {
                _TotalAmount = addStock.TStockInvestments.Where(x => x.ProductTypeId == -888).Sum(x => x.Amount);
                using (var transaction = tKTradersDBContext.Database.BeginTransaction())
                {
                    try
                    {
                        List<int> fInvestmentOrderIDs = new List<int>();
                        for(int i = 0; i < addStock.TStockInvestments.Where(x => x.ProductTypeId > 0).Count(); i++)
                        {
                            var fInvestments = CreateOrder(addStock.TStockInvestments.Where(x => x.ProductTypeId > 0).ToList()[i]);
                            fInvestmentOrderIDs.Add(fInvestments.Item1);
                            addStock.TStockInvestments.Where(x => x.ProductTypeId > 0).ToList()[i].Amount = fInvestments.Item2;
                        }
                       
                        TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                        TOrder order = new TOrder();
                        order.TransportTypeId = 3;
                        order.SupplierId = (int)Constant.OwnUserId;
                        order.CustomerId = (int)Constant.OwnUserId;
                        order.StatusTypeId = 2;
                        order.OrderDate = DateTime.Now;
                        order.IsInternalTruck = true;
                        order.IsInternalDriver = true;
                        order.Comments = "Internal stock is added";
                        order.CreateDateTime = DateTime.Now;
                        order.CreatedBy = loggedUser.Id;

                        order.TOrderProductDetail = new TOrderProductDetail();
                        order.TOrderProductDetail.ProductId = addStock.ProductId;
                        order.TOrderProductDetail.ProductTypeId = addStock.ProductTypeId;
                        order.TOrderProductDetail.Quantity = addStock.Quantity;
                        order.TOrderProductDetail.RemainingQuantity = addStock.Quantity;
                        order.TOrderProductDetail.StockTypeId = 1;
                        order.TOrderProductDetail.BuyAmount = _TotalAmount;
                        order.TOrderProductDetail.PaymentTypeId = 3;

                        if(fInvestmentOrderIDs.Count>0)
                        order.TOrderProductDetail.InvestmenOrderIds = JsonConvert.SerializeObject(fInvestmentOrderIDs);

                        order.TOrderTruckDetail = new TOrderTruckDetail();
                        order.TOrderTruckDetail.TruckOwnerId = (int)Constant.OwnUserId;
                        order.TOrderTruckDetail.PaymentTypeId = 3;
                        addStock.TransportTypeId = 3;
                        addStock.IsObsolete = false;
                        addStock.CreatedDate = DateTime.Now;
                        addStock.CreatedBy = loggedUser.Id;
                        order.TStock = addStock;
                        tKTradersDBContext.TOrders.Add(order);
                       
                        if (tKTradersDBContext.SaveChanges() > 0)
                        {
                            //addStock.IsObsolete = false;
                            //addStock.CreatedDate = DateTime.Now;
                            //addStock.CreatedBy = loggedUser.Id;
                            //tKTradersDBContext.TStocks.Add(addStock);
                            //tKTradersDBContext.SaveChanges();
                            transaction.Commit();
                            return Json(new { statusCode = 1, statusMessage = "Stock added successfully" });

                            //return RedirectToAction("AddStock");
                        }

                    }


                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return Json(new { statusCode = -101, statusMessage = "Something went to wrong, Please contact to administrator..!" });
                    }
                }

            }
            else
                return Json(new { statusCode = -101, statusMessage = "Error in saving" });
            return Json(new { statusCode = -101, statusMessage = "Error in data..!" });
        }

        private Tuple<int,decimal> CreateOrder(TStockInvestment stockInvestment)
        {
           
                try
                {
                    TUser loggedUser = SessionHelper.GetObjectFromJson<TUser>(HttpContext.Session, "UserProfile");
                    TOrder order = new TOrder();
                    order.TransportTypeId = 4;
                    order.SupplierId = (int)Constant.OwnUserId;
                    order.CustomerId = (int)Constant.OwnUserId;
                    order.StatusTypeId = 2;
                    order.OrderDate = DateTime.Now;
                    order.IsInternalTruck = true;
                    order.IsInternalDriver = true;
                    order.Comments = "Internal used";
                    order.CreateDateTime = DateTime.Now;
                    order.CreatedBy = loggedUser.Id;

                    order.TOrderProductDetail = new TOrderProductDetail();
                    order.TOrderProductDetail.ProductId = tKTradersDBContext.TProductTypes.Where(x => x.Id == stockInvestment.ProductTypeId)?.FirstOrDefault()?.ProductId ?? 0;
                    order.TOrderProductDetail.ProductTypeId = stockInvestment.ProductTypeId;
                    order.TOrderProductDetail.Quantity = stockInvestment.Quantity;
                    order.TOrderProductDetail.RemainingQuantity = stockInvestment.Quantity;
                    order.TOrderProductDetail.StockTypeId = 1;
                    var fAmount = getAmounts(4, order.TOrderProductDetail.ProductTypeId, order.TOrderProductDetail.Quantity);
                    order.TOrderProductDetail.BuyAmount = fAmount.Item1;
                    _TotalAmount = _TotalAmount + fAmount.Item1;
                    order.TOrderProductDetail.ReferredOrders = fAmount.Item2;
                    order.TOrderProductDetail.PaymentTypeId = 3;

                    order.TOrderTruckDetail = new TOrderTruckDetail();
                    order.TOrderTruckDetail.TruckOwnerId = (int)Constant.OwnUserId;
                    order.TOrderTruckDetail.PaymentTypeId = 3;

                    AddStock addStock = new AddStock();
                    addStock.ProductId = order.TOrderProductDetail.ProductId;
                    addStock.ProductTypeId = order.TOrderProductDetail.ProductTypeId;
                    addStock.Quantity = order.TOrderProductDetail.Quantity;
                    addStock.TransportTypeId = 4;
                    addStock.IsObsolete = false;
                    addStock.CreatedDate = DateTime.Now;
                    addStock.CreatedBy = loggedUser.Id;
                    order.TStock = addStock;
                    tKTradersDBContext.TOrders.Add(order);
                    tKTradersDBContext.SaveChanges();
                return new Tuple<int,decimal>(order.OrderId,fAmount.Item1);
                }
                catch (Exception ex)
                {
                     throw;
                }           
        }

        public int DeleteOrder(int orderId)
        {

            TOrderProductDetail orderProduct = tKTradersDBContext.TOrderProductDetails.Where(orderProduct => orderProduct.OrderId == orderId).First();
            if (orderProduct?.StockTypeId > 1)
            {
                TempData["ErrorMessage"] = "Stock is being used. Order can't be deleted.";
                return -1;
            }
            try
            {
                TOrder order = tKTradersDBContext.TOrders.Where(order => order.OrderId == orderId).FirstOrDefault();
                if (order.TransportTypeId != 5 && order.TransportTypeId != 6 && orderProduct.ReferredOrders != null)
                {
                    List<ReferredOrders> fReferredOrders = JsonConvert.DeserializeObject<List<ReferredOrders>>(orderProduct.ReferredOrders);
                    List<TOrderProductDetail> fTOrderProductDetails = new List<TOrderProductDetail>();

                    if (fReferredOrders != null && fReferredOrders.Count > 0)
                    {
                        foreach (ReferredOrders referredOrder in fReferredOrders)
                        {
                            TOrderProductDetail fTOrderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(x => x.OrderId == referredOrder.OrderId).FirstOrDefault();
                            if (fTOrderProductDetail != null)
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

                if (order.TransportTypeId != 5 && order.TransportTypeId != 6)
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
                return tKTradersDBContext.SaveChanges();

            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error in deleting data";
                tKTradersDBContext.TLogErrors.Add(new TLogError { ErrorMessage = ex.ToString(), StackTrace = ex.StackTrace, CreateDate = DateTime.Now });
                tKTradersDBContext.SaveChanges();
                throw;
            }


        }
        public IActionResult GetStocks()
        {
            List<ListCollection> listCollections = new List<ListCollection>();
            DataSet dataSet = getAvailableStock(0, 0, 0);
            if (dataSet != null && dataSet.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < dataSet.Tables[0].Rows.Count; i++)
                {
                    ListCollection listCollection = new ListCollection();
                    listCollection.ProductId = Convert.ToInt32(dataSet.Tables[0].Rows[i]["ProductId"]);
                    listCollection.ProductTypeId = Convert.ToInt32(dataSet.Tables[0].Rows[i]["ProductTypeId"]);
                    listCollection.ProductName = Convert.ToString(dataSet.Tables[0].Rows[i]["ProductName"]);
                    listCollection.ImagePath = Convert.ToString(dataSet.Tables[0].Rows[i]["ImagePath"]);
                    listCollection.Stock = Convert.ToDecimal(dataSet.Tables[0].Rows[i]["Stock"]);
                    listCollection.ItemCount = Convert.ToInt32(dataSet.Tables[0].Rows[i]["ItemCount"]);

                    listCollections.Add(listCollection);
                }
            }
            return View(listCollections);
        }
        public IActionResult GetStock(int productId, int productTypeId, int transportId = 0)
        {
            try
            {
                DataSet dataSet = getAvailableStock(productId, productTypeId, transportId);

                if (dataSet != null && dataSet.Tables[0].Rows.Count > 0)
                    return Json(new { statusCode = 1, data = JsonConvert.SerializeObject(dataSet) });
                else
                    return Json(new { statusCode = -102, data = "Stock is not available" });
            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -101, data = "Something went to wrong, Please contact to administrator..!" });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteStock(TStock stock)
        {
            try
            {
                var _stock = tKTradersDBContext.TStocks.Where(stockDB => stockDB.TransportTypeId == 3 && stockDB.Id == stock.Id).FirstOrDefault();
                //if (!validateStock(_stock.Id, 0, _stock.ProductId, _stock.ProductTypeId))
                //    return Json(new { statusCode = -101, statusMessage = "Stock is being used. It can't be deleted" });


                if (tKTradersDBContext.TOrderProductDetails.Where(product => product.OrderId == _stock.OrderId && product.StockTypeId > 1).Any())
                    return Json(new { statusCode = -101, statusMessage = "Stock is being used. It can't be deleted" });
                if (_stock != null)
                {
                    using (var transaction = tKTradersDBContext.Database.BeginTransaction())
                    {
                        try
                        {
                            var stockInvestment = tKTradersDBContext.TStockInvestments.Where(x => x.StockId == stock.Id);
                            tKTradersDBContext.TStockInvestments.RemoveRange(stockInvestment);
                            tKTradersDBContext.TStocks.Remove(_stock);
                            var orderTruckDetails = tKTradersDBContext.TOrderTruckDetails.Where(x => x.OrderId == _stock.OrderId).FirstOrDefault();
                            var orderProductDetail = tKTradersDBContext.TOrderProductDetails.Where(product => product.OrderId == _stock.OrderId).FirstOrDefault();
                            List<int> fInvestmentOrderIDs = JsonConvert.DeserializeObject<List<int>>(orderProductDetail.InvestmenOrderIds);
                            for(int i=0;i<fInvestmentOrderIDs?.Count;i++)
                            {
                                if (DeleteOrder(fInvestmentOrderIDs[i]) != 1)
                                    new Exception("Stock can't be deleted");
                            }
                            var order = tKTradersDBContext.TOrders.Where(x => x.OrderId == _stock.OrderId).FirstOrDefault();
                            tKTradersDBContext.TOrderTruckDetails.Remove(orderTruckDetails);
                            tKTradersDBContext.TOrderProductDetails.Remove(orderProductDetail);
                            tKTradersDBContext.TOrders.Remove(order);
                            if (tKTradersDBContext.SaveChanges() > 0)
                            {
                                transaction.Commit();
                                return Json(new { statusCode = 1, statusMessage = "Stock deleted successfully" });
                            }

                            else
                                return Json(new { statusCode = -101, statusMessage = "Error in deleting" });
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            return Json(new { statusCode = -102, statusMessage = "Something went wrong, please contact to administrator..!" });
                        }
                    }
                }
                return Json(new { statusCode = -101, statusMessage = "You can't delete this stock" });

            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -102, statusMessage = "Something went wrong, please contact to administrator..!" });
            }

        }
        public IActionResult Investment()
        {
            IQueryable<StockView> fStockView = tKTradersDBContext.TStocks.Where(x=>x.TransportTypeId == 3).Select(x=>new StockView { Title=x.Title,StockId=x.Id});
            

            return View(fStockView);
        }

        public IActionResult GetInvestment(int stockId)
        {

            List<StockView> fStockView = (
                                                from stock in tKTradersDBContext.TStocks.Where(x => x.Id == stockId)
                                                join investment in tKTradersDBContext.TStockInvestments on stock.Id equals investment.StockId
                                                select new StockView { InvestmentId = investment.Id, StockId = stock.Id, Title = stock.Title, ProductTypeId = investment.ProductTypeId, Quantity = investment.Quantity, Amount = investment.Amount }).ToList();
            if (fStockView != null && fStockView.Count() > 0)
            {
                StringBuilder sb = new StringBuilder();
                foreach (var inevestment in fStockView)
                {
                    sb.Append("<tr>");
                    sb.Append("<td>" + inevestment.InvestmentId + "</td>");
                    //sb.Append("<td>" + inevestment.Title + "</td>");
                    sb.Append("<td>" + GetProductName(inevestment.ProductTypeId) + "</td>");
                    sb.Append("<td>" + inevestment.Quantity + "</td>");
                    sb.Append("<td>" + inevestment.Amount + "</td>");
                    sb.Append("<tr>");
                }
                return Json(new { statusCode = 1, data = sb.ToString() });
            }
            else
                return Json(new { statusCode = -101, data = "" });
        }
        private string GetProductName(int productTypeId)
        {
            string productName = tKTradersDBContext.TProducts.Join(tKTradersDBContext.TProductTypes.Where(x => x.Id == productTypeId), x => x.Id, y => y.ProductId, (x, y) => y.Title + " " + x.Title).FirstOrDefault();
            if (productTypeId == (int)Constant.LabourChargeId)
                return "Lobour Charges";
            return productName;
        }
        public IActionResult DeleteInvestment(int stockId, int investmentId)
        {
            try
            {
                var _stock = tKTradersDBContext.TStocks.Where(stockDB => stockDB.TransportTypeId == 3 && stockDB.Id == stockId).FirstOrDefault();


                if (tKTradersDBContext.TOrderProductDetails.Where(product => product.OrderId == _stock.OrderId && product.StockTypeId > 1).Any())
                    return Json(new { statusCode = -101, statusMessage = "Stock is being used. It can't be deleted" });
                if (_stock != null)
                {
                    using (var transaction = tKTradersDBContext.Database.BeginTransaction())
                    {
                        try
                        {
                            var investment = tKTradersDBContext.TStockInvestments.Where(x => x.Id == investmentId).FirstOrDefault();
                            tKTradersDBContext.TStockInvestments.Remove(investment);
                            if (tKTradersDBContext.SaveChanges() > 0)
                            {
                                transaction.Commit();
                                return Json(new { statusCode = 1, statusMessage = "Investment deleted successfully" });
                            }

                            else
                                return Json(new { statusCode = -101, statusMessage = "Error in deleting" });
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            return Json(new { statusCode = -102, statusMessage = "Something went wrong, please contact to administrator..!" });
                        }
                    }
                }
                return Json(new { statusCode = -101, statusMessage = "You can't change this stock" });

            }
            catch (Exception ex)
            {
                return Json(new { statusCode = -102, statusMessage = "Something went wrong, please contact to administrator..!" });
            }

        }
        private DataSet getAvailableStock(int productId, int productTypeId, int transportId)
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
                            return ds;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private bool validateStock(int id, decimal quantity, int productId, int productTypeId)
        {
            decimal importedStock = tKTradersDBContext.TStocks.Where(stock => stock.IsObsolete == false && stock.Id != id && stock.ProductId == productId && stock.ProductTypeId == productTypeId && (stock.TransportTypeId == 1 || stock.TransportTypeId == 6)).Sum(stock => stock.Quantity);
            decimal exportedStock = tKTradersDBContext.TStocks.Where(stock => stock.IsObsolete == false && stock.Id != id && stock.ProductId == productId && stock.ProductTypeId == productTypeId && stock.TransportTypeId == 2).Sum(stock => stock.Quantity);
            importedStock = quantity + importedStock;
            if (importedStock < exportedStock)
                return false;
            return true;
        }
        private void GetDropdown(int ProductId)
        {
            CommonController commonController = new CommonController(tKTradersDBContext);
            ViewBag.ProductDropdown = commonController.GetProducts();
            ViewBag.ProductTypesDropdown = commonController.GetProductTypes(ProductId);
            var fProducts = commonController.GetInvestmentProductTypes(-1);
            fProducts.Insert(0, new SelectListItem { Value = Constant.OwnUserId.ToString(), Text = "Lobour Charge" });
            ViewBag.InvestmentProductDropdown = fProducts;
        }

        private Tuple<decimal, string> getAmounts(int transportTypeId, int productTypeId, decimal quantity)
        {
            decimal SellAmount = 0;
            decimal FinalSellAmount = 0;
            List<ReferredOrders> fReferredOrders = new List<ReferredOrders>();
            if (transportTypeId == 2 || transportTypeId == 4 || transportTypeId == 6)
            {
                try
                {
                    var orderProductDetail = tKTradersDBContext.TOrders.Where(order => order.StatusTypeId == 2 && order.TransportTypeId == 1).Join(tKTradersDBContext.TOrderProductDetails.Where(productDetails => productDetails.ProductTypeId == productTypeId && productDetails.RemainingQuantity > 0), order => order.OrderId, orderProduct => orderProduct.OrderId, (order, orderProduct) => orderProduct);
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
                            return new Tuple<decimal, string>(FinalSellAmount, JsonConvert.SerializeObject(fReferredOrders));
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
