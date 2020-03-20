@isTest
public class Lookup_To_ControllerTest 
{
    static testmethod void testlookup()
    {
        //insert Account
        Account newAccount = TestUtils.createAccounts(1 , 'the Account' , true)[0];
    
        //insert contact
        Contact newContact = TestUtils.createContacts(1 , 'the Contact' , newAccount.Id , true)[0];
       
    
        List<Case> newCases = TestUtils.createCases(5,true);
        integer i = 1;
        for(Case theCase : newCases)
        {
            theCase.ContactId = newContact.ID;
            theCase.Processing_Number__c = i+'';
            ++i;
        }
        
        ApexPages.currentPage().getParameters().put('id', newCases[0].id);
        Lookup_To_Controller cntrl = new Lookup_To_Controller();
        cntrl.newContact = newContact;
        
        
        cntrl.updateCaseWithContact();
        
        cntrl.createNewContact();
        cntrl.newContact.lastNAme = 'test';
        cntrl.saveNewContact();
        
        cntrl.cancel();
        cntrl.getTextData();
        cntrl.setTextData('test');
        cntrl.searchContact();
        cntrl.getsearchR();
        cntrl.ClearResult();
        
        
    }
}