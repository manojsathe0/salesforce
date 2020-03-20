@isTest
public class IADContactCaseHistoryPanelControllerTest {

  static testmethod void IADContactCaseHistoryPanelControllerTest()
  {
    //insert Account
    Account newAccount = TestUtils.createAccounts(1 , 'the Account' , true)[0];

    //insert contact
    Contact newContact = TestUtils.createContacts(1 , 'the Contact' , newAccount.Id , false)[0];
    newContact.Email = 'lztest@lzTestClass.com';
    insert newContact;
    List<Order__c> testOrders = TestUtils.createOrders(5 , null , true);
    List<Order_Item__c> orderItems = new List<Order_Item__c>();
    for(Order__c theOrder : testOrders)
    {
        theOrder.State_Of_Formation__c = 'CA';
        orderItems.add(TestUtils.createOrderItems(1 , theOrder.Id , false)[0]);
    }
    update testOrders;
    
    Integer i = 1;
    for(Order_Item__c theItem : orderItems)
    {
        theItem.User_Order_ID__c = i+'';
    }
    insert orderItems;    

    List<Case> newCases = TestUtils.createCases(5,false);
    i = 1;
    for(Case theCase : newCases)
    {
        theCase.ContactId = newContact.ID;
        theCase.Processing_Number__c = i+'';
        ++i;
        system.debug(theCase);
    }
    insert newCases;

    Test.startTest();

        PageReference pageRef = Page.IADContactCaseHistoryPanelPage;
        pageRef.getParameters().put('id', String.valueOf(newContact.Id));
        Test.setCurrentPage(pageRef);
        IADContactCaseHistoryPanelController thecontroller = new IADContactCaseHistoryPanelController();
      
        
        System.assertEquals(newCases.size(), (thecontroller.allCases).size(), 'Right number of cases should have been displayed');
    Test.stopTest();  
  } 
}