@isTest

private class IADContactCaseHistoryGridTest_ltng {
    static testMethod void gridTest() {

        string recid;

        
        List<Account> accs = TestUtils.createAccounts(1, 'someName', true);
        
        for(Account acc : accs)
        {
            
            List<Contact> contacts = TestUtils.createContacts(1, 'name', acc.Id, true);
            
            for(Contact c : contacts)
            {
               recid=c.id;
               
                TestUtils.createCasesRelatedToContact(20, true, c);
            }
        }
        
       IADContactCaseHGridController_ltng gridcaseltng = new IADContactCaseHGridController_ltng();
       IADContactCaseHGridController_ltng.intialsetup(recid);
            }   
    
}