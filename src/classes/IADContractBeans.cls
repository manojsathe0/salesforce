public class IADContractBeans
{


    public class IADPaymentBeanWrapper
    {
        public List<IADPaymentBean> payments{get;set;}
    }
    
    public class IADRefundBeanWrapper
    {
        public IADPaymentBean refundDetails{get;set;}
    }

    public class IADPaymentBean
    {
        public String id {get;set;}
        public String paymentTransactionId{get;set;}
        public string orderId{get; set;}
        public Integer transactionType{get; set;}
        public string paymentType{get; set;}
        public Decimal amount{get; set;}
        public string currencyCode{get; set;}
        public string creationDate{get; set;}
        public string creatorId{get; set;}
        public Integer status{get; set;}
        public Integer transactionStatus{get;set;}
        public string statusDate{get; set;}
        public string parentId{get; set;}
        public string customerId{get; set;}
        public string comments{get; set;}
        public string reason{get; set;}
        public string paymentProfileId{get; set;}
        public string gateway{get; set;}
        public string canceled{get; set;}
        public string cancelationDate{get; set;}
        public string source{get; set;}
        public string manualCheckId{get; set;}
        public string receiptEmail{get; set;}
        public Datetime adjCreationDate{get;set;}
        public Datetime adjStatusDate{get;set;}
        public String createdDateTimeInString{get;set;}
        public String statusDateTimeInString{get;set;}
        public String iadStatus{get;set;}

    }

    public class IADOrderPromoCodeBean
    {
        public String orderId {get;set;}
        public List<IADOrderPromoCode> orderPromoCodes{get;set;}
    }
    public class IADOrderPromoCode
    {
        public String code{get;set;}
        public Decimal amount{get;set;}
        public Boolean isCancelled{get;set;}
    }
    public class IADMakePaymentBean
    {
        public string orderId{get; set;}
        public string amount{get; set;}
        public string createdBy{get;set;}
        public string paymentProfileId{get; set;}
        public string gateway{get; set;}
        public string source{get; set;}
        public string comments{get;set;}
        public string reasonId{get;set;}
        public string notificationEmail{get;set;}

    }
    public class IADMakePaymentInstallmentBean
    {
        public string orderId{get; set;}
        public string amount{get; set;}
        public string createdBy{get;set;}
        public string paymentProfileId{get; set;}
        public string gateway{get; set;}
        public string source{get; set;}
        public string comments{get;set;}
        public string reasonId{get;set;}
        public string notificationEmail{get;set;}
        public string installmentBill{get;set;}

    }
    public class IADPaymentProfiles
    {
        public List<IADPaymentProfileBean> paymentProfiles{get;set;}
    }
    public class IADPaymentProfileBean
    {
        
        public String profileId {get;Set;}
        public string customerId{get; set;}
        public string gateway{get; set;}
        public string firstName{get; set;}
        public string lastName{get; set;}
        public string paymentType{get; set;}
        public string accountType{get; set;}
        public string addressLine1{get; set;}
        public string addressLine2{get; set;}
        public string city{get; set;}
        public string state{get; set;}
        public string zip{get; set;}
        public string phone{get; set;}
        public string firstDigit{get; set;}
        public string last4Digits{get; set;}
        public string month{get; set;}
        public string year{get; set;}
        public string token{get; set;}
        public Boolean isActive{get; set;}
        public string isRecurring{get; set;}
        public string bankName{get; set;}
        public string routingNumber{get; set;}
        public string checkNumber{get; set;}
        public string dateCreated{get; set;}
        public Datetime adjCreationDate{get;set;}
        public Boolean isExpired{get;set;}
        public void setIsExpiredFlag()
        {
            
            isExpired = false;
            Date today = Date.today();
            Integer currentMonth = today.month();
            Integer currentYear = today.year();
            if(currentYear > Integer.valueOf(this.year))
            {
                isExpired = true;             
            }
            else if(currentYear == Integer.valueOf(this.year))
            {
                if(currentMonth > Integer.valueOf(this.month))
                {
                    isExpired = true;
                }
            }
           
        }
    }
    public class IADPaymentUpdateProfileBean
    {
        public IADPaymentProfileUpdate updatePaymentProfile{get;set;}
    }
    public class IADPaymentProfileUpdate
    {
        public string firstName{get; set;}
        public string lastName{get; set;}
        public Integer customerId {get;set;}
        public string paymentType{get; set;}
        public string accountType{get; set;}
        public string addressLine1{get; set;}
        public string addressLine2{get; set;}
        public string city{get; set;}
        public string state{get; set;}
        public string zip{get; set;}
        public string phone{get; set;}
        public string month{get; set;}
        public string year{get; set;}
    }

    public class IADInstallmentsWrapper
    {
        public List<IADInstallmentBean> installments{get;set;}
    }

    public class IADInstallmentWrapper
    {
        public IADInstallmentBean installment{get;set;}
    }

    public class IADInstallmentBean
    {
        public String installmentId {get;set;}
        public String orderId {get;set;}
        public String dueDate {get;set;}
        public String paid {get;set;}
        public String paymentDate {get;set;}
        public String canceled {get;set;}
        public String cancelationDate {get;set;}
        public String totalDueAmount {get;set;}
        public String balanceDueAmount {get;set;}
        public Integer installmentBillStatus {get;set;}
        public String status {get;set;}
        public String paymentProfileId {get;set;}
        public String dateCreated {get;set;}
        public String creatorId {get;set;}
        public Datetime adjPaymentDate {get;set;}
        public Datetime adjCreationDate {get;set;}
        public Datetime adjDueDate {get;set;}
        public Boolean isActiveProfile{get;set;}
        public String adjPaymentDateInString {get;set;}
        public String adjCreationDateInString {get;set;}
        public String adjDueDateInString {get;set;}
        public Boolean hasPaymentProfileExpired{get;set;}
    }
    public class IADInstallmentUpdateBean
    {
        public String dueDate {get;set;}
        public String updatedBy{get;set;}
        public Integer paymentProfileId{get;set;}
    }
    public class IADContactUpdateBean
    {
        public IADContactUpdate contact {get;set;}
    }
    public class IADContactUpdate
    {
        public String description {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String addressLine1 {get;set;}
        public String addressLine2 {get;set;}
        public String city {get;set;}
        public String stateId {get;set;}
        public String county {get;set;}
        public String zipcode {get;set;}
        public String email1 {get;set;}
        public String email2 {get;set;}
        public String email3 {get;set;}
        public String homePhone {get;set;}
        public String workPhone {get;set;}
        public String cellPhone {get;set;}
        public String fax {get;set;}
        public String country {get;set;}
        public String state {get;set;}
        public String taxID {get;set;}
        public String active {get;set;}
        public String statusChanged {get;set;}
        public String statusChangedBy {get;set;}
        public String crmContactId {get;set;}
        public String contactInfoType {get;set;}
        public String updateSource {get;set;}

        public IADContactUpdateResponseBean responseBean{get;set;}
    }
    public class IADContactCreateBean
    {
        public IADContactCreate status{get;set;}
    }
    public class IADContactCreate
    {
        public String existingContact{get;set;}
        public String contactCreated{get;set;}
        public String contactUpdated{get;set;}
        public String contactInfoId{get;set;}
        public String message{get;set;}
    }
    public class IADContactUpdateResponseBean
    {
        public IADContactUpdateResponseStatusBean status{get;set;}
    }
    public class IADContactUpdateResponseStatusBean
    {
        public String existingContact{get;set;}
        public String contactCreated{get;set;}
        public String contactUpdated{get;set;}
        public String contactInfoId{get;set;}
        public String message{get;set;}
    }

    public class IADSecurityQuestionBean
    {
        public IADSecurityQuestion securityQuestion {get;set;}
    }
    public class IADSecurityQuestion
    {
        public String question {get;set;}
        public String answer {get;set;}
    }

    public class IADRequestPasswordBean
    {
        public IADRequestPasswordresponseBean requestPasswordMessage{get;set;}
    }

    public class IADRequestPasswordresponseBean
    {
        public String status{get;set;}
        public String message{get;set;}
    }

    public class IADRequestPasswordRequestBean
    {
        public requestpassword requestpassword{get;set;}
    }

    public class requestpassword
    {
        public String email{get;set;}
    }

    public class IADNewPaymentProfileRequestBean
    {
        public IADNewPaymentProfileRequest paymentProfile{get;set;}
    }
    public class IADNewPaymentProfileRequest
    {
        public String customerId{get;set;}
        public String gateway{get;set;} //litle
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String paymentType{get;set;}
        public String accountType{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zip{get;set;}
        public String phone{get;set;}
        public String firstDigit{get;set;}
        public String last4Digits{get;set;}
        public Integer month{get;set;}
        public Integer year{get;set;}
        public String token{get;set;}
        public Boolean isActive{get;set;}
        public Boolean isRecurring{get;set;}
        public String accountNumber{get;set;}
    }


    public class IADNewPaymentProfileResponseBean
    {
        public String id{get;set;}
        public String userId{get;set;}
        public String gateWay{get;set;} //litle
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String paymentType{get;set;}
        public String accountType{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zip{get;set;}
        public String phone{get;set;}
        public String firstDigit{get;set;}
        public String last4Digits{get;set;}
        public Integer month{get;set;}
        public Integer year{get;set;}
        public String cardNumber{get;set;}
        public String token{get;set;}
        public Boolean isActive{get;set;}
        public Boolean isRecurring{get;set;}
        public String bankName{get;set;}
        public String routingNumber{get;set;}
        public String checkNumber{get;set;}
    }

    public class IADCustomerHistoryBean
    {
        public List<IADCustomerHistory> customerHistories{get;set;}
    }

    public class IADCustomerHistory implements Comparable
    {
        public Integer customerId{get;set;}
        public String description{get;set;}
        public String newValue{get;set;}
        public String oldValue{get;set;}
        public String tableName{get;set;}
        public String fieldName{get;set;}
        public String dateModified{get;set;}
        public String modifiedBy{get;set;}
        public String adjDateModified{get;set;}
        public Datetime adjDateModifiedDT{get;set;}
        public String mailTo{get;set;} 
        public String subject{get;set;}
        public String passwordResetUrl{get;set;}
        public String body{get;set;}

        public Integer compareTo(Object theCompareTo)
        {
            IADCustomerHistory compareTo = (IADCustomerHistory)theCompareTo;

            Integer returnValue = 0;
            if (adjDateModifiedDT < compareTo.adjDateModifiedDT)
            {
                returnValue = 1;
            }
            else if (adjDateModifiedDT > compareTo.adjDateModifiedDT)
            {
                returnValue = -1;
            }

            return returnValue;
        }
    }

    public class IncompleteOrdersBean
    {
        public List<IncompleteOrders> IncompleteOrders{get;set;}
    }

    public class IncompleteOrders{
        public Integer cartId{get;set;}
        public ProductConfiguration product{get;set;}
        public String dateCreated{get;set;}
        public String createdBy{get;set;}
        public String dateLastModified{get;set;}
        public String lastModifiedBy{get;set;}
    }

    public class IADMiscItem
    {
        public String description{get;set;}
        public Integer quantity{get;set;}
        public Decimal pricePerUnit{get;set;}
        public String createdBy{get;set;}
    }
    public class IADOrderBeanWrapper
    {
        public IADOrderBean Order{get;set;}
    }
    public class IADOrderBean
    {
        public String customerId{get;set;}
        public String orderGroupId{get;set;}
        public String orderId{get;set;}
        public String isRevision{get;set;}
        public List<IADOrderItem> orderItems{get;set;}
        public Boolean isCancelled{get;set;}
        public String paymentStatus{get;set;}
        public String dateCreated{get;set;}
        public Datetime dateCreatedDatetime{get;set;}
        public String createdBy{get;set;}
        public String dateLastModified{get;set;}
        public String lastModifiedBy{get;set;}
        public IADOrderFlags orderFlags{get;set;}
        public String productName{get;set;}
        public String paymentStatusName{get;set;}
    }

    public class IADOrderFlags
    {
        public Boolean isThreePay{get;set;}
        public Boolean isPhoneOrder{get;set;}
        public Boolean isSamsClub{get;set;}
        public Boolean isPrintingOptional{get;set;}
    }
    public class IADOrderHistoryBean
    {
        public List<IADOrderItemsHistoryBean> orderItemsHistory{get;set;}
    }
    public class IADOrderItemsHistoryBean
    {
        public String orderItemId {get;set;}
        public List<IADOrderItemsHistory> history{get;set;}
    }
    public class IADOrderItemsHistory
    {

        public String updatedBy{get;set;}
        public String description{get;set;}
        public String status{get;set;}
        public String additionalInfo{get;set;}
        public String createdDate{get;set;}
        public DateTime adjCreatedDate{get;set;}
        public String adjCreatedDateString{get;set;}
          
    }
    public class IADOrderItemAvailableProductsBean
    {
        public List<IADOrderItemAvailableProducts> products{get;set;}
    }
    public class IADOrderItemAvailableProducts
    {
        public String productConfigurationId{get;set;}
        public IADProductType productType {get;set;}
        public IADProductComponent productComponent{get;set;}
        public List<IADOrderItemAvailableProducts> childProducts{get;set;}
        public ProductConfigurationFlags productConfigurationFlags {get;set;}
    }
    public class IADProductType
    {
        public String productTypeId {get;set;}
        public String name{get;set;}
    }
    public class IADProductComponent
    {
        public String productComponentId {get;set;}
        public String name {get;set;}
        public String displayNameOnWeb {get;set;}
        public String displayNameOnBill {get;set;}
    }

    public class AvailableProductWrapper
    {
        public String productComponentId{get;set;}
        public String name;
    }

    public class IADOrderItem {
        public String orderItemId{get;set;}
        public String orderId{get;set;}
        public String parentOrderItemId{get;set;}
        public String basePrice{get;set;}
        public String extendedPrice{get;set;}
        public String quantity{get;set;}
        public ProductConfiguration productConfiguration{get;set;}
        public Boolean isCancelled{get;set;}
        public List<IADOrderItem> childOrderItems{get;set;}
        public ProcessingOrder processingOrder{get;set;}
        public String dateCreated{get;set;}
        public String createdBy{get;set;}
        public String dateLastModified{get;set;}
        public DateTime sfDateCreated{get;set;}
        public String dateTimeCreatedInString{get;set;}
        public String productName{get;set;}

    }

    public class IADOrderItemResponse {
        public String orderId{get;set;}
        public IADOrderItem orderItem{get;set;}
    }

    public class ProductConfiguration {
        public String productConfigurationId{get;set;}
        public String productTypeId{get;set;}
        public Boolean shouldDisplayOnBill{get;set;}
        public ProductComponent productComponent{get;set;}

    }
    public class ProductConfigurationFlags {
        public Boolean doNotShowInOrderManager{get;set;}

    }
    public class ProductComponent {
        public String productComponentId{get;set;}
        public ProductComponentFlags productComponentFlags{get;set;}
        public String name{get;set;}
        public String displayNameOnBill{get;set;}
        public String displayNameOnWeb{get;set;}
        public String description{get;set;}
        public String longDescription{get;set;}
        public String internalDescription{get;set;}
        public String helpText{get;set;}
        public Boolean isActive{get;set;}

    }

    public  class ProductComponentFlags {
        public Boolean allowCustomerToAdd{get;set;}
        public Boolean allowCustomizablePrice{get;set;}
        public Boolean allowExpediteOnPackage{get;set;}
        public Boolean allowStoreCredit{get;set;}
        public Boolean allowElectronicChecks{get;set;}
        public Boolean canSubscribe{get;set;}
        public Boolean canEditQuantity{get;set;}
        public Boolean autoRenewByDefault{get;set;}
        public Boolean mustAutoRenewToSubscribe{get;set;}
        public Boolean isService{get;set;}



    }



    public class ProcessingOrder {
        public String processingOrderId{get;set;}
        public String processId{get;set;}
        public String questionnaireId{get;set;}
        public String processingStatusId{get;set;}
        public String processingStatusCategoryId{get;set;}


    }


    public class IADOrderBalance
    {
        public String orderId{get;set;}
        public String customerId{get;set;}
        public Decimal subTotalCharges{get;set;}
        public String subTotalPayments{get;set;}
        public String subTotalRefunds{get;set;}
        public String subTotalDiscount{get;set;}
        public String subTotalInstallmentBalance{get;set;}
        public Decimal  grandTotal{get;set;}
        public Decimal  totalOrderAmount{get;set;}
        public Decimal  orderBalanceAmount{get;set;}
        public List<IADDiscountDetail> discountDetails{get;set;}

    }

    public class IADDiscountDetail implements Comparable
    {
        public String orderDiscountId{get;set;}
        public String createdBy{get;set;}
        public String code{get;set;}
        public String reason{get;set;}
        public Decimal amount{get;set;}
        public Boolean isCancelled{get;set;}
        public String comment{get;set;}
        public String dateEntered{get;set;}
        public IADDiscountType discountType{get;set;}
        public String adjDateEntered{get;set;}
        public Datetime adjDateEnteredDT{get;set;}

        public Integer compareTo(Object theCompareTo)
        {
            IADDiscountDetail compareTo = (IADDiscountDetail)theCompareTo;

            Integer returnValue = 0;
            if (adjDateEnteredDT < compareTo.adjDateEnteredDT)
            {
                returnValue = 1;
            }
            else if (adjDateEnteredDT > compareTo.adjDateEnteredDT)
            {
                returnValue = -1;
            }

            return returnValue;
        }

    }

    public class IADDiscountType
    {
        public Integer discountTypeId{get;set;}
        public String name{get;set;}
        public Boolean isActive{get;set;}
    }
    public class IADProcessRefundBean
    {
        public IADProcessRefund refundDetail{get;set;}
    }
    public class IADProcessRefund
    {
        public string orderId{get; set;}
        public string amount{get; set;}
        public string createdBy{get;set;}
        public string paymentProfileId{get; set;}
        public string comments{get;set;}
        public string reasonId{get;set;}
        public string customerId{get;set;}
        public string paymentTransactionId{get;set;}
        public string notificationEmail{get;set;}
        public string source{get;set;}
    }

    public class IADProcessRefundRequestBean
    {
        public Integer orderId{get;set;}
        public String refundType{get;set;}
        public Integer amount{get;set;}
        public String currencyCode{get;set;}
        public String creatorId{get;set;}
        public Integer parentId{get;set;}
        public String customerId{get;set;}
        public String comments{get;set;}
        public String reason{get;set;}
        public Integer email{get;set;}
        public String gateway{get;set;}
        public String source{get;set;}
        public IADRefund_address address{get;set;}
        public IADRefund_manualCheckDetails manualCheckDetails{get;set;}
    }

    public class IADRefund_address
    {
        public String firstName{get;set;}
        public Integer lastName{get;set;}
        public Integer addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zip{get;set;}
        public String country{get;set;}
        public String email{get;set;}
        public String phone{get;set;}
    }

    public class IADRefund_manualCheckDetails
    {
        public String bankName{get;set;}
        public String checkNumber{get;set;}
        public String depositDate{get;set;}
    }

    public class IADShippingAddressBean
    {
        public List<IADShippingContact> contacts{get;set;}
    }

    public class IADShippingContact
    {
        public Integer orderContactId{get;set;}
        public String contactType{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zipCode{get;set;}
        public string updatedBy {get;set;}
        public List<IADShippingContact_Email> emailAddresses{get;set;}
        public String homePhone {get;set;}
        public String workPhone {get;set;}
        public String mobilePhone {get;set;}
        public String faxPhone {get;set;}
        public String theEmail{get;set;}
    }

    public class IADOrderContact
    {
        public String contactType{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zipCode{get;set;}
        public string createdBy {get;set;}
        public List<IADShippingContact_Email> emailAddresses{get;set;}
        public String homePhone {get;set;}
        public String workPhone {get;set;}
        public String mobilePhone {get;set;}
        public String faxPhone {get;set;}
        public String theEmail{get;set;}
    }

    public class IADShippingContact_Email
    {
        public String emailAddress{get;set;}
    }

    public class IADSubscriptionBean
    {
        public List<IADSubscription> subscriptions{get;set;}
    }

    public class IADSingleSubscriptionBean
    {
        public IADSubscription subscription{get;set;}
    }

    public class IADSubscriptionRequestBean
    {
        public List<IADSubscriptionRequest> orderItems{get;set;}
    }

    public class IADSubscriptionRequest
    {
        public String orderItem{get;set;}
    }

    public class Errors
    {
        public String message{get;set;}
        public String code{get;set;}
        public List<FieldErrors> fieldErrors{get;set;}
    }

    public class ErrorResponse
    {
        public List<Errors> errors{get;set;}
    }
    public class FieldErrors
    {
        public String field{get;set;}
        public String type{get;set;}
        public String details{get;set;}
    }
    public class IADSubscription
    {
        public String orderItemSubscriptionId{get;set;}
        public String orderItemId{get;set;}
        public String orderId{get;set;}
        public String productName{get;set;}
        public String isActive{get;set;}
        public String status{get;set;}
        public String autoRenew{get;set;}
        public String additionalInfo{get;set;}
        public String processing{get;set;}
        public String createdDate{get;set;}
        public String adjCreatedDate{get;set;}
        public String subscriptionStartDate{get;set;}
        public String adjSubscriptionStartDate{get;set;}
        public String subscriptionEndDate{get;set;}
        public String adjSubscriptionEndDate{get;set;}
        public String relationshipType{get;set;}
        public String renewalTerm{get;set;}
        public Decimal renewalPrice{get;set;}
        public Boolean isActiveProfile{get;set;}
        public String userPaymentProfile{get;set;}
        public String paymentProfileId {get;set;}
        public Boolean isRA{get;set;}
        public List<IADSubscriptionInfoDetail> subscriptionInfoDetail{get;set;}
        public Boolean hasPaymentProfileExpired{get;set;}

    }
    public class IADSubscriptionInfoDetail
    {
        public String orderItemSubscriptionId{get;set;}
        public String orderItemId{get;set;}
        public String subscriptionOrderItem{get;set;}
        public String subscriptionStartDate{get;set;}
        public String adjSubscriptionStartDate{get;set;}

        public String subscriptionEndDate{get;set;}
        public String adjSubscriptionEndDate{get;set;}
        public String freeShippingStartDate{get;set;}
        public String freeShippingEndDate{get;set;}
        public String createdBy{get;set;}
        public String createdDate{get;set;}
        public String adjCreatedDate{get;set;}

        public String renewalAlertStartDate{get;set;}
        public String renewalAlertEnd{get;set;}
        public String isActive{get;set;}

    }

    public class IADUpdateSubscriptionBean
    {
        public IADUpdateSubscription orderItemSubscription{get;set;}
    }
    public class IADUpdateSubscription
    {
        public String subscriptionID{get;set;}
        public Integer autoRenewOptionId{get;set;}
        public String updatedBy{get;set;}
        public Integer userPaymentProfileId{get;set;}
    }
    public class IADUpdateSubscriptionResponse
    {
        public Boolean success{get;set;}
        public string message{get;set;}
        public Integer orderItemSubscriptionId {get;set;}
    }

    public class IADUpdateOrderSubscription
    {
        public Integer customerId{get;set;}
        public Integer orderItemId{get;set;}
        public Boolean isPartialRefund{get;set;}
        public Double refundAmount{get;set;}
        public String subscriptionEndDate{get;set;}
        public String updatedBy{get;set;}
        public String note{get;set;}
        public Integer actionType{get;set;}
    }

    public class OauthError
    {
        public String ErrorCode{get;set;}
        public String Error{get;set;}
    }

    public class FaultError
    {
        public APIFault fault{get;set;}
    }

    public class APIFault
    {
        public String faultString{get;set;}
    }

    public class OauthToken
    {
        public String issued_at{get;set;}
        public String expires_in{get;set;}
        public String access_token{get;set;}
    }

    public class IADCustomerBean
    {
        public List<IADthirdPartyUserInfoBean> thirdPartyUserInfo{get;set;}
        public IADSecurityQuestion securityQuestion{get;set;}
    }

    public class IADthirdPartyUserInfoBean
    {
        public String userId{get;set;}
        public String thirdPartyId{get;set;}
        public String thirdPartyTypeId{get;set;}
        public String createdBy{get;set;}

    }
    public class IADStoreCredit
    {
        public List<IADStoreCreditBean> storeCredits{get;set;}
    }
    public class IADStoreCreditBean
    {
        public String storeCreditId{get;set;}
        public String customerId{get;set;}
        public String code{get;set;}
        public String status{get;set;}
        public String storeCreditStatusId{get;set;}
        public String expriationDate{get;set;} //wrong spell in API label
        public String adjExpirationDate{get;set;}
        public Datetime adjExpirationDateDT{get;set;}
        public Decimal amount{get;set;}
        public String createdBy{get;set;}
        public String dateCreated{get;set;}
        public String adjDateCreated{get;set;}
        public Datetime adjDateCreatedDT{get;set;}

        public String paymentTransactionId{get;set;}
        public Boolean refundableFlag{get;set;}
    }

    public class IADStoreCreditById
    {
        public IADStoreCreditBean storeCredit{get;set;}
    }
    public class IADMakePaymentStoreCredit
    {
        public String storeCreditId{get;set;}
        public String storeCreditPaymentAmount{get;set;}
        public String orderId{get;set;}
        public String creatorId{get;set;}
        public String comments{get;set;}
    }
    public class IADMakePaymentStoreCreditResponse
    {
        public String storeCreditId{get;set;}
        public String storeCreditTransactionId{get;set;}
        public String amount{get;set;}
        public String storeCreditTransactionType{get;set;}
    }
    public class IADActionItemBean
    {
        public List<IADActionItem> actionItems{get;set;}
    }

    public class IADActionItem
    {
        public String orderId{get;set;}
        public String orderItemId{get;set;}
        public String actionItemsType{get;set;}
        public String productComponentId{get;set;}
        public String productConfigurationId{get;set;}
        public String productTypeId{get;set;}
        public String description{get;set;}
        public String productTypeName{get;set;}
    }

    public class IADProRatedRefundWrapper
    {
        public Map<String,String> proratedRefundData{get;set;}
    }
    
    public class IADOrderTerms
    {
        public String orderId{get;set;}
        public String orderTermStatus{get;set;}
        public String orderTermsText{get;set;}
        public String dateAccepted{get;set;}
        public String adjDateAccepted{get;set;}
    }

    public class IADPromoCode
    {
        public Boolean isValid{get;set;}
        public String promoCode{get;set;}
        public Decimal discountAmount{get;set;}
    }
    public class IADOrdersBean
    {
        public String customerId{get;set;}
        public List<IADOrderGroup> orderGroups{get;set;}
    }
    public class IADOrderGroup
    {
        public String orderGroupId{get;set;}
        public List<IADOrderBean> orders{get;set;}
    }
    public class IADStoreCreditRefundToCard
    {
        public String storeCreditId{get;set;}
        public Decimal amount{get;set;}
        public String customerId{get;set;}
        public String comments{get;set;}
        public String notificationEmail{get;set;}
        public String createdBy{get;set;}
    }
}