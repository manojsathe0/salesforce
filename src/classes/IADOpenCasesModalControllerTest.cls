@isTest

private class IADOpenCasesModalControllerTest{
    static testMethod void testModal() {



        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FkUser__c='1234');
        insert con1;

        List<Case> theCases = TestUtils.createCasesRelatedToContact(1, true, con1);
        

        Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01));
        insert order1;
        Order__c order2 = new Order__c(Name = '1100', Contact__c = con1.Id, State_of_Formation__c = '13', Entity_Name__c = '14', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01));
        insert order2;
        Order_Item__c orderItem1 = new Order_Item__c(Name = '1000', Order__c = order1.Id);
        insert orderItem1;
        Order_Item__c orderItem2 = new Order_Item__c(Name = '1100', Order__c = order2.Id);
        insert orderItem2;

        
        List<Case> cases = TestUtils.createCasesRelatedToContact(2, true, con1);

        for(Case c : cases)
        {
            c.Status = 'Open';
        }
        
        update cases;

        PageReference pageRef = Page.IADCreateCase;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', con1.Id);
        ApexPages.currentPage().getParameters().put('caseId', theCases[0].id);
      
        IADOpenCasesModalController cntrl = new IADOpenCasesModalController();

        system.assertEquals(cases.size(), cntrl.openCases.size());
        
        ApexPages.currentPage().getParameters().put('id', cases[0].Id);
      
        cntrl = new IADOpenCasesModalController();
        cntrl.setMsg();
        cntrl.showModal = true;
        IADOpenCasesModalController.logDismissal();
    }   
    
    
}