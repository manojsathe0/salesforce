public with sharing class IADCreateCaseController
{

    public Case theCase{get;set;}
    public Id contactId{get;set;}
    public Contact theContact{get;set;}
    public String selectedProduct{get;set;}
    public String selectedtype{get;set;}
    public String selectedStatus{get;set;}
    public String selectedStatusReason{get;set;}
    public List<IAD_Case_Status_Reasons__c> allStatusReasons = new List<IAD_Case_Status_Reasons__c>();
    public final String SERVICE_INQUIRY = 'Service_Inquiry';
    public final String NONE = '--None--';
    public Boolean showModal{get;set;}
    public String newCaseId{get;set;}
    public String caseNumber{get;set;}
    public List<IADMessage> iadMessages{get;set;}
    public Boolean isSuccess{get;set;}


    public IADCreateCaseController(ApexPages.StandardController stdController) {

        theCase = new Case();
        contactId  = stdController.getId();
        theContact = [SELECT  Id , Genesys_Interaction_Id__c FROM Contact WHERE Id = :contactId][0];
        allStatusReasons = [SELECT Status_Reason__c, Product__c, Record_Type__c, Status__c FROM IAD_Case_Status_Reasons__c];
        system.debug('All Status Reasons-----' +allStatusReasons);
        iadMessages = new List<IADMessage>();
        isSuccess = false;

        selectedProduct = NONE;
        selectedtype = 'Service Inquiry';
        selectedStatus = NONE;
        selectedStatusReason = NONE;

    }

    public void dismiss()
    {
        system.debug('called dismiss');
        showModal = false;


        IADOpenCasesModalController.logDismissal();
    }
    public PageReference createCase()
    {
        isSuccess = false;
        system.debug('Inside Create Case');
        iadMessages.clear();
        Boolean isValidProcessingNumber = false;

        if(theCase.Subject == null )
        {

            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must provide a Subject'));
            return null;
        }

        if(selectedProduct == NONE )
        {

            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must Select a Product'));
            return null;
        }


        if(selectedStatus == NONE)
        {

            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must Select a Status'));
            return null;
        }

        if(selectedStatusReason == NONE )
        {

            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must Select a Reason'));
            return null;
        }

        if(theCase.Queue__c == NONE )
        {
            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must Select a Queue'));
            return null;
        }

        if(theCase.Processing_Number__c != null)
        {
            if(theCase.Processing_Number__c.length() <= 9 && theCase.Processing_Number__c.length() >= 7 && theCase.Processing_Number__c.isNumeric())
            {
                isValidProcessingNumber = true;
            }
            if(!isValidProcessingNumber)
            {

                iadMessages.add(IADMessageFactory.createMessage('error' , 'Processing number should be 7-9 digits.'));
                return null;
            }
        }

        if(theCase.Description == '')
        {
            iadMessages.add(IADMessageFactory.createMessage('error' , 'You must provide a Description'));
            return null;
        }


        theCase.Product_Line__c = selectedProduct;
        if(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE.contains(selectedtype))
            theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
        system.debug(theCase);
        system.debug(selectedStatus);
        theCase.Status = selectedStatus;
        theCase.Status_Reasons__c = selectedStatusReason;
        theCase.Assigned_User__c = UserInfo.getUserId();
        theCase.ContactId = contactId;
        system.debug(theCase);

        try
        {
            upsert theCase;
            theCase = [SELECT Id , Contact.Genesys_Interaction_Id__c , Status , Status_Reasons__c , ContactId ,description FROM Case WHERE Id = :theCase.Id];
            newCaseId = theCase.Id;
            system.debug(theCase.Id + '---'+newCaseId);

            ApexPages.currentPage().getParameters().put('caseId', newCaseId);

            Case insertedCase = [SELECT CaseNumber FROM Case WHERE ID =: theCase.ID];
            caseNumber = insertedCase.CaseNumber;

            IADCaseHelper.createActivityForCaseInsert(theCase , theCase.description);
            showModal = true;
            theCase = new Case();


            iadMessages.add(IADMessageFactory.createMessage('success' , 'Case Created!!'));
            isSuccess = true;
        }
        catch(DMLEXception dmlEx)
        {
            if(dmlEx.getMessage().contains('UNABLE_TO_LOCK_ROW'))
                iadMessages.add(IADMessageFactory.createMessage('error' , 'A record related to this is currently being updated, please wait and try again.'));
            else
                    iadMessages.add(IADMessageFactory.createMessage('error' , 'Failed Creating Case!!'));
            if(UtilityLibrary.sendEmail)
                SendExceptionEmail.sendExceptionEmail(dmlEx , 'IAD Exception');
        }

        return null;
    }

    public List<selectOption> getproducts()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Case_Status_Reasons__c.Product__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        system.debug(pickListValues);
        options.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry value : pickListValues)
        {
            options.add(new SelectOption(value.getLabel(), value.getValue()));
        }
        system.debug(options);
        return options;
    }

    public List<selectOption> getTypes()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Case_Status_Reasons__c.Record_Type__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry value : pickListValues)
        {
            if(value.getLabel() != 'Problem')
                options.add(new SelectOption(value.getLabel(), value.getValue()));
        }

        return options;
    }

    public List<selectOption> getStatus()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Case_Status_Reasons__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        if(selectedtype != '--None--' && selectedProduct != '--None--')
        {
            for( Schema.PicklistEntry value : pickListValues)
            {
                options.add(new SelectOption(value.getLabel(), value.getValue()));
            }
        }
        return options;
    }

    public List<selectOption> getStatusReasons()
    {
        List<selectOption> options = new List<selectOption>();
        system.debug(allStatusReasons);

        options.add(new SelectOption('--None--','--None--'));
        if(selectedtype != '--None--' && selectedProduct != '--None--' && selectedStatus != '--None--')
        {

            for(IAD_Case_Status_Reasons__c theReason : allStatusReasons)
            {
                system.debug(theReason.Product__c + '---' + theReason.Record_Type__c + '---' + theReason.Status__c+'---'+theReason.Status_Reason__c+'---'+theReason.Id);
                system.debug(selectedProduct+'---'+selectedtype+'----'+selectedStatus);
                if(theReason.Product__c == selectedProduct && theReason.Record_Type__c == selectedtype && theReason.Status__c == selectedStatus)
                {
                    system.debug('Inside');
                    if(theReason.Status_Reason__c != null)
                        for(String theStatusReason : theReason.Status_Reason__c.Split(';'))
                            options.add(new SelectOption(theStatusReason, theStatusReason));
                }
            }
        }
        system.debug(options);
        return options;
    }



}