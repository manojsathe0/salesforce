public with sharing class IADInstallmentController 
{
    public String theId {get;set;}
    public String orderId {get;set;}
    public String dayview{get;set;}
    public String profileId{get;set;}
    public String customerId {get;set;}
    public IADInstallmentService installmentService{get;set;}
    public Map<String,IADApiGeeEndPoint__mdt> paymentAPItoEndpoint{get;set;}
    public String dueDate{get;set;}
    
    
    public IADInstallmentController () 
    {
        dayview = IADSGVIconStrings.dayview;
        paymentAPItoEndpoint = new Map<String,IADApiGeeEndPoint__mdt>();
        theId = ApexPages.currentPage().getParameters().get('id');
        orderId = ApexPages.currentPage().getParameters().get('orderid');
        installmentService  = new IADInstallmentService();
        Order__c theOrder = [select Contact__r.FKUser__c, Name from Order__c where name =:orderId limit 1];
        customerId = theOrder.Contact__r.FKUser__c;
        system.debug('theOrder' + theOrder);
    }
    
    public void setProfileIdManual()
    {
       //profileId = Apexpages.currentPage().getParameters().get('profileId');
       system.debug('profile id '  + profileId);
    }
    
    
    public Object populateInstallment()
    {
        Object continuationObject;
        try
        {
            String installmentId = theId;
            installmentService.initWrapper(IADInstallmentService.GETINSTALLMENTBYINSTALLMENTID, 'processInstallmentResponse');
            continuationObject = installmentService.getInstallmentByInstallmentId(installmentId);
           
        }
        catch(IADException theException)
        {
            installmentService.populateErrorMessage(theException);       
        }
        catch(Exception theException)
        {
            installmentService.populateErrorMessage(theException);
        }
        return continuationObject; 
       
    }
    
    //Callback method for Asynchronous
    public Object processInstallmentResponse() 
    {   
        try
        {
            installmentService.populateInstallment();
            profileId = 'pp' + installmentService.theInstallmentWrapper.installment.paymentProfileId;
            if(installmentService.theInstallmentWrapper.installment.paymentProfileId != null)
                installmentService.theInstallmentWrapper.installment.paymentProfileId = 'pp' + installmentService.theInstallmentWrapper.installment.paymentProfileId;
        }
        catch(IADException theException)
        {
            installmentService.populateErrorMessage(theException);       
        }
        catch(Exception theException)
        {
            installmentService.populateErrorMessage(theException);
        }
         
        return null;
    }
    
    
    public Object updateInstallment()
    {
        Object continuationObject;
        try
        {
            installmentService.clearMessages();

            String installmentId = theId;
            installmentService.initWrapper(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID, 'processUpdateInstallmentResponse');
            IADContractBeans.IADInstallmentUpdateBean installmentBean = new IADContractBeans.IADInstallmentUpdateBean();

            Datetime oldDueDate = UtilityLibrary.getIADDateTimeDT(installmentService.theInstallmentWrapper.installment.dueDate);
            Datetime newDueDate = UtilityLibrary.convertJSDateToIADDateDT(dueDate);

            Integer dueDateDaysBetween = Date.valueOf(oldDueDate).daysBetween(Date.valueOf(newDueDate));

            Integer todayDaysBetween = Date.valueOf(Datetime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0))).daysBetween(Date.valueOf(newDueDate));

            if(dueDateDaysBetween>14)
            {
               installmentService.populateErrorMessage('Date cannot be set past two weeks from the original due date.');
            }
            else if(todayDaysBetween<0)
            {
                installmentService.populateErrorMessage('Date cannot be set to the past.');
            }

            if(installmentService.errorCount==0)
            {
                installmentBean.dueDate = UtilityLibrary.convertJSDateToIADDate(dueDate, installmentService.theInstallmentWrapper.installment.dueDate);
                installmentBean.updatedBy = UtilityLibrary.generateUpdatedBy();
                installmentBean.paymentProfileId = Integer.valueOf(UtilityLibrary.stripStoreCreditOrProfileId(profileId));

                continuationObject = installmentService.putInstallmentByInstallmentId(JSON.serialize(installmentBean), installmentId);
            }


        }
        catch(IADException theException)
        {
           installmentService.populateErrorMessage(theException);           
        }
        catch(Exception theException)
        {
           installmentService.populateErrorMessage(theException);      
        }
        return continuationObject; 
    }
    
    //Callback method for Asynchronous
    public Object processUpdateInstallmentResponse() 
    {  
        try
        {
           installmentService.populateInstallmentUpdateReponse();
        }
        catch(IADException theException)
        {
            installmentService.populateErrorMessage(theException);       
        }
        catch(Exception theException)
        {
            installmentService.populateErrorMessage(theException);
        }
         
        return null;

    }
  
}