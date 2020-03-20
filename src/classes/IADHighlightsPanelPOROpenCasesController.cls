public with sharing class IADHighlightsPanelPOROpenCasesController 
{
    public String theId;
    public Set<string> processingNumbers = new Set<string>();
    public Map<Id,Order_Item__c> caseIdtoOrderItem = new Map<Id,Order_Item__c>();
    public List<Order_Item__c> orderItems = new List<Order_Item__c>();
    public Map<String, Order_Item__c> processingNumberToOrderItem = new Map<String, Order_Item__c>();
    public Boolean hasOpenCases{get;set;}
    public String baseURL {get;set;}
    public String recordIcon{get;set;}
    public String inboxIcon{get;set;}
    public String settingsIcon{get;set;}
    public String pageIcon{get;set;}
    public String approvalIcon{get;set;}
    public List<ProblemCasesWrapper> problemCases {get;set;}

    public IADHighlightsPanelPOROpenCasesController () 
    {
        theId = ApexPages.currentPage().getParameters().get('id');
       
        if(theId.startsWith('a0p')) //If this is Order get the Contact associated with order
        {
          List<Order__c> orders = [SELECT Contact__c FROM Order__c WHERE Id = :theId];
          if(!orders.isEmpty())
          {
                if(orders[0].Contact__c != null)
                    theId = orders[0].Contact__c;
          }  
        }
        hasOpenCases = false;
        
        
        problemCases = setupProblemCases();
        
        if(!problemCases.isEmpty())
            hasOpenCases = true;

       baseURL = URL.getSalesforceBaseUrl().toExternalForm();
       
       recordIcon = IADSGVIconStrings.recordIcon;
       inboxIcon = IADSGVIconStrings.inboxIcon;
       settingsIcon = IADSGVIconStrings.settingsIcon;
       pageIcon = IADSGVIconStrings.pageIcon;
       approvalIcon =  IADSGVIconStrings.checkIcon;
       
    }
    public List<ProblemCasesWrapper> setupProblemCases()
    {
        problemCases = new List<ProblemCasesWrapper>();
        if(theId != null && theId != '')
        {
            Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id,Name,DeveloperName FROM RecordType 
                 WHERE sObjectType = 'Case' and (DeveloperName = 'Standard_Case' or DeveloperName = 'Problem_Case')]);  
                  
            List<Case> cases = [SELECT ID, Order__c, Order__r.Processing_Status__c, Status_Reasons__c, Order__r.Name, Order__r.State_of_Formation__c, Product__c, Subject, Processing_Number__c, Status, CaseNumber  FROM Case WHERE ContactId = :theId 
                                    AND (Status != 'Closed' OR Status_Reasons__c = 'Auto Closed (Timeout) - Unresolved') AND Processing_Number__c != '' AND (RecordTypeId in: recordTypes.keySet()) ORDER BY CaseNumber ASC];
            
            for(Case theCase : cases)
            {
                if(theCase.Processing_Number__c != null)
                {
                    processingNumbers.add(theCase.Processing_Number__c);
                }
            }
            
            orderItems = [SELECT Id, Product_Name__c, Order__c, User_Order_ID__c, Order__r.State_of_Formation__c, Order__r.Processing_Status__c, Order__r.Name FROM Order_Item__c WHERE User_Order_ID__c IN: processingNumbers];
            
            for(Order_Item__c theOrderItem : orderItems)
            {
                processingNumberToOrderItem.put(theOrderItem.User_Order_ID__c, theOrderItem);
            }
            
            for(Case theCase : cases)
            {
                Order_Item__c orderItem = processingNumberToOrderItem.get(theCase.Processing_Number__c);
                
                if(orderItem != null)
                {
                    
                    String theProcessingNumber = orderItem.User_Order_ID__c;
                    String state = orderItem.Order__r.State_of_Formation__c==null?'':'-'+orderItem.Order__r.State_of_Formation__c;
                    String orderItemStr = orderItem.Product_Name__c +'('+orderItem.User_Order_ID__c+')' + state ;
                    problemCases.add(new ProblemCasesWrapper(theCase.CaseNumber,
                                    theCase.Id,
                                    orderItem.Order__c, 
                                    orderItemStr,
                                    orderItem.Id,
                                    theCase.Subject,
                                    theCase.Status,
                                    theProcessingNumber,
                                    orderItem.Order__r.Name, 
                                    orderItem.Order__r.Processing_Status__c,
                                    theCase.Status_Reasons__c));
                }
                
            }

        }
        
        //}
        system.debug(problemCases.size());
        system.debug(hasOpenCases);
        return problemCases;
    }
    
    public PageReference refreshPage()
    {
        return null;
    }
    
    public class ProblemCasesWrapper
    {
        public String caseNumber{get;set;}
        public String caseId{get;set;}
        public String orderId{get;set;}
        public String orderItem{get;set;}
        public String orderItemId{get;set;}
        public String subject{get;set;}
        public String caseStatus{get;set;}
        public String processingNumber{get;set;}
        public String orderNumber{get;set;}
        public String processingStatus{get;set;}
        public String caseStatusReason{get;set;}
        
        public ProblemCasesWrapper(String theCaseNumber, 
                                   String theCaseId, 
                                   String theOrderId, 
                                   String theOrderItem, 
                                   String theOrderItemId, 
                                   String theSubject, 
                                   String theCaseStatus, 
                                   String theProcessingNumber, 
                                   String theOrderNumber,
                                   String theProcessingStatus,
                                   String theCaseStatusReason)
        {
            caseId = theCaseId;
            caseNumber = theCaseNumber;
            orderId = theOrderId;
            orderItem = theOrderItem;
            orderItemId = theOrderItemId;
            subject = theSubject;
            caseStatus = theCaseStatus;
            processingNumber = theProcessingNumber;
            orderNumber = theOrderNumber;
            processingStatus= theProcessingStatus;
            caseStatusReason = theCaseStatusReason;
        }
    }
}