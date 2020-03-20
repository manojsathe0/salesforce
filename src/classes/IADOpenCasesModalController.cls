public class IADOpenCasesModalController 
{
    public List<Case> openCases{get;set;}
    public Integer openCasesSize { get; set; }
    public Boolean showMsg{get;set;}
    public String contactId {get;set;}
    public String caseId {get;set;}
    
    
    public IADOpenCasesModalController()
    {
        openCasesSize = 0;
        
        showModal = false;
        
    }
    public Boolean showModal
    {
        get{
            return showModal;
        }
        set{
            try{

                showModal = value;
                caseId = ApexPages.currentPage().getParameters().get('id');

                 //differentiate between a new case vs an updated case. New case has Contact as the parameter id
                if(!caseId.startsWith('500'))
                {
                    contactId = ApexPages.currentPage().getParameters().get('id');
                    caseId = ApexPages.currentPage().getParameters().get('caseId');
                }
                else
                {
                    Case theCase = [select contactId from Case where id=:caseId limit 1];
                    if(theCase != null && UtilityLibrary.isNotNullOrBlank(theCase.contactId))
                    {
                        contactId = theCase.contactId;

                    }
                }
            }
            catch(Exception theException)
            {
                if(UtilityLibrary.sendEmail)
                    SendExceptionEmail.sendExceptionEmail(theException , 'IAD Exception');
            }
            if(UtilityLibrary.isNotNullOrBlank(contactId) && UtilityLibrary.isNotNullOrBlank(caseId))
            {
                refreshOpenCases();
            }
        }
    }
    public void refreshOpenCases()
    {
        if(contactId != null && contactId != '')
        {
            try{

                openCases = [SELECT Id, CaseNumber, Status, Subject, Priority, CreatedDate, ContactId, AccountId, OwnerID, Processing_Number__c from Case WHERE ContactId != '' and ContactId =: contactId
                and Id !=: caseId and Status !='Closed' and Status !='Closed – First Response'];
                openCasesSize = openCases.size();

                system.debug('openCases ' + openCases);
            }
            catch(Exception theException)
            {
                if(UtilityLibrary.sendEmail)
                    SendExceptionEmail.sendExceptionEmail(theException , 'IAD Exception');
            }

        }
    }
    public void setMsg()
    {
        showMsg = true;
    }
    public static void logDismissal()
    {
        IAD_Case_View_Later_Counter__c counter = new IAD_Case_View_Later_Counter__c();
        
        insert counter;
        
        system.debug('logging dismissal');
    }
}