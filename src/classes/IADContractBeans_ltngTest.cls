@isTest
public with sharing class IADContractBeans_ltngTest {
    
    static testMethod void testIADPaymentBeanWrapper()
    {
        Test.startTest();
        IADContractBeans_ltng.IADPaymentBeanWrapper theObject = new IADContractBeans_ltng.IADPaymentBeanWrapper();
        theObject.payments = null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();    
    }
    
    static testMethod void testIADPaymentBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADPaymentBean theObject = new IADContractBeans_ltng.IADPaymentBean();
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
        theObject.mailingAddress = null; /*STORY B-39088 */
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    /*STORY B-39088 */
    static testMethod void testMailingAddress(){
        Test.startTest();
        IADContractBeans_ltng.MailingAddress theObject = new IADContractBeans_ltng.MailingAddress();
    	theObject.userPaymentProfile =null;
        theObject.orderContactId=null;
		theObject.firstName=null;
		theObject.lastName=null;
		theObject.addressLine1=null;
		theObject.addressLine2=null;
		theObject.city=null;
		theObject.stateId=null;
		theObject.state=null;
		theObject.zipCode=null;
		theObject.country=null;
		theObject.county=null;
		theObject.emailAddress=null;
		theObject.homePhone=null;
		theObject.workPhone=null;
		theObject.mobilePhone=null;
		theObject.faxPhone=null;
        Test.stopTest();
        System.assertEquals(null , theObject.firstName );
    }
    /*STORY B-39088 */

    static testMethod void testIADOrderPromoCodeBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADOrderPromoCodeBean theObject = new IADContractBeans_ltng.IADOrderPromoCodeBean();
        theObject.orderId = null;
        theObject.orderPromoCodes= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADOrderPromoCode()
    {
        Test.startTest();
        IADContractBeans_ltng.IADOrderPromoCode theObject = new IADContractBeans_ltng.IADOrderPromoCode();
        theObject.code= null;
        theObject.amount= null;
        theObject.isCancelled= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADMakePaymentBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADMakePaymentBean theObject = new IADContractBeans_ltng.IADMakePaymentBean();
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
        IADContractBeans_ltng.IADPaymentProfiles theObject = new IADContractBeans_ltng.IADPaymentProfiles();
        theObject.paymentProfiles= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADPaymentProfileBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADPaymentProfileBean theObject = new IADContractBeans_ltng.IADPaymentProfileBean();
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
        IADContractBeans_ltng.IADPaymentUpdateProfileBean theObject = new IADContractBeans_ltng.IADPaymentUpdateProfileBean();
        theObject.updatePaymentProfile= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADPaymentProfileUpdate()
    {
        Test.startTest();
        IADContractBeans_ltng.IADPaymentProfileUpdate theObject = new IADContractBeans_ltng.IADPaymentProfileUpdate();
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
        IADContractBeans_ltng.IADInstallmentsWrapper theObject = new IADContractBeans_ltng.IADInstallmentsWrapper();
        theObject.installments= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADInstallmentWrapper()
    {
        Test.startTest();
        IADContractBeans_ltng.IADInstallmentWrapper theObject = new IADContractBeans_ltng.IADInstallmentWrapper();
        theObject.installment= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADInstallmentBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADInstallmentBean theObject = new IADContractBeans_ltng.IADInstallmentBean();
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
        IADContractBeans_ltng.IADInstallmentUpdateBean theObject = new IADContractBeans_ltng.IADInstallmentUpdateBean();
        theObject.dueDate = null;
        theObject.updatedBy= null;
        theObject.paymentProfileId= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADContactUpdateBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADContactUpdateBean theObject = new IADContractBeans_ltng.IADContactUpdateBean();
        theObject.contact = null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADContactUpdate()
    {
        Test.startTest();
        IADContractBeans_ltng.IADContactUpdate theObject = new IADContractBeans_ltng.IADContactUpdate();
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
        IADContractBeans_ltng.IADContactCreateBean theObject = new IADContractBeans_ltng.IADContactCreateBean();
        theObject.status= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADContactCreate()
    {
        Test.startTest();
        IADContractBeans_ltng.IADContactCreate theObject = new IADContractBeans_ltng.IADContactCreate();
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
        IADContractBeans_ltng.IADContactUpdateResponseBean theObject = new IADContractBeans_ltng.IADContactUpdateResponseBean();
        theObject.status= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADContactUpdateResponseStatusBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADContactUpdateResponseStatusBean theObject = new IADContractBeans_ltng.IADContactUpdateResponseStatusBean();
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
        IADContractBeans_ltng.IADSecurityQuestionBean theObject = new IADContractBeans_ltng.IADSecurityQuestionBean();
        theObject.securityQuestion = null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADSecurityQuestion()
    {
        Test.startTest();
        IADContractBeans_ltng.IADSecurityQuestion theObject = new IADContractBeans_ltng.IADSecurityQuestion();
        theObject.question = null;
        theObject.answer = null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADRequestPasswordBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADRequestPasswordBean theObject = new IADContractBeans_ltng.IADRequestPasswordBean();
        theObject.requestPasswordMessage= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADRequestPasswordresponseBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADRequestPasswordresponseBean theObject = new IADContractBeans_ltng.IADRequestPasswordresponseBean();
        theObject.status= null;
        theObject.message= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADRequestPasswordRequestBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADRequestPasswordRequestBean theObject = new IADContractBeans_ltng.IADRequestPasswordRequestBean();
        theObject.requestpassword= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testRequestpassword()
    {
        Test.startTest();
        IADContractBeans_ltng.requestpassword theObject = new IADContractBeans_ltng.requestpassword();
        theObject.email= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADNewPaymentProfileRequestBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADNewPaymentProfileRequestBean theObject = new IADContractBeans_ltng.IADNewPaymentProfileRequestBean();
        theObject.paymentProfile= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADNewPaymentProfileRequest()
    {
        Test.startTest();
        IADContractBeans_ltng.IADNewPaymentProfileRequest theObject = new IADContractBeans_ltng.IADNewPaymentProfileRequest();
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
        IADContractBeans_ltng.IADNewPaymentProfileResponseBean theObject = new IADContractBeans_ltng.IADNewPaymentProfileResponseBean();
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
        IADContractBeans_ltng.IADCustomerHistoryBean theObject = new IADContractBeans_ltng.IADCustomerHistoryBean();
        theObject.customerHistories= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADCustomerHistory()
    {
        Test.startTest();
        IADContractBeans_ltng.IADCustomerHistory theObject = new IADContractBeans_ltng.IADCustomerHistory();
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
        IADContractBeans_ltng.IncompleteOrdersBean theObject = new IADContractBeans_ltng.IncompleteOrdersBean();
        theObject.IncompleteOrders= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIncompleteOrders()
    {
        Test.startTest();
        IADContractBeans_ltng.IncompleteOrders theObject = new IADContractBeans_ltng.IncompleteOrders();
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
        IADContractBeans_ltng.IADMiscItem theObject = new IADContractBeans_ltng.IADMiscItem();
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
        IADContractBeans_ltng.IADOrderBeanWrapper theObject = new IADContractBeans_ltng.IADOrderBeanWrapper();
        theObject.Order= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADOrderBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADOrderBean theObject = new IADContractBeans_ltng.IADOrderBean();
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
        IADContractBeans_ltng.IADOrderHistoryBean theObject = new IADContractBeans_ltng.IADOrderHistoryBean();
        theObject.orderItemsHistory= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADOrderItemsHistoryBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADOrderItemsHistoryBean theObject = new IADContractBeans_ltng.IADOrderItemsHistoryBean();
        theObject.orderItemId = null;
        theObject.history= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADOrderItemsHistory()
    {
        
        Test.startTest();
        IADContractBeans_ltng.IADOrderItemsHistory theObject = new IADContractBeans_ltng.IADOrderItemsHistory();
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
        IADContractBeans_ltng.IADOrderItemAvailableProductsBean theObject = new IADContractBeans_ltng.IADOrderItemAvailableProductsBean();
        theObject.products= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADOrderItemAvailableProducts()
    {
        Test.startTest();
        IADContractBeans_ltng.IADOrderItemAvailableProducts theObject = new IADContractBeans_ltng.IADOrderItemAvailableProducts();
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
        IADContractBeans_ltng.IADProductType theObject = new IADContractBeans_ltng.IADProductType();
        theObject.productTypeId = null;
        theObject.name= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADProductComponent()
    {
        Test.startTest();
        IADContractBeans_ltng.IADProductComponent theObject = new IADContractBeans_ltng.IADProductComponent();
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
        IADContractBeans_ltng.AvailableProductWrapper theObject = new IADContractBeans_ltng.AvailableProductWrapper();
        theObject.productComponentId= null;
        theObject.name = null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADOrderItem()
    {
        Test.startTest();
        IADContractBeans_ltng.IADOrderItem  theObject = new IADContractBeans_ltng.IADOrderItem();
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
        IADContractBeans_ltng.IADOrderItemResponse theObject = new IADContractBeans_ltng.IADOrderItemResponse();
        theObject.orderId= null;
        theObject.orderItem= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testProductConfiguration()
    {
        Test.startTest();
        IADContractBeans_ltng.ProductConfiguration theObject = new IADContractBeans_ltng.ProductConfiguration();
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
        IADContractBeans_ltng.ProductConfigurationFlags theObject = new IADContractBeans_ltng.ProductConfigurationFlags();
        theObject.doNotShowInOrderManager= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
        
    }
    static testMethod void testProductComponent()
    {
        Test.startTest();
        IADContractBeans_ltng.ProductComponent theObject = new IADContractBeans_ltng.ProductComponent();
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
        IADContractBeans_ltng.ProductComponentFlags theObject = new IADContractBeans_ltng.ProductComponentFlags();
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
        IADContractBeans_ltng.ProcessingOrder theObject = new IADContractBeans_ltng.ProcessingOrder();
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
        IADContractBeans_ltng.IADOrderBalance theObject = new IADContractBeans_ltng.IADOrderBalance();
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
        IADContractBeans_ltng.IADProcessRefundBean theObject = new IADContractBeans_ltng.IADProcessRefundBean();
        theObject.refundDetail= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADProcessRefund()
    {
        Test.startTest();
        IADContractBeans_ltng.IADProcessRefund theObject = new IADContractBeans_ltng.IADProcessRefund();
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
        IADContractBeans_ltng.IADProcessRefundRequestBean theObject = new IADContractBeans_ltng.IADProcessRefundRequestBean();
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
        IADContractBeans_ltng.IADRefund_address theObject = new IADContractBeans_ltng.IADRefund_address();
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
        IADContractBeans_ltng.IADRefund_manualCheckDetails theObject = new IADContractBeans_ltng.IADRefund_manualCheckDetails();
        theObject.bankName= null;
        theObject.checkNumber= null;
        theObject.depositDate= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADShippingAddressBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADShippingAddressBean theObject = new IADContractBeans_ltng.IADShippingAddressBean();
        theObject.contacts= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADShippingContact()
    {
        Test.startTest();
        IADContractBeans_ltng.IADShippingContact theObject = new IADContractBeans_ltng.IADShippingContact();
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
        IADContractBeans_ltng.IADOrderContact theObject = new IADContractBeans_ltng.IADOrderContact();
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
        IADContractBeans_ltng.IADShippingContact_Email theObject = new IADContractBeans_ltng.IADShippingContact_Email();
        theObject.emailAddress= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADSubscriptionBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADSubscriptionBean theObject = new IADContractBeans_ltng.IADSubscriptionBean();
        theObject.subscriptions= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADSingleSubscriptionBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADSingleSubscriptionBean theObject = new IADContractBeans_ltng.IADSingleSubscriptionBean();
        theObject.subscription= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADSubscriptionRequestBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADSubscriptionRequestBean theObject = new IADContractBeans_ltng.IADSubscriptionRequestBean();
        theObject.orderItems= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADSubscriptionRequest()
    {
        Test.startTest();
        IADContractBeans_ltng.IADSubscriptionRequest theObject = new IADContractBeans_ltng.IADSubscriptionRequest();
        theObject.orderItem= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testErrors()
    {
        Test.startTest();
        IADContractBeans_ltng.Errors theObject = new IADContractBeans_ltng.Errors();
        theObject.message= null;
        theObject.code= null;
        theObject.fieldErrors= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testErrorResponse()
    {
        Test.startTest();
        IADContractBeans_ltng.ErrorResponse theObject = new IADContractBeans_ltng.ErrorResponse();
        theObject.errors= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testFieldErrors()
    {
        Test.startTest();
        IADContractBeans_ltng.FieldErrors theObject = new IADContractBeans_ltng.FieldErrors();
        theObject.field= null;
        theObject.type= null;
        theObject.details= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADSubscription()
    {
        Test.startTest();
        IADContractBeans_ltng.IADSubscription theObject = new IADContractBeans_ltng.IADSubscription();
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
        IADContractBeans_ltng.IADUpdateSubscriptionBean theObject = new IADContractBeans_ltng.IADUpdateSubscriptionBean();
        theObject.orderItemSubscription= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADUpdateSubscription()
    {
        Test.startTest();
        IADContractBeans_ltng.IADUpdateSubscription theObject = new IADContractBeans_ltng.IADUpdateSubscription();
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
        IADContractBeans_ltng.IADUpdateSubscriptionResponse theObject = new IADContractBeans_ltng.IADUpdateSubscriptionResponse();
        theObject.success= null;
        theObject.message= null;
        theObject.orderItemSubscriptionId = null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testOauthError()
    {
        Test.startTest();
        IADContractBeans_ltng.OauthError theObject = new IADContractBeans_ltng.OauthError();
        theObject.ErrorCode= null;
        theObject.Error= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testFaultError()
    {
        Test.startTest();
        IADContractBeans_ltng.FaultError theObject = new IADContractBeans_ltng.FaultError();
        theObject.fault= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testAPIFault()
    {
        Test.startTest();
        IADContractBeans_ltng.APIFault theObject = new IADContractBeans_ltng.APIFault();
        theObject.faultString= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testOauthToken()
    {
        Test.startTest();
        IADContractBeans_ltng.OauthToken theObject = new IADContractBeans_ltng.OauthToken();
        theObject.issued_at= null;
        theObject.expires_in= null;
        theObject.access_token= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADCustomerBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADCustomerBean theObject = new IADContractBeans_ltng.IADCustomerBean();
        theObject.thirdPartyUserInfo= null;
        theObject.securityQuestion= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADthirdPartyUserInfoBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADthirdPartyUserInfoBean theObject = new IADContractBeans_ltng.IADthirdPartyUserInfoBean();
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
        IADContractBeans_ltng.IADStoreCredit theObject = new IADContractBeans_ltng.IADStoreCredit();
        theObject.storeCredits= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADStoreCreditBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADStoreCreditBean theObject = new IADContractBeans_ltng.IADStoreCreditBean();
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
        IADContractBeans_ltng.IADStoreCreditById theObject = new IADContractBeans_ltng.IADStoreCreditById();
        theObject.storeCredit= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    static testMethod void testIADActionItemBean()
    {
        Test.startTest();
        IADContractBeans_ltng.IADActionItemBean theObject = new IADContractBeans_ltng.IADActionItemBean();
        theObject.actionItems= null;
        System.assertNotEquals(null , theObject , 'Should not be null');
        Test.stopTest();
    }
    
    static testMethod void testIADActionItem()
    {
        Test.startTest();
        IADContractBeans_ltng.IADActionItem theObject = new IADContractBeans_ltng.IADActionItem();
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
    
    static testMethod void testIADSubscriptionChangeOptionBean()
    {        
        List<IADContractBeans_Ltng.AvailableRenewalTerms> artlist = new List<IADContractBeans_Ltng.AvailableRenewalTerms>();
        IADContractBeans_Ltng.AvailableRenewalTerms art = new IADContractBeans_Ltng.AvailableRenewalTerms();
        art.renewalTerm = 'test';
        art.extendedPrice = 1.1;
        art.productComponentId = 1;
        art.productConfigurationId = 1;
        artlist.add(art);
        
        IADContractBeans_Ltng.SubscriptionChangeOptionsResponse sucr = new IADContractBeans_Ltng.SubscriptionChangeOptionsResponse();
        sucr.subscriptionChangeOptionID = 1;
        sucr.subscriptionChangeFromComponentID =1;
        sucr.subscriptionChangeToComponentID = 1;
        sucr.subscriptionChangeTypeID = 1;
        sucr.dateCreated = system.now();        
        sucr.createdBy = 'test';
        sucr.dateLastModified = system.now();        
        sucr.lastModifiedBy = 'test';
        sucr.isActive = true;
        sucr.subscriptionChangeToConfiguration = 1;
        sucr.subscriptionChangeToName = 'test';
        sucr.availableRenewalTerm = artList;
    }
    
    static testMethod void testCalculateProratedAmountForSubscriptionBean(){
        IADContractBeans_Ltng.CurrentSubscriptionSummaryBean cssb = new IADContractBeans_Ltng.CurrentSubscriptionSummaryBean();
        cssb.subscriptionId = 1234;
        cssb.newEndDate = system.now();
        cssb.serviceTermRemainingStartDate = system.now();
        cssb.serviceTermRemainingEndDate = system.now();
        
        IADContractBeans_Ltng.ChangeSubscriptionSummaryBean cssb1 = new IADContractBeans_Ltng.ChangeSubscriptionSummaryBean();
        cssb1.productConfigurationId = 1231243;
        cssb1.purchasePrice = 112.1;
        cssb1.availableStoredCredit = 112.1;
        cssb1.remainingStoredCredit = 112.1;
        cssb1.proratedFee = 112.1;
        cssb1.balanceDue = 112.1;
        cssb1.serviceStartDate = system.now();
        cssb1.renewalDate = system.now();
        
        IADContractBeans_Ltng.CalculateProratedAmountForSubscriptionBean cpafs = new IADContractBeans_Ltng.CalculateProratedAmountForSubscriptionBean();
        cpafs.orderId = 123455;
        cpafs.orderItemId = 12314;
        cpafs.orderSubscriptionInfoId = 123413;
        cpafs.currentSubscriptionSummary = cssb;  
        cpafs.changeSubscriptionSummary = cssb1;  
    }
    
    static testMethod void testIADStoreCreditToManualCheckBean()
    {        
        IADContractBeans_ltng.IADStoreCreditToManualCheckBean refund = new IADContractBeans_ltng.IADStoreCreditToManualCheckBean();
        refund.storeCreditId = 123;
        refund.customerId = 123;
        refund.amount = 10.00;
        refund.comments = 'test';
        refund.manualCheckReasonId = 123;
        refund.firstName = 'firstname';
        refund.lastName = 'lastname';
        refund.address = 'address';
        refund.city = 'city';
        refund.state = 0;
        refund.zipcode = 'zipcode';
        refund.notificationEmail = 'email@email.com';
        refund.checkNumber = '';
        refund.depositDate = system.now();
        refund.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
        refund.approvedBy = 'string';
    }
    
    static testmethod void testIADrelatedorders()
    {
        IADContractBeans_ltng.IADrelatedorders related =  new IADContractBeans_ltng.IADRelatedOrders();
        related.ordergroupid=0;
        related.customerId=123;
        related.orderSource='legalzoom';
        related.createdBy='test';
        related.dateCreated='2016-05-05T19:36:32.816Z';
        related.lastModifiedBy='test';
    }
    
	static testMethod void testIADStoreCreditV2()
    {
        IADContractBeans_Ltng.IADStoreCreditV2Bean iscv2b = new IADContractBeans_Ltng.IADStoreCreditV2Bean();
        iscv2b.storeCreditId = 123;
        iscv2b.remainingAmount = 10.00;
        iscv2b.customerId = 12345;
        iscv2b.code = 'test';
        iscv2b.status =  'testing';
        iscv2b.storeCreditStatus = 2;
        iscv2b.adjDateCreated = ''+system.now();
        iscv2b.adjExpirationDate = ''+system.now();
        iscv2b.expriationDate = ''+system.now();
        iscv2b.createdBy = ''+system.now();
        iscv2b.dateCreated = ''+system.now();
        iscv2b.paymentTransactionId = 5;
        iscv2b.refundableFlag = false;
        iscv2b.amount = 12.67;
        
        IADContractBeans_Ltng.IADStoreCreditOrderTransactionDetails iscotd = new IADContractBeans_Ltng.IADStoreCreditOrderTransactionDetails();
        iscotd.storeCreditCode = 'test';
        iscotd.isRefundable = false;
        iscotd.expiredDate = ''+system.now();
        iscotd.orderId = 12345;
        iscotd.amount = 34.50;
        iscotd.createdBy = ''+system.now();
        iscotd.createdDate = ''+system.now();
        iscotd.transactionId = 2;
        iscotd.transactionStatusId = 2;
        iscotd.transactionTypeId = 1;
        iscotd.refundManualCheckId = 2;
        iscotd.refundTransactionStatusId = 5;
        iscotd.isCancelled = false;
        iscotd.statusDescription = 'test';
        iscotd.emailNotifyTo = 'test@test.com';
    }    
}