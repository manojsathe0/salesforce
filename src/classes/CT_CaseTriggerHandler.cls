public without sharing class CT_CaseTriggerHandler extends CT_BaseTriggerHandler implements CT_ITriggerHandler.ICaseTriggerHandler{
    final String CLASSNAME = '\n\n**** CT_CaseTriggerHandler.METHODNAME()';
    private integer BatchSize = 0;
    private CT_CaseTriggerHelper helper;
    private User currentUser;

    //  @author : CloudTrigger, Inc.
    //  @date : 11/29/2011
    //  @description : the class constructor method
    //  @paramaters : a Boolean value indicating if a trigger is executing or not, an Integer value indicating the number of records in the batch/list
    //  @returns : nothing
    //  @sample call : CT_ITriggerHandler.ICaseTriggerHandler handler = new CT_CaseTriggerHandler(Trigger.isExecuting, Trigger.size);
    public CT_CaseTriggerHandler(boolean isExecuting, integer pTriggerSize){
        TriggerIsExecuting = isExecuting;
        BatchSize = pTriggerSize;
        Profile currentUserProfile = [Select Name From Profile where Id = :UserInfo.getProfileId()];
        currentUser = [Select Name, Id From User where Id = :UserInfo.getUserId()];
        helper = CT_CaseTriggerHelper.NewTriggerHelper(currentUserProfile.Name);
    }

    //  @author : CloudTrigger, Inc.
    //  @date : 11/29/2011
    //  @description :  this method handles the 'before insert' event for the trigger; it's purpose is to ...
    //  @paramaters : an array of Case objects
    //  @returns : nothing
    public void OnBeforeInsert(Case[] pNewCases){
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'OnBeforeInsert');
        System.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' with '+ pNewCases.size() +' Case objects in the array\n\n');
        CT_StringBuilder sb = CT_StringBuilder.NewWithFirstValue('Inside CT_CaseTriggerHandler.OnBeforeInsert() method;');
        
        try{
            if(IsTriggerContext && (!IsVisualforcePageContext && !IsWebServiceContext && !IsExecuteAnonymousContext)){
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: Current User\'s name is \''+ currentUser.Name +'\' ('+ currentUser.Id +')\n\n');
                
                list<Case> CasesWithNoMatchingContact = new list<Case>();
                map<String, Case> EmailToCaseMap = new map<String, Case>();
                map<String, Contact> EmailToContactMap = new map<String, Contact>();
                map<String, Account> EmailToAccountMap = new map<String, Account>();

                for(Case theCase : pNewCases){
                    Boolean EmailWasSupplied = (CT_Utility.StringIsNullOrEmpty(theCase.SuppliedEmail) == false);
                    Boolean SuppliedEmailIsNotLegalZoomSupport = false;
                    if(EmailWasSupplied){
                        SuppliedEmailIsNotLegalZoomSupport = (theCase.SuppliedEmail.Equals('support@legalzoom.com') == false);
                        if(SuppliedEmailIsNotLegalZoomSupport)
                            sb.Append('The \'SuppliedEmail\' address for this Case is '+ theCase.SuppliedEmail +';');
                        else
                            sb.Append('The \'SuppliedEmail\' address for this Case is support@legalzoom.com;');
                    }
                    else
                        sb.Append('The \'SuppliedEmail\' address was NOT provided for this Case;');
                    Boolean CaseContactIdIsNull = (theCase.ContactId == null);
                    if(CaseContactIdIsNull){
                        sb.Append('The \'ContactId\' for this Case is missing (NULL);');
                    }
                    System.debug(LoggingLevel.INFO, METHODNAME + ' :: EmailWasSupplied = '+ EmailWasSupplied +'\nSuppliedEmailIsNotLegalZoomSupport = '+ SuppliedEmailIsNotLegalZoomSupport +'\nCaseContactIdIsNull = '+ CaseContactIdIsNull +' .\n\n');
                    
                    if( CaseContactIdIsNull && EmailWasSupplied && SuppliedEmailIsNotLegalZoomSupport){                     
                        if(currentUser.Name.contains('Email to Case'))
                            System.debug(LoggingLevel.INFO, METHODNAME + ' :: Case Supplied Email is \''+ theCase.SuppliedEmail +'\' and Case Subject = \''+ theCase.Subject +'\'\n\n');
                        sb.Append('Adding this Case to the \'EmailToCase\' map;');
                        EmailToCaseMap.put(theCase.SuppliedEmail, theCase);
                    }else{
                        sb.Append('The \'ContactId\' for this Case is NOT missing/NULL, or no \'SuppliedEmail\' address was provided, or the \'SuppliedEmail\' address provided is \'support@legalzoom.com\' so...code is NOT adding the Case to the \'EmailToCase\' map;');
                        system.debug(LoggingLevel.INFO, METHODNAME + ' :: NOT adding to the \'EmailToCaseMap\' now.\n\n');
                        if(currentUser.Name.contains('Email to Case'))
                            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Case Supplied Email is \''+ theCase.SuppliedEmail +'\' and Case Subject = \''+ theCase.Subject +'\'\n\n');
                    }
                }

                if(CT_Utility.ValidateMap(EmailToCaseMap)){
                    // get existing Contacts that have matching email addresses
                    EmailToContactMap = helper.GetEmailAddressToContactMap(EmailToCaseMap.keyset());
    
                    // get existing Accounts that have matching email addresses
                    EmailToAccountMap = helper.GetEmailAddressToAccountMap(EmailToCaseMap.keyset());
                }
                
                // loop through all new inserted Cases
                for(Case theCase:pNewCases){
                    Boolean CaseContactIdIsNull = (theCase.ContactId == null);
                    
                    // if the Case has a ContactId already, then we do not need to do anything 
                    if(CaseContactIdIsNull){
                        if(EmailToContactMap.containskey(theCase.SuppliedEmail)){
                            // there is an existing Contact match - make the Case/Contact link
                            theCase.ContactId = EmailToContactMap.get(theCase.SuppliedEmail).Id;
                            sb.Append('There is a MATCH on \'SuppliedEmail\' for this Case and an existing Contact ('+ EmailToContactMap.get(theCase.SuppliedEmail).Id +') - setting the ContactId or the Case;');
                        }else if (EmailToAccountMap.containskey(theCase.SuppliedEmail)){
                            // there is an existing Account match - make the Case/Account link
                            theCase.AccountId = EmailToAccountMap.get(theCase.SuppliedEmail).Id;
                            sb.Append('No match was found for an exisitng Contact, but there is a MATCH on \'SuppliedEmail\' for this Case and an existing Account ('+ EmailToAccountMap.get(theCase.SuppliedEmail).Id +') - setting the AccountId or the Case;');
                        }else{
                            sb.Append('No match was found for an exisitng Contact or an existing Account based on the \'SuppliedEmail\' address for this Case - adding this Case to list to create a new Parent Account and Contact;');
                            
                            // add the debugging info to the Case record
                            theCase.Debug_Info__c = sb.AsString();

                            // add to list of Cases needing Contacts added
                            CasesWithNoMatchingContact.add(theCase);
                        }
                    }
                }// end of loop through all new inserted Cases
 
                if(CT_Utility.ValidateList(CasesWithNoMatchingContact)){
                    helper.CreateParentAccountAndContact(CasesWithNoMatchingContact);
                }
            }
        }catch(Exception ex){
            if(ex instanceof CT_BaseApplicationException)
                throw ex;
            else
                throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, ex.getMessage(), 'A problem has occurred & processing cannot complete successfully - please see system log for details.', ex);
        }
    }

    //  @author : CloudTrigger, Inc.
    //  @date : 11/29/2011
    //  @description :  this method handles the 'after insert' event for the trigger; it's purpose is to ...
    //  @paramaters : an array of Case objects
    //  @returns : nothing
    public void OnAfterInsert(Case[] pCases)
    {/* currently not implemeneted */ }

    //  @author : CloudTrigger, Inc.
    //  @date : 11/29/2011
    //  @description :  this method handles the 'after update' event for the trigger; 
    //  @paramaters : an array of ...
    //  @returns : nothing
    public void OnAfterUpdate(Case[] pOldCases, Case[] pUpdatedCases, map<ID, sobject> pCaseMap)
    {/* currently not implemeneted */ }


/* =============================================  TEST METHODS  ============================================= */

    private static testMethod void testCaseTriggerHandler_New_1(){
        CT_ITriggerHandler.ICaseTriggerHandler handler = null;
        handler = new CT_CaseTriggerHandler(true, 1);
        System.assert(handler != null);
    }


}