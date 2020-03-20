public with sharing class CT_NewAcctCont_Controller extends CT_PageControllerBase
{
    private String CLASSNAME = '\n\n**** CT_NewAcctCont_Controller.@@METHODNAME()';
    
    //private ApexPages.StandardController sc;
    public Boolean saveSuccessful {get; private set;}
    private String returnUrl;
    private String Id;
    
	public CT_NewAcctCont_Model model {get; private set;}

	public CT_NewAcctCont_Controller(ApexPages.StandardController stdController)
	{
        try
        {
            saveSuccessful = false;
            returnUrl = ApexPages.currentPage().getParameters().get('retURL');
            //Id = ApexPages.currentPage().getParameters().get('id');
            
			model = CT_NewAcctCont_Model.NewModel(UserInfo.getUserId());
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,ex.getMessage()));
        }
    }
     
	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to 
	//@paramaters : none
	//@returns : PageReference
    public PageReference EventButtonClickCancel()
    {
        if(CT_Utility.StringIsNullOrEmpty(Id) == false){
	        return GetPostSavePageReference(Id);
    	}else{
	        return GetPostSavePageReference('home/home.jsp');
    	}
    }
    
	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to clear the values on the screen
	//@paramaters : none
	//@returns : nothing
	public void EventButtonClickClear()
	{
		model.NewAcct = new Account();
		model.NewCont = new Contact();
		model.NewCont.Contact_Type__c = 'Primary Contact';
	}

	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to determine the PageReference where the end-user should be sent after Save event
	//@paramaters : none
	//@returns : PageReference where user should be sent after Save event
    private PageReference GetPostSavePageReference(String pId)
    {
    	String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetPostSavePageReference');
    	system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        PageReference newPageReference;
        if(CT_Utility.StringIsNullOrEmpty(returnUrl) == false){
        	newPageReference = new PageReference(returnUrl);
    	}else{
	        newPageReference = new PageReference('/' + pId);
    	}
        newPageReference.setRedirect(true);
        return newPageReference;
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to save the values entered by the user
	//@paramaters : none
	//@returns : PageReference
	public PageReference EventButtonClickSave()
    {
    	String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventButtonClickSave');
    	system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        try
        {
            model.SaveAll();
            saveSuccessful = true;
	        return GetPostSavePageReference(model.NewCont.Id);
        }
		catch(CT_BaseApplicationException bex)
		{
			this.ErrorMessageFatal(bex.UserFriendlyMessage);
			saveSuccessful = false;
			return null;
		}
        catch(DMLException dmle)
        {
            for (Integer i=0; i < dmle.getNumDml(); i++)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmle.getDmlMessage(i)));
            }
            saveSuccessful = false;
            return null;
        }
        catch(Exception ex)
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,ex.getMessage()));
            this.ErrorMessageFatal(ex.getMessage());
            saveSuccessful = false;
            return null;
        }
    }

}