public with sharing class IADContactCaseHGridController_ltng
{
    public static String theId{get;set;}
    public static Boolean hasOpenCases{get;set;}
    public static  String caseIcon{get;Set;}
    public static String sortIcon{get;Set;}

    @AuraEnabled
    public static List<case>  intialsetup (string recid) 
    {
        
        //theId = ApexPages.currentPage().getParameters().get('id');
        theId=recid;
        hasOpenCases = false;
        caseIcon = IADSGVIconStrings.caseIcon;
        sortIcon = IADSGVIconStrings.sortIcon;
        if(!problemCasesAll.isEmpty())
            hasOpenCases = true;
            
            return problemCasesAll;
    }
    
    
    public  static List<Schema.FieldSetMember> getContactFields() 
    {
        return SObjectType.Case.FieldSets.Case_History_Fields.getFields();
    }
    
    @AuraEnabled
    public static  List<String> getFieldPaths()
    {
        List<String> fields = new List<String>();
        for(Schema.FieldSetMember field : getContactFields())
        {
            fields.add(field.getFieldPath());
        }
        return fields;
    }
    
    @AuraEnabled
    public  static List<String> getFieldLabels()
    {
        List<String> fields = new List<String>();
        for(Schema.FieldSetMember field : getContactFields())
        {
            fields.add(field.getLabel());
        }
        return fields;
    }
    
    @AuraEnabled
    public static String buildCaseSOQL()
    {
        String query = 'Select Id,RecordType.Name ,Order_Exception__r.Exception_Type__c';
        for(String field : getFieldPaths())
        {
            if(field != 'Id')
            {
                query +=  ',' + field;
            }
        }
        
        system.debug('the query is '+query);
        return query;
    }
    
    @AuraEnabled
    public static List<Case> problemCasesAll
    {
        get {
            try {
                if (problemCasesAll == null) {
                    problemCasesAll = new List<Case>();
                    if (theId != null && theId != '') {

                        List<Case> cases = Database.query(buildCaseSOQL()+ ' FROM Case WHERE ContactId = :theId');
                        system.debug('The cases'+cases);
                        for (Case theCase : cases)
                            problemCasesAll.add(theCase);

                    }

                }
            }
            catch(Exception theException)
            {
                if(UtilityLibrary.sendEmail)
                    SendExceptionEmail.sendExceptionEmail(theException , 'IAD Exception');
                return null;
            }
            return problemCasesAll;
        }
        set;
    }
    
}