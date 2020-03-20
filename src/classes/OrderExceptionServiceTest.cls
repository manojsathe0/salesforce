//Updated B-38758
@isTest
public class OrderExceptionServiceTest {
    @isTest
    static void testCheckIfInbinDateModified() {
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=200;
        mock.testBody = '{    "message": "Success",    "customerId": 11631589,    "uuid": "33d08ebc-b285-4a94-b4de-2de604042e23"}';
        Test.setMock(HttpCalloutMock.class, mock);
        
        Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
        Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        insert newExc;
        DateTime dt = datetime.newInstance(1996, 6, 23);

        newExc.Due_Date__c = dt;
        update newExc;
        
    }
    
     @isTest
    static void testGetInbinDate() {
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=200;
        mock.testBody = '{  "expedite": "false", "orderNumber": "506858833", "refresh": "true", "message": "success", "timestamp": "2018-05-21 08:40:07.392", "inbindate": "05/21/18  8:22:30 AM","status": "200"}';
        Test.setMock(HttpCalloutMock.class, mock);
        
        Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
        Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newExc.Processing_Number__c='1234567';
        insert newExc;
        DateTime dt = datetime.newInstance(1996, 6, 23);

      
        
    }
     @isTest
    static void testUpdateProcessingStatus() {
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=200;
        mock.testBody = '{  "expedite": "false", "orderNumber": "506858833", "refresh": "true", "message": "success", "timestamp": "2018-05-21 08:40:07.392", "inbindate": "05/21/18  8:22:30 AM","status": "200"}';
        Test.setMock(HttpCalloutMock.class, mock);
        
        Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
        Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newExc.Processing_Number__c='1234567';
        newExc.Exception_Type__c='problem';
        insert newExc;
   newExc.Status__c='Hold';
        update newExc;
        DateTime dt = datetime.newInstance(1996, 6, 23);

      
        
    }

   @isTest
    static void testGetInbinDatefuture() {
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.statusCode=200;
        mock.testBody = '{  "expedite": "false", "orderNumber": "506858833", "refresh": "true", "message": "success", "timestamp": "2018-05-21 08:40:07.392", "inbindate": "05/21/18  8:22:30 AM","status": "200"}';
        Test.setMock(HttpCalloutMock.class, mock);
        
        Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
        Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newExc.Processing_Number__c='1234567';
        insert newExc;
        set<id> excids = new set<id>();
        excids.add(newExc.id);
        Test.starttest();
       OrderExceptionService.inbindatenonfuture(excids,true);
       test.stoptest();
        DateTime dt = datetime.newInstance(1996, 6, 23);

      
        
    }

}