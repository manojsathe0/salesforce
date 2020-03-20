public with sharing class CT_WebToCase_Controller extends CT_PageControllerBase
{
    private String CLASSNAME = '\n\n**** CT_WebToCase_Controller.@@METHODNAME()';
    
    //private ApexPages.StandardController sc;
    private Boolean saveSuccessful = false;
    private String returnUrl;
    private String Id;
    
	public CT_WebToCase_Model model {get; private set;}

	public CT_WebToCase_Controller()
	{
        try
        {
            returnUrl = ApexPages.currentPage().getParameters().get('retURL');
            
			model = CT_WebToCase_Model.NewModel(UserInfo.getUserId());
        }
        catch(Exception ex)
        {
            this.ErrorMessageFatal(ex.getMessage());
        }
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/30/2011
	//@description : method to add more attachments
	//@paramaters : none
	//@returns : nothing
	public void EventButtonClickAddAnother()
	{
		model.AddMoreAttachments();
	}

	//@author : CloudTrigger, Inc.
	//@date : 11/30/2011
	//@description : method to create & return a collection of SelectOptions for the Radio Button list
	//@paramaters : none
	//@returns : a collection of SelectOptions for the Radio Button list
	public list<SelectOption> GetRadioButtonOptions()
	{
		list<SelectOption> options = new list<SelectOption>(); 
        options.add(new SelectOption('Y','Yes')); 
        options.add(new SelectOption('N','No'));
        return options;
	}
	
	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to determine the PageReference where the end-user should be sent after Save event
	//@paramaters : none
	//@returns : PageReference where user should be sent after Save event
    private PageReference GetPostSavePageReference(String pId)
    {
    	//String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetPostSavePageReference');
    	//system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
    	PageReference thankYouPage;
    	thankYouPage= Page.LZWTCthankYou;    
        return thankYouPage.setRedirect(true);        
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/18/2011
	//@description : method to save the values entered by the user
	//@paramaters : none
	//@returns : PageReference
	public PageReference EventButtonClickSave()
    {
    	//String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventButtonClickSave');
    	//system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        try
        {
            model.SaveAll();
            saveSuccessful = true;
	        return GetPostSavePageReference('');
        }
        catch(Exception ex)
        {
        	saveSuccessful = false;    
            if(ex instanceof CT_BaseApplicationException)
				this.ErrorMessageFatal(((CT_BaseApplicationException)ex).UserFriendlyMessage);
			else
				this.ErrorMessageFatal(ex.getMessage());
        }
        
        return null;
    }

}