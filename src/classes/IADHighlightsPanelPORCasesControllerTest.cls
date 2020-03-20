@isTest
public class IADHighlightsPanelPORCasesControllerTest {

    static List<Order__c> newOrders = new List<Order__c>();
    static Customer_Login__c newCustomerLogin = new Customer_Login__c();
    static Contact newContact = new Contact();
    final static Datetime problemIdentified = system.today().addDays(-2);
    static Id relationshipTypeId;
    static Process__c newProcess;
    static Product2 newProduct;
    static Relationship_Type__c relationshipTypeId_Revised;
    final static Integer SIZE = 1;
    
    static void setupData()
    {
       
        //insert custom seetings for queue
        POR_case_routing_queues__c PORSetting = new POR_case_routing_queues__c(
            Name = ProblemOrderConstants.POA, 
            Queue_Name__c = ProblemOrderConstants.QUEUE_NAME,
            Template_DeveloperName__c = ProblemOrderConstants.EMAIL_TEMPLATE);
        insert PORSetting;

        //create relationship id for a process
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process' , true)[0].Id;
        relationshipTypeId_Revised = TestUtils.createRelationshipTypesTypes(1 , '' , false)[0];
        relationshipTypeId_Revised.Name = 'Revision';
        relationshipTypeId_Revised.Relationship_Type_ID__c = '1';
        insert relationshipTypeId_Revised;
        system.debug(relationshipTypeId_Revised);

        //create process
        newProcess = new Process__c();
            newProcess.Name = ProblemOrderConstants.POA;
            newProcess.Process_ID__c = 1;
         insert newProcess;

        //create new product
        List<Product2> newProducts = TestUtils.createProducts(1 , '', false);
        newProducts[0].Name = ProblemOrderConstants.POA;
        newProducts[0].Relationship_Type__c = relationshipTypeId;
        newProducts[0].Process__c = newProcess.Id;
        insert newProducts;

        //insert Account
        Account newAccount = TestUtils.createAccounts(1 , 'POR Account' , true)[0];

        //insert contact
        newContact = TestUtils.createContacts(1 , 'POR Contact' , newAccount.Id , false)[0];
        newContact.Email = 'lzPORtest@lzTestClass.com';
        insert newContact;

        //insert Customer login
        newCustomerLogin = TestUtils.createCustomerLogins(1 , 'Cust Login' , false)[0];
        newCustomerLogin.Primary_Contact__c = newContact.Id;
        insert newCustomerLogin;

        //insert dummy orders
        newOrders = TestUtils.createOrders(SIZE, newProducts[0].Id, false);
        integer i=0;
        for(Order__c theOrder : newOrders)
        {
            theOrder.contact__c = newContact.Id;
            theOrder.customer_Login__c = newCustomerLogin.Id;
            theOrder.User_Order_ID__c = '500000'+i;
            i++;
        }
        insert newOrders;

        List<Order_Item__c> orderItemsToinsert = new List<Order_Item__c>();
        for(Order__c theOrder : newOrders)
        {
            Order_Item__c newOrderItem = new Order_Item__c();
            newOrderItem.Order__c = theOrder.Id;
            newOrderItem.Product__c = newProducts[0].Id;
            newOrderItem.User_Order_ID__c = theOrder.User_Order_ID__c;
            orderItemsToinsert.add(newOrderItem);
        }
        insert orderItemsToinsert;
        
        
        List<Case> createCasesRelatedToContact = TestUtils.createCasesRelatedToContact(SIZE, true, newContact);
        
        RecordType rt = [SELECT Id,Name,DeveloperName FROM RecordType 
                 WHERE sObjectType = 'Case' and DeveloperName = 'Standard_Case']; 
        
        
        for(Case c : createCasesRelatedToContact)
        {
            c.RecordTypeId = rt.Id;
            c.Processing_Number__c = newOrders[0].User_Order_ID__c;
        }
        update createCasesRelatedToContact;
    }

  static testMethod void IADHighlightsPanelPORCasesControllerTest() 
  {
    setupData();

    PageReference pageRef = Page.IADHighlightsPanelPOROpenCasesPage;
    pageRef.getParameters().put('id', String.valueOf(newContact.Id));
    Test.setCurrentPage(pageRef);
    IADHighlightsPanelPOROpenCasesController thecontroller = new IADHighlightsPanelPOROpenCasesController();
    thecontroller.refreshPage();

    system.assertEquals(SIZE, thecontroller.problemCases.size(), 'Write number of cases should have been displayed');


  }
}