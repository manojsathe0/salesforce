/**
 * Created by jboles on 4/14/2017.
 */

public class SEADContractBeans
{
    public class LeadContactBean
    {
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String uuid{get;set;}
        public String SessionId {get;set;}
        public Integer leadId{get;set;}
        public String email{get;set;}
        public String customerId{get;set;}
        public String phone{get;set;}
        public Datetime VisitStart{get;set;}
        public String device{get;set;}
        public MarketingInfo marketingInfo{get;set;}
        public QuestionnaireInfo questionnaireInfo{get;set;}
        public CartInfo cartInfo{get;set;}
        public MyAccount myAccount{get;set;}
        public UserPage page{get;set;}

    }
    public class MarketingInfo
    {
        public String marketingChannel{get;set;}
        public String marketingSource{get;set;}
        public String marketingCampaign{get;set;}
    }
    public class QuestionnaireInfo
    {
        public Datetime startDateTime{get;set;}
        public Datetime endDateTime{get;set;}
        public Decimal percentageQuestionnaireCompletion{get;set;}
        public String lastPageOnQuestionnaire{get;set;}
        public String processingNumber{get;set;}
        public String processName{get;set;}
        public String packageName{get;set;}
        public String state{get;set;}
        public Decimal amount{get;set;}
        public List<Optins> optIns{get;set;}
        public Milestone milestone{get;set;}
        public String ProcessId{get;set;} //added by Artyom M. per Story B-23468
        public Boolean firstEntity{get;set;} //following fields added by Artyom M. per Story B-27611
        public String businessActivity{get;set;}
        public String promoCode{get;set;}
        public Boolean installmentPayment{get;set;}
    }
    public class Optins
    {
        public String optin{get;set;}
    }
    public class Milestone
    {
        public Boolean purchaseLockPage{get;set;}
        public Boolean productOverviewPage{get;set;}
        public Boolean checkoutPage{get;set;}
    }
    public class CartInfo
    {
        public List<CartItems> cartItems{get;set;}
    }
    public class CartItems
    {
        public String productName{get;set;}
        public Decimal price{get;set;}
    }
    public class MyAccount
    {
        public Datetime startDateTime{get;set;}
        public Datetime endDateTime{get;set;}
        public List<Activities> Activities{get;set;}
    }
    public class Activities
    {
        public String action{get;set;}
    }
    public class UserPage //Page is reserved
    {
        public String pageName{get;set;}
        public Datetime startDateTime{get;set;}
        public Datetime endDateTime{get;set;}
    }
}