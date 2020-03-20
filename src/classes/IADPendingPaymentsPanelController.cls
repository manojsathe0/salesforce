public class IADPendingPaymentsPanelController
{

    public String theId{get;set;}
    public String orderId{get;set;}
    public IADPendingPaymentsService pendingPaymentService{get;set;} 
    public IADPendingPaymentsPanelController() 
    {
        theId = ApexPages.currentPage().getParameters().get('id');
        pendingPaymentService = new IADPendingPaymentsService();
        if(theId != null)
        {
           List<Order__c> orders = [SELECT OrderID__c FROM Order__c WHERE Id = :theId];
           if(!orders.isEmpty())
           {
              orderId = orders[0].OrderID__c;
           }
        }
        
    }
    
    public Object populatePayments()
    {
              
        Object continuationObject;
        try
        {
            pendingPaymentService.initWrapper(IADPendingPaymentsService.GETPAYMENTSBYORDERID, 'processPaymentResponse');
            continuationObject = pendingPaymentService.getPaymentsByOrderId(orderId);  
            
        }
        catch(IADException theException)
        {
          pendingPaymentService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
           
            pendingPaymentService.populateErrorMessage(theException);
        }
        return continuationObject; 
              
    }
    
    //Callback method for Asynchronous
    public Object processPaymentResponse() 
    {   
          try
          {
              pendingPaymentService.populatePayments();
          }
          catch(IADException theException)
          {
               pendingPaymentService.populateErrorMessage(theException);
          } 
          catch(Exception theException)
          {
               pendingPaymentService.populateErrorMessage(theException);
          }
              
          
          return null;
          
    }
     
 }