@istest
private class IADEditpaymentltng_test
{


 static testmethod void testpaymentupate()
    {
        
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.postPaymentResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"zip":"34252","year":2022 , "customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
           IADEditPaymentController_ltng.updatePaymentProfile(responsebody, '1234','123' ,null);
        test.stopTest();
        
    }
     static testmethod void testpaymentupateonload()
    {
        
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getPaymentProfileResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"zip":"34252","year":2022 ,"customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
           IADEditPaymentController_ltng.onload('123');
        test.stopTest();
        
    }
     static testmethod void testpaymentupateerror()
    {
        
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  '';
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"zip":"34252","year":2022 , "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
           IADEditPaymentController_ltng.updatePaymentProfile(responsebody, '','',null);
        test.stopTest();
        
    }
    
    static testmethod void testpaymentdelete()
    {
        
        
         IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.postPaymentResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
     String responsebody ='{"zip":"34252","year":2022 , "customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
           IADEditPaymentController_ltng.deletePaymentProfile(responsebody, '1234','123' ,false);
        test.stopTest();
        
    }



}