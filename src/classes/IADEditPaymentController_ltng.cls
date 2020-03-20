public class IADEditPaymentController_ltng
{
    public IADEditPaymentService dataService{get;set;}
    public String theId{get;set;}

   
    @auraenabled public static map<string ,string> months{get;set;}
    @auraenabled public static map<string ,string> years{get;set;}
    @auraenabled public static map<string ,string> cardtypes{get;set;}
    @auraenabled public static map<string ,string> states{get;set;}
    @auraenabled public static IADContractBeans_ltng.IADPaymentProfileBean profilerequest{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    
    @auraenabled
    public static IADEditPaymentController_ltng onload(string profileid )
    {
         exceptions = new List<IADMessage_ltng>();
     system.debug('the pro '+profileid);
     months = new map<string ,string>();
        years = new map<string ,string>();
        cardtypes = new map<string ,string>();
        states = new map<string ,string>();
        for(SelectOption  expmonth : UtilityLibrary.expMonths)
        {
            months.put(expmonth.getLabel(), expmonth.getValue());
        }
        for(SelectOption  expmonth : UtilityLibrary.expYears)
        {
            years.put(expmonth.getLabel(), expmonth.getValue());
        }
        for(SelectOption  expmonth : UtilityLibrary.paymentTypes)
        {
            cardtypes.put(expmonth.getLabel(), expmonth.getValue());
        }
        for(SelectOption  expmonth : UtilityLibrary.statePicklist)
        {
            states.put(expmonth.getLabel(), expmonth.getValue());
        }
        
        IADEditPaymentService_ltng editpaymentservice = new IADEditPaymentService_ltng();
         IADEditPaymentController_ltng newpayment = new IADEditPaymentController_ltng();
          IADServiceBase_ltng.initWrapper(IADEditPaymentService_ltng.GETPROFILEBYID);
          IADEditPaymentService_ltng.getPaymentProfileById(profileid);
           processProfile();
       
        return  newpayment;
        
    }

    

   
    public static void processProfile()
    {

        try
        {
            IADEditPaymentService_ltng.populateProfileById();
            profilerequest= IADEditPaymentService_ltng.theProfile;
            
            if(Integer.valueOf(IADEditPaymentService_ltng.theProfile.year) < System.today().year())
            {
                years.put(IADEditPaymentService_ltng.theProfile.year, IADEditPaymentService_ltng.theProfile.year);
                }
        }
       
        catch(Exception theException)
        {
             IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
       
    }
    @Auraenabled 
    public static  IADEditPaymentController_ltng  updatePaymentProfile(string profiletoupdate , string profileid ,string customerid ,Boolean deletecheck )
    {
        IADEditPaymentController_ltng newpaymentservice = new IADEditPaymentController_ltng();
      IADContractBeans_ltng.IADPaymentProfileBean   newPayment = (IADContractBeans_ltng.IADPaymentProfileBean) JSON.deserialize(profiletoupdate,IADContractBeans_ltng.IADPaymentProfileBean.class);
        IADEditPaymentService_ltng.theProfile=newPayment;
        IADEditPaymentService_ltng.deletecheck=deletecheck;
        exceptions = new List<IADMessage_ltng>();
        system.debug('the profile o'+IADEditPaymentService_ltng.theProfile);

        try
        {
            if(Integer.valueOf(IADEditPaymentService_ltng.theProfile.year) >= System.today().year() )
            {
            
                 IADEditPaymentService_ltng editpaymentservice = new IADEditPaymentService_ltng();
                IADServiceBase_ltng.initWrapper(IADEditPaymentService_ltng.PUTPROFILEBYID);
                IADEditPaymentService_ltng.customerid=customerid;
                IADEditPaymentService_ltng.putPaymentProfileById(profileid);
                processUpdateProfile();
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage('Please select a current or future year.');
           exceptions = IADServiceBase_ltng.iadMessages;
               // dataService.populateErrorMessage('Please select a current or future year.');
            }
        }
       
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        
exceptions = IADServiceBase_ltng.iadMessages;
return newpaymentservice;
    }
    public static  void  processUpdateProfile()
    {
        try
        {
            IADEditPaymentService_ltng.putPopulateProfileById();

        }
       
        catch(Exception theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
       
    }
    
     @Auraenabled 
    public static  IADEditPaymentController_ltng  deletePaymentProfile(string profiletoupdate , string profileid ,string customerid ,Boolean deletecheck )
    {
        IADEditPaymentController_ltng newpaymentservice = new IADEditPaymentController_ltng();
      IADContractBeans_ltng.IADPaymentProfileBean   newPayment = (IADContractBeans_ltng.IADPaymentProfileBean) JSON.deserialize(profiletoupdate,IADContractBeans_ltng.IADPaymentProfileBean.class);
        IADEditPaymentService_ltng.theProfile=newPayment;
        IADEditPaymentService_ltng.deletecheck=deletecheck;
        exceptions = new List<IADMessage_ltng>();
        system.debug('the profile o'+IADEditPaymentService_ltng.theProfile);

        try
        {
          
                 IADEditPaymentService_ltng editpaymentservice = new IADEditPaymentService_ltng();
                IADServiceBase_ltng.initWrapper(IADEditPaymentService_ltng.DELETEPAYMENTPROFILEBYID);
                IADEditPaymentService_ltng.customerid=customerid;
                IADEditPaymentService_ltng.DeletePaymentProfileById(profileid);
                 processDeleteProfile();
          
        }
       
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
        
exceptions = IADServiceBase_ltng.iadMessages;
return newpaymentservice;
    }
    
    public static  void  processDeleteProfile()
    {
        try
        {
            IADEditPaymentService_ltng.DeleteProfileById();

        }
       
        catch(Exception theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
           exceptions = IADServiceBase_ltng.iadMessages;
        }
       
    }
}