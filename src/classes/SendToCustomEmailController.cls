public without sharing class SendToCustomEmailController {

     public static final String LEAD = '00Q';
     public static final String CONTACT = '003';
     public final static String CASE_RECORD_TYPE = 'Liquid_Mangoose_case';
     public final static String CASE_ORIGIN_NAME = 'Liquid Mangoose case';
     public static Lead queriedLead;

     public PageReference createCaseAndForward()
     {
        boolean moveToCustomEmailPage = true;
        PageReference pageToSend = Page.Custom_Email;
        Id recordId = ApexPages.currentPage().getParameters().get('recordId');
        Id caseId;
        string objectName = findObjectName(recordId);
        if(objectName == LEAD && recordId != null)
        {
            List<Lead> queriedleads = [SELECT Id, Name, Lead_Case__c, isConverted, Email, convertedContactId FROM Lead WHERE Id = :recordId];
            queriedLead = queriedleads[0];
            if(queriedleads[0].isConverted == false)
            {
                if(!queriedleads.isEmpty())
                {
                    if(queriedleads[0].Lead_Case__c != null)
                    {
                        caseId = queriedleads[0].Lead_Case__c;
                    } 
                    else
                    {
                        case theCase = createCase(CASE_RECORD_TYPE , null , null, queriedleads[0].Name , CASE_ORIGIN_NAME);
                        caseId = theCase.Id; 
                        Lead theLead = new Lead(Id = recordId);
                        theLead.Lead_Case__c = theCase.Id;
                        update theLead;

                    }
                }
            }
            else
            {
                moveToCustomEmailPage = false;
            }
                
        }
        if(objectName == CONTACT && recordId != null)
        {
            List<COntact> queriedContacts = [SELECT Id , Name ,  Contact_Case__c ,AccountId FROM COntact WHERE Id = :recordId];
            if(!queriedContacts.isEmpty())
            {
                if(queriedContacts[0].Contact_Case__c != null)
                {
                    caseId = queriedContacts[0].Contact_Case__c;
                } 
                else
                {
                    case theCase = createCase(CASE_RECORD_TYPE , queriedContacts[0].AccountId , queriedContacts[0].Id , queriedContacts[0].Name , CASE_ORIGIN_NAME);
                    caseId = theCase.Id;
                    COntact theContact = new COntact(Id = recordId);
                    theContact.Contact_Case__c = theCase.Id;
                    update theContact;
                }
            }
        }
        pageToSend.getParameters().put('recordId',recordId);
        pageToSend.getParameters().put('id',caseId);
        if(moveToCustomEmailPage == true)
            return pageToSend;
        else
        {
            contact theContact = [Select Id, Email, Name From Contact Where Id =: queriedLead.convertedContactId][0];
            String link = '<a href="https://legalzoom--vishnu2--c.cs11.visual.force.com/'+theContact.Id+'" target="_blank"><h4>'+theContact.Name+'</h4></a>';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Lead has been converted to a Contact.'+link));
            return null;
        }
    }

    public Static String findObjectName(Id recordId)
    {
        system.debug(recordId);
        String convertedRecordId = String.valueOf(recordId);
        string objectName;
        if(convertedRecordId.startsWith(LEAD))
            objectName = LEAD;
        else if(convertedRecordId.startsWith(CONTACT))
                objectName = CONTACT;
        
        return objectName;
    }

    public static Case createCase(String recordTypeDeveloperName, Id accountId, ID theContactID, String name, string originName)
    {
        Case theCase = new Case();
        theCase.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :recordTypeDeveloperName limit 1].Id;
        theCase.AccountId = accountId;
        theCase.Origin = originName;
        theCase.Status = 'Closed';
        theCase.Subject = name;
        theCase.ContactId = theContactId;
        insert theCase;

        return theCase;
    }
    
}