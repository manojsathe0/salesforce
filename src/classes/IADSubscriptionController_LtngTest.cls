@isTest
private class IADSubscriptionController_LtngTest
{
    static Contact con;
    static Order__c order;
    
    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FKUser__c='1234');
        insert con;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }
    
    static testMethod void testPopulateSubscriptionPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.populateSubscription('1234', '4567910');
    }
    
    static testMethod void testPopulateSubscriptionNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderNumberFromOrderItemId();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.populateSubscription('', '');
    }
    /*
    static testMethod void testProcessSubscriptionPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderNumberFromOrderItemId();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        system.debug('Inside Test Class: testProcessSubscriptionPositive');
        String lsID = IADTestDataUtil_ltng.getSubscriptionInfoDetail();
        system.debug(lsID);
        IADSubscriptionController_Ltng.processSubscription('1234', '4567910', '50117042', lsID);
    }
    
    static testMethod void testProcessSubscriptionNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrdersResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.processSubscription('', '', '', IADTestDataUtil_ltng.getSubscriptionInfoDetail());
    }
    */
    static testMethod void testUpdateSubscriptionPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionUpdateResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.updateSubscription('1234', '0', 'pp112342', 1, 1, 1.0);
    }
    
    static testMethod void testUpdateSubscriptionNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionUpdateResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.updateSubscription('', '', '', null, null, null);
    } 
    /*
    static testMethod void testGetOrderNumberFromOrderItemPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderNumberFromOrderItemId();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        String subInfoDetails = IADTestDataUtil_ltng.getSubscriptionInfoDetails();
        IADSubscriptionController_Ltng.getOrderNumberFromOrderItemNumber('1234', '4567', subInfoDetails, 1);
    }
    
    static testMethod void testGetOrderNumberFromOrderItemNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderNumberFromOrderItemId();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.getOrderNumberFromOrderItemNumber('', '', '', 1);
    }
    */
    static testMethod void testCancelSubscriptionPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.cancelSubscriptionRenewal('10.00', '1525398', '10994143', true, '52716289', '2016-12-15T00:00:00Z', 'testing');
    }
    
    static testMethod void testCancelSubscriptionNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.cancelSubscriptionRenewal('', '', '', true, '', '', 'testing');
    }
    
    static testMethod void testpopulateProratedRefundPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getProratedRefundData();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.populateProratedRefund('1234', '10994143', true, '50117590');
    }
    
    static testMethod void testpopulateProratedRefundNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.populateProratedRefund('', '', true, '');
    }
    
    static testMethod void testPopulatePaymentMethodPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.populateProfiles('10994143','Subscription');
    }
    
    static testMethod void testPopulatePaymentMethodNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.populateProfiles('', '');
    } 
    /*
    static testMethod void testGetTransactionNumberResultNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.getTransactionNumberResult(0);
    }  
    */
    static testMethod void testPopulateSubscriptionsPanelPositive()
    {
        setupData();
        Test.startTest();
        IADSubscriptionsPanelController_Ltng theController = new IADSubscriptionsPanelController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionsPanelController_Ltng.populateSubscriptions(String.valueOf(order.Id));
        Test.stopTest();
    }  
    
    static testMethod void testPopulateSubscriptionsPanelNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getSubscriptionResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionsPanelController_Ltng.populateSubscriptions('');
    } 
    
    static testmethod  void testpopulatesubscriptions()
    {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234',Contact_Type__c='Primary Contact');
        insert con1;
        
        order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
        insert order1;
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody =  IADTestDataUtil_ltng.getSubscriptionByOrderIdResponse();
        mock.statusCode=200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        String responsebody ='{"paymentProfile":{"zip":"34252","year":2022,"token":null,"state":"KY","phone":"4352345243","paymentType":"1","month":1,"lastName":"sdfasdf","last4Digits":"5234","isRecurring":false,"isActive":true,"gateway":"13","firstName":"asdfasdfasdfasdfasdfasd","firstDigit":"3","customerId":"11596577","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}}';
       	IADSubscriptionsPanelController_Ltng.populateSubscriptions(con1.id);
        test.stopTest();
    }
    
    static testMethod void testGetSubscriptionRenewalTermsPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 201;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.getSubscriptionRenewalTerms('123456');
	}   
    
    static testMethod void testGetSubscriptionRenewalTermsNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.getSubscriptionRenewalTerms('');
	}   
    
    
    static testMethod void testGetNextSubscriptionModificationPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 201;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.getNextSubscriptionModification('123456');
	}   
    
    static testMethod void testGetNextSubscriptionModificationNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.getNextSubscriptionModification('');
	}
    
    static testMethod void testCancelSubscriptionUpgradePositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 201;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.cancelSubscriptionUpgrade('123456','12345');
	}   
    
    static testMethod void testCancelSubscriptionUpgradeNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.cancelSubscriptionUpgrade('','');
	}
    
    static testMethod void testCancelSubscriptionWithoutRefundPositive()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.cancelSubscriptionWithoutRefund('123');
	}
    
    static testMethod void testCancelSubscriptionWithoutRefundNegative()
    {
        IADSubscriptionController_Ltng theController = new IADSubscriptionController_Ltng();
        IADSubscriptionPanelService_Ltng service = new IADSubscriptionPanelService_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADSubscriptionController_Ltng.cancelSubscriptionWithoutRefund('');
	}
    
    public static string getSubscriptionServices()
    {
        return '{ "subscriptionServices": [ { "subscriptionCoverageId": 7039633, "subscriptionId": 1562002, "autoRenewOption": 0, "productComponentId": 2313, "renewalPrice": 0, "autoRenewEndDate": "0001-01-01T00:00:00Z", "autoRenewOptOutReason": 0, "subscriptionStatus": 3, "subscriptionOrderItemId": 53170735, "subscriptionStartDate": "2018-08-16T00:00:01Z", "subscriptionEndDate": "2019-08-15T23:59:59Z", "serviceProductComponentId": 1245, "serviceType": 1, "coveredProductComponentId": 0 }, { "subscriptionCoverageId": 7039634, "subscriptionId": 1562002, "autoRenewOption": 0, "productComponentId": 2313, "renewalPrice": 0, "autoRenewEndDate": "0001-01-01T00:00:00Z", "autoRenewOptOutReason": 0, "subscriptionStatus": 3, "subscriptionOrderItemId": 53170735, "subscriptionStartDate": "2018-08-16T00:00:01Z", "subscriptionEndDate": "2019-08-15T23:59:59Z", "serviceProductComponentId": 1245, "serviceType": 1, "coveredProductComponentId": 0 } ] }';
    }
}