@istest
private class IADRelatedorders_test
{

@isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
        
    }
    
    
      
      @isTest static void testRelatedOrdersorderresponse()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
        
        RelatedOrdersController_ltng   inst = new   RelatedOrdersController_ltng  ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =   IADTestDataUtil_ltng.getOrderResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
         RelatedOrdersController_ltng.getOrderByOrderId(order1.id);
        Test.stopTest();

    }

  @isTest static void testRelatedOrdersresponse()
    {
       
        
        RelatedOrdersController_ltng   inst = new   RelatedOrdersController_ltng  ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =IADTestDataUtil_ltng.getRelatedOrdersResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
         RelatedOrdersController_ltng.getRelatedOrders('1234');
        Test.stopTest();

    }
    
      @isTest static void testRelatedOrdersorderresponsenegative()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
        
        RelatedOrdersController_ltng   inst = new   RelatedOrdersController_ltng  ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =   IADTestDataUtil_ltng.getOrderResponse();
      mock.statusCode=500;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
         RelatedOrdersController_ltng.getOrderByOrderId(order1.id);
        Test.stopTest();

    }

  @isTest static void testRelatedOrdersresponsenegative()
    {
       
        
        RelatedOrdersController_ltng   inst = new   RelatedOrdersController_ltng  ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =IADTestDataUtil_ltng.getRelatedOrdersResponse();
      mock.statusCode=500;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
         RelatedOrdersController_ltng.getRelatedOrders('1234');
        Test.stopTest();

    }

   @isTest static void testRelatedOrdersorderresponsenegative1()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
        
        RelatedOrdersController_ltng   inst = new   RelatedOrdersController_ltng  ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =   IADTestDataUtil_ltng.getOrderResponse();
      mock.statusCode=500;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
         RelatedOrdersController_ltng.getOrderByOrderId('');
        Test.stopTest();

    }

  @isTest static void testRelatedOrdersresponsenegative1()
    {
       
        
        RelatedOrdersController_ltng   inst = new   RelatedOrdersController_ltng  ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =IADTestDataUtil_ltng.getRelatedOrdersResponse();
      mock.statusCode=500;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
         RelatedOrdersController_ltng.getRelatedOrders('');
        Test.stopTest();

    }


}