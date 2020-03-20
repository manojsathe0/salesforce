@isTest
public class  IADPendingPaymentControllerTest_ltng
{
    
    static Contact con1;
    static Order__c order1;
    
    public static void setupData() 
    {
        con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con1;
        
        order1 = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order1;
    }
    
    static testMethod void testPopulatePayments_PaymentsByOrderId() {
        
        setupData();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getPaymentsByOrderIdResponse(1);
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentController_ltng.populatePayments('32456' ,'1');
        Test.stopTest();
    }
    
    static testMethod void testPopulatePayments_refundsByOrderId() {
        
        setupData();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  '{ "refundDetails": { "id": 0, "orderId": 0, "transactionType": 2, "paymentType": "string", "amount": 0, "creatorId":"Legalzoom", "createdBy":"Legalzoom","currencyCode": "string", "creationDate": "2016-12-08T00:38:37.638Z",  "status": 2, "statusDate": "2016-12-08T00:38:37.638Z", "parentId": 0, "customerId": "string", "comments": "string", "reason": "string", "paymentProfileId": 0, "gateway": "string", "cancelled": true, "cancellationDate": "string", "source": "string", "manualCheckId": "string", "receiptEmail": "string" } }';
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentController_ltng.populatePayments('32456' ,'2');
        Test.stopTest();
        
    }
    static testMethod void testPopulatePayments_OriginalPaymentByPaymentId() {
        
        setupData();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getPaymentsByOrderIdResponse(1);
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentController_ltng.populatePayments('32456' ,'1');
        IADPendingPaymentController_ltng.populateOriginalPayment();
        
        
        Test.stopTest();
    }
    
    
    static testMethod void testPopulatePayments_Originalprofile() {
        
        setupData();
        IADPendingPaymentController_ltng  pendingpayment = new  IADPendingPaymentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getPaymentsByOrderIdResponse(1);
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADContractBeans_ltng.IADPaymentBean theOriginalPayment = new IADContractBeans_ltng.IADPaymentBean();
        IADPendingPaymentController_ltng.theOriginalPayment=theOriginalPayment;
        IADPendingPaymentController_ltng.theOriginalPayment.paymentProfileId='27756997';
        IADContractBeans_ltng.IADPaymentBean thePayment = new IADContractBeans_ltng.IADPaymentBean();
        IADPendingPaymentController_ltng.thePayment=thePayment;
        IADPendingPaymentController_ltng.thePayment.paymentType='1';
        IADPendingPaymentController_ltng.populateOriginalPaymentProfile();
        
        
        Test.stopTest();
    }
    static testMethod void testErrors() {
        
        setupData();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentController_ltng.populatePayments('32456' ,'1');
        IADPendingPaymentController_ltng.populatePayments('32456' ,'2');
        IADPendingPaymentController_ltng.populateOriginalPayment();
        IADPendingPaymentController_ltng.populateOriginalPaymentProfile();
        
        
        Test.stopTest();
    }
    static testMethod void testPopulatePayments_OriginalprofileResponse() {
        
        setupData();
        
        
        
        Test.startTest();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getPaymentProfileResponse();
        system.debug('the df profile '+ mock.testBody);
        mock.statusCode=200;
        
        IADContractBeans_ltng.IADPaymentBean theOriginalPayment = new IADContractBeans_ltng.IADPaymentBean();
        IADPendingPaymentController_ltng.theOriginalPayment=theOriginalPayment;
        IADPendingPaymentController_ltng.theOriginalPayment.paymentProfileId='27756997';
        IADContractBeans_ltng.IADPaymentBean thePayment = new IADContractBeans_ltng.IADPaymentBean();
        IADPendingPaymentController_ltng.thePayment=thePayment;
        IADPendingPaymentController_ltng.thePayment.paymentType='1';
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentController_ltng.populateOriginalPaymentProfile();
        system.debug('edit'+IADEditPaymentService_ltng.theProfile);
        
        
        Test.stopTest();
    }
       
    /* Code Coverage for Stories - STORY B-38496 & STORY B-38746  - Starts Here*/
        /* This method creates the test data */
    @testSetup
    private static void setupTestData() {
        // Create Admin User
        TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
    }

    @isTest private static void sendUpdatePaymentStatusTest1() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                //mock.testBody =  '{"transactionId": 1211,"isStoreCreditRefund": false,"updatedBy": "string","transactionStatus": "Approved","reasonCode": "1","reasonText": "test1"}';
                mock.testBody =  '{"isSuccess": true}';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
                resp = IADPendingPaymentController_ltng.sendUpdatePaymentStatus('1211','Approved','1','test1');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendUpdatePaymentStatusTest2() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                //mock.testBody =  '{"transactionId": 1211,"isStoreCreditRefund": false,"updatedBy": "string","transactionStatus": "Approved","reasonCode": "1","reasonText": "test1"}';
                mock.testBody =  '{"isSuccess": false}';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
                resp = IADPendingPaymentController_ltng.sendUpdatePaymentStatus('1211','Approved','1','test1');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }

	@isTest private static void sendUpdatePaymentStatusTest3() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator'And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '{"errors":[{"code":"Payment GateWay Error","message":null}]}';
                mock.statusCode=400;
                Test.setMock(HttpCalloutMock.class, mock);
                resp = IADPendingPaymentController_ltng.sendUpdatePaymentStatus('1211','Approved','1','test1');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }  
    
    @isTest private static void sendUpdatePaymentStatusTest4() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
        		resp = IADPendingPaymentController_ltng.sendUpdatePaymentStatus('1211','','1','');    
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendUpdatePaymentStatusTest5() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
                resp = IADPendingPaymentController_ltng.sendUpdatePaymentStatus('1211','Approved','1','test1');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundUpdateDetailsTest1(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp, req;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody = '{"storeCreditTransactionId": 0,"paymentTransactionId": 0,"isStatusChanged": true,"errorMessge": "string"}';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
            	req = '{"customerId":"12004623","transactionStatusDate":"2019-04-17T13:11:56.57Z","status":"Declined","checkNumber":"","firstName":"Test","lastName":"Test","orderId":"32819948","address1":"PO Box 123","address2":"-","city":"Glendale","stateId":5,"zipCode":"91209","country":"US"}';
        		resp = IADPendingPaymentController_ltng.sendRefundUpdateDetails(req,'122333');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundUpdateDetailsTest2(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp, req;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody ='{"errors":[{"code":"Could not Update Payment status of already Approved/Declined transaction","message":null}]}';
                mock.statusCode =400;
            	Test.setMock(HttpCalloutMock.class, mock);
                req = '{"customerId":"12004623","transactionStatusDate":"2019-04-17T13:11:56.57Z","status":"Declined","checkNumber":"","firstName":"Test","lastName":"Test","orderId":"32819948","address1":"PO Box 123","address2":"-","city":"Glendale","stateId":5,"zipCode":"91209","country":"US"}';
        		resp = IADPendingPaymentController_ltng.sendRefundUpdateDetails(req,'122333');      
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundUpdateDetailsTest3(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody ='';
                mock.statusCode =200;
            	Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADPendingPaymentController_ltng.sendRefundUpdateDetails('','000');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void sendRefundUpdateDetailsTest4(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp,req;
        system.runAs(u){
            Test.startTest();
            	IADPendingPaymentController_ltng.responseRefundClass rRC = new IADPendingPaymentController_ltng.responseRefundClass();
            	rRC.errorMessge='';
            	rRC.isStatusChanged =false;
            	rRC.paymentTransactionId =12124;
            	rRC.storeCreditTransactionId =858555;
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody ='';
                mock.statusCode =400;
            	Test.setMock(HttpCalloutMock.class, mock);
                req = '{"customerId":"12004623","transactionStatusDate":"2019-04-17T13:11:56.57Z","status":"Declined","checkNumber":"","firstName":"Test","lastName":"Test","orderId":"32819948","address1":"PO Box 123","address2":"-","city":"Glendale","stateId":5,"zipCode":"91209","country":"US"}';
        		resp = IADPendingPaymentController_ltng.sendRefundUpdateDetails(req,'122333');  
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void responseRefundClassTest1(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'System Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
            	IADPendingPaymentController_ltng.responseRefundClass rRC = new IADPendingPaymentController_ltng.responseRefundClass();
            	rRC.errorMessge='';
            	rRC.isStatusChanged =false;
            	rRC.paymentTransactionId =12124;
            	rRC.storeCreditTransactionId =858555;   
            Test.stopTest();
            system.assert(rRC!=null);
        }
    }
    /*
    @isTest private static void updateTransactionStatusResponseClassTest1(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'System Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
            	IADPendingPaymentController_ltng.updateTransactionStatusResponseClass rRC = new IADPendingPaymentController_ltng.updateTransactionStatusResponseClass();
            	rRC.transactionId=1234;
            	rRC.isStoreCreditRefund = false;
            	rRC.updatedBy = 'TestUser';
            	rRC.transactionStatus = 'pending';
            	rRC.reasonCode = '1';
            	rRC.reasonText = 'Test Reason Text';
            Test.stopTest();
            system.assert(rRC!=null);
        }
    }
	*/
    /* Code Coverage for Stories - STORY B-38496 & STORY B-38746  - Ends Here*/
    
    @isTest private static void  isFinanceUserTest(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'System Administrator' And IsActive=true LIMIT 1];
        boolean resp;
        system.runAs(u){
            Test.startTest();
        		resp = IADPendingPaymentController_ltng.isFinanceUser();   
            Test.stopTest();
            system.assert(resp!=null);
        }
    }
    
    @isTest private static void updateManualCheckStatusTest1(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody = '{"storeCreditTransactionId": 0,"paymentTransactionId": 0,"isStatusChanged": true,"errorMessge": "string"}';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADPendingPaymentController_ltng.updateManualCheckStatus( system.now().format(), '1111','pending' );   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void updateManualCheckStatusTest2(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody ='{"errors":[{"code":"Could not Update Payment status of already Approved/Declined transaction","message":null}]}';
                mock.statusCode =400;
            	Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADPendingPaymentController_ltng.updateManualCheckStatus( system.now().format(),'1111','pending');    
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
    
    @isTest private static void updateManualCheckStatusTest3(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody ='';
                mock.statusCode =200;
            	Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADPendingPaymentController_ltng.updateManualCheckStatus('','','1111');   
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }   
    @isTest private static void updateManualCheckStatusTest4(){
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody = '{"storeCreditTransactionId": 0,"paymentTransactionId": 0,"isStatusChanged": false,"errorMessge": "string"}';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
        		resp = IADPendingPaymentController_ltng.updateManualCheckStatus( system.now().format(),'1111','pending');
            Test.stopTest();
            system.assert(string.isNotBlank(resp));
        }
    }
}