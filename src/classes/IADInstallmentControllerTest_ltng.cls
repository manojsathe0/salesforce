@istest
public class IADInstallmentControllerTest_ltng
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
    
     @isTest static void testGetInstallment()
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
       IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getInstallmentResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentController_ltng.populateInstallment('1234',order1.Id);
        Test.stopTest();

    }
      @isTest static void testprofilesInstallment()
    {
        setupData();
       IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getPaymentProfilesResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentController_ltng.populateProfiles('1234', 'Installment');
        Test.stopTest();

    }
    
      @isTest static void testputInstallment()
    {
        setupData();
       IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getInstallmentResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentController_ltng.updateInstallment('1234',IADTestDataUtil.getInstallmentResponse(), '1234' ,String.valueOf(Date.today()) );
        Test.stopTest();

    }
   
  @isTest static void testGetInstallmentnegative()
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
       IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  null;
      mock.statusCode=500;
     IADMessageFactory_ltng.clearMessage();
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentController_ltng.populateInstallment('1234',order1.Id);
        Test.stopTest();

    }



  @isTest static void testputInstallmentnegative()
    {
        setupData();
       IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getInstallmentResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentController_ltng.updateInstallment('1234','', '1234' ,String.valueOf(Date.today()) );
        Test.stopTest();

    }




 @isTest static void testputInstallmentnegativenull()
    {
        setupData();
        IADConstants testconst = new IADConstants();
       IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  null;
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentController_ltng.updateInstallment('1234',IADTestDataUtil.getInstallmentResponse(), '1234' ,String.valueOf(Date.today()) );
        Test.stopTest();

    }




}