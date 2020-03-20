@isTest
public with sharing class IADOrderLinksControllerTest {
	
	static Contact con1;
    static Order__c order1;

    public static void setupData() 
    {
        con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con1;
        
        order1 = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order1;
    }

    static testMethod void testIADOrderLinksController()
    {
    	setupData();
        
        PageReference pageRef = Page.IADOrderLinksPanelPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        Test.startTest();
        	IADOrderLinksController theController = new IADOrderLinksController();
        Test.stopTest();
        System.assertNotEquals(null , theController , 'Controller should not have been null');
    }
}