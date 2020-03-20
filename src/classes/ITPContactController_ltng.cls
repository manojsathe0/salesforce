public class ITPContactController_ltng
{
    public static string customerid{get;set;}
    @auraenabled public static ITPContactService_ltng Itpservice{get;set;}
    public  static void onload(string contactid)
    {
        
      
         List<Contact> contacts=[select FkUser__c  ,PrimaryContact__c, PrimaryContact__r.name from contact where id=:contactid];
        if(contacts.size()>0)
        {
            
            customerid=contacts[0]. FkUser__c;
            if(contacts[0]. PrimaryContact__c!=null)
            {
                ITPContactService_ltng.Accounttype='PlusOne';
                ITPContactService_ltng.primarycontactName=contacts[0].PrimaryContact__r.name;
            }
            
            else
            {
                
                ITPContactService_ltng.Accounttype='Primary';
            }
        }
    }
    
    
    @Auraenabled 
    public static ITPContactService_ltng AccountStatus(string recordid)
    {
        
        
        
        
        try
        {
            onload(recordid);
            Itpservice = new ITPContactService_ltng();
            IADServiceBase_ltng.initWrapper(ITPContactService_ltng.GETACCOUNTSTATUSBYCUSTOMERID); //, 'processInstallmentResponse'
            
            ITPContactService_ltng.getAccountStatus(customerid);
            IADServiceBase_ltng.initWrapper(ITPContactService_ltng.GETINVITATIONDETAILS);
            // ITPContactService_ltng.getInvitationDetails(customerid);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
        return  Itpservice;
        
    }
    @Auraenabled 
    public static ITPContactService_ltng DeActivateAccount(string recordid,  string subscribernumber ,string reason )
    {
        
        
        
        
        try
        {
            onload(recordid);
            Itpservice = new ITPContactService_ltng();
            IADServiceBase_ltng.initWrapper(ITPContactService_ltng.DEACTIVATEACCOUNT); //, 'processInstallmentResponse'
            IADContractBeans_ltng.ITPAccountDelete accountdeletepayload = new IADContractBeans_ltng.ITPAccountDelete();
            accountdeletepayload.subscriberNumber=subscribernumber;
            accountdeletepayload.deactivationReason=reason;
            accountdeletepayload.delayDeactivation=false;
            String payload = json.serialize(accountdeletepayload);
            
            //String payload = '{"subscriberNumber":'+subscribernumber+',"deactivationReason":' + reason + '}';
            
            ITPContactService_ltng.putAccountStatus(customerid, payload);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            
        }
        
        return  Itpservice;
        
    }
    
    @Auraenabled 
    public static ITPContactService_ltng InvitationDetails(string recordid)
    {
        
        
        
        
        try
        {
            onload(recordid);
            Itpservice = new ITPContactService_ltng();
            
            IADServiceBase_ltng.initWrapper(ITPContactService_ltng.GETINVITATIONDETAILS);
            ITPContactService_ltng.getInvitationDetails(customerid);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
        return  Itpservice;
        
    }
    
    //Anvesh@ B-34762
    
     @Auraenabled 
    public static ITPContactService_ltng sendInvitation(String payload,String recId){
        
        try
        {
            onload(recId);
            System.debug('payload'+payload);
            System.debug('customerid'+customerid);
            Itpservice = new ITPContactService_ltng();
            
            IADServiceBase_ltng.initWrapper(ITPContactService_ltng.SENDITPINVITATION);//Anvesh @B-33787
            ITPContactService_ltng.sendInvitaion(payload, customerid);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            ITPContactService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return Itpservice;
        
    }    
    
  
    
}