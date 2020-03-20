public with sharing class CT_ContactTriggerHandler extends CT_BaseTriggerHandler implements CT_ITriggerHandler.IContactTriggerHandler
{
    final String CLASSNAME = '\n\n**** CT_ContactTriggerHandler.METHODNAME()';
    private integer BatchSize = 0;
    private CT_ContactTriggerHelper helper;

	//	@author : CloudTrigger, Inc.
	//	@date : 11/17/2011
	//	@description : the class constructor method
	//	@paramaters : a Boolean value indicating if a trigger is executing or not, an Integer value indicating the number of records in the batch/list
	//	@returns : nothing
	//	@sample call : CT_ITriggerHandler.IContactTriggerHandler handler = new CT_ContactTriggerHandler(Trigger.isExecuting, Trigger.size);
    public CT_ContactTriggerHandler(boolean isExecuting, integer pTriggerSize)
    {
        TriggerIsExecuting = isExecuting;
        BatchSize = pTriggerSize;
        Profile currentUserProfile = [Select Name From Profile where Id = :UserInfo.getProfileId()];

        helper = CT_ContactTriggerHelper.NewTriggerHelper(currentUserProfile.Name);
    }

	//	@author : CloudTrigger, Inc.
	//	@date : 11/17/2011
	//	@description :  this method handles the 'after insert' event for the trigger; for each new Contact where the Contact Type 
	//					is "Primary Contact," this method sets the Contact Type for all other Contacts on the Account to "Authorized Contact"
	//	@paramaters : an array of Contact objects
	//	@returns : nothing
    public void OnAfterInsert(Contact[] pContacts)
    {
    	String METHODNAME = CLASSNAME.replace('METHODNAME', 'OnAfterInsert');
    	system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' with '+ pContacts.size() +' Contact objects in the array\n\n');

    	try
    	{
	    	if(IsTriggerContext && (!IsVisualforcePageContext && !IsWebServiceContext && !IsExecuteAnonymousContext))
	    	{
	    		list<Contact> ContactsToUpdate = new list<Contact>();
	    		for(Contact cont : pContacts)
	    		{
	    			if(cont.Contact_Type__c == 'Primary Contact')
	    			{
	    				list<Contact> conts = helper.GetContactsToUpdateByAccountId(cont.AccountId, cont.Id);
	    				if(CT_Utility.ValidateList(conts))
	    				{
	    					for(Contact contc : conts)
	    					{
	    						contc.Contact_Type__c = 'Authorized Contact';
	    					}
	    					ContactsToUpdate.addAll(conts);
	    				}
	    			}
	    		}
	    		helper.UpdateContacts(ContactsToUpdate);
	    	}
    	}
    	catch(Exception ex)
    	{
    		if(ex instanceof CT_BaseApplicationException)
    			throw ex;
    		else
	    		throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'A problem has occurred & processing cannot complete successfully - please see system log for details.', ex);
    	}
    }

	//	@author : CloudTrigger, Inc.
	//	@date : 11/17/2011
	//	@description :  this method handles the 'after update' event for the trigger; for each updated Contact where the Contact Type 
	//					is "Primary Contact," this method sets the Contact Type for all other Contacts on the Account to "Authorized Contact" 
	//	@paramaters : an array of "pre-update" Contacts, an array of "post-update" Contacts, and a key/value collection of the updated Contacts
	//	@returns : nothing
    public void OnAfterUpdate(Contact[] pOldContacts, Contact[] pUpdatedContacts, map<ID, sobject> pContactMap)
    {
    	String METHODNAME = CLASSNAME.replace('METHODNAME', 'OnAfterUpdate');

    	try
    	{
	    	if(IsTriggerContext && (!IsVisualforcePageContext && !IsWebServiceContext && !IsExecuteAnonymousContext))
	    	{
	    		list<Contact> ContactsToUpdate = new list<Contact>();
	    		for(Contact cont : pUpdatedContacts)
	    		{
	    			if(cont.Contact_Type__c == 'Primary Contact')
	    			{
	    				list<Contact> conts = helper.GetContactsToUpdateByAccountId(cont.AccountId, cont.Id);
	    				if(CT_Utility.ValidateList(conts))
	    				{
	    					for(Contact contc : conts)
	    					{
	    						contc.Contact_Type__c = 'Authorized Contact';
	    					}
	    					ContactsToUpdate.addAll(conts);
	    				}
	    			}
	    		}
	    		helper.UpdateContacts(ContactsToUpdate);
	    	}
    	}
    	catch(Exception ex)
    	{
    		if(ex instanceof CT_BaseApplicationException)
    			throw ex;
    		else
	    		throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'A problem has occurred & processing cannot complete successfully - please see system log for details.', ex);
    	}
    }

	//	@author : CloudTrigger, Inc.
	//	@date : 11/17/2011
	//	@description :  this method handles the 'before insert' event for the trigger; it's purpose is to ...
	//	@paramaters : an array of Contact objects
	//	@returns : nothing
	public void OnBeforeInsert(Contact[] pNewContacts)
	{/*NOT IN USE*/}

	//	@author : CloudTrigger, Inc.
	//	@date : 11/17/2011
	//	@description :  this method handles the 'after insert' event for the trigger; it's purpose is to ...
	//	@paramaters : an array of Contact objects
	//	@returns : nothing
	public void OnBeforeUpdate(SObject[] pOldContacts, SObject[] pUpdatedContacts, map<ID, SObject> pContactMapNew, map<ID, SObject> pContactMapOld)
	{/*NOT IN USE*/}

/* =============================================  TEST METHODS  ============================================= */

    private static testMethod void testContactTriggerHandler_New_1()
    {
        CT_ITriggerHandler.IContactTriggerHandler handler = null;
        handler = new CT_ContactTriggerHandler(true, 1);
        System.assert(handler != null);
    }


}