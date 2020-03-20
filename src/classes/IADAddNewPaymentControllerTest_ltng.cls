@IsTest
public class IADAddNewPaymentControllerTest_ltng
{

static testmethod void testonload()
{
    
  IADAddNewPaymentController_ltng.onload(); 
    
    
    
}
    static testmethod void testaddnewpayment()
    {
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.postPaymentResponse();
      mock.statusCode=201;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"zip":"34252","year":2022 , "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
        IADAddNewPaymentController_ltng.addNewPayment(responsebody,'12324');
        test.stopTest();
        
    }
     static testmethod void testprofiles()
    {
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getPaymentProfilesResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"paymentProfile":{"zip":"34252","year":2022,"token":null,"state":"KY","phone":"4352345243","paymentType":"1","month":1,"lastName":"sdfasdf","last4Digits":"5234","isRecurring":false,"isActive":true,"gateway":"13","firstName":"asdfasdfasdfasdfasdfasd","firstDigit":"3","customerId":"11596577","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}}';
        IADAddNewPaymentController_ltng.populateProfiles(responsebody,'12324');
        test.stopTest();
        
    }
    
    static testmethod  void testpopulateinstallments()
    {
         Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234',Contact_Type__c='Primary Contact');
            insert con1;

          order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getInstallmentsResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"paymentProfile":{"zip":"34252","year":2022,"token":null,"state":"KY","phone":"4352345243","paymentType":"1","month":1,"lastName":"sdfasdf","last4Digits":"5234","isRecurring":false,"isActive":true,"gateway":"13","firstName":"asdfasdfasdfasdfasdfasd","firstDigit":"3","customerId":"11596577","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}}';
        IADAddNewPaymentController_ltng.populateInstallments(order1.Id,'12324');
        test.stopTest();
        
        
        
    }
    
      static testmethod  void testpopulatesubscriptions()
    {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234',Contact_Type__c='Primary Contact');
            insert con1;

          order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getSubscriptionByOrderIdResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"paymentProfile":{"zip":"34252","year":2022,"token":null,"state":"KY","phone":"4352345243","paymentType":"1","month":1,"lastName":"sdfasdf","last4Digits":"5234","isRecurring":false,"isActive":true,"gateway":"13","firstName":"asdfasdfasdfasdfasdfasd","firstDigit":"3","customerId":"11596577","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}}';
        IADAddNewPaymentController_ltng.populateSubscriptions(order1.Id,'12324');
        test.stopTest();
        
        
        
    }
     static testmethod  void testpopulatewrappers()
    {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234',Contact_Type__c='Primary Contact');
            insert con1;

          order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getSubscriptionByOrderIdResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
 string ints =  '[{"installmentId":1234,"orderId":1234,"dueDate":"'+ String.valueOf(Date.today()) +  'T00:00:00Z' + '","paid":false,"paymentDate":null,"canceled":false,"cancellationDate":null,"totalDueAmount":163.98,"balanceDueAmount":163.97,"installmentBillStatus":2,"paymentProfileId":27756997,"dateCreated":"2016-11-03T13:53:07.147Z","createdBy":"Basudev Khakurel","dateLastModified":"2016-11-30T08:31:05.627Z","lastModifiedBy":"Jane Boles"},{"installmentId":12345,"orderId":1234,"dueDate":"'+ String.valueOf(Date.today()) +'T00:00:00Z' + '","paid":false,"paymentDate":null,"canceled":false,"cancellationDate":null,"totalDueAmount":163.97,"balanceDueAmount":163.97,"installmentBillStatus":2,"paymentProfileId":27756803,"dateCreated":"2016-11-03T13:53:07.147Z","createdBy":"Basudev Khakurel","dateLastModified":"2016-11-08T12:26:24.6Z","lastModifiedBy":"Jane Boles"}]';
   string subs=  '[{"orderItemSubscriptionId":1234,"orderItemId":52674001,"orderId":1234,"productName":"Legal Advantage Plus Annual Membership","productionComponentId":1595,"paymentProfileId":27756997,"subscriptionEndDate":"2017-10-20T23:59:59Z","isActive":"true","status":"Active","isRA":false,"autoRenew":"Yes","additionalInfo":""}]';
   string profiles='[{"profileId":27756997,"customerId":11596577,"gateway":"13","firstName":"test1234","lastName":"test","paymentType":"1","accountType":"1","addressLine1":"addrcvsdvsdgsdg34","addressLine2":"","city":"cty","state":"CA","zip":"91203","phone":"1234567890","firstDigit":"4","last4Digits":"0002","month":12,"year":2018,"token":"1121000103070002","isActive":true,"isRecurring":false,"bankName":null,"routingNumber":null,"checkNumber":null,"dateCreated":"2016-11-11T13:35:52.007Z"}]';
        IADAddNewPaymentController_ltng.populateWrappers(order1.Id,ints,subs,profiles,order1.name);
        test.stopTest();
        
        
        
    }
      static testmethod  void testupdateinst()
    {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234',Contact_Type__c='Primary Contact');
            insert con1;

          order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        string ints =  '[{"installmentId":1234,"orderId":1234,"dueDate":"'+ String.valueOf(Date.today()) +  'T00:00:00Z' + '","paid":false,"paymentDate":null,"canceled":false,"cancellationDate":null,"totalDueAmount":163.98,"balanceDueAmount":163.97,"installmentBillStatus":2,"paymentProfileId":27756997,"dateCreated":"2016-11-03T13:53:07.147Z","createdBy":"Basudev Khakurel","dateLastModified":"2016-11-30T08:31:05.627Z","lastModifiedBy":"Jane Boles"},{"installmentId":12345,"orderId":1234,"dueDate":"'+ String.valueOf(Date.today()) +'T00:00:00Z' + '","paid":false,"paymentDate":null,"canceled":false,"cancellationDate":null,"totalDueAmount":163.97,"balanceDueAmount":163.97,"installmentBillStatus":2,"paymentProfileId":27756803,"dateCreated":"2016-11-03T13:53:07.147Z","createdBy":"Basudev Khakurel","dateLastModified":"2016-11-08T12:26:24.6Z","lastModifiedBy":"Jane Boles"}]';
   string subs=  '[{"orderItemSubscriptionId":1234,"orderItemId":52674001,"orderId":1234,"productName":"Legal Advantage Plus Annual Membership","productionComponentId":1595,"paymentProfileId":27756997,"subscriptionEndDate":"2017-10-20T23:59:59Z","isActive":"true","status":"Active","isRA":false,"autoRenew":"Yes","additionalInfo":""}]';
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getSubscriptionByOrderIdResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"paymentProfile":{"zip":"34252","year":2022,"token":null,"state":"KY","phone":"4352345243","paymentType":"1","month":1,"lastName":"sdfasdf","last4Digits":"5234","isRecurring":false,"isActive":true,"gateway":"13","firstName":"asdfasdfasdfasdfasdfasd","firstDigit":"3","customerId":"11596577","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}}';
        IADAddNewPaymentController_ltng.updateinstallment('123', '12345', ints);
        test.stopTest();
        
        
        
    }
      static testmethod  void testupdatesubscriptions()
    {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234',Contact_Type__c='Primary Contact');
            insert con1;

          order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        string ints =  '[{"installmentId":1234,"orderId":1234,"dueDate":"'+ String.valueOf(Date.today()) +  'T00:00:00Z' + '","paid":false,"paymentDate":null,"canceled":false,"cancellationDate":null,"totalDueAmount":163.98,"balanceDueAmount":163.97,"installmentBillStatus":2,"paymentProfileId":27756997,"dateCreated":"2016-11-03T13:53:07.147Z","createdBy":"Basudev Khakurel","dateLastModified":"2016-11-30T08:31:05.627Z","lastModifiedBy":"Jane Boles"},{"installmentId":12345,"orderId":1234,"dueDate":"'+ String.valueOf(Date.today()) +'T00:00:00Z' + '","paid":false,"paymentDate":null,"canceled":false,"cancellationDate":null,"totalDueAmount":163.97,"balanceDueAmount":163.97,"installmentBillStatus":2,"paymentProfileId":27756803,"dateCreated":"2016-11-03T13:53:07.147Z","createdBy":"Basudev Khakurel","dateLastModified":"2016-11-08T12:26:24.6Z","lastModifiedBy":"Jane Boles"}]';
   string subs=  '[{"orderItemSubscriptionId":1234,"orderItemId":52674001,"orderId":1234,"productName":"Legal Advantage Plus Annual Membership","productionComponentId":1595,"paymentProfileId":27756997,"subscriptionEndDate":"2017-10-20T23:59:59Z","isActive":"true","status":"Active","isRA":false,"autoRenew":"Yes","additionalInfo":""}]';
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getSubscriptionByOrderIdResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"paymentProfile":{"zip":"34252","year":2022,"token":null,"state":"KY","phone":"4352345243","paymentType":"1","month":1,"lastName":"sdfasdf","last4Digits":"5234","isRecurring":false,"isActive":true,"gateway":"13","firstName":"asdfasdfasdfasdfasdfasd","firstDigit":"3","customerId":"11596577","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}}';
        IADAddNewPaymentController_ltng.updatesubscription('12','234');
        test.stopTest();
        
        
        
    }
   
     
    



}