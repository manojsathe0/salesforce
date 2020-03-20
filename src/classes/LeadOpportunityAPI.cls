/**
 * Created by jboles on 4/13/2017.
 */
@RestResource(urlMapping='/LeadOpportunityAPI/*')
global class LeadOpportunityAPI
{
    private static String contactName;
    private static Id contactOwnerId;
    private static Boolean ifOwnBySales;
    private static Id contactId;
    private static Id parentAccId;
    public static Boolean isOwnedBySEAD2{get;set;}
    
    @HttpPost
    global static String createOrUpdateLeadOrOpportunity()
        {
            RestRequest req = RestContext.request;
            RestResponse res = Restcontext.response;
            String requestBody = req.requestBody.toString();

            system.debug('requestBody ' + requestBody);

            SEADContractBeans.LeadContactBean leadResponse = (SEADContractBeans.LeadContactBean) JSON.deserialize(requestBody, SEADContractBeans.LeadContactBean.class);
            system.debug('leadResponse ' + leadResponse);
            if(!Test.isRunningTest()){
                isOwnedBySEAD2 = false;
            }
            
            Boolean pOverviewPage;
            Boolean checkOutPage;
            string ACRecordTypeId=Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Authorized Contact').getRecordTypeId();
            
            Contact theContact = new Contact();
            Lead theLead                                = new Lead();
            String idToReturn;
            //List<Lead> theLeadByEmail                   = [select id from Lead where email =: leadResponse.email order by lastmodifieddate desc limit 1];
            List<Lead> theLeadByEmail                   = new List<Lead>();
            List<Contact> theContactByEmail             = new List<Contact>();
            if((leadResponse.email != null && leadResponse.email != '') || (leadResponse.phone != null && leadResponse.phone != '')){

                String responseEmail;
                if (leadResponse.email != null && leadResponse.email != '') {
                    responseEmail = leadResponse.email;
                }
                String phoneNumber;
                if(leadResponse.phone != null && leadResponse.phone != '') {
                    phoneNumber = PhoneFormatter.formatPhone(leadResponse.phone);
                }

                //Lead Query with email
                String leadObject = 'Lead';
                String query = 'SELECT ';
                Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(leadObject).getDescribe().fields.getMap();
                if (String.isNotBlank(responseEmail)) {
                    for(String fieldName : objectFields.keySet())
                        {
                            query += ' ' + fieldName + ', ';
                        }
                    query = query.removeEnd(', ');
                    query += ' FROM ' + leadObject;
                    query +=' WHERE (Email=\'' + responseEmail +'\') AND Isconverted = FALSE ORDER BY lastmodifieddate DESC LIMIT 1';
                    system.debug('query ' + query);
                    theLeadByEmail = database.query(query);
                }
                if (theLeadByEmail.size() < 1 && String.isNotBlank(phoneNumber)) {
                    //Lead Query with phone
                    leadObject = 'Lead';
                    query = 'SELECT ';
                    for(String fieldName : objectFields.keySet())
                        {
                            query += ' ' + fieldName + ', ';
                        }
                    query = query.removeEnd(', ');
                    query += ' FROM ' + leadObject;
                    query +=' WHERE (Phone = \'' + phoneNumber +'\') AND Isconverted = FALSE ORDER BY lastmodifieddate DESC LIMIT 1';
                    system.debug('query ' + query);
                    theLeadByEmail = database.query(query);
                }

                //Contact Query

                String contactObject = 'Contact';
                String query1 = 'SELECT ';
                Map<String, Schema.SObjectField> objectFieldsC = Schema.getGlobalDescribe().get(contactObject).getDescribe().fields.getMap();
                if (String.isNotBlank(responseEmail)) {
                    for(String fieldName : objectFieldsC.keySet())
                        {
                            query1 += ' ' + fieldName + ', ';
                        }
                    query1 = query1.removeEnd(', ');
                    query1 += ' FROM ' + contactObject;
                    query1 +=' WHERE (Email=\'' + responseEmail +'\') AND RecordTypeId != \''+ ACRecordTypeId +'\' AND Inactive__c = FALSE ORDER BY lastmodifieddate DESC LIMIT 1';
                    theContactByEmail = database.query(query1);
                    system.debug('query1 ' + query1);
                }
               /* if (theContactByEmail.size() < 1 && String.isNotBlank(phoneNumber)) { // padma updated for contact phone update.
                    contactObject = 'Contact';
                    query1 = 'SELECT ';

                    for(String fieldName : objectFieldsC.keySet())
                        {
                            query1 += ' ' + fieldName + ', ';
                        }
                    query1 = query1.removeEnd(', ');
                    query1 += ' FROM ' + contactObject;
                    query1 +=' WHERE (HomePhone= \'' + phoneNumber +'\') AND RecordTypeId != \''+ ACRecordTypeId +'\' AND Inactive__c = FALSE ORDER BY lastmodifieddate DESC LIMIT 1';
                    theContactByEmail = database.query(query1);

                    system.debug('query1 ' + query1);
                }*/

                //theLeadByEmail                              = [select id from Lead where email =: leadResponse.email order by lastmodifieddate desc limit 1];
            }

            /*
             Author: Artyom M.
             Story: B-19892
             Description: Modofications per story B-19892. We need to search a matching contact first and only if not found, assigned the values to the lead.
             */
            
            /*
             * The following code is being added per Story: B-24110
             * The code esures different flow for different profiles: Sales Specialist (SEAD) 2 and other Sales profiles
             * After transition to new version, this code will be removed.
             */
            
            //TEMP CODE STARTED
            
            if (theContactByEmail.size()  > 0) {
                contactOwnerId = theContactByEmail[0].OwnerId;
                List<User> SEAD2User = new List<User>();
                try {
                    SEAD2User = [SELECT Id, Profile.Name FROM User WHERE Id = :contactOwnerId LIMIT 1];
                }
                catch(Exception e) {
                }
                SEAD_Profiles__c mc = SEAD_Profiles__c.getValues('Default');
                List<String> profileNames = new List<String>();
                if (mc != null) {
                    profileNames = mc.Allowed_Profile_Names__c.split(';');  
                }
                
                
                if (!SEAD2User.isEmpty() && !profileNames.isEmpty()) {
                    for (String profileN : profileNames) {
                        System.Debug('profileN = ' + profileN);
                        
                        if (SEAD2User[0].Profile.Name.equals(profileN)) {
                            isOwnedBySEAD2 = true;
                            break;
                        }
                        System.Debug('Profile Name: ' + SEAD2User[0].Profile.Name);
                        System.Debug('isOwnedBySEAD2: ' + isOwnedBySEAD2);
                        
                    }
                    // || SEAD2User[0].Profile.Name.contains('System Admin-')
                    
                }
                else {
                    System.Debug('Could not load profile.');
                }
                
                //padma added for contact update
                
                theContact = theContactByEmail[0];
                //if (leadResponse.firstName != null && leadResponse.firstName != '' && theContact.firstName ==null ) {
               /* if (leadResponse.firstName != null && leadResponse.firstName != ''  ) {
                    theContact.firstName                           = leadResponse.firstName;
                }

                if(leadResponse.lastName!=null && leadResponse.lastName != '' ){
                theContact.lastName                            = leadResponse.lastName;
                } */
                theContact.LeadSource                          = 'Abandoner';
                if (leadResponse.leadId != null) {
                    theContact.LeadID__c = leadResponse.leadId;
                }

               // if(leadResponse.email != null && leadResponse.email != '' && theContact.email == null ) {
                /* if(leadResponse.email != null && leadResponse.email != ''  ) {   
                    theContact.email                               = leadResponse.email;
                } */
               // if(leadResponse.uuid !=null && leadResponse.uuid !='' && theContact.UUID__c == null) {  // Padma changed per defect B-3726
               if(leadResponse.uuid !=null && leadResponse.uuid !='' ) {
                    theContact.UUID__c = leadResponse.uuid ;
                }
                /*if(leadResponse.customerId != null && leadResponse.customerId != '') {
                    theContact.FkUser__c                           = leadResponse.customerId;
                }*/
                //if(leadResponse.phone !=null && leadResponse.phone !='' && theContact.HomePhone == null) {
               /* if(leadResponse.phone !=null && leadResponse.phone !='' ) {
                    theContact.HomePhone                            = PhoneFormatter.formatPhone(leadResponse.phone);
                }
                if(leadResponse.device !=null && leadResponse.device !='' ) {
                    theContact.Device_Type__c                      = leadResponse.device;
                }*/
                if(leadResponse.marketingInfo !=null) {
                    theContact.Marketing_Channel__c                = leadResponse.marketingInfo.marketingChannel;
                    theContact.Marketing_Source__c                 = leadResponse.marketingInfo.marketingSource;
                    theContact.Marketing_Campaign__c               = leadResponse.marketingInfo.marketingCampaign;
                }

                if(leadResponse.myAccount.startDateTime != null) {
                    theContact.My_Account_Start_Time__c            = leadResponse.myAccount.startDateTime;
                }
                if(leadResponse.myAccount.endDateTime != null) {
                    theContact.My_Account_End_Time__c              = leadResponse.myAccount.endDateTime;
                }
                if(leadResponse.VisitStart !=null ) {
                    theContact.Website_Start_Time__c               = leadResponse.VisitStart;
                }

                theContact.Website_Page_Name__c                = leadResponse.page.pageName;
                if(leadResponse.page.endDateTime != null) {
                    theContact.Website_End_Time__c                 = leadResponse.page.endDateTime;
                }
                
                theContact.SessionId__c=UtilityLibrary.isNotNullOrBlank(theContact.SessionId__c)?theContact.SessionId__c+';'+leadResponse.SessionId :leadResponse.SessionId; //B-21240
                theContact.Company__c                             = 'UNKNOWN';

                if(leadResponse.questionnaireInfo !=null) {
                    
                    if (UtilityLibrary.isNotNullOrBlank(leadResponse.QuestionnaireInfo.ProcessId)) {
                      theContact.Process_ID__c = leadResponse.QuestionnaireInfo.ProcessId;
                }

                    if(leadResponse.questionnaireInfo.startDateTime != null )
                        theContact.Questionnaire_Start_Time__c         = leadResponse.questionnaireInfo.startDateTime;

                    if(leadResponse.questionnaireInfo.endDateTime != null)
                        theContact.Questionnaire_End_Time__c           = leadResponse.questionnaireInfo.endDateTime;

                    if(leadResponse.questionnaireInfo.percentageQuestionnaireCompletion != null )
                        theContact.Questionnaire_Percent_Complete__c   = leadResponse.questionnaireInfo.percentageQuestionnaireCompletion;

                    if(leadResponse.questionnaireInfo.lastPageOnQuestionnaire != null && leadResponse.questionnaireInfo.lastPageOnQuestionnaire != '')
                        theContact.Questionnaire_Last_Page__c          = leadResponse.questionnaireInfo.lastPageOnQuestionnaire;

                    if(leadResponse.questionnaireInfo.processingNumber != null && leadResponse.questionnaireInfo.processingNumber != '')
                        theContact.User_Order_ID__c                    = leadResponse.questionnaireInfo.processingNumber;

                    if(leadResponse.questionnaireInfo.state !=null && leadResponse.questionnaireInfo.state != ''){
                        theContact.State_of_Formation__c               = leadResponse.questionnaireInfo.state;
                    }

                    String thePackage                           = leadResponse.questionnaireInfo.packageName != null ?leadResponse.questionnaireInfo.packageName :null ;

                    try{
                        if(thePackage !=null) {
                            theContact.Package__c                          = [select id from Product2 where name =:thePackage limit 1].id;
                        }
                    }
                    catch(Exception e)
                    {

                    }

                    if(leadResponse.questionnaireInfo.amount !=null )
                        theContact.Amount__c                           = leadResponse.questionnaireInfo.amount;

                    String theProductName;
                    if(leadResponse.questionnaireInfo.processName != null && leadResponse.questionnaireInfo.processName !='')
                        theProductName  = leadResponse.questionnaireInfo.processName;

					 /* Added per B-27611 START */
          if (leadResponse.questionnaireInfo.firstEntity != null) {
                      theContact.First_Entity__c = leadResponse.questionnaireInfo.firstEntity;
                  }
                  if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.businessActivity)) {
                      theContact.Business_Activity__c = leadResponse.questionnaireInfo.businessActivity;
                  }
                  if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.promoCode)) {
                      theContact.Promo_Code__c = leadResponse.questionnaireInfo.promoCode;
                  }
                  if (leadResponse.questionnaireInfo.installmentPayment != null) {
                      theContact.Installment_Payment__c = leadResponse.questionnaireInfo.installmentPayment;
                  }
          
          /* Added per B-27611 END */
                    if(UtilityLibrary.isNotNullOrBlank(theLead.Product2__c) && !theLead.Product2__c.contains(theProductName))
                    {
                        theContact.Product2__c = theContact.Product2__c+';'+theProductName;
                    }
                    else
                    {
                        theContact.Product2__c = theProductName;
                    }

                    if(leadResponse.questionnaireInfo.milestone != null){
                        theContact.Purchase_Lock_Page__c               = leadResponse.questionnaireInfo.milestone.purchaseLockPage;
                        theContact.Product_Overview_Page__c            = leadResponse.questionnaireInfo.milestone.productOverviewPage;
                        theContact.Checkout_Page__c                    = leadResponse.questionnaireInfo.milestone.checkoutPage;

                        pOverviewPage= leadResponse.questionnaireInfo.milestone.productOverviewPage;
                        checkOutPage = leadResponse.questionnaireInfo.milestone.checkoutPage;
                    }
                }
                theContact.Updated_By_Tealium__c               = true;

                //Modification by Artyom M. for Defect D-03716
                //Current time will be populated into Updated_By_Tealium_DateTime__c on both Lead and Contact
                theContact.Updated_By_Tealium_DateTime__c = System.now();

                update theContact;
                     
                //child records
               handleAccountActivitiesContact(theContact.id, leadResponse);
                //handleOptInsCartItems(theContact, leadResponse);


                idToReturn = theContact.id;
                
            
      //CONTACT UPDATE END
           
            if (isOwnedBySEAD2) {
                /*
             Author: Artyom M.
             Story:  B-22456
             Description: This section was redone to work with Opp instead of Contacts.
             */
                
                contactId = theContactByEmail[0].Id;
                parentAccId = theContactByEmail[0].accountid;
                contactName = theContactByEmail[0].Name;
                
                /*
                Checking if contact is owned by a Sales agent and assigning the Opp to it too.
                Author: Artyom M.
                Story: Story B-22376
                START
                */
                contactOwnerId = theContactByEmail[0].OwnerId;
                ifOwnBySales = false;
                List<User> salesUsers = new List<User>();
                try {
                    salesUsers = [SELECT Id, Profile.Name FROM User WHERE Id = :contactOwnerId LIMIT 1];
                }
                catch(Exception e) {

                }

                if (!salesUsers.isEmpty()) {
                    
                    if (salesUsers[0].Profile.Name.Contains('Sales')) {
                        ifOwnBySales = true;
                    }
                    System.Debug('Profile Name: ' + salesUsers[0].Profile.Name);
                }
                else {
                    System.Debug('Could not load profile.');
                }
                /*
                Checking if contact is owned by a Sales agent and assigning the Opp to it too.
                Author: Artyom M.
                Story: Story B-22376
                END
                */
                
                
                //Account parentAcc = new Account(Id=theContactByEmail[0].accountid);//theContactByEmail[0].Account;
                String theProductName;
                if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.processName)) {
                    theProductName  = leadResponse.questionnaireInfo.processName;
                }
                System.debug('theProductName ' + theProductName);
                /*
                    Story: B-24546
                    By: Artyom M.
                    Ensuring that Opps are being created only in case when there are not orders for the Contact.
                */
                List<Order__c> orderList = new List<Order__c>(); 
                if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.processingNumber)) {
                    String processingNumber = leadResponse.questionnaireInfo.processingNumber;
                    try {
                        orderList = [SELECT Id, User_Order_ID__c, Contact__c FROM Order__c WHERE User_Order_ID__c = :processingNumber AND Contact__c = :contactId];
                    }
                    catch(QueryException e) {
                        System.debug('Issue querying order: ' + e.getMessage());
                    }
                    
                }
                
                if (orderList.isEmpty()) {
                	if (theContactByEmail[0].Internal_List__c != true) {
	                    List<Opportunity> existingOpps = new List<Opportunity>();
	                    existingOpps = [SELECT Id, Product2__c FROM Opportunity WHERE Contact__c = :contactId AND (NOT StageName Like 'Closed%') AND Product2__c != null AND OptIn_Opportunity__c != true];
	                    System.Debug('existingOpps = ' + existingOpps.size());
	                    Opportunity matchingOpp;
	                    for (Opportunity opp : existingOpps) {
	                        System.debug('Product is ' + opp.Product2__c);
	                        if (opp.Product2__c.equals(theProductName)) {
	                            matchingOpp = opp;
	                        }
	                        System.debug('Existing Opps ');
	                    }
	                    //populateOpportunityDataFromPayload
	                    if (matchingOpp != null) {
	                        matchingOpp = populateOpportunityDataFromPayload(matchingOpp, leadResponse, false);
	                        upsert matchingOpp;
	                        handleOpportunityOptIns(matchingOpp, leadResponse);
	                        System.debug('Matching found ');
	                        idToReturn = matchingOpp.Id;
	                    }
	                    else {
	                        System.debug('No Matching  ');
	                        //Id accId = '0013B00000HpKZS';
	                        //Account acc = new Account(Id = accId);
	                        Opportunity theOpp = new Opportunity();
	                        
	                        System.debug('theOpp.Contact__c ' + theOpp.Account.Id);
	                        theOpp = populateOpportunityDataFromPayload(theOpp, leadResponse, false);
	                        insert theOpp;
	                        handleOpportunityOptIns(theOpp, leadResponse);
	                        idToReturn = theOpp.Id;
	                    }
                	}
                }
                else {
                    idToReturn = orderList[0].Id;
                }
                
      //Opportunity
            } 
        } 
            else {
            if(theLeadByEmail.size() > 0 ) {
                    theLead                                 = theLeadByEmail[0];
                }
				system.debug('Padma in leadUpdate');
               // if(leadResponse.firstName != null && leadResponse.firstName != '' && theLead.firstName == null){
               if(leadResponse.firstName != null && leadResponse.firstName != '' ){
                    theLead.firstName                           = leadResponse.firstName;
                }
                if(leadResponse.lastName != null && leadResponse.lastName != '' ){
                    theLead.lastName                            = leadResponse.lastName;
                }
                theLead.LeadSource                          = 'Abandoner';
                if (leadResponse.leadId != null) {
                    theLead.LeadID__c = leadResponse.leadId;
                }
                if(leadResponse.VisitStart !=null ){
                    theLead.Website_Start_Time__c               =  leadResponse.VisitStart;
                }
                    
                //theLead.UUID__c                           = leadResponse.uuid;
                // if(leadResponse.uuid !=null && leadResponse.uuid !='' &&theLead.UUID__c == null ){ // Padma changed per defect B-3726
                 //if(leadResponse.uuid !=null && leadResponse.uuid !='' ){
                 if (UtilityLibrary.isNotNullOrBlank(leadResponse.uuid)) {
                     system.debug('Padma entering UUID');
                    theLead.UUID__c                         = leadResponse.uuid; // Padma changed per defect B-3726
                }
                /*
                    Changes per story B-23297
                    Adding temporary per QA request
                    Orig: if(leadResponse.email !=null && leadResponse.email != '' && theLead.email == null )
                */
                if(leadResponse.email != null && leadResponse.email != ''){
                    theLead.email                               = leadResponse.email;
                }
                    
                /* if(leadResponse.customerId != null && leadResponse.customerId != ''){
                    theLead.FkUser__c                           = leadResponse.customerId ;
                }*/
               // if(leadResponse.phone !=null && leadResponse.phone !='' && theLead.Phone == null ){
               if(leadResponse.phone !=null && leadResponse.phone !='' ){
                    theLead.Phone                               = PhoneFormatter.formatPhone(leadResponse.phone);
                }
                if(leadResponse.device !=null && leadResponse.device !='' )
                    theLead.Device_Type__c                      = leadResponse.device;

                if(leadResponse.marketingInfo !=null){
                    theLead.Marketing_Channel__c                = leadResponse.marketingInfo.marketingChannel;
                    theLead.Marketing_Source__c                 = leadResponse.marketingInfo.marketingSource;
                    theLead.Marketing_Campaign__c               = leadResponse.marketingInfo.marketingCampaign;
                }

                if(leadResponse.myAccount.startDateTime != null)
                    theLead.My_Account_Start_Time__c            =leadResponse.myAccount.startDateTime;
                if(leadResponse.myAccount.endDateTime != null)
                    theLead.My_Account_End_Time__c              =leadResponse.myAccount.endDateTime ;

                theLead.Website_Page_Name__c                = leadResponse.page.pageName;
                //theLead.Website_Start_Time__c               = leadResponse.page.startDateTime;
                String WebPage = leadResponse.page.pageName;
                //theLead.Checkout_Page__c = WebPage.contains('Checkout_Page') ? True : False;
                if(leadResponse.page.endDateTime != null){
                    theLead.Website_End_Time__c                 = leadResponse.page.endDateTime;
                }
                theLead.SessionId__c=UtilityLibrary.isNotNullOrBlank(theLead.SessionId__c)?theLead.SessionId__c+';'+leadResponse.SessionId:leadResponse.SessionId; 
                theLead.Company                             = 'UNKNOWN';
                if(leadResponse.questionnaireInfo !=null) {
                    if (UtilityLibrary.isNotNullOrBlank(leadResponse.QuestionnaireInfo.ProcessId)) {
                        theLead.Process_ID__c = leadResponse.QuestionnaireInfo.ProcessId;
                    }
                    
                    if(leadResponse.questionnaireInfo.startDateTime != null )
                        theLead.Questionnaire_Start_Time__c         = leadResponse.questionnaireInfo.startDateTime;

                    if(leadResponse.questionnaireInfo.endDateTime != null)
                        theLead.Questionnaire_End_Time__c              =  leadResponse.questionnaireInfo.endDateTime;

                    if(leadResponse.questionnaireInfo.percentageQuestionnaireCompletion != null )
                        theLead.Questionnaire_Percent_Complete__c   = leadResponse.questionnaireInfo.percentageQuestionnaireCompletion;

                    if(leadResponse.questionnaireInfo.lastPageOnQuestionnaire != null && leadResponse.questionnaireInfo.lastPageOnQuestionnaire != '')
                        theLead.Questionnaire_Last_Page__c          = leadResponse.questionnaireInfo.lastPageOnQuestionnaire;

                    if(leadResponse.questionnaireInfo.processingNumber != null && leadResponse.questionnaireInfo.processingNumber != '')
                        theLead.User_Order_ID__c                        = leadResponse.questionnaireInfo.processingNumber;

                    if(leadResponse.questionnaireInfo.state !=null && leadResponse.questionnaireInfo.state != ''){
                        theLead.State_of_Formation__c               = leadResponse.questionnaireInfo.state;
                    }

                    String thePackage                           = leadResponse.questionnaireInfo.packageName != null ?leadResponse.questionnaireInfo.packageName :null ;

                    try{
                        if(thePackage !=null) {
                            theLead.Package__c                          = [select id from Product2 where name =:thePackage limit 1].id;
                        }
                    }
                    catch(Exception e)
                    {

                    }

                    if(leadResponse.questionnaireInfo.amount !=null )
                        theLead.Amount__c                           = leadResponse.questionnaireInfo.amount;

                    String theProductName;
                    if(leadResponse.questionnaireInfo.processName != null && leadResponse.questionnaireInfo.processName !='')
                        theProductName  = leadResponse.questionnaireInfo.processName;

					 /* Added per B-27611 START */
          if (leadResponse.questionnaireInfo.firstEntity != null) {
                      theLead.First_Entity__c = leadResponse.questionnaireInfo.firstEntity;
                  }
                  if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.businessActivity)) {
                      theLead.Business_Activity__c = leadResponse.questionnaireInfo.businessActivity;
                  }
                  if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.promoCode)) {
                      theLead.Promo_Code__c = leadResponse.questionnaireInfo.promoCode;
                  }
                  if (leadResponse.questionnaireInfo.installmentPayment != null) {
                      theLead.Installment_Payment__c = leadResponse.questionnaireInfo.installmentPayment;
                  }
          
          /* Added per B-27611 END */
                    
                    if(UtilityLibrary.isNotNullOrBlank(theLead.Product2__c) && !theLead.Product2__c.contains(theProductName))
                    {
                        theLead.Product2__c = theLead.Product2__c+';'+theProductName;
                    }
                    else
                    {
                        theLead.Product2__c = theProductName;
                    }

                    if(leadResponse.questionnaireInfo.milestone != null){
                        theLead.Purchase_Lock_Page__c               = leadResponse.questionnaireInfo.milestone.purchaseLockPage;
                        theLead.Product_Overview_Page__c            = leadResponse.questionnaireInfo.milestone.productOverviewPage;
                        theLead.Checkout_Page__c                    = leadResponse.questionnaireInfo.milestone.checkoutPage;
                        pOverviewPage= leadResponse.questionnaireInfo.milestone.productOverviewPage;
                        checkOutPage = leadResponse.questionnaireInfo.milestone.checkoutPage;

                    }
                }
                if(!theLeadByEmail.isEmpty()){
                    if(theLeadByEmail[0].status == 'New'){
                        if(pOverviewPage || checkOutPage){
                            theLead.Status = 'Validated';
                        }
                        else {
                            theLead.Status = 'Qualified';
                        }
                    }
                    else if(theLeadByEmail[0].status == 'Qualified'){
                        if(pOverviewPage || checkOutPage){
                            theLead.Status = 'Validated';
                        }
                    }
                }
                else {

                    if(pOverviewPage || checkOutPage){
                        theLead.Status = 'Validated';
                    }
                    else {
                        theLead.Status = 'Qualified';
                    }

                }
                List<Lead> leadsByPhone = new List<Lead>();
                String phoneNumber;
                if(leadResponse.phone != null && leadResponse.phone != '') {
                	phoneNumber = PhoneFormatter.formatPhone(leadResponse.phone);
	            	leadsByPhone = [SELECT Id, Phone, Internal_List__c FROM Lead WHERE Phone = :phoneNumber AND Internal_List__c = true];
				}
                
                if (leadsByPhone.isEmpty()) {
                	if(theLeadByEmail.size()>0){
	                    //Modification by Artyom M. for Defect D-03716
	                    //Current time will be populated into Updated_By_Tealium_DateTime__c on both Lead and Contact
	                    theLead.Updated_By_Tealium__c = true;
	                    theLead.Updated_By_Tealium_DateTime__c = System.now();
	                    System.debug('Updating case>>>>');
	                    update theLead;
	                }
	                else {
	                	if(leadResponse.leadId != null){
	                        system.debug('for loop to upsert');
	                        upsert theLead LeadID__c;                     //do this first to allow children to be attached
	                    }
	                    else {
	                        system.debug('for loop to insert');
	                        insert theLead;
	                    }
	                }
	                //child records
	                handleAccountActivities(theLead.id, leadResponse);
	                handleOptInsCartItems(theLead, leadResponse);
	
	                try {
	
	                    theLead.Product2__c                         = [select Product2__c from Lead where id=:theLead.id].Product2__c;
	                }
	                catch(Exception e) {
	
	                }
	                idToReturn = theLead.id;
                }
                else {
                	System.Debug('No DML on a Lead because ' + leadsByPhone);
                	idToReturn = 'No DML on this Lead';
                	
                }
                
                
            }
            return idToReturn;
        }
        
    /*
             Author: Artyom M.
             Story:  B-22456
             Description: This method handles creation of child opps for parent opp
             */
    private Static void handleOpportunityOptIns(Opportunity opp, SEADContractBeans.LeadContactBean leadResponse) {
        System.debug('Optins for ' + opp.Name);
        List<Opportunity> childOppsToUpsert = new List<Opportunity>();
        
        List<Opportunity> existingChildOpps = new List<Opportunity>();
        existingChildOpps = [SELECT Id, Name, Product2__c FROM Opportunity WHERE Opportunity__c =:opp.Id];
        System.Debug('existingChildOpps' + existingChildOpps.size());
        
        System.Debug('Size of OPTINS' + leadResponse.questionnaireInfo.optIns.size());
        if (leadResponse.questionnaireInfo.optIns != null) {
            for (SEADContractBeans.Optins jsonOptin : leadResponse.questionnaireInfo.optIns) {
                System.Debug('Inside Optin' + jsonOptin.optin);
                Opportunity newOpp = new Opportunity();
                for (Opportunity exstingOpp : existingChildOpps) {
                    //Check if there is similar optin opp
                    if (jsonOptin.optin.equals(exstingOpp.Product2__c)) {
                        System.Debug('Found match with existing' + exstingOpp.Id);
                        newOpp = exstingOpp;
                        break;
                    }
                }
                if (String.isNotBlank(jsonOptin.optin)) {
                    newOpp.name = contactName + '-' + jsonOptin.optin;
                    newOpp.Product2__c = jsonOptin.optin;
                    newOpp.Opportunity__c = opp.Id;
                    populateOpportunityDataFromPayload(newOpp, leadResponse, true); //clarify if what child needs to have
                    childOppsToUpsert.add(newOpp);
                }

                
                
            }
        }/*
        if (leadResponse.cartInfo != null) {
            for (SEADContractBeans.CartItems jsonCartItem : leadResponse.cartInfo.cartItems) {
                
            }
        } */
        if (childOppsToUpsert.size() > 0) {
            upsert childOppsToUpsert;
        }
        
    }
    
    /*
             Author: Artyom M.
             Story:  B-22456
             Description: This method populates the new opps with payload data
             */
    private Static Opportunity populateOpportunityDataFromPayload(Opportunity opp, SEADContractBeans.LeadContactBean leadResponse, Boolean isChildOpp) {
        Opportunity theOpp = opp;
    Date closeDate = System.today().addDays(7);
        theOpp.CloseDate = closeDate;
        theOpp.StageName = 'New';
        
        theOpp.LeadSource = 'Abandoner';
        theOpp.Company__c = 'UNKNOWN';
        theOpp.Contact__c = contactId;
        theOpp.AccountId = parentAccId;
        
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.SessionId)) {
            theOpp.SessionId__c = leadResponse.SessionId;
        }
                
        /*      
        String oppFirstName = '';
        String oppLastName = '';
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.firstName)) {
            oppFirstName = leadResponse.firstName;
        }
                
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.lastName)) {
            oppLastName = leadResponse.lastName;
        }
        */

        System.Debug('populateOpportunityDataFromPayload knows profile name - ' + ifOwnBySales + ' ' + contactOwnerId);
        /*
        Checking if contact is owned by a Sales agent and assigning the Opp to it too.
        Author: Artyom M.
        Story: Story B-22376
        */
        if (ifOwnBySales) {
            theOpp.OwnerId = contactOwnerId;
        }
        
        
        if (!isChildOpp) {
            if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.processName)) {
                theOpp.Name = contactName + '-' + leadResponse.questionnaireInfo.processName;
            }
            theOpp.OptIn_Opportunity__c = false;
        }
        else {
            theOpp.OptIn_Opportunity__c = true;
        }
            
        
        
        if (leadResponse.leadId != null) {
            theOpp.LeadID__c = leadResponse.leadId;
        }
                
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.email)) {
            theOpp.Email__c = leadResponse.email;
        }
                
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.uuid)) {
            theOpp.UUID__c = leadResponse.uuid;
        }
                
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.customerId)) {
            theOpp.User_Foreign_Key__c = leadResponse.customerId;
        }
                
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.phone)) {
            theOpp.Phone__c = leadResponse.phone;
        }
                
        if (UtilityLibrary.isNotNullOrBlank(leadResponse.device)) {
            theOpp.Device_Type__c = leadResponse.device;
        }
                
        if (leadResponse.marketingInfo !=null) {
            theOpp.Marketing_Channel__c = leadResponse.marketingInfo.marketingChannel;
            theOpp.Marketing_Source__c = leadResponse.marketingInfo.marketingSource;
            theOpp.Marketing_Campaign__c = leadResponse.marketingInfo.marketingCampaign;
        }
                
        if(leadResponse.myAccount.startDateTime != null) {
            theOpp.My_Account_Start_Time__c = leadResponse.myAccount.startDateTime;
        }
                
         if(leadResponse.myAccount.endDateTime != null) {
            theOpp.My_Account_End_Time__c = leadResponse.myAccount.endDateTime;
         }

        theOpp.Website_Page_Name__c = leadResponse.page.pageName;                
        if(leadResponse.VisitStart != null ) {
            theOpp.Website_Start_Time__c = leadResponse.VisitStart;
        }

        if(leadResponse.page.endDateTime != null) {
            theOpp.Website_End_Time__c = leadResponse.page.endDateTime;
        }
                
        if(leadResponse.questionnaireInfo != null) {
            if (UtilityLibrary.isNotNullOrBlank(leadResponse.QuestionnaireInfo.ProcessId)) {
                theOpp.Process_ID__c = leadResponse.QuestionnaireInfo.ProcessId;
            }
            
            if(leadResponse.questionnaireInfo.startDateTime != null )
                theOpp.Questionnaire_Start_Time__c = leadResponse.questionnaireInfo.startDateTime;

            if(leadResponse.questionnaireInfo.endDateTime != null)
                theOpp.Questionnaire_End_Time__c = leadResponse.questionnaireInfo.endDateTime;
            
            if(leadResponse.questionnaireInfo.percentageQuestionnaireCompletion != null )
                theOpp.Questionnaire_Percent_Complete__c = leadResponse.questionnaireInfo.percentageQuestionnaireCompletion;
            
            if(leadResponse.questionnaireInfo.lastPageOnQuestionnaire != null && leadResponse.questionnaireInfo.lastPageOnQuestionnaire != '')
                theOpp.Questionnaire_Last_Page__c = leadResponse.questionnaireInfo.lastPageOnQuestionnaire;
            
            if(leadResponse.questionnaireInfo.processingNumber != null && leadResponse.questionnaireInfo.processingNumber != '')
                theOpp.User_Order_ID__c = leadResponse.questionnaireInfo.processingNumber;
            
            if(leadResponse.questionnaireInfo.state !=null && leadResponse.questionnaireInfo.state != ''){
                theOpp.State_of_Formation__c = leadResponse.questionnaireInfo.state;
            }
                    
            String thePackage = leadResponse.questionnaireInfo.packageName != null ?leadResponse.questionnaireInfo.packageName :null ;
            if (UtilityLibrary.isNotNullOrBlank(thePackage)) {
                try {
                    theOpp.Package__c = [select id from Product2 where name =:thePackage limit 1].id;
                }
                catch(Exception e) {
                }
            }
               /* Added per B-27611 START */
      		if (leadResponse.questionnaireInfo.firstEntity != null) {
              theOpp.First_Entity__c = leadResponse.questionnaireInfo.firstEntity;
            }
            if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.businessActivity)) {
              theOpp.Business_Activity__c = leadResponse.questionnaireInfo.businessActivity;
            }
            if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.promoCode)) {
              theOpp.Promo_Code__c = leadResponse.questionnaireInfo.promoCode;
      		}
            if (leadResponse.questionnaireInfo.installmentPayment != null) {
              theOpp.Installment_Payment__c = leadResponse.questionnaireInfo.installmentPayment;
            }
          
      /* Added per B-27611 END */
                    
            if(leadResponse.questionnaireInfo.amount !=null ) {
                theOpp.Amount = leadResponse.questionnaireInfo.amount;
            }
                    
            if (UtilityLibrary.isNotNullOrBlank(leadResponse.questionnaireInfo.processName)) {
                if (!isChildOpp) {
                    theOpp.Product2__c = leadResponse.questionnaireInfo.processName;
                }
                
            }
                    
            if(leadResponse.questionnaireInfo.milestone != null){
                theOpp.Purchase_Lock_Page__c = leadResponse.questionnaireInfo.milestone.purchaseLockPage;
                theOpp.Product_Overview_Page__c = leadResponse.questionnaireInfo.milestone.productOverviewPage;
                theOpp.Checkout_Page__c = leadResponse.questionnaireInfo.milestone.checkoutPage;

                //pOverviewPage= leadResponse.questionnaireInfo.milestone.productOverviewPage;
                //checkOutPage = leadResponse.questionnaireInfo.milestone.checkoutPage;
            }
                    
        }
        theOpp.Updated_By_Tealium__c = true;
        theOpp.Updated_By_Tealium_DateTime__c = System.now();
        
        return theOpp;
        
    }//populateOpportunityDataFromPayload
    
    
    public static void handleAccountActivities(Id leadId, SEADContractBeans.LeadContactBean leadResponse)
        {
            if(leadResponse.myAccount.Activities !=null){
                List<My_Account_Activity__c> myAccountActivities = [select id from My_Account_Activity__c where Lead__c=:leadId];

                String errorMessage = '';

                if(myAccountActivities.size()>0)
                {
                    MyAccountActivityService.deleteMyAccountActivities(myAccountActivities);


                }

                myAccountActivities = new List<My_Account_Activity__c>();

                for(SEADContractBeans.Activities jsonActivity : leadResponse.myAccount.Activities)
                    {
                        My_Account_Activity__c activity = new My_Account_Activity__c();
                        activity.name                   = jsonActivity.action;
                        activity.Lead__c                = leadId;
                        myAccountActivities.add(activity);
                    }
                insert myAccountActivities;
            }
        }
    

    public static void handleOptInsCartItems(Lead theLead, SEADContractBeans.LeadContactBean leadResponse)
        {
            /* String theProductName   = leadResponse.questionnaireInfo.processName != null?leadResponse.questionnaireInfo.processName:null;
             System.debug('theProductName'+theProductName);
            if(UtilityLibrary.isNotNullOrBlank(theLead.Product2__c) && !theLead.Product2__c.contains(theProductName))
             //if(!theLead.Product2__c.contains(theProductName))
             {
                 theLead.Product2__c = theLead.Product2__c+';'+theProductName;
             }
             else
             {
                  System.debug('entered else');
                 theLead.Product2__c = theProductName;
             }*/
            //start from a clean slate
            List<Opt_In_Cart_Item__c> jsonOptins = [select id from Opt_In_Cart_Item__c where Lead__c=:theLead.id];

            String errorMessage = '';

            if(jsonOptins.size()>0)
            {
                OptInService.deleteOptIns(jsonOptins);

            }

            jsonOptins = new List<Opt_In_Cart_Item__c>();
            if(leadResponse.questionnaireInfo.optIns != null){
                for(SEADContractBeans.Optins jsonOptin : leadResponse.questionnaireInfo.optIns)
                    {
                        Opt_In_Cart_Item__c optIn = new Opt_In_Cart_Item__c();
                        optIn.name                = jsonOptin.optin;
                        optIn.Lead__c             = theLead.ID;
                        jsonOptins.add(optIn);
                    }
            }
            if(leadResponse.cartInfo != null){
                for(SEADContractBeans.CartItems jsonCartItem : leadResponse.cartInfo.cartItems)
                    {
                        Opt_In_Cart_Item__c cartItem = new Opt_In_Cart_Item__c();
                        cartItem.name                = jsonCartItem.productName;
                        cartItem.price__c            = jsonCartItem.price;
                        cartItem.Lead__c             = theLead.ID;
                        jsonOptins.add(cartItem);
                    }
            }
            insert jsonOptins;
        }
    /*
    METHODS:
        handleAccountActivitiesContact
        handleOptInsCartItems
    Have been unCommented per Story B-24110. Comment them back after transition
    */
    
    
    public static void handleAccountActivitiesContact(Id contactId, SEADContractBeans.LeadContactBean leadResponse) {
        if(leadResponse.myAccount.Activities !=null){
            List<My_Account_Activity__c> myAccountActivities = [select id from My_Account_Activity__c where Contact__c=:contactId];

            String errorMessage = '';

            if(myAccountActivities.size()>0)
            {
                MyAccountActivityService.deleteMyAccountActivities(myAccountActivities);


            }

            myAccountActivities = new List<My_Account_Activity__c>();

            for(SEADContractBeans.Activities jsonActivity : leadResponse.myAccount.Activities)
                {
                    My_Account_Activity__c activity = new My_Account_Activity__c();
                    activity.name                   = jsonActivity.action;
                    activity.Contact__c                = contactId;
                    myAccountActivities.add(activity);
                }
            insert myAccountActivities;
        }
    }

    public static void handleOptInsCartItems(Contact theContact, SEADContractBeans.LeadContactBean leadResponse) {
        List<Opt_In_Cart_Item__c> jsonOptins = [select id from Opt_In_Cart_Item__c where Contact__c=:theContact.id];

        String errorMessage = '';

        if(jsonOptins.size()>0)
        {
            OptInService.deleteOptIns(jsonOptins);

        }

        jsonOptins = new List<Opt_In_Cart_Item__c>();
        if(leadResponse.questionnaireInfo.optIns != null){
            for(SEADContractBeans.Optins jsonOptin : leadResponse.questionnaireInfo.optIns)
                {
                    Opt_In_Cart_Item__c optIn = new Opt_In_Cart_Item__c();
                    optIn.name                = jsonOptin.optin;
                    optIn.Contact__c             = theContact.ID;
                    jsonOptins.add(optIn);
                }
        }
        if(leadResponse.cartInfo != null){
            for(SEADContractBeans.CartItems jsonCartItem : leadResponse.cartInfo.cartItems)
                {
                    Opt_In_Cart_Item__c cartItem = new Opt_In_Cart_Item__c();
                    cartItem.name                = jsonCartItem.productName;
                    cartItem.price__c            = jsonCartItem.price;
                    cartItem.Contact__c             = theContact.ID;
                    jsonOptins.add(cartItem);
                }
        }
        insert jsonOptins;
    }
    
    
    
    
}