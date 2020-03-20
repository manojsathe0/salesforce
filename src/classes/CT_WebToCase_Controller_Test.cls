@isTest	
private class CT_WebToCase_Controller_Test
{

	static testMethod void test_ControllerCreation_Positive()
	{
		CT_WebToCase_Controller wtc = new CT_WebToCase_Controller();
		system.assert(wtc != null);
	}

	static testMethod void test_ControllerCreation_Positive2()
	{
		CT_WebToCase_Controller wtc = new CT_WebToCase_Controller();
		
		system.assert(wtc.model != null);
		system.assert(wtc.model.NewCase != null);
		system.assert(wtc.model.newAttachments != null);
		system.assert(wtc.model.attachmentFileNames != null);
		system.assert(wtc.model.fileAttachment != null);
	}

    static testMethod void CT_WebToCase_Controller_Load() {
        CT_WebToCase_Controller wtc = new  CT_WebToCase_Controller();
        wtc.EventButtonClickAddAnother();
        wtc.getRadioButtonOptions();
    }
    
    static testMethod void testEventButtonClickSave() {
        CT_WebToCase_Controller wtc = new  CT_WebToCase_Controller();
        system.assert(wtc.model != null);
        system.assert(wtc.model.fileAttachment != null);
        system.assert(wtc.model.newAttachments.size() == 0);
        system.assert(wtc.model.attachmentFileNames.size() == 0);        
        wtc.model.fileAttachment.Name = 'test.txt';  
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        
    	wtc.model.fileAttachment.Body= bodyBlob;
        wtc.EventButtonClickSave();
    }
    
    static testMethod void testEventButtonClickSave_Fail() {
        CT_WebToCase_Controller wtc = new  CT_WebToCase_Controller();
        wtc.model.fileAttachment.Name = 'test.txt';  
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
    	wtc.model.fileAttachment.Body= bodyBlob;
        //wtc.model.newAttachments.add(wtc.model.fileAttachment);
        wtc.EventButtonClickSave();
    }
    
    static testMethod void testEventButtonClickAddAnother() {
        CT_WebToCase_Controller wtc = new  CT_WebToCase_Controller();
        wtc.model.fileAttachment = new Attachment();        
        wtc.model.fileAttachment.Name = 'test.txt';        
        wtc.EventButtonClickAddAnother();
    }
	
	static testMethod void test_EventButtonClickAddAnother()
	{
		CT_WebToCase_Controller wtc = new CT_WebToCase_Controller();
    	
		wtc.model.fileAttachmentName = 'test.txt';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');        
    	wtc.model.fileAttachmentBody= bodyBlob;
    	
    	system.assert(wtc.model.attachmentFileNames.Size() == 0);
    	system.assert(wtc.model.newAttachments.Size() == 0);
		
		wtc.EventButtonClickAddAnother();
		
		system.assert(wtc.model.attachmentFileNames.Size() > 0);
    	//system.assert(wtc.model.newAttachments.Size() > 0);
	}
	
	static testMethod void test_GetRadioButtonOptions()
	{
		CT_WebToCase_Controller wtc = new CT_WebToCase_Controller();
    	list<SelectOption> so;
    	
    	system.assert(so == null);
		
		so = wtc.GetRadioButtonOptions();
		
		system.assert(so != null);
    	system.assert(so.Size() > 1);
	}
	/*
	static testMethod void test_GetPostSavePageReference()
	{
		CT_WebToCase_Controller wtc = new CT_WebToCase_Controller();

    	PageReference pr = wtc.GetPostSavePageReference('');
		
		system.assert(pr == Page.LZWTCthankYou);
	}
	*/
	static testMethod void test_EventButtonClickSave()
	{
		CT_WebToCase_Controller wtc = new CT_WebToCase_Controller();

		wtc.model.fileAttachmentName = 'test.txt';  
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');        
    	wtc.model.fileAttachmentBody= bodyBlob;
		wtc.model.AddMoreAttachments();
		
		wtc.model.NewCase.SuppliedEmail = 'test@testemail.com';		
		wtc.model.NewCase.Subject = 'Test';
		wtc.model.NewCase.Description = 'Test';
		wtc.model.NewCase.Order_Submitted__c = false;

    	try{
    		PageReference pr = wtc.EventButtonClickSave();
    		system.assert(true);
    	}catch(Exception ex){
    		system.assert(false);
    	}
		
		

	}

}