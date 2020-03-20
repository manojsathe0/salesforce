public with sharing class CT_NewAcctCont_Model
{
	private String CLASSNAME = '\n\n**** CT_NewAcctCont_Model.@@METHODNAME()';
	private User CurrentUser;
	
	public Account NewAcct {get;set;}
	public Contact NewCont {get;set;}
	
	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : static method to get a new instance of the CT_NewAcctCont_Model class
	//@paramaters : a String
	//@returns : an instance of the CT_NewAcctCont_Model class
    public static CT_NewAcctCont_Model NewModel(String pUserId)
    {
    	CT_NewAcctCont_Model newModel = new CT_NewAcctCont_Model(pUserId);
    	return newModel;
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : constructor method for the CT_NewAcctCont_Model class
	//@paramaters : a String
	//@returns : an instance of the CT_NewAcctCont_Model class
    private CT_NewAcctCont_Model(String pUserId)
    {
    	CurrentUser = new User();
    	CurrentUser = [SELECT Id, Username, Email, Name, FirstName, LastName FROM User WHERE Id = :pUserId];
    	
    	NewAcct = new Account();
    	NewCont = new Contact();
    	NewCont.Contact_Type__c = 'Primary Contact';
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to save changes (i.e. insert the Account & Contact) to the database
	//@paramaters : none
	//@returns : nothing
    public void SaveAll()
    {
    	String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'SaveAll');
    	system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');

    	Savepoint sp = Database.setSavepoint();
    	try
    	{
    		Database.SaveResult srAcct = Database.insert(NewAcct);
    		
    		if(srAcct.isSuccess())
    		{
    			system.debug(LoggingLevel.INFO, METHODNAME + ' :: Account insert was SUCCESSFUL.\n\n');
    			NewCont.AccountId = srAcct.getId();
    			
    			// set Account login ID as Contact email address
    			NewCont.Email = NewAcct.Name;
    			
    			Database.SaveResult srCont = Database.insert(NewCont);
    			if(srCont.isSuccess())
    			{
    				system.debug(LoggingLevel.INFO, METHODNAME + ' :: Contact insert was SUCCESSFUL.\n\n');
    			}else{
    				system.debug(LoggingLevel.INFO, METHODNAME + ' :: Contact insert FAILED.\n\n');
    				throw CT_BaseApplicationException.NewException(METHODNAME, 'Contact insert FAILED!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.');
    			}
    		}else{
    			system.debug(LoggingLevel.INFO, METHODNAME + ' :: Account insert FAILED.\n\n');
    			throw CT_BaseApplicationException.NewException(METHODNAME, 'Account insert FAILED!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.');
    		}
    	}
		catch(CT_BaseApplicationException bex)
		{
    		Database.rollback(sp);
            throw bex;
		}
    	catch(DMLException dmle)
    	{
    		Database.rollback(sp);
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'DML Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', dmle);
    	}
    	catch(Exception e)
        {
            Database.rollback(sp);
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', e);
        }
    }

}