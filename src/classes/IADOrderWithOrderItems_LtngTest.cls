@isTest
private class IADOrderWithOrderItems_LtngTest {
    static Contact con;
    static Order__c order;
    
    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }
    
    static testMethod void testGetOrderByOrderIdPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.getOrderByOrderId('', '32549426');
    }
    
    static testMethod void testGetOrderByOrderIdNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.getOrderByOrderId(String.valueOf(order.Id), order.OrderID__c);
    }
    
    static testMethod void testGetOrderBalanceByOrderIdPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.getOrderBalanceByOrderId('', '32546240');
    }
    
    static testMethod void testGetOrderBalanceByOrderIdNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.getOrderBalanceByOrderId(String.valueOf(order.Id), order.OrderID__c);
    }
    
    static testMethod void testGetOrderTagsPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERTAGBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.getOrderTags('', '32546240');
    }
    
    static testMethod void testGetOrderTagsNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERTAGBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.getOrderTags(String.valueOf(order.Id), order.OrderID__c);
    }
    
    static testMethod void testCreateOrderTagsPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.POSTORDERTAGBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.createOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createOrderTags('', 'tag1', '32546240');
    }
    
    static testMethod void testCreateOrderTagsNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.POSTORDERTAGBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.createOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createOrderTags(String.valueOf(order.Id),'tag1', order.OrderID__c);
    }
    
    static testMethod void testDeleteOrderTagsPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERTAGBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.deleteOrderTags('', 'tag1', '32546240');
    }
    
    static testMethod void testDeleteOrderTagsNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERTAGBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.deleteOrderTags(String.valueOf(order.Id),'tag1', order.OrderID__c);
    }
    
    static testMethod void testGetShipmentsByOrderIdPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETSHIPMENTSBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getShipmentsByOrderIdResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.getShipmentsByOrderId('', '32546240');
    }
    
    static testMethod void testGetShipmentsByOrderIdNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();        
        IADOrderWithOrderItemsService_ltng.OrderItemShipmentsWrapper oisw = new IADOrderWithOrderItemsService_ltng.OrderItemShipmentsWrapper('345345345', '/test', '31-10-2000', '234wrerfsdf324', 'UPS', '/teste');
        
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETSHIPMENTSBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getShipmentsByOrderIdResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.getShipmentsByOrderId(String.valueOf(order.Id), order.OrderID__c);
    }
    
    static testMethod void testPopulateActionItemsByOrderItemIdPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETACTIONITEMSBYORDERITEMID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.populateActionItemsByOrderItemIdResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.populateActionItemsByOrderItemId('50113751', 'addItem');
    }
    
    static testMethod void testPopulateActionItemsByOrderItemIdNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETACTIONITEMSBYORDERITEMID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.populateActionItemsByOrderItemIdResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.populateActionItemsByOrderItemId('', 'changePackage');
    }
    
    
    static testMethod void testModifyOrderItemAddOrderItemPdtType3(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '3';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.orderItemResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
        //B-34246 
    }
    
    static testMethod void testModifyOrderItemAddOrderItemPdtType9(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '9';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemAddOrderItemPdtType7(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '7';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemAddOrderItemPdtType8(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '8';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        //mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.testBody = IADTestDataUtil_ltng.orderItemResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemAddOrderItemPdtType12(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '12';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemChangeOrderItemPdtType2(){
        String str1 = '{actionItemsType=3, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '2';
        actionItem.actionItemsType = '3';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemChangeOrderItemPdtType7(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '7';
        actionItem.actionItemsType = '3';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemCancelOrderItemPdtType2(){
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        IADContractBeans_ltng.IADActionItem actionItem = IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse();
        actionItem.productTypeId = '7';
        actionItem.actionItemsType = '2';
        pdtCnfgActionItem.put('1998',(Object)actionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.orderItemResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', '', '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }
    
    static testMethod void testModifyOrderItemNegative(){
        setupData();
        String str1 = '{actionItemsType=2, description=Cancel Miscellaneous Charge - Please specify, orderId=31927425, orderItemId=50117042, productComponentId=1222, productConfigurationId=1998, productTypeId=3, productTypeName=AddOn}';
        Map<String, Object> pdtCnfgActionItem = new Map<String, Object>();
        pdtCnfgActionItem.put('1998',(Object)IADTestDataUtil_ltng.getSingleActionItemsByOrderItemIdResponse());
        
        system.debug('pdtCnfgActionItem');
        system.debug(pdtCnfgActionItem);
        
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('50098076',(Object)'145');
        orderItemIdToPdtCnfgId.put('50098080',(Object)'159');
        orderItemIdToPdtCnfgId.put('50098081',(Object)'3974');
        orderItemIdToPdtCnfgId.put('50098082',(Object)'3476');
        orderItemIdToPdtCnfgId.put('50098085',(Object)'1341');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'4600');
        orderItemIdToPdtCnfgId.put('50098094',(Object)'803');
        orderItemIdToPdtCnfgId.put('50098095',(Object)'4532');
        orderItemIdToPdtCnfgId.put('50098096',(Object)'959');
        orderItemIdToPdtCnfgId.put('50113728',(Object)'1155');
        
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERITEMBYORDERITEMDID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.modifyOrderItemCancellationResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.modifyOrderItem('1998', '50117042', String.valueOf(order.Id), '32546240', pdtCnfgActionItem, orderItemIdToPdtCnfgId);
    }   
    
    static testMethod void testCallCancelOrderPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.callCancelOrder('', '32546240');
    }
    
    static testMethod void testCallCancelOrderNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.callCancelOrder(String.valueOf(order.Id), order.OrderID__c);
    }
    
    static testMethod void testCallUnCancelOrderPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.callUncancelOrder('', '32546240');
    }
    
    static testMethod void testCallUnCancelOrderNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        Map<String, String> pdtCmpMap = IADOrderWithOrderItemsService_ltng.productComponentIdToName;
        Map<String, String> proStatIdToNameMap = IADOrderWithOrderItemsService_ltng.processingStatusIdToName;
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.deleteOrderTagResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.callUncancelOrder(String.valueOf(order.Id), order.OrderID__c);
    }
    
    static testMethod void testConvertOrderToThreePayPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.orderThreePayResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.convertOrderToThreePay('', '32546240');
    }    
    
    static testMethod void testConvertOrderToThreePayNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.orderThreePayResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.convertOrderToThreePay(String.valueOf(order.Id), order.OrderID__c);
    } 
    
    static testMethod void testOrderHistoryPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.orderHistoryResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.populateOrderHistory('', '32546240', new Map<String, Object>());
    }    
    
    static testMethod void testOrderHistoryNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents> orderItemHistory = new List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents>();
        IADOrderWithOrderItemsService_ltng.OrderItemHistoryWrapper oihw = new IADOrderWithOrderItemsService_ltng.OrderItemHistoryWrapper('12314', 'productName', 1 , orderItemHistory);
        
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.orderHistoryResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.populateOrderHistory(String.valueOf(order.Id), order.OrderID__c, new Map<String, Object>());
    }
    
    static testMethod void testCreateMiscItemPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createMiscItem('','1', '10', 'test item', '32546240');
    }    
    
    static testMethod void testCreateMiscItemNegative(){
        setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createMiscItem(String.valueOf(order.Id),'1', '10', 'test item', order.OrderID__c);
    }
    
    static testMethod void testreAutomateOrder(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.POSTDOCUMENTBYPROCESSINGORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        //mock.testBody = IADTestDataUtil_ltng.getOrderResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.reAutomateOrder('32549427');
    }
    
    static testMethod void testGetDocumentsByProcessingOrderId(){
        String response = '{"documentList":[{"createdDate":"2018-05-29T20:32:58.985Z","documentId":4,"documentName":"506830529_BEATTACHMENT_FLYER.pdf","folderName":"","isFileNetDocument":true},{"createdDate":"2018-05-29T20:32:58.985Z","documentId":5,"documentName":"506830529_BEATTACHMENT.pdf","folderName":"506830529-301969","isFileNetDocument":true},{"createdDate":"2018-05-29T20:32:58.985Z","documentId":6,"documentName":"506830529_NEWLETTER.doc","folderName":"506830529-301969","isFileNetDocument":true}]}';
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETDOCUMENTSBYPROCESSINGORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = response;
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.getDocumentsByProcessingOrderId('32549427');
    }
    
    static testMethod void testShareDocumentsByProcessingOrderId(){
        String payload = '[{"createdDate":"2018-05-29T20:32:58.985Z","documentId":4,"documentName":"506830529_BEATTACHMENT_FLYER.pdf","folderName":"","isFileNetDocument":true}]';
        List<Decimal> selDcos = new List<Decimal>{1};
            IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.SHAREDOCUMENTSBYPROCESSINGORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.shareDocumentsByProcessingOrderId('12324','32549427', 2, 'LLC', 'primary', payload, selDcos);
    }
    static testMethod void testGetEntityByProcessingProcess(){
        String response ='{"entity":{"entityId":0,"entityName":"string","entityType":{"processId":0,"description":"string"},"formationState":"string","processingOrderId":0,"contactFirstName":"string","contactLastName":"string","contactEmail":"string","contactPhone":"string","entityAddress":{"street1":"string","street2":"string","city":"string","state":"string","zip":"string"},"mailingAddress":{"street1":"string","street2":"string","city":"string","state":"string","zip":"string"},"formationDate":"2017-11-03T16:41:06.219Z","ein":"string","raProvider":0,"subscriptionTermId":0,"taxMattersMember":"string","businessPurpose":"string","status":"string","fiscalYearEndDate":"2017-11-03T16:41:06.219Z","orderItemId":0,"subscriptionOrderItemId":0,"parentCompanyId":0,"taxClassification":"string","professionalCorpType":"string","operators":[{"operatorId":0,"entityId":0,"title":"string","firstName":"string","lastName":"string","address":{"street1":"string","street2":"string","city":"string","state":"string","zip":"string"},"parentOperatorId":0}],"owners":[{"ownerId":0,"entityId":0,"ownerFirstName":"string","ownerLastName":"string","address":{"street1":"string","street2":"string","city":"string","state":"string","zip":"string"},"parentOwnerId":0}],"subscriptions":[{"subscriptionId":0,"entityId":0,"orderItemId":0,"subscriptionProvider":"string","subscriptionType":"string","raSubscriptionTermId":0}]}}';
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = response;
        mock.statusCode = 200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.getEininfo('1234');
        test.stoptest();
        
    }
    static testMethod void testExpediteProcessingPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createExpedite('','1', '10', 'test item', '32546240');
    }  
    
    static testMethod void testFilingitemPositive(){
     setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createFiling(String.valueOf(Order.Id),'4492', 10, '32546240');
    } 
    
    static testMethod void testFilingitemPositivetest1(){
    setupData();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.DELETEORDERBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADOrderWithOrderItemsController_ltng.createFiling(String.valueOf(Order.Id),'1', 10, '32546240');
    } 
    
    static testMethod void testGetSubscriptionChangeOptions(){
        setupData();
        String response = '{ "subscriptionChangeOptions": [ { "subscriptionChangeOptionID": 0, "subscriptionChangeFromComponentID": 0, "subscriptionChangeToComponentID": 0, "subscriptionChangeTypeID": 0, "dateCreated": "2018-08-08T17:47:48.296Z", "createdBy": "string", "dateLastModified": "2018-08-08T17:47:48.296Z", "lastModifiedBy": "string", "isActive": true, "subscriptionChangeToConfiguration": 0, "subscriptionChangeToName": "string", "availableRenewalTerm": [ { "renewalTerm": "string", "extendedPrice": 0, "productComponentId": 0, "productConfigurationId": 0 } ] } ] }';
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETSUBSCRIPTIONCHANGEOPTIONS, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = response;
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.subscriptionChangeOptions(String.valueOf(Order.Id),'32549427', '1241324', 'test');
    }
    
    static testMethod void testPostProratedSubscriptionTermInfo(){
        setupData();
        String response = '{ "orderId": 0, "orderItemId": 0, "currentSubscriptionSummary": { "subscriptionId": 0, "newEndDate": "2018-08-12T18:30:00Z", "serviceTermRemainingStartDate": "2018-08-13T18:30:00Z", "serviceTermRemainingEndDate": "2019-08-13T23:59:59Z" }, "changeSubscriptionSummary": { "productConfigurationId": 0, "purchasePrice": 0.0, "availableStoredCredit": 0.0, "remainingStoredCredit": 0.0, "proratedFee": 0.0, "balanceDue": 0.0, "serviceStartDate": "2018-08-13T18:30:00Z", "renewalDate": "2019-08-12T18:30:00Z" } }';
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.POSTPRORATEDSUBSCRIPTIONTERM, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = response;
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.proratedSubscriptionTermInfo(String.valueOf(Order.Id),'32549427', '1241324', 'test');
    }
    
    static testMethod void testPutUpgradeSubscritionPackage(){
        setupData();
        String response = '{ "order": { "orderGroupId": 0, "orderId": 0, "customerId": 0, "orderItems": [ { "orderItemId": 0, "parentOrderItemId": 0, "basePrice": 0, "extendedPrice": 0, "quantity": 0, "productConfiguration": { "productConfigurationId": 0, "shouldDisplayOnBill": true, "productComponent": { "productComponentId": 0, "productComponentFlags": { "allowCustomerToAdd": true, "allowCustomizablePrice": true, "allowExpediteOnPackage": true, "allowStoreCredit": true, "allowElectronicChecks": true, "canSubscribe": true, "canEditQuantity": true, "autoRenewByDefault": true, "mustAutoRenewToSubscribe": true, "isService": true }, "name": "string", "displayNameOnBill": "string", "displayNameOnWeb": "string", "description": "string", "longDescription": "string", "internalDescription": "string", "isActive": true } }, "isCancelled": true, "childOrderItems": [ {} ], "processingOrder": { "processingOrderId": 0, "questionnaireId": 0, "processingStatusId": 0, "processingStatusCategoryId": 0 } } ], "isCancelled": true, "paymentStatus": 1, "dateCreated": "2016-04-11T21:13:28.017Z", "createdBy": "string", "dateLastModified": "2016-04-11T21:13:28.017Z", "lastModifiedBy": "string" } }';
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.PutSubscriptionAdjustment, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = response;
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.upgradeSubscritionPackage(String.valueOf(Order.Id),3254942, '1241324', '1234', '3456', '123');
    }
    
      static testMethod void testUpdateProcessingstatus(){
       
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 200;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderWithOrderItemsController_ltng.updateProcessingStatus('1234');
        test.stoptest();
        
    }

    /* Code Coverage for Stories - STORY B-39539 - Starts Here*/
    /* This method creates the test data */
    @testSetup
    private static void setupTestData() {
        // Create Admin User
        TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
    }

    @isTest private static void updateOrderToCancelTest1() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '{"isSuccess": true}';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
            	IADOrderWithOrderItemsController_ltng.cancelRequestWrapper crWrap = new IADOrderWithOrderItemsController_ltng.cancelRequestWrapper();
            	crWrap.approvedBy=UserInfo.getUserEmail().substring(0, UserInfo.getUserEmail().indexOf('@'));
                resp = IADOrderWithOrderItemsController_ltng.updateOrderToCancel(crWrap,'1254552');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    
    @isTest private static void updateOrderToCancelTest2() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '';
                mock.statusCode=200;
                Test.setMock(HttpCalloutMock.class, mock);
            	IADOrderWithOrderItemsController_ltng.cancelRequestWrapper crWrap = new IADOrderWithOrderItemsController_ltng.cancelRequestWrapper();
            	crWrap.approvedBy=UserInfo.getUserEmail().substring(0, UserInfo.getUserEmail().indexOf('@'));
                resp = IADOrderWithOrderItemsController_ltng.updateOrderToCancel(crWrap,'1254552');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    @isTest private static void updateOrderToCancelTest3() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                resp = IADOrderWithOrderItemsController_ltng.updateOrderToCancel(null,'');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    @isTest private static void updateOrderToCancelTest4() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        string resp;
        system.runAs(u){
            Test.startTest();
                IADTestMockGenerator mock = new IADTestMockGenerator();
                mock.testBody =  '{"errors":[{"code":"Could not Cancel this Order at this Time","message":null}]}';
                mock.statusCode=400;
                Test.setMock(HttpCalloutMock.class, mock);
            	IADOrderWithOrderItemsController_ltng.cancelRequestWrapper crWrap = new IADOrderWithOrderItemsController_ltng.cancelRequestWrapper();
            	crWrap.approvedBy=UserInfo.getUserEmail().substring(0, UserInfo.getUserEmail().indexOf('@'));
                resp = IADOrderWithOrderItemsController_ltng.updateOrderToCancel(crWrap,'1254552');   
            Test.stopTest();
            system.assert(String.isNotBlank(resp));
        }
    }
    /* Code Coverage for Stories - STORY B-39539 - Ends Here*/
}