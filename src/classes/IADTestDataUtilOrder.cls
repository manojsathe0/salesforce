public with sharing class IADTestDataUtilOrder {
	public IADTestDataUtilOrder() {
		
	}

	public static IADContractBeans.IADActionItemBean getActionItemsByOrderItemIdResponse()
    {
        
        IADContractBeans.IADActionItemBean actionItemHolder = new IADContractBeans.IADActionItemBean();
        List<IADContractBeans.IADActionItem> actionItems = new List<IADContractBeans.IADActionItem>(); 
        IADContractBeans.IADActionItem theActionItem = new IADContractBeans.IADActionItem();
        theActionItem.orderId = '1000';
        theActionItem.orderItemId = '5678';
        theActionItem.actionItemsType = '0';
        theActionItem.productComponentId = '78907';
        theActionItem.productConfigurationId = '980637';
        theActionItem.productTypeId = '2';
        theActionItem.description = 'My Package';
       	actionItems.add(theActionItem);
        actionItemHolder.actionItems = actionItems;
        return actionItemHolder;

    }
    public static IADContractBeans.IADActionItemBean getMultipleActionItemsByOrderItemIdResponse()
    {
        
        IADContractBeans.IADActionItemBean actionItemHolder = new IADContractBeans.IADActionItemBean();
        List<IADContractBeans.IADActionItem> actionItems = new List<IADContractBeans.IADActionItem>(); 
        IADContractBeans.IADActionItem theActionItemChangePackage = new IADContractBeans.IADActionItem();
        theActionItemChangePackage.orderId = '1000';
        theActionItemChangePackage.orderItemId = '5678';
        theActionItemChangePackage.actionItemsType = '3'; //Change Package
        theActionItemChangePackage.productComponentId = '78907';
        theActionItemChangePackage.productConfigurationId = '980637';
        theActionItemChangePackage.productTypeId = '2';
        theActionItemChangePackage.description = 'My Package';
        actionItems.add(theActionItemChangePackage);

        IADContractBeans.IADActionItem theActionItemAddAdOn = new IADContractBeans.IADActionItem();
        theActionItemAddAdOn.orderId = '1000';
        theActionItemAddAdOn.orderItemId = '567890';
        theActionItemAddAdOn.actionItemsType = '0';//Add
        theActionItemAddAdOn.productComponentId = '7890712';
        theActionItemAddAdOn.productConfigurationId = '983712';
        theActionItemAddAdOn.productTypeId = '3';
        theActionItemAddAdOn.description = 'My AddOn';
        actionItems.add(theActionItemAddAdOn);

        IADContractBeans.IADActionItem theActionItemAddCrossSell = new IADContractBeans.IADActionItem();
        theActionItemAddCrossSell.orderId = '1000';
        theActionItemAddCrossSell.orderItemId = '5678901';
        theActionItemAddCrossSell.actionItemsType = '0';//Add
        theActionItemAddCrossSell.productComponentId = '78907121';
        theActionItemAddCrossSell.productConfigurationId = '9837121';
        theActionItemAddCrossSell.productTypeId = '9';
        theActionItemAddCrossSell.description = 'My Cross Sell';
        actionItems.add(theActionItemAddCrossSell);


        IADContractBeans.IADActionItem theActionItemAddFilingFee = new IADContractBeans.IADActionItem();
        theActionItemAddFilingFee.orderId = '1000';
        theActionItemAddFilingFee.orderItemId = '5678902';
        theActionItemAddFilingFee.actionItemsType = '0';//Add
        theActionItemAddFilingFee.productComponentId = '78907122';
        theActionItemAddFilingFee.productConfigurationId = '9837122';
        theActionItemAddFilingFee.productTypeId = '8';
        theActionItemAddFilingFee.description = 'My Filing Fee';
        actionItems.add(theActionItemAddFilingFee); 



        IADContractBeans.IADActionItem theActionItemAddShipping = new IADContractBeans.IADActionItem();
        theActionItemAddShipping.orderId = '1000';
        theActionItemAddShipping.orderItemId = '5678903';
        theActionItemAddShipping.actionItemsType = '0';//Add
        theActionItemAddShipping.productComponentId = '78907123';
        theActionItemAddShipping.productConfigurationId = '9837123';
        theActionItemAddShipping.productTypeId = '7';
        theActionItemAddShipping.description = 'My Shipping';
        actionItems.add(theActionItemAddShipping);

       



        IADContractBeans.IADActionItem theActionItemCancelCrossSell = new IADContractBeans.IADActionItem();
        
        theActionItemCancelCrossSell.orderId = '1000';
        theActionItemCancelCrossSell.orderItemId = '5678901';
        theActionItemCancelCrossSell.actionItemsType = '2';//Cancel
        theActionItemCancelCrossSell.productComponentId = '7890733';
        theActionItemCancelCrossSell.productConfigurationId = '98063733';
        theActionItemCancelCrossSell.productTypeId = '9';//Cross-Sell
        theActionItemCancelCrossSell.description = 'My Cross Sell';
        actionItems.add(theActionItemCancelCrossSell);

        IADContractBeans.IADActionItem theActionItemChangeShipping = new IADContractBeans.IADActionItem();
        theActionItemChangeShipping.orderId = '1000';
        theActionItemChangeShipping.orderItemId = '5678904';
        theActionItemChangeShipping.actionItemsType = '3';//Change
        theActionItemChangeShipping.productComponentId = '78907124';
        theActionItemChangeShipping.productConfigurationId = '9837124';
        theActionItemChangeShipping.productTypeId = '7';
        theActionItemChangeShipping.description = 'Change Shipping';
        actionItems.add(theActionItemChangeShipping);

        IADContractBeans.IADActionItem theActionItemAddRenewal = new IADContractBeans.IADActionItem();
        theActionItemAddRenewal.orderId = '1000';
        theActionItemAddRenewal.orderItemId = '5678905';
        theActionItemAddRenewal.actionItemsType = '0';//Add
        theActionItemAddRenewal.productComponentId = '78907125';
        theActionItemAddRenewal.productConfigurationId = '9837125';
        theActionItemAddRenewal.productTypeId = '12';
        theActionItemAddRenewal.description = 'Add Renewal';
        actionItems.add(theActionItemAddRenewal);

     

        actionItemHolder.actionItems = actionItems;
        return actionItemHolder;

    }
    //TODO : Combine Good and Bad Response to single method and pass boolean parameter to set bad fields
    public static IADContractBeans.IADOrderItemResponse getOrderItemResponse()
    {
        
        IADContractBeans.IADOrderItemResponse theItemResponse = new IADContractBeans.IADOrderItemResponse();
        IADContractBeans.IADOrderItem theItem = new IADContractBeans.IADOrderItem();
        
        theItem.orderItemId = '12345';
        theItem.parentOrderItemId = '34565';
        IADContractBeans.ProductConfiguration theProductConfig = new IADContractBeans.ProductConfiguration();
        theProductConfig.productTypeId = '2';
        IADContractBeans.ProductComponent theComponent = new IADContractBeans.ProductComponent();
        theComponent.displayNameOnBill = 'My Addon';
        theProductConfig.productComponent = theComponent;

        theItem.productConfiguration = theProductConfig;
        IADContractBeans.ProcessingOrder theProcessingOrder = new IADContractBeans.ProcessingOrder();
        theProcessingOrder.processId = '243';
        theProcessingOrder.processingOrderId = '65765756';

        theItem.processingOrder = theProcessingOrder;
        theItem.isCancelled = false;
        theItem.dateCreated = '2016-11-02T15:18:45.85Z';

        theItemResponse.orderItem = theItem;
        theItemResponse.orderId = '1000';

        return theItemResponse;

    }

    public static IADContractBeans.IADOrderItemResponse getBadOrderItemResponse()
    {
        
        IADContractBeans.IADOrderItemResponse theItemResponse = new IADContractBeans.IADOrderItemResponse();
        IADContractBeans.IADOrderItem theItem = new IADContractBeans.IADOrderItem();
        
        theItem.orderItemId = '12345';
        theItem.parentOrderItemId = '34565';
        IADContractBeans.ProductConfiguration theProductConfig = new IADContractBeans.ProductConfiguration();
        theProductConfig.productTypeId = '2';
        IADContractBeans.ProductComponent theComponent = new IADContractBeans.ProductComponent();
        theComponent.displayNameOnBill = 'My Addon';
        theProductConfig.productComponent = theComponent;

        theItem.productConfiguration = theProductConfig;
        IADContractBeans.ProcessingOrder theProcessingOrder = new IADContractBeans.ProcessingOrder();
        theProcessingOrder.processId = '243';
        theProcessingOrder.processingOrderId = '65765756';

        theItem.processingOrder = theProcessingOrder;
        theItem.isCancelled = false;
        theItem.dateCreated = 'Bad Data';

        theItemResponse.orderItem = theItem;
        theItemResponse.orderId = '1000';

        return theItemResponse;

    }

    public static IADContractBeans.IADOrderBeanWrapper getOrderBean()
    {
        IADContractBeans.IADOrderBeanWrapper theOrderBeanWrapper = new IADContractBeans.IADOrderBeanWrapper();
        IADContractBeans.IADOrderBean theOrder = new IADContractBeans.IADOrderBean();
        theOrder.customerId = '1234';
        theOrder.orderId = '1000';
        theOrder.isCancelled = false;
        theOrder.dateCreated = '2016-11-02T15:18:45.85Z';
        theOrder.orderItems = new List<IADContractBeans.IADOrderItem>{getOrderItemResponse().orderItem};
        theOrderBeanWrapper.Order = theOrder;
        return theOrderBeanWrapper;
    }

    public static IADContractBeans.IADOrderBeanWrapper getBadOrderBean()
    {
        IADContractBeans.IADOrderBeanWrapper theOrderBeanWrapper = new IADContractBeans.IADOrderBeanWrapper();
        IADContractBeans.IADOrderBean theOrder = new IADContractBeans.IADOrderBean();
        theOrder.customerId = '1234';
        theOrder.orderId = '1000';
        theOrder.isCancelled = false;
        theOrder.dateCreated = 'Bad Data';
        theOrder.orderItems = new List<IADContractBeans.IADOrderItem>{getOrderItemResponse().orderItem};
        theOrderBeanWrapper.Order = theOrder;
        return theOrderBeanWrapper;
    }


    public static IADContractBeans.IADOrderHistoryBean  getOrderHistoryBean()
    {
        IADContractBeans.IADOrderHistoryBean theOrderHistoryWrapper = new IADContractBeans.IADOrderHistoryBean();
        IADContractBeans.IADOrderItemsHistoryBean theItemHistory = new IADContractBeans.IADOrderItemsHistoryBean();
        IADContractBeans.IADOrderItemsHistory theHistory = new IADContractBeans.IADOrderItemsHistory();
        theHistory.updatedBy = 'Buddy';
        theHistory.description = 'Some changes';
        theHistory.status = 'Good';
        theHistory.createdDate = '2016-11-02T15:18:45.85Z';
        theItemHistory.orderItemId = '123456';
        theItemHistory.history = new List<IADContractBeans.IADOrderItemsHistory>{theHistory};
        theOrderHistoryWrapper.orderItemsHistory = new List<IADContractBeans.IADOrderItemsHistoryBean>{theItemHistory};

        return theOrderHistoryWrapper;
    }


}