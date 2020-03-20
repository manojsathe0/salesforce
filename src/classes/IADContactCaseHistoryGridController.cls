public with sharing class IADContactCaseHistoryGridController
{
    public String theId{get;set;}
    public Boolean hasOpenCases{get;set;}
    public String caseIcon{get;Set;}
    public String sortIcon{get;Set;}

    public IADContactCaseHistoryGridController () 
    {
        
        theId = ApexPages.currentPage().getParameters().get('id');
        hasOpenCases = false;
        caseIcon = IADSGVIconStrings.caseIcon;
        sortIcon = IADSGVIconStrings.sortIcon;
        if(!problemCasesAll.isEmpty())
            hasOpenCases = true;
    }
    public List<Schema.FieldSetMember> getContactFields() 
    {
        return SObjectType.Case.FieldSets.Case_History_Fields.getFields();
    }
    public List<String> getFieldPaths()
    {
        List<String> fields = new List<String>();
        for(Schema.FieldSetMember field : getContactFields())
        {
            fields.add(field.getFieldPath());
        }
        return fields;
    }
    public List<String> getFieldLabels()
    {
        List<String> fields = new List<String>();
        for(Schema.FieldSetMember field : getContactFields())
        {
            fields.add(field.getLabel());
        }
        return fields;
    }
    public String buildCaseSOQL()
    {
        String query = 'Select Id,Order_Exception__r.Exception_Type__c';
        for(String field : getFieldPaths())
        {
            if(field != 'Id')
            {
                query +=  ',' + field;
            }
        }
        return query;
    }
    public List<Case> problemCasesAll
    {
        get {
            try {
                if (problemCasesAll == null) {
                    problemCasesAll = new List<Case>();
                    if (theId != null && theId != '') {

                        List<Case> cases = Database.query(buildCaseSOQL() + ' FROM Case WHERE ContactId = :theId');
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