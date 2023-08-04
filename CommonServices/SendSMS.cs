using System.Text;
using TKTradersWebApp.Models;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace TKTradersWebApp.CommonServices
{
    public class SendSMS
    {
        private IConfiguration configuration;
        private readonly string AuthSID;
        private readonly string AuthToken;
        public SendSMS(IConfiguration configuration)
        {
            this.configuration = configuration;
            AuthSID = configuration.GetSection("AppSettings:TWILIOSID").Value;
            AuthToken = configuration.GetSection("AppSettings:TWILIOTOKEN").Value;
        }
        public string send(SMSRequest sMSRequest)
        {
            try
            {
                
                TwilioClient.Init(AuthSID, AuthToken);

                var message = MessageResource.Create(

              body: sMSRequest.MessageBody,
              from: new Twilio.Types.PhoneNumber("+12342616718"),
              to: new Twilio.Types.PhoneNumber("+91" + sMSRequest.MobileNumber)
          );

                return message.Body;
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }
        public string getSupplierOrderMessage(OrderMessage orderMessage)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Hi " + orderMessage.SupplierName + ", \n");
            stringBuilder.Append("Your have delivered order of " + orderMessage.ProductType + " " + orderMessage.Product + " to "+orderMessage.CustomerName+".\n");
            stringBuilder.Append("Order Details:-\n");
            stringBuilder.Append("Order Date: " + orderMessage.OrderDate + "\n");
            stringBuilder.Append("Quantity: " + orderMessage.Quantity + "\n");
            stringBuilder.Append("Total Amount: " + orderMessage.SellAmount + "\n");
            stringBuilder.Append("Paid Amount: " + orderMessage.SellPaidAmount + "\n");
            stringBuilder.Append("Thank you for choosing TK Traders.");
            return stringBuilder.ToString();   
        }
        public string getReceiverOrderMessage(OrderMessage orderMessage)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Hi " + orderMessage.CustomerName + ", \n");
            stringBuilder.Append("Your order for " + orderMessage.ProductType + " " + orderMessage.Product + " has been delievered successfully.\n");
            stringBuilder.Append("Order Details:-\n");
            stringBuilder.Append("Order Date: " + orderMessage.OrderDate + "\n");
            stringBuilder.Append("Quantity: " + orderMessage.Quantity + "\n");
            stringBuilder.Append("Total Amount: " + orderMessage.SellAmount + "\n");
            stringBuilder.Append("Paid Amount: " + orderMessage.SellPaidAmount + "\n");
            stringBuilder.Append("Thank you for choosing TK Traders.");
            return stringBuilder.ToString();
        }
       
    }
}
