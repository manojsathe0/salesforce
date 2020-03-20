public with sharing class IADContactCaseHPanelController_ltng
{
    @AuraEnabled public  static String theId{get;set;}
    public static List<String> processingNumbers = new List<String>();
    @AuraEnabled public static  List<CaseWrapper> allCases{get;set;}
    @AuraEnabled public  static Boolean hasOpenCases{get;set;}
    public static Map<String,String> processingNumberToOrderItemLabel;
    @AuraEnabled public  static String caseIcon{get;set;}
    @AuraEnabled public static String checkIcon{get;set;}
    
    @AuraEnabled
    public static List<CaseWrapper> intialsetup(string recid)
    {   
        theId=recid;
        processingNumberToOrderItemLabel = new Map<String,String>();
        
        caseIcon = IADSGVIconStrings.caseIcon;
        checkIcon= IADSGVIconStrings.checkIcon;
        
        getAllCases();
        return  allcases;
        
        
        
    }
    @AuraEnabled
    public static void getAllCases()
    {
        
        try
        {
            allCases = new List<CaseWrapper>();
            if(theId != null && theId != '')
            {
                List<Case> caseObjects = new List<Case>();
                for(Case theCase : [SELECT ID, Processing_Number__c , created_date__c, CreatedDate, Order_Exception__r.Exception_Type__c,     Reason_for_Contact_new__c, Subject, Status, Status_Reasons__c, CaseNumber, Product__c, Product2__c, Product_Line__c  FROM Case WHERE ContactId = :theId
                                    AND ((RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Standard_Case'))
                                         OR (RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Web_Case'))
                                         OR (Status = 'Closed' AND RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Problem_Case')) OR(Order_Exception__c!=null AND RecordTypeId = : ProblemOrderRoutingService.developerNameToRecordTypeIds.get('Problem_Case') ))  ORDER BY LastModifiedDate DESC limit 5])
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
                    CaseWrapper theWrapper = new CaseWrapper(theCase ,processingNumberToOrderItemLabel.get(theCase.Processing_Number__c));
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
        @AuraEnabled public Case theCase{get;set;}
        @AuraEnabled public String theOrderItemLabel{get;set;}
        @AuraEnabled public String casenum {get;set;}
        @AuraEnabled public String casestatus {get;set;}
        @AuraEnabled public string caseid{get;set;}
        
        public CaseWrapper(Case tCase , String orderItemLabel)
        {
            theCase = tCase;
           
            
            if(orderItemLabel != null && orderItemLabel != '')
                theOrderItemLabel = orderItemLabel;
        }
    }
    
    
}