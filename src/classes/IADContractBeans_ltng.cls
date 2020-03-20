public class IADContractBeans_ltng
{
    
    
    public class IADPaymentBeanWrapper
    {
        @AuraEnabled public List<IADPaymentBean> payments{get;set;} 
    }
    
    public class IADRefundBeanWrapper
    {
        @AuraEnabled public IADPaymentBean refundDetails{get;set;}
    }
    
    public class IADChargeback
    {
       /* @AuraEnabled public String paymentTransactionId {get;set;}
        @AuraEnabled public Decimal amount{get; set;}
        @AuraEnabled public String comments{get; set;}
        @AuraEnabled public Integer reasonId{get; set;}
        */
    }
    
    public class IADChargebackBean
    {
       /* @AuraEnabled public String paymentTransactionId {get;set;}
        @AuraEnabled public String orderId{get; set;}
        @AuraEnabled public String transactionType{get; set;}
        @AuraEnabled public String paymentType{get; set;}
        @AuraEnabled public Decimal amount{get; set;}
        @AuraEnabled public String currencyCode{get; set;}
        @AuraEnabled public String creationDate{get; set;}
        @AuraEnabled public String createdBy{get; set;}
        @AuraEnabled public String transactionStatus{get;set;}
        @AuraEnabled public String statusDate{get; set;}
        @AuraEnabled public String parentId{get; set;}
        @AuraEnabled public String comments{get; set;}
        @AuraEnabled public String reason{get; set;}
        @AuraEnabled public Integer paymentProfileId{get; set;}
        @AuraEnabled public String gateway{get; set;}
        @AuraEnabled public String cancelled{get; set;}
        @AuraEnabled public String cancellationDate{get; set;}
        @AuraEnabled public String source{get; set;}
        @AuraEnabled public String manualCheckId{get; set;}
        @AuraEnabled public String receiptEmail{get; set;}
        */
    }
    
    public class IADPaymentBean
    {
        @AuraEnabled public String id {get;set;}
        @AuraEnabled public String paymentTransactionId{get;set;}
        @AuraEnabled public string orderId{get; set;}
        @AuraEnabled public Integer transactionType{get; set;}
        @AuraEnabled public string paymentType{get; set;}
        @AuraEnabled public Decimal amount{get; set;}
        @AuraEnabled public string currencyCode{get; set;}
        @AuraEnabled public string creationDate{get; set;}
        @AuraEnabled public string creatorId{get; set;}
        @AuraEnabled public Integer status{get; set;}
        @AuraEnabled public Integer transactionStatus{get;set;}
        @AuraEnabled public string statusDate{get; set;}
        @AuraEnabled public string parentId{get; set;}
        @AuraEnabled public string customerId{get; set;}
        @AuraEnabled public string comments{get; set;}
        @AuraEnabled public string reason{get; set;}
        @AuraEnabled public string reasonId{get;set;}
        @AuraEnabled public string paymentProfileId{get; set;}
        @AuraEnabled public string gateway{get; set;}
        @AuraEnabled public string canceled{get; set;}
        @AuraEnabled public string cancelationDate{get; set;}
        @AuraEnabled public string source{get; set;}
        @AuraEnabled public string manualCheckId{get; set;}
        @AuraEnabled public string receiptEmail{get; set;}
        @AuraEnabled public Datetime adjCreationDate{get;set;}
        @AuraEnabled public Datetime adjStatusDate{get;set;}
        @AuraEnabled public String createdDateTimeInString{get;set;}
        @AuraEnabled public String statusDateTimeInString{get;set;}
        @AuraEnabled public String iadStatus{get;set;}
        @AuraEnabled public String  createdBy{get;set;}
        /*STORY B-39088 */
        @AuraEnabled public MailingAddress mailingAddress{get;set;}
        /*STORY B-39088 */
    }
    /*STORY B-39088 */
    public class MailingAddress {
		@AuraEnabled public Integer userPaymentProfile;
		@AuraEnabled public Integer orderContactId;
		@AuraEnabled public String firstName;
		@AuraEnabled public String lastName;
		@AuraEnabled public String addressLine1;
		@AuraEnabled public String addressLine2;
		@AuraEnabled public String city;
		@AuraEnabled public Integer stateId;
		@AuraEnabled public String state;
		@AuraEnabled public String zipCode;
		@AuraEnabled public String country;
		@AuraEnabled public String county;
		@AuraEnabled public String emailAddress;
		@AuraEnabled public String homePhone;
		@AuraEnabled public String workPhone;
		@AuraEnabled public String mobilePhone;
		@AuraEnabled public String faxPhone;
	}
    /*STORY B-39088 */
    public class IADOrderPromoCodeBean
    {
        @AuraEnabled public String orderId {get;set;}
        @AuraEnabled public List<IADOrderPromoCode> orderPromoCodes{get;set;}
    }
    public class IADOrderPromoCode
    {
        @AuraEnabled public String code{get;set;}
        @AuraEnabled public Decimal amount{get;set;}
        @AuraEnabled public Boolean isCancelled{get;set;}
    }
    public class IADMakePaymentBean
    {
        @AuraEnabled public string orderId{get; set;}
        @AuraEnabled public string amount{get; set;}
        @AuraEnabled public string createdBy{get;set;}
        @AuraEnabled public string paymentProfileId{get; set;}
        @AuraEnabled public string gateway{get; set;}
        @AuraEnabled public string source{get; set;}
        @AuraEnabled public string comments{get;set;}
        @AuraEnabled public string reasonId{get;set;}
        @AuraEnabled public string notificationEmail{get;set;}
        
    }
    public class IADMakePaymentInstallmentBean
    {
        @AuraEnabled public string orderId{get; set;}
        @AuraEnabled public string amount{get; set;}
        @AuraEnabled public string createdBy{get;set;}
        @AuraEnabled public string paymentProfileId{get; set;}
        @AuraEnabled public string gateway{get; set;}
        @AuraEnabled public string source{get; set;}
        @AuraEnabled public string comments{get;set;}
        @AuraEnabled public string reasonId{get;set;}
        @AuraEnabled public string notificationEmail{get;set;}
        @AuraEnabled public string installmentBill{get;set;}
        
    }
    public class IADPaymentProfiles
    {
        @AuraEnabled public List<IADPaymentProfileBean> paymentProfiles{get;set;}
    }
    public class IADPaymentProfileBean
    {
        
        @AuraEnabled public String profileId {get;Set;}
        @AuraEnabled public string customerId{get; set;}
        @AuraEnabled public string gateway{get; set;}
        @AuraEnabled public string firstName{get; set;}
        @AuraEnabled public string lastName{get; set;}
        @AuraEnabled public string paymentType{get; set;}
        @AuraEnabled public string accountType{get; set;}
        @AuraEnabled public string addressLine1{get; set;}
        @AuraEnabled public string addressLine2{get; set;}
        @AuraEnabled public string city{get; set;}
        @AuraEnabled public string state{get; set;}
        @AuraEnabled public string zip{get; set;}
        @AuraEnabled public string phone{get; set;}
        @AuraEnabled public string firstDigit{get; set;}
        @AuraEnabled public string last4Digits{get; set;}
        @AuraEnabled public string month{get; set;}
        @AuraEnabled public string year{get; set;}
        @AuraEnabled public string token{get; set;}
        @AuraEnabled public Boolean isActive{get; set;}
        @AuraEnabled public string isRecurring{get; set;}
        @AuraEnabled public string bankName{get; set;}
        @AuraEnabled public string routingNumber{get; set;}
        @AuraEnabled public string checkNumber{get; set;}
        @AuraEnabled public string dateCreated{get; set;}
        @AuraEnabled public Datetime adjCreationDate{get;set;}
        @AuraEnabled public Boolean isExpired{get;set;}
        
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
        @AuraEnabled public IADPaymentProfileUpdate updatePaymentProfile{get;set;}
    }
    public class IADPaymentProfileUpdate
    {
        @AuraEnabled public string firstName{get; set;}
        @AuraEnabled public string lastName{get; set;}
        @AuraEnabled  public Integer customerId {get;set;}
        @AuraEnabled public string paymentType{get; set;}
        @AuraEnabled public string accountType{get; set;}
        @AuraEnabled public string addressLine1{get; set;}
        @AuraEnabled public string addressLine2{get; set;}
        @AuraEnabled public string city{get; set;}
        @AuraEnabled public string state{get; set;}
        @AuraEnabled public string zip{get; set;}
        @AuraEnabled public string phone{get; set;}
        @AuraEnabled public string month{get; set;}
        @AuraEnabled public string year{get; set;}
        @Auraenabled public boolean isActive{get;set;}
    }
    
    public class IADInstallmentsWrapper
    {
        @AuraEnabled public List<IADInstallmentBean> installments{get;set;}
    }
    
    public class IADInstallmentWrapper
    {
        @AuraEnabled public IADInstallmentBean installment{get;set;}
    }
    
    public class IADInstallmentBean
    {
        @AuraEnabled public String installmentId {get;set;}
        @AuraEnabled public String orderId {get;set;}
        @AuraEnabled public String dueDate {get;set;}
        @AuraEnabled public String paid {get;set;}
        @AuraEnabled public String paymentDate {get;set;}
        @AuraEnabled public String canceled {get;set;}
        @AuraEnabled public String cancelationDate {get;set;}
        @AuraEnabled public String totalDueAmount {get;set;}
        @AuraEnabled public String balanceDueAmount {get;set;}
        @AuraEnabled public Integer installmentBillStatus {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String paymentProfileId {get;set;}
        @AuraEnabled public String dateCreated {get;set;}
        @AuraEnabled public String creatorId {get;set;}
        @AuraEnabled public Datetime adjPaymentDate {get;set;}
        @AuraEnabled public Datetime adjCreationDate {get;set;}
        @AuraEnabled public Datetime adjDueDate {get;set;}
        @AuraEnabled public Boolean isActiveProfile{get;set;}
        @AuraEnabled public String adjPaymentDateInString {get;set;}
        @AuraEnabled public String adjCreationDateInString {get;set;}
        @AuraEnabled public String adjDueDateInString {get;set;}
        @AuraEnabled public Boolean hasPaymentProfileExpired{get;set;}
    }
    public class IADInstallmentUpdateBean
    {
        @AuraEnabled public String dueDate {get;set;}
        @AuraEnabled public String updatedBy{get;set;}
        @AuraEnabled public Integer paymentProfileId{get;set;}
    }
    public class IADContactUpdateBean
    {
        @AuraEnabled public IADContactUpdate contact {get;set;}
    }
    public class IADContactUpdate
    {
        @AuraEnabled public String description {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String addressLine1 {get;set;}
        @AuraEnabled public String addressLine2 {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String stateId {get;set;}
        @AuraEnabled public String county {get;set;}
        @AuraEnabled public String zipcode {get;set;}
        @AuraEnabled public String email1 {get;set;}
        @AuraEnabled public String email2 {get;set;}
        @AuraEnabled public String email3 {get;set;}
        @AuraEnabled public String homePhone {get;set;}
        @AuraEnabled public String workPhone {get;set;}
        @AuraEnabled public String cellPhone {get;set;}
        @AuraEnabled public String fax {get;set;}
        @AuraEnabled public String country {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String taxID {get;set;}
        @AuraEnabled public String active {get;set;}
        @AuraEnabled public String statusChanged {get;set;}
        @AuraEnabled public String statusChangedBy {get;set;}
        @AuraEnabled public String crmContactId {get;set;}
        @AuraEnabled public String contactInfoType {get;set;}
        @AuraEnabled public String updateSource {get;set;}
        
        @AuraEnabled public IADContactUpdateResponseBean responseBean{get;set;}
    }
    public class IADContactCreateBean
    {
        @AuraEnabled public IADContactCreate status{get;set;}
    }
    public class IADContactCreate
    {
        @AuraEnabled public String existingContact{get;set;}
        @AuraEnabled public String contactCreated{get;set;}
        @AuraEnabled public String contactUpdated{get;set;}
        @AuraEnabled public String contactInfoId{get;set;}
        @AuraEnabled public String message{get;set;}
    }
    public class IADContactUpdateResponseBean
    {
        @AuraEnabled public IADContactUpdateResponseStatusBean status{get;set;}
    }
    public class IADContactUpdateResponseStatusBean
    {
        @AuraEnabled public String existingContact{get;set;}
        @AuraEnabled public String contactCreated{get;set;}
        @AuraEnabled public String contactUpdated{get;set;}
        @AuraEnabled public String contactInfoId{get;set;}
        @AuraEnabled public String message{get;set;}
    }
    
    public class IADSecurityQuestionBean
    {
        @AuraEnabled public IADSecurityQuestion securityQuestion {get;set;}
    }
    public class IADSecurityQuestion
    {
        @AuraEnabled public String question {get;set;}
        @AuraEnabled public String answer {get;set;}
    }
    
    public class IADRequestPasswordBean
    {
        @AuraEnabled public IADRequestPasswordresponseBean requestPasswordMessage{get;set;}
    }
    
    public class IADRequestPasswordresponseBean
    {
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String message{get;set;}
    }
    
    public class IADRequestPasswordRequestBean
    {
        @AuraEnabled public requestpassword requestpassword{get;set;}
    }
    
    public class requestpassword
    {
        @AuraEnabled public String email{get;set;}
        @AuraEnabled public String ordertype{get;set;}
    }
    
    public class IADNewPaymentProfileRequestBean
    {
        @AuraEnabled public IADNewPaymentProfileRequest paymentProfile{get;set;}
    }
    public class IADNewPaymentProfileRequest
    {
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String gateway{get;set;} //litle
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String paymentType{get;set;}
        @AuraEnabled public String accountType{get;set;}
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String zip{get;set;}
        @AuraEnabled public String phone{get;set;}
        @AuraEnabled public String firstDigit{get;set;}
        @AuraEnabled public String last4Digits{get;set;}
        @AuraEnabled public Integer month{get;set;}
        @AuraEnabled public Integer year{get;set;}
        @AuraEnabled public String token{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
        @AuraEnabled public Boolean isRecurring{get;set;}
        @AuraEnabled public String accountNumber{get;set;}
    }
    
    
    public class IADNewPaymentProfileResponseBean
    {
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String userId{get;set;}
        @AuraEnabled public String gateWay{get;set;} //litle
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String paymentType{get;set;}
        @AuraEnabled public String accountType{get;set;}
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String zip{get;set;}
        @AuraEnabled public String phone{get;set;}
        @AuraEnabled public String firstDigit{get;set;}
        @AuraEnabled public String last4Digits{get;set;}
        @AuraEnabled public Integer month{get;set;}
        @AuraEnabled public Integer year{get;set;}
        @AuraEnabled public String cardNumber{get;set;}
        @AuraEnabled public String token{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
        @AuraEnabled public Boolean isRecurring{get;set;}
        @AuraEnabled public String bankName{get;set;}
        @AuraEnabled public String routingNumber{get;set;}
        @AuraEnabled public String checkNumber{get;set;}
    }
    
    public class IADCustomerHistoryBean
    {
        @AuraEnabled public List<IADCustomerHistory> customerHistories{get;set;}
    }
    
    public class IADCustomerHistory implements Comparable
    {
        @AuraEnabled public Integer customerId{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String newValue{get;set;}
        @AuraEnabled public String oldValue{get;set;}
        @AuraEnabled public String tableName{get;set;}
        @AuraEnabled public String fieldName{get;set;}
        @AuraEnabled public String dateModified{get;set;}
        @AuraEnabled public String modifiedBy{get;set;}
        @AuraEnabled public String adjDateModified{get;set;}
        @AuraEnabled public Datetime adjDateModifiedDT{get;set;}
        @AuraEnabled public String passwordResetUrl{get;set;}
        
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
        @AuraEnabled public List<IncompleteOrders> IncompleteOrders{get;set;}
    }
    
    public class IncompleteOrders{
        @AuraEnabled public Integer cartId{get;set;}
        @AuraEnabled public ProductConfiguration product{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateLastModified{get;set;}
        @AuraEnabled public String lastModifiedBy{get;set;}
    }
    
    public class IADMiscItem
    {
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public Integer quantity{get;set;}
        @AuraEnabled public Decimal pricePerUnit{get;set;}
        @AuraEnabled public String createdBy{get;set;}
    }
    public class IADOrderBeanWrapper
    {
        @AuraEnabled public IADOrderBean Order{get;set;}
    }
    public class IADOrderBean
    {
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String orderGroupId{get;set;}
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String isRevision{get;set;}
        @AuraEnabled public List<IADOrderItem> orderItems{get;set;}
        @AuraEnabled public Boolean isCancelled{get;set;}
        @AuraEnabled public String paymentStatus{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public Datetime dateCreatedDatetime{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateLastModified{get;set;}
        @AuraEnabled public String lastModifiedBy{get;set;}
        @AuraEnabled public IADOrderFlags orderFlags{get;set;}
        @AuraEnabled public String productName{get;set;}
        @AuraEnabled public String paymentStatusName{get;set;}
    }
    
    public class IADOrderFlags
    {
        @AuraEnabled public Boolean isThreePay{get;set;}
        @AuraEnabled public Boolean isPhoneOrder{get;set;}
        @AuraEnabled public Boolean isSamsClub{get;set;}
        @AuraEnabled public Boolean isPrintingOptional{get;set;}
    }
    public class IADOrderHistoryBean
    {
        @AuraEnabled public List<IADOrderItemsHistoryBean> orderItemsHistory{get;set;}
    }
    public class IADOrderItemsHistoryBean
    {
        @AuraEnabled public String orderItemId {get;set;}
        @AuraEnabled public List<IADOrderItemsHistory> history{get;set;}
    }
    public class IADOrderItemsHistory
    {
        
        @AuraEnabled public String updatedBy{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String additionalInfo{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public DateTime adjCreatedDate{get;set;}
        @AuraEnabled public String adjCreatedDateString{get;set;}
        
    }
    
    public class IADOrderItemsHistoryWithUIComponents
    {
        
        @AuraEnabled public String updatedBy{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String additionalInfo{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public DateTime adjCreatedDate{get;set;}
        @AuraEnabled public String adjCreatedDateString{get;set;}
        @AuraEnabled public Integer rowNumber{get;set;} //required to control the display
        
    }
    
    public class IADOrderItemAvailableProductsBean
    {
        @AuraEnabled public List<IADOrderItemAvailableProducts> products{get;set;}
    }
    public class IADOrderItemAvailableProducts
    {
        @AuraEnabled public String productConfigurationId{get;set;}
        @AuraEnabled public IADProductType productType {get;set;}
        @AuraEnabled public IADProductComponent productComponent{get;set;}
        @AuraEnabled public List<IADOrderItemAvailableProducts> childProducts{get;set;}
        @AuraEnabled public ProductConfigurationFlags productConfigurationFlags {get;set;}
    }
    public class IADProductType
    {
        @AuraEnabled public String productTypeId {get;set;}
        @AuraEnabled public String name{get;set;}
    }
    public class IADProductComponent
    {
        @AuraEnabled public String productComponentId {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String displayNameOnWeb {get;set;}
        @AuraEnabled public String displayNameOnBill {get;set;}
    }
    
    public class AvailableProductWrapper
    {
        @AuraEnabled public String productComponentId{get;set;}
        @AuraEnabled public String name;
    }
    
    public class IADOrderItem {
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String parentOrderItemId{get;set;}
        @AuraEnabled public String basePrice{get;set;}
        @AuraEnabled public String extendedPrice{get;set;}
        @AuraEnabled public String quantity{get;set;}
        @AuraEnabled public ProductConfiguration productConfiguration{get;set;}
        @AuraEnabled public Boolean isCancelled{get;set;}
        @AuraEnabled public List<IADOrderItem> childOrderItems{get;set;}
        @AuraEnabled public ProcessingOrder processingOrder{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateLastModified{get;set;}
        @AuraEnabled public DateTime sfDateCreated{get;set;}
        @AuraEnabled public String dateTimeCreatedInString{get;set;}
        @AuraEnabled public String productName{get;set;}
        //@AuraEnabled public Boolean isShipped{get;set;} 
    }
    
    public class IADOrderItemResponse {
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public IADOrderItem orderItem{get;set;}
    }
    
    public class ProductConfiguration {
        @AuraEnabled public String productConfigurationId{get;set;}
        @AuraEnabled public String productTypeId{get;set;}
        @AuraEnabled public Boolean shouldDisplayOnBill{get;set;}
        @AuraEnabled public ProductComponent productComponent{get;set;}
        @AuraEnabled public String displayNameOnBill{get;set;}
    }
    
    public class ProductConfigurationFlags {
        @AuraEnabled public Boolean doNotShowInOrderManager{get;set;}
    }
    
    public class ProductComponent {
        @AuraEnabled public String productComponentId{get;set;}
        @AuraEnabled public ProductComponentFlags productComponentFlags{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String displayNameOnBill{get;set;}
        @AuraEnabled public String displayNameOnWeb{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String longDescription{get;set;}
        @AuraEnabled public String internalDescription{get;set;}
        @AuraEnabled public String helpText{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
        
    }
    
    public  class ProductComponentFlags {
        @AuraEnabled public Boolean allowCustomerToAdd{get;set;}
        @AuraEnabled public Boolean allowCustomizablePrice{get;set;}
        @AuraEnabled public Boolean allowExpediteOnPackage{get;set;}
        @AuraEnabled public Boolean allowStoreCredit{get;set;}
        @AuraEnabled public Boolean allowElectronicChecks{get;set;}
        @AuraEnabled public Boolean canSubscribe{get;set;}
        @AuraEnabled public Boolean canEditQuantity{get;set;}
        @AuraEnabled public Boolean autoRenewByDefault{get;set;}
        @AuraEnabled public Boolean mustAutoRenewToSubscribe{get;set;}
        @AuraEnabled public Boolean isService{get;set;}
    }
    
    public class ProcessingOrder {
        @AuraEnabled public String processingOrderId{get;set;}
        @AuraEnabled public String processId{get;set;}
        @AuraEnabled public String questionnaireId{get;set;}
        @AuraEnabled public String processingStatusId{get;set;}
        @AuraEnabled public String processingStatusCategoryId{get;set;}
    }
    
    public class IADOrderTagBean{
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public List<IADOrderTags> orderTags{get;set;}
    }
    
    public class IADCreateTag{
        @AuraEnabled public IADOrderTags orderTag{get;set;}
    }
    
    public class IADDeleteTag{
        @AuraEnabled public IADOrderTags tag{get;set;}
    }
    
    public class IADOrderTags{
        @AuraEnabled public String tagId{get;set;}
        @AuraEnabled public String tagType{get;set;}
        @AuraEnabled public String tag{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateUpdated{get;set;}
        @AuraEnabled public String updatedBy{get;set;}
    }
    
    public class IADCustomerTagBean{
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public List<IADCustomerTags> customerTags{get;set;}
    }
    
    public class IADCustomerTags{
        @AuraEnabled public String tagId{get;set;}
        @AuraEnabled public String tagType{get;set;}
        @AuraEnabled public String tag{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateUpdated{get;set;}
        @AuraEnabled public String updatedBy{get;set;}
    }
    
    public class IADShipmentBean{
        @AuraEnabled public String OrderId{get;set;}
        @AuraEnabled public List<IADShipments> shipments{get;set;}
    }
    
    public class IADShipments{
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String shipmentId{get;set;}
        @AuraEnabled public String trackingCode{get;set;}
        @AuraEnabled public String shippedDate{get;set;}
        @AuraEnabled public String isReceiptConfirmed{get;set;}
        @AuraEnabled public String receivedDate{get;set;}
        @AuraEnabled public IADShippingType shippingType{get;set;}
        @AuraEnabled public IADShippingMethod shippingMethod{get;set;}
        @AuraEnabled public String shipmentStatus{get;set;}
        @AuraEnabled public String vendorName{get;set;}
    }
    
    public class IADShippingType{
        @AuraEnabled public String shippingTypeId{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String isActive{get;set;}
    }
    
    public class IADShippingMethod{
        @AuraEnabled public String shipMethodId{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String isActive{get;set;}
    }
    
    public class IADOrderBalance
    {
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public Decimal subTotalCharges{get;set;}
        @AuraEnabled public String subTotalPayments{get;set;}
        @AuraEnabled public String subTotalRefunds{get;set;}
        @AuraEnabled public String subTotalDiscount{get;set;}
        @AuraEnabled public String subTotalInstallmentBalance{get;set;}
        @AuraEnabled public Decimal  grandTotal{get;set;}
        @AuraEnabled public Decimal  totalOrderAmount{get;set;}
        @AuraEnabled public Decimal  orderBalanceAmount{get;set;}
        @AuraEnabled public List<IADDiscountDetail> discountDetails{get;set;}
        
    }
    
    public class IADDiscountDetail implements Comparable
    {
        @AuraEnabled public String orderDiscountId{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String code{get;set;}
        @AuraEnabled public String reason{get;set;}
        @AuraEnabled public Decimal amount{get;set;}
        @AuraEnabled public Boolean isCancelled{get;set;}
        @AuraEnabled public String comment{get;set;}
        @AuraEnabled public String dateEntered{get;set;}
        @AuraEnabled public IADDiscountType discountType{get;set;}
        @AuraEnabled public String adjDateEntered{get;set;}
        @AuraEnabled public Datetime adjDateEnteredDT{get;set;}
        
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
        @AuraEnabled public Integer discountTypeId{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
    }
    public class IADProcessRefundBean
    {
        @AuraEnabled public IADProcessRefund refundDetail{get;set;}
    }
    
    public class IADProcessRefund
    {
        @AuraEnabled public string orderId{get; set;}
        @AuraEnabled public string amount{get; set;}
        @AuraEnabled public string createdBy{get;set;}
        @AuraEnabled public string paymentProfileId{get; set;}
        @AuraEnabled public string comments{get;set;}
        @AuraEnabled public string reasonId{get;set;}
        @AuraEnabled public string customerId{get;set;}
        @AuraEnabled public string paymentTransactionId{get;set;}
        @AuraEnabled public string notificationEmail{get;set;}
        @AuraEnabled public string source{get;set;}
    }
    
    public class IADProcessRefundRequestBean
    {
        @AuraEnabled public Integer orderId{get;set;}
        @AuraEnabled public String refundType{get;set;}
        @AuraEnabled public Integer amount{get;set;}
        @AuraEnabled public String currencyCode{get;set;}
        @AuraEnabled public String creatorId{get;set;}
        @AuraEnabled public Integer parentId{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String comments{get;set;}
        @AuraEnabled public String reason{get;set;}
        @AuraEnabled public Integer email{get;set;}
        @AuraEnabled public String gateway{get;set;}
        @AuraEnabled public String source{get;set;}
        @AuraEnabled public IADRefund_address address{get;set;}
        @AuraEnabled public IADRefund_manualCheckDetails manualCheckDetails{get;set;}
    }
    
    public class IADRefund_address
    {
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public Integer lastName{get;set;}
        @AuraEnabled public Integer addressLine1{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String zip{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String email{get;set;}
        @AuraEnabled public String phone{get;set;}
    }
    
    public class IADRefund_manualCheckDetails
    {
        @AuraEnabled public String bankName{get;set;}
        @AuraEnabled public String checkNumber{get;set;}
        @AuraEnabled public String depositDate{get;set;}
    }
    
    public class IADShippingAddressBean
    {
        @AuraEnabled public List<IADShippingContact> contacts{get;set;}
    }
    
    public class IADShippingContact
    {
        @AuraEnabled public Integer orderContactId{get;set;}
        @AuraEnabled public String contactType{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String zipCode{get;set;}
        @AuraEnabled public string updatedBy {get;set;}
        @AuraEnabled public List<IADShippingContact_Email> emailAddresses{get;set;}
        @AuraEnabled public String homePhone {get;set;}
        @AuraEnabled public String workPhone {get;set;}
        @AuraEnabled public String mobilePhone {get;set;}
        @AuraEnabled public String faxPhone {get;set;}
        @AuraEnabled public String theEmail{get;set;}
    }
    
    public class IADOrderContact
    {
        @AuraEnabled public String contactType{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String zipCode{get;set;}
        @AuraEnabled public string createdBy {get;set;}
        @AuraEnabled public List<IADShippingContact_Email> emailAddresses{get;set;}
        @AuraEnabled public String homePhone {get;set;}
        @AuraEnabled public String workPhone {get;set;}
        @AuraEnabled public String mobilePhone {get;set;}
        @AuraEnabled public String faxPhone {get;set;}
        @AuraEnabled public String theEmail{get;set;}
    }
    
    public class IADShippingContact_Email
    {
        @AuraEnabled public String emailAddress{get;set;}
    }
    
    public class IADSubscriptionBean
    {
        @AuraEnabled public List<IADSubscription> subscriptions{get;set;}
    }
    
    public class IADSingleSubscriptionBean
    {
        @AuraEnabled public IADSubscription subscription{get;set;}
    }
    
    public class IADSubscriptionRequestBean
    {
        @AuraEnabled public List<IADSubscriptionRequest> orderItems{get;set;}
    }
    
    public class IADSubscriptionRequest
    {
        @AuraEnabled public String orderItem{get;set;}
    }
    
    public class Errors
    {
        @AuraEnabled public String message{get;set;}
        @AuraEnabled public String code{get;set;}
        @AuraEnabled public List<FieldErrors> fieldErrors{get;set;}
    }
    
    public class ErrorResponse
    {
        @AuraEnabled public List<Errors> errors{get;set;}
    }
    public class FieldErrors
    {
        @AuraEnabled public String field{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String details{get;set;}
    }
    public class IADSubscription  implements Comparable
    {
        @AuraEnabled public String orderItemSubscriptionId{get;set;}
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String productName{get;set;}
        @AuraEnabled public String isActive{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String autoRenew{get;set;}
        @AuraEnabled public String additionalInfo{get;set;}
        @AuraEnabled public String processing{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public String adjCreatedDate{get;set;}
        @AuraEnabled public String subscriptionStartDate{get;set;}
        @AuraEnabled public String adjSubscriptionStartDate{get;set;}
        @AuraEnabled public String subscriptionEndDate{get;set;}
        @AuraEnabled public String adjSubscriptionEndDate{get;set;}
        @AuraEnabled public String relationshipType{get;set;}
        @AuraEnabled public String renewalTerm{get;set;}
        @AuraEnabled public Decimal renewalPrice{get;set;}
        @AuraEnabled public Boolean isActiveProfile{get;set;}
        @AuraEnabled public String userPaymentProfile{get;set;}
        @AuraEnabled public String paymentProfileId {get;set;}
        @AuraEnabled public Boolean isRA{get;set;}
        @AuraEnabled public Integer productComponent{get;set;}
        @AuraEnabled public Integer renewalProductConfiguration{get;set;}
        @AuraEnabled public List<IADSubscriptionInfoDetail> subscriptionInfoDetail{get;set;}
        @AuraEnabled public Boolean hasPaymentProfileExpired{get;set;}
        
        public Integer compareTo(Object theCompareTo)
        {
            IADSubscription compareTo = (IADSubscription)theCompareTo;
            
            Integer returnValue = 0;
            if (orderId < compareTo.orderId)
            {
                returnValue = 1;
            }
            else if (orderId > compareTo.orderId)
            {
                returnValue = -1;
            }
            
            return returnValue;
        }
        
    }
    public class IADSubscriptionInfoDetailsBean
    {
        @AuraEnabled public List<IADSubscriptionInfoDetail> subscriptionInfoDetails{get;set;}
    }
    
    public class IADSubscriptionInfoDetail
    {
        @AuraEnabled public String orderItemSubscriptionId{get;set;}
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String associatedSFDCRecordId{get;set;}
        @AuraEnabled public String subscriptionOrderItem{get;set;}
        @AuraEnabled public String subscriptionStartDate{get;set;}
        @AuraEnabled public String adjSubscriptionStartDate{get;set;}
        
        @AuraEnabled public String subscriptionEndDate{get;set;}
        @AuraEnabled public String adjSubscriptionEndDate{get;set;}
        @AuraEnabled public String freeShippingStartDate{get;set;}
        @AuraEnabled public String freeShippingEndDate{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public String adjCreatedDate{get;set;}
        
        @AuraEnabled public String renewalAlertStartDate{get;set;}
        @AuraEnabled public String renewalAlertEnd{get;set;}
        @AuraEnabled public String isActive{get;set;}
        
    }
    
    public class IADUpdateSubscriptionBean
    {
        @AuraEnabled public IADUpdateSubscription orderItemSubscription{get;set;}
    }
    public class IADUpdateSubscription
    {
        @AuraEnabled public String subscriptionID{get;set;}
        @AuraEnabled public Integer autoRenewOptionId{get;set;}
        @AuraEnabled public String updatedBy{get;set;}
        @AuraEnabled public Integer userPaymentProfileId{get;set;}
        @AuraEnabled public Decimal extendedPrice{get;set;}
        @AuraEnabled public Integer productComponentId{get;set;}
        @AuraEnabled public Integer renewalProductConfigurationId{get;set;}
    }
    public class IADUpdateSubscriptionResponse
    {
        @AuraEnabled public Boolean success{get;set;}
        @AuraEnabled public string message{get;set;}
        @AuraEnabled public Integer orderItemSubscriptionId {get;set;}
    }
    
    public class IADUpdateOrderSubscription
    {
        @AuraEnabled public Integer customerId{get;set;}
        @AuraEnabled public Integer orderItemId{get;set;}
        @AuraEnabled public Boolean isPartialRefund{get;set;}
        @AuraEnabled public Double refundAmount{get;set;}
        @AuraEnabled public String subscriptionEndDate{get;set;}
        @AuraEnabled public String updatedBy{get;set;}
        @AuraEnabled public String note{get;set;}
        @AuraEnabled public Integer actionType{get;set;}
    }
    
    public class OauthError
    {
        @AuraEnabled public String ErrorCode{get;set;}
        @AuraEnabled public String Error{get;set;}
    }
    
    public class FaultError
    {
        @AuraEnabled public APIFault fault{get;set;}
    }
    
    public class APIFault
    {
        @AuraEnabled public String faultString{get;set;}
    }
    
    public class OauthToken
    {
        @AuraEnabled public String issued_at{get;set;}
        @AuraEnabled public String expires_in{get;set;}
        @AuraEnabled public String access_token{get;set;}
    }
    
    public class IADCustomerBean
    {
        @AuraEnabled public List<IADthirdPartyUserInfoBean> thirdPartyUserInfo{get;set;}
        @AuraEnabled public IADSecurityQuestion securityQuestion{get;set;}
    }
    
    public class IADthirdPartyUserInfoBean
    {
        @AuraEnabled public String userId{get;set;}
        @AuraEnabled public String thirdPartyId{get;set;}
        @AuraEnabled public String thirdPartyTypeId{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        
    }
    public class IADStoreCredit
    {
        @AuraEnabled public List<IADStoreCreditBean> storeCredits{get;set;}
    }
    public class IADStoreCreditBean
    {
        @AuraEnabled public String storeCreditId{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String code{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String storeCreditStatusId{get;set;}
        @AuraEnabled public String expriationDate{get;set;} //wrong spell in API label
        @AuraEnabled public String adjExpirationDate{get;set;}
        @AuraEnabled public Datetime adjExpirationDateDT{get;set;}
        @AuraEnabled public Decimal amount{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public String adjDateCreated{get;set;}
        @AuraEnabled public Datetime adjDateCreatedDT{get;set;}
        
        @AuraEnabled public String paymentTransactionId{get;set;}
        @AuraEnabled public Boolean refundableFlag{get;set;}
    }
    
    public class IADStoreCreditV2
    {
        @AuraEnabled public IADStoreCreditV2Bean storeCredit{get;set;}
    }
    
    public class IADStoreCreditV2Bean
    {
        @AuraEnabled public Integer storeCreditId{get;set;}
        @AuraEnabled public Decimal remainingAmount{get;set;}
        @AuraEnabled public Integer paymentType{get;set;}
        @AuraEnabled public Integer customerId{get;set;}
        @AuraEnabled public Integer orderId{get;set;}
        @AuraEnabled public String code{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public Integer storeCreditStatus{get;set;}
        @AuraEnabled public String adjDateCreated{get;set;}
        @AuraEnabled public String adjExpirationDate{get;set;}
        @AuraEnabled public String expriationDate{get;set;} //wrong spell in API label
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String dateCreated{get;set;}
        @AuraEnabled public Integer paymentTransactionId{get;set;}
        @AuraEnabled public Boolean refundableFlag{get;set;}
    	@AuraEnabled public Decimal amount{get;set;}
        @AuraEnabled public List<IADStoreCreditOrderTransactionDetails> storeCreditOrderTransactionDetails{get;set;}
    }
    
    public class IADStoreCreditOrderTransactionDetails
    {
        @AuraEnabled public String storeCreditCode{get;set;}
        @AuraEnabled public Boolean isRefundable{get;set;}
        @AuraEnabled public String expiredDate{get;set;}
        @AuraEnabled public Integer orderId{get;set;}
        @AuraEnabled public Decimal amount{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public String adjCreatedDate{get;set;}
        @AuraEnabled public Integer transactionId{get;set;}
        @AuraEnabled public Integer transactionStatusId{get;set;}
        @AuraEnabled public Integer transactionTypeId{get;set;}
        @AuraEnabled public Integer refundManualCheckId{get;set;}
        @AuraEnabled public Integer refundTransactionStatusId{get;set;}
        @AuraEnabled public String transactionStatus{get;set;}
        @AuraEnabled public Boolean isCancelled{get;set;}
        @AuraEnabled public String statusDescription{get;set;}
        @AuraEnabled public String emailNotifyTo{get;set;}
    }
    
    public class IADStoreCreditById
    {
        @AuraEnabled public IADStoreCreditBean storeCredit{get;set;}
    }
    
    public class IADMakePaymentStoreCredit
    {
        @AuraEnabled public String storeCreditId{get;set;}
        @AuraEnabled public String storeCreditPaymentAmount{get;set;}
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String creatorId{get;set;}
        @AuraEnabled public String comments{get;set;}
    }
    
    public class IADMakePaymentStoreCreditResponse
    {
        @AuraEnabled public String storeCreditId{get;set;}
        @AuraEnabled public String storeCreditTransactionId{get;set;}
        @AuraEnabled public String amount{get;set;}
        @AuraEnabled public String storeCreditTransactionType{get;set;}
    }
    
    public class IADActionItemBean
    {
        @AuraEnabled public List<IADActionItem> actionItems{get;set;}
    }   
    
    public class IADActionItem
    {
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String actionItemsType{get;set;}
        @AuraEnabled public String productComponentId{get;set;}
        @AuraEnabled public String productConfigurationId{get;set;}
        @AuraEnabled public String productTypeId{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String productTypeName{get;set;}
    }
    
    public class IADProRatedRefundWrapper
    {
        @AuraEnabled public Map<String,String> proratedRefundData{get;set;}
    }
    
    public class IADOrderTerms
    {
        @AuraEnabled public String orderId{get;set;}
        @AuraEnabled public String orderTermStatus{get;set;}
        @AuraEnabled public String orderTermsText{get;set;}
        @AuraEnabled public String dateAccepted{get;set;}
        @AuraEnabled public String adjDateAccepted{get;set;}
    }
    
    public class IADPromoCode
    {
        @AuraEnabled public Boolean isValid{get;set;}
        @AuraEnabled public String promoCode{get;set;}
        @AuraEnabled public Decimal discountAmount{get;set;}
    }
    public class IADOrdersBean
    {
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public List<IADOrderGroup> orderGroups{get;set;}
    }
    public class IADOrderGroup
    {
        @AuraEnabled public String orderGroupId{get;set;}
        @AuraEnabled public List<IADOrderBean> orders{get;set;}
    }
    public class IADStoreCreditRefundToCard
    {
        @AuraEnabled public String storeCreditId{get;set;}
        @AuraEnabled public String amount{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String comments{get;set;}
        @AuraEnabled public String notificationEmail{get;set;}
        @AuraEnabled public String createdBy{get;set;}
    }
    
    public class EntityType {
        public Integer processId;
        public String description;
    }
    
    public class Entity {
        public Integer entityId;
        @AuraEnabled public String entityName {get;set;}
        public EntityType entityType;
        @AuraEnabled public String formationState {get;set;}
        public Integer processingOrderId;
        public String contactFirstName;
        public String contactLastName;
        public String contactEmail;
        public String contactPhone;
        public EntityAddress entityAddress;
        public EntityAddress mailingAddress;
        @AuraEnabled public String formationDate {get;set;}
        @AuraEnabled public String ein {get;set;}
        public Integer raProvider;
        public Integer subscriptionTermId;
        public String taxMattersMember;
        public String businessPurpose;
        public String status;
        public String fiscalYearEndDate;
        public Integer orderItemId;
        public Integer subscriptionOrderItemId;
        public Integer parentCompanyId;
        public String taxClassification;
        public String professionalCorpType;
        public List<Operators> operators;
        public List<Owners> owners;
        public List<Subscriptions> subscriptions;
    }
    public class IADEntity{
        @AuraEnabled public Entity entity{get;set;}
    }
    public class Operators {
        public Integer operatorId;
        public Integer entityId;
        public String title;
        public String firstName;
        public String lastName;
        public EntityAddress address;
        public Integer parentOperatorId;
    }
    
    
    
    public class Subscriptions {
        public Integer subscriptionId;
        public Integer entityId;
        public Integer orderItemId;
        public String subscriptionProvider;
        public String subscriptionType;
        public Integer raSubscriptionTermId;
    }
    
    public class EntityAddress {
        public String street1;
        public String street2;
        public String city;
        public String state;
        public String zip;
    }
    
    public class Owners {
        public Integer ownerId;
        public Integer entityId;
        public String ownerFirstName;
        public String ownerLastName;
        public EntityAddress address;
        public Integer parentOwnerId;
    }
    
    
    public class IADManualCheckRefundbean {
        
        public Integer paymentTransactionId;
        public Decimal amount;
        public Integer refundReasonId;
        public String notificationEmail;
        public String comments;
        public Integer manualCheckReasonId;
        public String firstName;
        public String lastName;
        public String address;
        public String city;
        public Integer state;
        public String zipCode;
        public String createdBy;
        public String approvedBy;
    }
    
    public class IADStoreCreditToManualCheckBean {
        public Integer storeCreditId;
        public Integer customerId;
        public Decimal amount;
        public String comments;
        public Integer manualCheckReasonId;
        public String firstName;
        public String lastName;
        public String address;
        public String city;
        public Integer state;
        public String zipCode;
        public String notificationEmail;
        public String checkNumber;
        public DateTime depositDate;
        public String createdBy;
        public String approvedBy;
    }
    
    public class IADDocumentsBean
    {
        @AuraEnabled public List<DocumentList> documentList{get;set;}
    } 
    
    public class IADDocumentShareBean
    {
        @AuraEnabled public Integer customerId{get;set;}
        @AuraEnabled public Integer processingOrderId{get;set;}
        @AuraEnabled public List<DocumentShareList> files{get;set;}
        @AuraEnabled public Integer processId{get;set;}
        @AuraEnabled public String processName{get;set;}
        @AuraEnabled public String contactType{get;set;}
    }
    
    public class DocumentList
    {
        @AuraEnabled public Integer documentId{get;set;}
        @AuraEnabled public String documentName{get;set;}
        @AuraEnabled public String folderName{get;set;}
        @AuraEnabled public Boolean isFileNetDocument{get;set;}
        @AuraEnabled public DateTime createdDate{get;set;}
    }
    
    public class DocumentShareList
    {
        @AuraEnabled public String documentName{get;set;}
        @AuraEnabled public String folderName{get;set;}
        @AuraEnabled public Boolean isFileNetDocument{get;set;}
        @AuraEnabled public DateTime createdDate{get;set;}
    }
    
    public class IADSubscriptionRenewalTerms{
        @AuraEnabled public List<AvailableRenewalTerms> availableRenewalTerms{get;set;}
    }
    
    public class AvailableRenewalTerms{
        @AuraEnabled public String renewalTerm{get;set;}
        @AuraEnabled public Decimal extendedPrice{get;set;}
        @AuraEnabled public Integer productComponentId{get;set;}
        @AuraEnabled public Integer productConfigurationId{get;set;}
    } 
    
    public class IADSubscriptionAdjustment{
        @AuraEnabled public SubscriptionUpgradeCancellationResponse scheduledUpgrade{get;set;}
    }    
    
    public class IADSubUpgradeCancellation{
        @AuraEnabled public SubscriptionUpgradeCancellationResponse cancelledUpgrade{get;set;}
    }
    
    public class SubscriptionUpgradeCancellationResponse{
        @AuraEnabled public Integer id{get;set;}
        @AuraEnabled public Integer subscriptionId{get;set;}
        @AuraEnabled public Integer orderItemId{get;set;}
        @AuraEnabled public Integer oldPackageId{get;set;}
        @AuraEnabled public Integer targetPackageId{get;set;}
        @AuraEnabled public String targetPackageName{get;set;}
        @AuraEnabled public String updatedBy{get;set;}
        @AuraEnabled public Integer oldProductConfigurationID{get;set;}
        @AuraEnabled public Integer newProductComponentId{get;set;}
        @AuraEnabled public Integer renewalProductConfigurationId{get;set;}
        @AuraEnabled public String renewalPackageName{get;set;}
        @AuraEnabled public Decimal renewalPrice{get;set;}
        @AuraEnabled public Integer status{get;set;}
        @AuraEnabled public DateTime loggedDate{get;set;}
        @AuraEnabled public DateTime processedDate{get;set;}
        @AuraEnabled public DateTime renewalDate{get;set;}       
    }
    
    public class  IADManualCheckPayment {
        
        public Integer paymentReasonId;
        public String bankName;
        public String firstName;
        public String lastName;
        public String checkNumber;
        public Integer amount;
        public String depositDate;
        public String notificationEmail;
        public String createdBy;
        public String comments;
        public String clearedDate;
        public String declinedDate;
        public List<Installments> installments;
        
    }
    
    public class Installments {
        public Integer installmentBillId;
        public Integer amount;
    }
    public class IADItpAccountstatus {
        
        public String encryptedData {get;set;} 
        public String traceNumber {get;set;} 
        @AuraEnabled public String subscriberNumber {get;set;} 
        public String status {get;set;} 
        public String errorText {get;set;} 
        public String errorType {get;set;} 
        public Version version {get;set;} 
        @AuraEnabled  public SubscriberData subscriberData {get;set;} 
        
    }
    public class InvitationResponse {
        
    @AuraEnabled public String responseData{get;set;}
    @AuraEnabled  public  String statusCode{get;set;}
    @AuraEnabled public  String errorMessage{get;set;}
        
    }
    
    public class SubscriberData {
        public Integer partnerNumber {get;set;} 
        public Integer type_Z {get;set;} // in json: type
        public String subscriberNumber {get;set;} 
        public String productType {get;set;} 
        public String emailAddress {get;set;} 
        public String firstName {get;set;} 
        public String middleInitial {get;set;} 
        public String lastName {get;set;} 
        public String generation {get;set;} 
        public String address1 {get;set;} 
        public String address2 {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public Integer zipCode {get;set;} 
        public String disclosureDateTime {get;set;} 
        public TelephoneDetails telephoneDetails {get;set;} 
        public Boolean active {get;set;} 
        public String subsriberPartnerStatus {get;set;} 
        @AuraEnabled  public String webActive {get;set;} 
        @AuraEnabled  public String cbStatus {get;set;} 
        public String futureDeactivationDate {get;set;} 
        public String futureActivationDate {get;set;} 
        public String breachSubscriptionExpirationDate {get;set;} 
        public Integer solicitOptInDays {get;set;} 
        public Integer renewalGraceDays {get;set;} 
        public String passportNumber {get;set;} 
        public String countryCode {get;set;} 
        public String securityQACaptured {get;set;} 
        public String subscriberLocaleCode {get;set;} 
        public String subscriberLanguageCode {get;set;}
    }
    
    
    
    public class Version {
        public String requested {get;set;} 
        public String minimumSupported {get;set;} 
        public String maximumSupported {get;set;} 
        
    }
    
    public class TelephoneDetails {
        public List<Telephone> telephone {get;set;} 
    }
    
    public class Telephone {
        public Integer number_Z {get;set;} // in json: number
        public String type_Z {get;set;} // in json: type
        public Boolean textEnabled {get;set;} 
        public Boolean primary {get;set;} 
    }
    
    public class IADInvitationDetails {
        
        @AuraEnabled  public List<ProductInvitations> productInvitations;
        
    }
    
    public class ProductInvitations {
        @AuraEnabled public  Integer productInvitationId;
        @AuraEnabled  public String expiryDate;
        @AuraEnabled public Integer customerId;
        public Integer inviteeId;
        @AuraEnabled  public String sentToEmail;
        @AuraEnabled   public String sentToName;
        @AuraEnabled  public String sentDate;
        public String description;
        @AuraEnabled  public String acceptedEmail;
        @AuraEnabled   public String acceptedDate;
        public double price;
        @AuraEnabled public String cancelledDate;
        public Boolean isActive;
        public Boolean isTokenExpired;
        @AuraEnabled  public String dateCreated;
        public String createdBy;
        public String dateUpdated;
        public String updatedBy;
    }
    
    public class updateItpcontact {
        
        public String originalType;
        public String originalNumber;
    }
    
    public class ITPAccountDelete {
        
        public String subscriberNumber;
        public String deactivationReason;
        public Boolean delayDeactivation;
        public String futureDeactivationDate;
    }
    
    public class UpdateEnrollmentResponse {
        public String status;
        public String subscriberNumber;
        public String errorType;
        public String errorText;
        public String traceNumber;
    }
    
    public class IADRelatedOrders {
        
        public Integer orderGroupId;
        public Integer customerId;
        public String orderSource;
        @AuraEnabled  public List<Orders> orders;
        public String dateCreated;
        public String createdBy;
        public String dateLastModified;
        public String lastModifiedBy;
        
    }
    
    public class Orders {
        @AuraEnabled public Integer orderId;
        public Integer index;
        @AuraEnabled  public String productName;
        @AuraEnabled public Integer processingOrderId;
        @AuraEnabled public string orderrecordid;
    }
    
    
    public class IADSubscriptionChangeOptionBean{
        @AuraEnabled public List<SubscriptionChangeOptionsResponse> subscriptionChangeOptions{get;set;}
    }
    
    public class SubscriptionChangeOptionsResponse{
        @AuraEnabled public Integer subscriptionChangeOptionID{get;set;}
        @AuraEnabled public Integer subscriptionChangeFromComponentID{get;set;}
        @AuraEnabled public Integer subscriptionChangeToComponentID{get;set;}
        @AuraEnabled public Integer subscriptionChangeTypeID{get;set;}
        @AuraEnabled public DateTime dateCreated{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public DateTime dateLastModified{get;set;}
        @AuraEnabled public String lastModifiedBy{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
        @AuraEnabled public Integer subscriptionChangeToConfiguration{get;set;}
        @AuraEnabled public String subscriptionChangeToName{get;set;}
        @AuraEnabled public List<AvailableRenewalTerms> availableRenewalTerm{get;set;}
    }
    
    public class CalculateProratedAmountForSubscriptionBean{
        @AuraEnabled public Integer orderId{get;set;}
        @AuraEnabled public Integer orderItemId{get;set;}
        @AuraEnabled public Integer orderSubscriptionInfoId{get;set;}
        @AuraEnabled public CurrentSubscriptionSummaryBean currentSubscriptionSummary{get;set;}  
        @AuraEnabled public ChangeSubscriptionSummaryBean changeSubscriptionSummary{get;set;}        
    }
    
    public class CurrentSubscriptionSummaryBean{
        @AuraEnabled public Integer subscriptionId{get;set;}
        @AuraEnabled public DateTime newEndDate{get;set;}
        @AuraEnabled public DateTime serviceTermRemainingStartDate{get;set;}
        @AuraEnabled public DateTime serviceTermRemainingEndDate{get;set;}
    }
    
    public class ChangeSubscriptionSummaryBean{
        @AuraEnabled public Integer productConfigurationId{get;set;}
        @AuraEnabled public Decimal purchasePrice{get;set;}
        @AuraEnabled public Decimal availableStoredCredit{get;set;}
        @AuraEnabled public Decimal remainingStoredCredit{get;set;}
        @AuraEnabled public Decimal proratedFee{get;set;}
        @AuraEnabled public Decimal balanceDue{get;set;}
        @AuraEnabled public DateTime serviceStartDate{get;set;}
        @AuraEnabled public DateTime renewalDate{get;set;}
    }
    
     public class lifeplanprovision
    {
       @AuraEnabled  public String userId;
    }
      
    //hari @B-34286
    public class IADSubscriptionServiceBean {
        @AuraEnabled public List<IADSubscriptionServices> subscriptionServices {get;set;}
    }   
    
    public class IADSubscriptionServices  {
        @AuraEnabled public Integer subscriptionCoverageId {get;set;}
        @AuraEnabled public Integer subscriptionId {get;set;}
        @AuraEnabled public Integer autoRenewOption {get;set;}
        @AuraEnabled public Integer productComponentId {get;set;}
        @AuraEnabled public Decimal renewalPrice {get;set;}
        @AuraEnabled public String autoRenewEndDate {get;set;}
        @AuraEnabled public Integer autoRenewOptOutReason {get;set;}
        @AuraEnabled public Integer subscriptionStatus {get;set;}
        @AuraEnabled public Integer subscriptionOrderItemId {get;set;}
        @AuraEnabled public String subscriptionStartDate {get;set;}
        @AuraEnabled public String subscriptionEndDate {get;set;}
        @AuraEnabled public Integer serviceProductComponentId {get;set;}
        @AuraEnabled public Integer serviceType {get;set;}
        @AuraEnabled public Integer coveredProductComponentId {get;set;}
        @AuraEnabled public Datetime adjsubscriptionEndDate {get;set;}
    }
    //hari EOC
}