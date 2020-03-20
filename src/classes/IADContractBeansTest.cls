@isTest
public with sharing class IADContractBeansTest {
	
	static testMethod void testIADPaymentBeanWrapper()
	{
		Test.startTest();
			IADContractBeans.IADPaymentBeanWrapper theObject = new IADContractBeans.IADPaymentBeanWrapper();
			theObject.payments = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();	
	}

	static testMethod void testIADPaymentBean()
	{
		Test.startTest();
			IADContractBeans.IADPaymentBean theObject = new IADContractBeans.IADPaymentBean();
			theObject.id = null;
			theObject.paymentTransactionId= null;
			theObject.orderId= null;
			theObject.transactionType= null;
			theObject.paymentType= null;
			theObject.amount= null;
			theObject.currencyCode= null;
			theObject.creationDate= null;
			theObject.creatorId= null;
			theObject.status= null;
			theObject.transactionStatus= null;
			theObject.statusDate= null;
			theObject.parentId= null;
			theObject.customerId= null;
			theObject.comments= null;
			theObject.reason= null;
			theObject.paymentProfileId= null;
			theObject.gateway= null;
			theObject.canceled= null;
			theObject.cancelationDate= null;
			theObject.source= null;
			theObject.manualCheckId= null;
			theObject.receiptEmail= null;
			theObject.adjCreationDate= null;
			theObject.adjStatusDate= null;
			theObject.createdDateTimeInString= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderPromoCodeBean()
	{
		Test.startTest();
			IADContractBeans.IADOrderPromoCodeBean theObject = new IADContractBeans.IADOrderPromoCodeBean();
			theObject.orderId = null;
			theObject.orderPromoCodes= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderPromoCode()
	{
		Test.startTest();
			IADContractBeans.IADOrderPromoCode theObject = new IADContractBeans.IADOrderPromoCode();
			theObject.code= null;
			theObject.amount= null;
			theObject.isCancelled= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
    static testMethod void testIADMakePaymentBean()
    {
        Test.startTest();
			IADContractBeans.IADMakePaymentBean theObject = new IADContractBeans.IADMakePaymentBean();
	        theObject.orderId= null;
	        theObject.amount= null;
	        theObject.createdBy= null;
	        theObject.paymentProfileId= null;
	        theObject.gateway= null;
	        theObject.source= null;
	        theObject.comments= null;
	        theObject.reasonId= null;
	        theObject.notificationEmail= null;
	        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();

    }
	static testMethod void testIADPaymentProfiles()
	{
	   Test.startTest();
			IADContractBeans.IADPaymentProfiles theObject = new IADContractBeans.IADPaymentProfiles();
	    	theObject.paymentProfiles= null;
	    	System.assertNotEquals(null , theObject , 'Should not be null');
	    Test.stopTest();
	}
	static testMethod void testIADPaymentProfileBean()
	{
		Test.startTest();
			IADContractBeans.IADPaymentProfileBean theObject = new IADContractBeans.IADPaymentProfileBean();
			theObject.profileId = null;
			theObject.customerId= null;
			theObject.gateway= null;
			theObject.firstName= null;
			theObject.lastName= null;
			theObject.paymentType= null;
			theObject.accountType= null;
			theObject.addressLine1= null;
			theObject.addressLine2= null;
			theObject.city= null;
			theObject.state= null;
			theObject.zip= null;
			theObject.phone= null;
			theObject.firstDigit= null;
			theObject.last4Digits= null;
			theObject.month= null;
			theObject.year= null;
			theObject.token= null;
			theObject.isActive= null;
			theObject.isRecurring= null;
			theObject.bankName= null;
			theObject.routingNumber= null;
			theObject.checkNumber= null;
			theObject.dateCreated= null;
			theObject.adjCreationDate= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADPaymentUpdateProfileBean()
	{
		Test.startTest();
			IADContractBeans.IADPaymentUpdateProfileBean theObject = new IADContractBeans.IADPaymentUpdateProfileBean();
			theObject.updatePaymentProfile= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADPaymentProfileUpdate()
	{
		Test.startTest();
			IADContractBeans.IADPaymentProfileUpdate theObject = new IADContractBeans.IADPaymentProfileUpdate();
			theObject.firstName= null;
			theObject.lastName= null;
			theObject.paymentType= null;
			theObject.accountType= null;
			theObject.addressLine1= null;
			theObject.addressLine2= null;
			theObject.city= null;
			theObject.state= null;
			theObject.zip= null;
			theObject.phone= null;
			theObject.month= null;
			theObject.year= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADInstallmentsWrapper()
	{
		Test.startTest();
			IADContractBeans.IADInstallmentsWrapper theObject = new IADContractBeans.IADInstallmentsWrapper();
			theObject.installments= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADInstallmentWrapper()
	{
		Test.startTest();
			IADContractBeans.IADInstallmentWrapper theObject = new IADContractBeans.IADInstallmentWrapper();
			theObject.installment= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADInstallmentBean()
	{
		Test.startTest();
			IADContractBeans.IADInstallmentBean theObject = new IADContractBeans.IADInstallmentBean();
			theObject.installmentId = null;
			theObject.orderId = null;
			theObject.dueDate = null;
			theObject.paid = null;
			theObject.paymentDate = null;
			theObject.canceled = null;
			theObject.cancelationDate = null;
			theObject.totalDueAmount = null;
			theObject.balanceDueAmount = null;
			theObject.installmentBillStatus = null;
			theObject.status = null;
			theObject.paymentProfileId = null;
			theObject.dateCreated = null;
			theObject.creatorId = null;
			theObject.adjPaymentDate = null;
			theObject.adjCreationDate = null;
			theObject.adjDueDate = null;
			theObject.isActiveProfile= null;
			theObject.adjPaymentDateInString = null;
			theObject.adjCreationDateInString = null;
			theObject.adjDueDateInString = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADInstallmentUpdateBean()
	{
		Test.startTest();
			IADContractBeans.IADInstallmentUpdateBean theObject = new IADContractBeans.IADInstallmentUpdateBean();
			theObject.dueDate = null;
	        theObject.updatedBy= null;
			theObject.paymentProfileId= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADContactUpdateBean()
	{
		Test.startTest();
			IADContractBeans.IADContactUpdateBean theObject = new IADContractBeans.IADContactUpdateBean();
			theObject.contact = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADContactUpdate()
	{
		Test.startTest();
			IADContractBeans.IADContactUpdate theObject = new IADContractBeans.IADContactUpdate();
			theObject.description = null;
			theObject.firstName = null;
			theObject.lastName = null;
			theObject.addressLine1 = null;
			theObject.addressLine2 = null;
			theObject.city = null;
			theObject.stateId = null;
			theObject.county = null;
			theObject.zipcode = null;
			theObject.email1 = null;
			theObject.email2 = null;
			theObject.email3 = null;
			theObject.homePhone = null;
			theObject.workPhone = null;
			theObject.cellPhone = null;
			theObject.fax = null;
			theObject.country = null;
			theObject.state = null;
			theObject.taxID = null;
			theObject.active = null;
			theObject.statusChanged = null;
			theObject.statusChangedBy = null;
			theObject.crmContactId = null;
			theObject.contactInfoType = null;
			theObject.updateSource = null;

			theObject.responseBean= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADContactCreateBean()
	{
		Test.startTest();
			IADContractBeans.IADContactCreateBean theObject = new IADContractBeans.IADContactCreateBean();
			theObject.status= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADContactCreate()
	{
		Test.startTest();
			IADContractBeans.IADContactCreate theObject = new IADContractBeans.IADContactCreate();
			theObject.existingContact= null;
			theObject.contactCreated= null;
			theObject.contactUpdated= null;
			theObject.contactInfoId= null;
			theObject.message= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADContactUpdateResponseBean()
	{
		Test.startTest();
			IADContractBeans.IADContactUpdateResponseBean theObject = new IADContractBeans.IADContactUpdateResponseBean();
			theObject.status= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADContactUpdateResponseStatusBean()
	{
		Test.startTest();
			IADContractBeans.IADContactUpdateResponseStatusBean theObject = new IADContractBeans.IADContactUpdateResponseStatusBean();
			theObject.existingContact= null;
			theObject.contactCreated= null;
			theObject.contactUpdated= null;
			theObject.contactInfoId= null;
			theObject.message= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADSecurityQuestionBean()
	{
		Test.startTest();
			IADContractBeans.IADSecurityQuestionBean theObject = new IADContractBeans.IADSecurityQuestionBean();
			theObject.securityQuestion = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADSecurityQuestion()
	{
		Test.startTest();
			IADContractBeans.IADSecurityQuestion theObject = new IADContractBeans.IADSecurityQuestion();
			theObject.question = null;
			theObject.answer = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADRequestPasswordBean()
	{
		Test.startTest();
			IADContractBeans.IADRequestPasswordBean theObject = new IADContractBeans.IADRequestPasswordBean();
			theObject.requestPasswordMessage= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADRequestPasswordresponseBean()
	{
		Test.startTest();
			IADContractBeans.IADRequestPasswordresponseBean theObject = new IADContractBeans.IADRequestPasswordresponseBean();
			theObject.status= null;
			theObject.message= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADRequestPasswordRequestBean()
	{
		Test.startTest();
			IADContractBeans.IADRequestPasswordRequestBean theObject = new IADContractBeans.IADRequestPasswordRequestBean();
			theObject.requestpassword= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testRequestpassword()
	{
		Test.startTest();
			IADContractBeans.requestpassword theObject = new IADContractBeans.requestpassword();
			theObject.email= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADNewPaymentProfileRequestBean()
	{
		Test.startTest();
			IADContractBeans.IADNewPaymentProfileRequestBean theObject = new IADContractBeans.IADNewPaymentProfileRequestBean();
			theObject.paymentProfile= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
    static testMethod void testIADNewPaymentProfileRequest()
    {
        Test.startTest();
			IADContractBeans.IADNewPaymentProfileRequest theObject = new IADContractBeans.IADNewPaymentProfileRequest();
	        theObject.customerId= null;
	        theObject.gateway= null; //litle
	        theObject.firstName= null;
	        theObject.lastName= null;
	        theObject.paymentType= null;
	        theObject.accountType= null;
	        theObject.addressLine1= null;
	        theObject.addressLine2= null;
	        theObject.city= null;
	        theObject.state= null;
	        theObject.zip= null;
	        theObject.phone= null;
	        theObject.firstDigit= null;
	        theObject.last4Digits= null;
	        theObject.month= null;
	        theObject.year= null;
	        theObject.token= null;
	        theObject.isActive= null;
	        theObject.isRecurring= null;
	        theObject.accountNumber= null;
	        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }


	static testMethod void testIADNewPaymentProfileResponseBean()
	{
		Test.startTest();
			IADContractBeans.IADNewPaymentProfileResponseBean theObject = new IADContractBeans.IADNewPaymentProfileResponseBean();
			theObject.id= null;
			theObject.userId= null;
			theObject.gateWay= null; //litle
			theObject.firstName= null;
			theObject.lastName= null;
			theObject.paymentType= null;
			theObject.accountType= null;
			theObject.addressLine1= null;
			theObject.addressLine2= null;
			theObject.city= null;
			theObject.state= null;
			theObject.zip= null;
			theObject.phone= null;
			theObject.firstDigit= null;
			theObject.last4Digits= null;
			theObject.month= null;
			theObject.year= null;
			theObject.cardNumber= null;
			theObject.token= null;
			theObject.isActive= null;
			theObject.isRecurring= null;
			theObject.bankName= null;
			theObject.routingNumber= null;
			theObject.checkNumber= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADCustomerHistoryBean()
	{
		Test.startTest();
			IADContractBeans.IADCustomerHistoryBean theObject = new IADContractBeans.IADCustomerHistoryBean();
			theObject.customerHistories= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADCustomerHistory()
	{
		Test.startTest();
			IADContractBeans.IADCustomerHistory theObject = new IADContractBeans.IADCustomerHistory();
			theObject.customerId= null;
			theObject.description= null;
			theObject.newValue= null;
			theObject.oldValue= null;
			theObject.tableName= null;
			theObject.fieldName= null;
			theObject.dateModified= null;
			theObject.modifiedBy= null;
			theObject.adjDateModified= null;
			theObject.adjDateModifiedDT= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	
	}

	static testMethod void testIncompleteOrdersBean()
	{
		Test.startTest();
			IADContractBeans.IncompleteOrdersBean theObject = new IADContractBeans.IncompleteOrdersBean();
			theObject.IncompleteOrders= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIncompleteOrders()
	{
		Test.startTest();
			IADContractBeans.IncompleteOrders theObject = new IADContractBeans.IncompleteOrders();
			theObject.cartId= null;
			theObject.product= null;
			theObject.dateCreated= null;
			theObject.createdBy= null;
			theObject.dateLastModified= null;
			theObject.lastModifiedBy= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADMiscItem()
	{
		Test.startTest();
			IADContractBeans.IADMiscItem theObject = new IADContractBeans.IADMiscItem();
			theObject.description= null;
			theObject.quantity= null;
			theObject.pricePerUnit= null;
			theObject.createdBy= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderBeanWrapper()
	{
		Test.startTest();
			IADContractBeans.IADOrderBeanWrapper theObject = new IADContractBeans.IADOrderBeanWrapper();
			theObject.Order= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderBean()
	{
		Test.startTest();
			IADContractBeans.IADOrderBean theObject = new IADContractBeans.IADOrderBean();
			theObject.customerId= null;
			theObject.orderGroupId= null;
			theObject.orderId= null;
			theObject.isRevision= null;
			theObject.orderItems= null;
			theObject.isCancelled= null;
			theObject.paymentStatus= null;
			theObject.dateCreated= null;
			theObject.createdBy= null;
			theObject.dateLastModified= null;
			theObject.lastModifiedBy= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderHistoryBean()
	{
		Test.startTest();
			IADContractBeans.IADOrderHistoryBean theObject = new IADContractBeans.IADOrderHistoryBean();
			theObject.orderItemsHistory= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderItemsHistoryBean()
	{
		Test.startTest();
			IADContractBeans.IADOrderItemsHistoryBean theObject = new IADContractBeans.IADOrderItemsHistoryBean();
			theObject.orderItemId = null;
			theObject.history= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderItemsHistory()
	{

		Test.startTest();
			IADContractBeans.IADOrderItemsHistory theObject = new IADContractBeans.IADOrderItemsHistory();
			theObject.updatedBy= null;
			theObject.description= null;
			theObject.status= null;
			theObject.additionalInfo= null;
			theObject.createdDate= null;
			theObject.adjCreatedDate= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderItemAvailableProductsBean()
	{
		Test.startTest();
			IADContractBeans.IADOrderItemAvailableProductsBean theObject = new IADContractBeans.IADOrderItemAvailableProductsBean();
			theObject.products= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADOrderItemAvailableProducts()
	{
		Test.startTest();
			IADContractBeans.IADOrderItemAvailableProducts theObject = new IADContractBeans.IADOrderItemAvailableProducts();
			theObject.productConfigurationId= null;
			theObject.productType = null;
			theObject.productComponent= null;
			theObject.childProducts= null;
			theObject.productConfigurationFlags = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADProductType()
	{
		Test.startTest();
			IADContractBeans.IADProductType theObject = new IADContractBeans.IADProductType();
			theObject.productTypeId = null;
			theObject.name= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADProductComponent()
	{
		Test.startTest();
			IADContractBeans.IADProductComponent theObject = new IADContractBeans.IADProductComponent();
			theObject.productComponentId = null;
			theObject.name = null;
			theObject.displayNameOnWeb = null;
			theObject.displayNameOnBill = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testAvailableProductWrapper()
	{
		Test.startTest();
			IADContractBeans.AvailableProductWrapper theObject = new IADContractBeans.AvailableProductWrapper();
			theObject.productComponentId= null;
			theObject.name = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADOrderItem()
	{
		Test.startTest();
			IADContractBeans.IADOrderItem  theObject = new IADContractBeans.IADOrderItem();
			theObject.orderItemId= null;
			theObject.parentOrderItemId= null;
			theObject.basePrice= null;
			theObject.extendedPrice= null;
			theObject.quantity= null;
			theObject.productConfiguration= null;
			theObject.isCancelled= null;
			theObject.childOrderItems= null;
			theObject.processingOrder= null;
			theObject.dateCreated= null;
			theObject.createdBy= null;
			theObject.dateLastModified= null;
			theObject.sfDateCreated= null;
			theObject.dateTimeCreatedInString= null;
			theObject.productName= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();

	}

	static testMethod void testIADOrderItemResponse()
	 {
		Test.startTest();
			IADContractBeans.IADOrderItemResponse theObject = new IADContractBeans.IADOrderItemResponse();
			theObject.orderId= null;
			theObject.orderItem= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testProductConfiguration()
	 {
		Test.startTest();
			IADContractBeans.ProductConfiguration theObject = new IADContractBeans.ProductConfiguration();
			theObject.productConfigurationId= null;
			theObject.productTypeId= null;
			theObject.shouldDisplayOnBill= null;
			theObject.productComponent= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();

	}
	static testMethod void testProductConfigurationFlags()
	{
		Test.startTest();
			IADContractBeans.ProductConfigurationFlags theObject = new IADContractBeans.ProductConfigurationFlags();
			theObject.doNotShowInOrderManager= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();

	}
	static testMethod void testProductComponent()
	{
		Test.startTest();
			IADContractBeans.ProductComponent theObject = new IADContractBeans.ProductComponent();
			theObject.productComponentId= null;
			theObject.productComponentFlags= null;
			theObject.name= null;
			theObject.displayNameOnBill= null;
			theObject.displayNameOnWeb= null;
			theObject.description= null;
			theObject.longDescription= null;
			theObject.internalDescription= null;
			theObject.helpText= null;
			theObject.isActive= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void  testProductComponentFlags() 
	{
		Test.startTest();
			IADContractBeans.ProductComponentFlags theObject = new IADContractBeans.ProductComponentFlags();
			theObject.allowCustomerToAdd= null;
			theObject.allowCustomizablePrice= null;
			theObject.allowExpediteOnPackage= null;
			theObject.allowStoreCredit= null;
			theObject.allowElectronicChecks= null;
			theObject.canSubscribe= null;
			theObject.canEditQuantity= null;
			theObject.autoRenewByDefault= null;
			theObject.mustAutoRenewToSubscribe= null;
			theObject.isService= null;
			System.assertNotEquals(null , theObject , 'Should not be null');

		Test.stopTest();

	}



	static testMethod void testProcessingOrder()
	{
		Test.startTest();
			IADContractBeans.ProcessingOrder theObject = new IADContractBeans.ProcessingOrder();
			theObject.processingOrderId= null;
			theObject.processId= null;
			theObject.questionnaireId= null;
			theObject.processingStatusId= null;
			theObject.processingStatusCategoryId= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();

	}


	static testMethod void testIADOrderBalance()
	{
		Test.startTest();
			IADContractBeans.IADOrderBalance theObject = new IADContractBeans.IADOrderBalance();
			theObject.orderId= null;
			theObject.customerId= null;
			theObject.subTotalCharges= null;
			theObject.subTotalPayments= null;
			theObject.subTotalRefunds= null;
			theObject.subTotalDiscount= null;
			theObject.subTotalInstallmentBalance= null;
			theObject.grandTotal= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();

	}

    static testMethod void testIADProcessRefundBean()
    {
        Test.startTest();
			IADContractBeans.IADProcessRefundBean theObject = new IADContractBeans.IADProcessRefundBean();
        	theObject.refundDetail= null;
        	System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
	static testMethod void testIADProcessRefund()
	{
        Test.startTest();
			IADContractBeans.IADProcessRefund theObject = new IADContractBeans.IADProcessRefund();
	        theObject.orderId= null;
	        theObject.amount= null;
	        theObject.createdBy= null;
	        theObject.paymentProfileId= null;
	        theObject.comments= null;
	        theObject.reasonId= null;
			theObject.paymentTransactionId= null;
	        theObject.notificationEmail= null;
	        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
	}

	static testMethod void testIADProcessRefundRequestBean()
	{
		Test.startTest();
			IADContractBeans.IADProcessRefundRequestBean theObject = new IADContractBeans.IADProcessRefundRequestBean();
			theObject.orderId= null;
			theObject.refundType= null;
			theObject.amount= null;
			theObject.currencyCode= null;
			theObject.creatorId= null;
			theObject.parentId= null;
			theObject.customerId= null;
			theObject.comments= null;
			theObject.reason= null;
			theObject.email= null;
			theObject.gateway= null;
			theObject.source= null;
			theObject.address= null;
			theObject.manualCheckDetails= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADRefund_address()
	{
		Test.startTest();
			IADContractBeans.IADRefund_address theObject = new IADContractBeans.IADRefund_address();
			theObject.firstName= null;
			theObject.lastName= null;
			theObject.addressLine1= null;
			theObject.addressLine2= null;
			theObject.city= null;
			theObject.state= null;
			theObject.zip= null;
			theObject.country= null;
			theObject.email= null;
			theObject.phone= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADRefund_manualCheckDetails()
	{
		Test.startTest();
			IADContractBeans.IADRefund_manualCheckDetails theObject = new IADContractBeans.IADRefund_manualCheckDetails();
			theObject.bankName= null;
			theObject.checkNumber= null;
			theObject.depositDate= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADShippingAddressBean()
	{
		Test.startTest();
			IADContractBeans.IADShippingAddressBean theObject = new IADContractBeans.IADShippingAddressBean();
			theObject.contacts= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADShippingContact()
	{
		Test.startTest();
			IADContractBeans.IADShippingContact theObject = new IADContractBeans.IADShippingContact();
			theObject.orderContactId= null;
			theObject.contactType= null;
			theObject.firstName= null;
			theObject.lastName= null;
			theObject.addressLine1= null;
			theObject.addressLine2= null;
			theObject.city= null;
			theObject.state= null;
			theObject.zipCode= null;
			theObject.updatedBy = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADOrderContact()
	{
		Test.startTest();
			IADContractBeans.IADOrderContact theObject = new IADContractBeans.IADOrderContact();
			theObject.contactType= null;
			theObject.firstName= null;
			theObject.lastName= null;
			theObject.addressLine1= null;
			theObject.addressLine2= null;
			theObject.city= null;
			theObject.state= null;
			theObject.zipCode= null;
			theObject.createdBy = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADShippingContact_Email()
	{
		Test.startTest();
			IADContractBeans.IADShippingContact_Email theObject = new IADContractBeans.IADShippingContact_Email();
			theObject.emailAddress= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADSubscriptionBean()
	{
		Test.startTest();
			IADContractBeans.IADSubscriptionBean theObject = new IADContractBeans.IADSubscriptionBean();
			theObject.subscriptions= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADSingleSubscriptionBean()
	{
		Test.startTest();
			IADContractBeans.IADSingleSubscriptionBean theObject = new IADContractBeans.IADSingleSubscriptionBean();
			theObject.subscription= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADSubscriptionRequestBean()
	{
		Test.startTest();
			IADContractBeans.IADSubscriptionRequestBean theObject = new IADContractBeans.IADSubscriptionRequestBean();
			theObject.orderItems= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADSubscriptionRequest()
	{
		Test.startTest();
			IADContractBeans.IADSubscriptionRequest theObject = new IADContractBeans.IADSubscriptionRequest();
			theObject.orderItem= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testErrors()
	{
		Test.startTest();
			IADContractBeans.Errors theObject = new IADContractBeans.Errors();
			theObject.message= null;
			theObject.code= null;
			theObject.fieldErrors= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testErrorResponse()
	{
		Test.startTest();
			IADContractBeans.ErrorResponse theObject = new IADContractBeans.ErrorResponse();
			theObject.errors= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testFieldErrors()
	{
		Test.startTest();
			IADContractBeans.FieldErrors theObject = new IADContractBeans.FieldErrors();
			theObject.field= null;
			theObject.type= null;
			theObject.details= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADSubscription()
	{
		Test.startTest();
			IADContractBeans.IADSubscription theObject = new IADContractBeans.IADSubscription();
			theObject.orderItemSubscriptionId= null;
			theObject.orderItemId= null;
			theObject.orderId= null;
			theObject.productName= null;
			theObject.isActive= null;
			theObject.status= null;
			theObject.autoRenew= null;
			theObject.additionalInfo= null;
			theObject.processing= null;
			theObject.createdDate= null;
			theObject.adjCreatedDate= null;
			theObject.subscriptionStartDate= null;
			theObject.adjSubscriptionStartDate= null;
			theObject.subscriptionEndDate= null;
			theObject.adjSubscriptionEndDate= null;
			theObject.relationshipType= null;
			theObject.renewalTerm= null;
			theObject.renewalPrice= null;
			theObject.isActiveProfile= null;
			theObject.userPaymentProfile= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADUpdateSubscriptionBean()
	{
		Test.startTest();
			IADContractBeans.IADUpdateSubscriptionBean theObject = new IADContractBeans.IADUpdateSubscriptionBean();
			theObject.orderItemSubscription= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADUpdateSubscription()
	{
		Test.startTest();
			IADContractBeans.IADUpdateSubscription theObject = new IADContractBeans.IADUpdateSubscription();
			theObject.subscriptionID= null;
			theObject.autoRenewOptionId= null;
			theObject.updatedBy= null;
			theObject.userPaymentProfileId= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

    static testMethod void testIADUpdateSubscriptionResponse()
    {
        Test.startTest();
			IADContractBeans.IADUpdateSubscriptionResponse theObject = new IADContractBeans.IADUpdateSubscriptionResponse();
        	theObject.success= null;
        	theObject.message= null;
        	theObject.orderItemSubscriptionId = null;
        	System.assertNotEquals(null , theObject , 'Should not be null');
    	Test.stopTest();
    }

	static testMethod void testOauthError()
	{
		Test.startTest();
			IADContractBeans.OauthError theObject = new IADContractBeans.OauthError();
			theObject.ErrorCode= null;
			theObject.Error= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testFaultError()
	{
		Test.startTest();
			IADContractBeans.FaultError theObject = new IADContractBeans.FaultError();
			theObject.fault= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testAPIFault()
	{
		Test.startTest();
			IADContractBeans.APIFault theObject = new IADContractBeans.APIFault();
			theObject.faultString= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testOauthToken()
	{
		Test.startTest();
			IADContractBeans.OauthToken theObject = new IADContractBeans.OauthToken();
			theObject.issued_at= null;
			theObject.expires_in= null;
			theObject.access_token= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADCustomerBean()
	{
		Test.startTest();
			IADContractBeans.IADCustomerBean theObject = new IADContractBeans.IADCustomerBean();
			theObject.thirdPartyUserInfo= null;
			theObject.securityQuestion= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADthirdPartyUserInfoBean()
	{
		Test.startTest();
			IADContractBeans.IADthirdPartyUserInfoBean theObject = new IADContractBeans.IADthirdPartyUserInfoBean();
			theObject.userId= null;
			theObject.thirdPartyId= null;
			theObject.thirdPartyTypeId= null;
			theObject.createdBy= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();	
	}
	static testMethod void testIADStoreCredit()
	{
		Test.startTest();
			IADContractBeans.IADStoreCredit theObject = new IADContractBeans.IADStoreCredit();
			theObject.storeCredits= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADStoreCreditBean()
	{
		Test.startTest();
			IADContractBeans.IADStoreCreditBean theObject = new IADContractBeans.IADStoreCreditBean();
			theObject.storeCreditId= null;
			theObject.customerId= null;
			theObject.code= null;
			theObject.storeCreditStatusId= null;
			theObject.expriationDate= null; //wrong spell in API label
			theObject.adjExpirationDate= null;
			theObject.adjExpirationDateDT= null;

			theObject.createdBy= null;
			theObject.dateCreated= null;
			theObject.adjDateCreated= null;
			theObject.adjDateCreatedDT= null;

			theObject.paymentTransactionId= null;
			theObject.refundableFlag = null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADStoreCreditById()
	{
		Test.startTest();
			IADContractBeans.IADStoreCreditById theObject = new IADContractBeans.IADStoreCreditById();
			theObject.storeCredit= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}
	static testMethod void testIADActionItemBean()
	{
		Test.startTest();
			IADContractBeans.IADActionItemBean theObject = new IADContractBeans.IADActionItemBean();
			theObject.actionItems= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testIADActionItem()
	{
		Test.startTest();
			IADContractBeans.IADActionItem theObject = new IADContractBeans.IADActionItem();
			theObject.orderId= null;
			theObject.orderItemId= null;
			theObject.actionItemsType= null;
			theObject.productComponentId= null;
			theObject.productConfigurationId= null;
			theObject.productTypeId= null;
			theObject.description= null;
			theObject.productTypeName= null;
			System.assertNotEquals(null , theObject , 'Should not be null');
		Test.stopTest();
	}



}