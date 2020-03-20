@isTest

private class IADContactCaseHistoryGridControllerTest{
    static testMethod void gridTest() {

        PageReference pageRef = Page.IADContactCaseHistoryGridPage;
        Test.setCurrentPage(pageRef);

        
        List<Account> accs = TestUtils.createAccounts(1, 'someName', true);
        
        for(Account acc : accs)
        {
            
            List<Contact> contacts = TestUtils.createContacts(1, 'name', acc.Id, true);
            
            for(Contact c : contacts)
            {
                
                ApexPages.currentPage().getParameters().put('id', c.Id);
                TestUtils.createCasesRelatedToContact(20, true, c);
            }
        }
        
        IADContactCaseHistoryGridController cntrl = new IADContactCaseHistoryGridController();
        List<String> fieldLabels = cntrl.getFieldLabels();
        
        System.assertEquals(cntrl.problemCasesAll.size(), 20);
    }   
    
}