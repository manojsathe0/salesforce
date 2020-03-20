public with sharing class IADContactCaseHistoryPanelController
{
    public String theId{get;set;}
    public List<String> processingNumbers = new List<String>();
    public List<CaseWrapper> allCases{get;set;}
    public Boolean hasOpenCases{get;set;}
    public Map<String,String> processingNumberToOrderItemLabel;
    public String caseIcon{get;set;}
    public String checkIcon{get;set;}

    public IADContactCaseHistoryPanelController () 
    {
        theId = ApexPages.currentPage().getParameters().get('id');
        processingNumberToOrderItemLabel = new Map<String,String>();
            
        caseIcon = IADSGVIconStrings.caseIcon;
        checkIcon= IADSGVIconStrings.checkIcon;

        getAllCases();
        
    }
    
    public void getAllCases()
    {
            
        try
        {
            allCases = new List<CaseWrapper>();
            if(theId != null && theId != '')
            {
               List<Case> caseObjects = new List<Case>();
               for(Case theCase : [SELECT ID,Order_Exception__c, Processing_Number__c , created_date__c,Order_Exception__r.Exception_Type__c, CreatedDate, Reason_for_Contact_new__c, Subject, Status, Status_Reasons__c, CaseNumber, Product__c, Product2__c, Product_Line__c  FROM Case WHERE ContactId = :theId
                                    AND ((RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Standard_Case'))
                                      OR (RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Web_Case'))
                                      OR (Status = 'Closed' AND RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Problem_Case')) OR (Order_Exception__c!=null AND RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Problem_Case') )) ORDER BY LastModifiedDate DESC limit 5])
               {
                   caseObjects.add(theCase);
                   if(theCase.Processing_Number__c != null && theCase.Processing_number__c != '')
                   {
                       processingNumbers.add(theCase.Processing_Number__c);
                   }
               }
               if(!processingNumbers.isEmpty())
               {
                   for(Order_Item__c theOrderItem : [SELECT ID, User_Order_ID__c , Product__r.Name , Order__r.Contact_State__c , Order__r.State_of_Formation__c , Product_Name__c FROM Order_Item__c Where User_Order_ID__c IN: processingNumbers])// AND Product__r.Name IN: ])
                   {
                       String state = theOrderItem.Order__r.State_of_Formation__c==null?'':'-'+theOrderItem.Order__r.State_of_Formation__c;
                       String orderItemLabel = theOrderItem.Product_Name__c +'('+theOrderItem.User_Order_ID__c+')' + state;
                       processingNumberToOrderItemLabel.put(theOrderItem.User_Order_ID__c, orderItemLabel);
                   }

               }
                for(Case theCase : caseObjects)
                {
                    CaseWrapper theWrapper = new CaseWrapper(theCase , processingNumberToOrderItemLabel.get(theCase.Processing_Number__c));
                    allCases.add(theWrapper);
                }


            }
            hasOpenCases = false;
            if(!allCases.isEmpty())
                hasOpenCases = true;
        }
        catch(Exception theException)
        {
            if(UtilityLibrary.sendEmail)
                SendExceptionEmail.sendExceptionEmail(theException , 'IAD Exception');
        }

    }
    
    public PageReference refreshPage()
    {
        getAllCases();
        return null;
    }
    
  
    public class CaseWrapper
    {
        public Case theCase{get;set;}
        public String theOrderItemLabel{get;set;}
        
        public CaseWrapper(Case tCase , String orderItemLabel)
        {
            theCase = tCase;
            if(orderItemLabel != null && orderItemLabel != '')
                theOrderItemLabel = orderItemLabel;
        }
    }
   
    
}