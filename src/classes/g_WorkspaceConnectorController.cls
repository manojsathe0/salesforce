global class g_WorkspaceConnectorController {

    private static DateTime convertTime(String the_time){
        if(the_time==null || the_time.length()<19)
            return null;
        DateTime convertedTime;
        try{
            system.debug('*** convertTime ' + the_time);
            String s_year = the_time.substring(0,4);
            String s_mo = the_time.substring(5,7);
            String s_d = the_time.substring(8,10);
            system.debug('*** year mo d ' + s_year + s_mo + s_d);
            String s_hr = the_time.substring(11,13);
            String s_min = the_time.substring(14,16);
            String s_sec = the_time.substring(17,19);
            system.debug('*** hr min sec' + s_hr + s_min + s_sec);
            Integer year = integer.valueof(s_year);
            Integer d = integer.valueof(s_d);
            Integer mo = integer.valueof(s_mo);
            Integer hr = integer.valueof(s_hr);
            Integer min = integer.valueof(s_min);
            Integer sec = integer.valueof(s_sec);
            convertedTime = DateTime.newInstance(year, mo, d, hr, min, sec);
        }catch(Exception e) {
            system.debug('*** convertTime error ' + e);
        }
        return convertedTime;
    }

    @RemoteAction
    global static void linkActivityToObjectSelected(String objId, String ixnId)
    {
        system.debug('[WSC] linkActivityToObjectSelected using  ' + objId + ' ixnId ' + ixnId);
        DateTime currentTime = system.now();
        Datetime startTime = currentTime.addDays(-1);
        Datetime endTime = currentTime.addMinutes(10);

        Task taskToUpdate;
        //find Activity from ixnId
        try{
            taskToUpdate = [SELECT Id  FROM Task WHERE OwnerId= :UserInfo.getUserID() AND CallObject = :ixnId AND CreatedDate >=: startTime and CreatedDate <=: endTime LIMIT 1];
        } catch(QueryException e){
            system.debug('[WSC] linkActivityToObjectSelected error ' + e);
            return;
        }
        //if found, then update Activity with object
        if(taskToUpdate != null){
            taskToUpdate.whoId = objId;
            try{
                update taskToUpdate;
            } catch(DmlException e) {
                System.debug('[WSC] linkActivityToObjectSelected update error' + e.getMessage());
            }
        }
    }

    @RemoteAction
    global static void updateObjectById(String objId, String ixnId)
    {
        system.debug('[WSC] updateObjectById using  ' + objId + ' ixnId ' + ixnId);

        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix();
        if(objId!=null && objId.indexOf(contactPrefix)==0){
            List<Contact> cobjects = [select name, Genesys_Interaction_Id__c from contact where Id = :objId];
            if(cobjects.size()==1)
            {
                //update Contact with genesysID
                Contact myContact = cobjects[0];
                myContact.Genesys_Interaction_Id__c = ixnId;
                try{
                    update myContact;
                } catch(DmlException e) {
                    System.debug('updateObjectById - update Contact' + e.getMessage());
                }
            }else{System.debug('updateObjectById - Contact not found!');}
        }else if(objId!=null && objId.indexOf(leadPrefix)==0){
            List<Lead> lobjects = [select name, Genesys_Interaction_Id__c from lead where Id = :objId];
            if(lobjects.size()==1)
            {
                //update Contact with genesysID
                Lead myLead = lobjects[0];
                myLead.Genesys_Interaction_Id__c = ixnId;
                try{
                    update myLead;
                } catch(DmlException e) {
                    System.debug('updateObjectById - update Lead' + e.getMessage());
                }
            }else{System.debug('updateObjectById - Lead not found!');}
        }

        return;
    }

    @RemoteAction
    global static Case findCaseFromNumber(String num)
    {
        system.debug('[WSC] findCaseFromNumber using  ' + num);
        try {
            List<Case> cases = [SELECT CaseNumber FROM Case WHERE CaseNumber= :num];
            if(!cases.isEmpty()) {
                // return the first case found (should only be one)
                for (Case c : cases) {
                    return c;
                }
            }
        } catch(QueryException e){
            return null;
        }
        return null;
    }



    @RemoteAction
    global static Object findObjectFromANI(String ANI)
    {
        system.debug('*** findObjectFromANIfor '+ANI);
        Integer listSize = 0;
        //List<SObject> objList;
        SObject obj_found = null;
        try{

            List<List<SObject>> aobjects = [FIND :ANI IN PHONE FIELDS RETURNING Account];
            if (!aobjects.isEmpty()){
                List<Account> accounts = ((List<Account>)aobjects[0]);
                listSize = accounts.size();
                system.debug('*** accounts listSize = ' + listSize);
                if(listSize > 1){
                    return 'multiple found';
                }
                if(listSize != 0){
                    for (List<SObject> objList : aobjects)
                        for (SObject aobj : objList){
                            obj_found = aobj;
                            system.debug('*** findObjectFromANI account = '+ obj_found.Id);
                        }
                }
            }


            List<List<SObject>> cobjects = [FIND :ANI IN PHONE FIELDS RETURNING Contact];
            if (!cobjects.isEmpty()){
                List<Contact> contacts= ((List<Contact>)cobjects[0]);
                listSize = contacts.size();
                system.debug('*** contacts listSize = ' + listSize);
                if(listSize > 1){
                    return 'multiple found';
                }
                if(listSize == 1 && obj_found != null){
                    return 'multiple found';
                }
                if(listSize != 0){
                    for (List<SObject> objList : cobjects)
                        for (SObject cobj : objList){
                            obj_found = cobj;
                            system.debug('*** findObjectFromANI contact = '+ obj_found.Id);
                        }
                }
            }


            List<List<SObject>> lobjects = [FIND :ANI IN PHONE FIELDS RETURNING Lead];
            if (!lobjects.isEmpty()){
                List<Lead> leads= ((List<Lead>)lobjects[0]);
                listSize = leads.size();
                system.debug('*** leads listSize = ' + listSize);
                if(listSize > 1){
                    return 'multiple found';
                }
                if(listSize == 1 && obj_found != null){
                    return 'multiple found';
                }
                if(listSize != 0){
                    for (List<SObject> objList : lobjects)
                        for (SObject lobj: objList){
                            obj_found = lobj;
                            system.debug('*** findObjectFromANI lead= '+obj_found.Id);
                        }
                }
            }

            if(obj_found != null)
                return obj_found;
            return 'not found';

        }
        catch(QueryException e){
            return 'not found';
        }
    }


    @RemoteAction
    global static Object findContactFromANI(String ANI, String genesysID, Boolean checkForPrimary)
    {
        system.debug('***LZ findContactFromANI '+ANI);
        //updated for LZ       
        try{
            //List<List<SObject>> cobjects = [FIND :ANI IN PHONE FIELDS RETURNING Contact];
            /*
            String formattedANI = ANI;
            if(formattedANI.length()==10)
            {
                system.debug('***LZ formatting required: '+ formattedANI);
                formattedANI = '%' + formattedANI.substring(0,3) + '%' + formattedANI.substring(3,6) + '%' + formattedANI.substring(6,10);
            }
            List<Contact> contacts = null;
            if (!objs.isEmpty()) {
                contact_results.addAll((List<Contact>) objs[0]);
                system.debug('*** contact_results = ' + contact_results);            
            List<Contact> cobjects = [select name from contact where HomePhone LIKE :formattedANI AND  contact_type__c = 'Primary Contact'];
            Integer listSize = cobjects.size();
            system.debug('*** listSize = ' + listSize);
            */
            List<List<SObject>> cobjects;
            //only Sales needs to check for primary contact
            system.debug('***LZ findContactFromANI check for primary '+ checkForPrimary);
            if(checkForPrimary)
                cobjects = [find :ANI in phone fields returning Contact(Id WHERE contact_type__c = 'Primary Contact') ];
            else
                    cobjects = [find :ANI in phone fields returning Contact];
            if (!cobjects.isEmpty()){
                List<Contact> contacts= ((List<Contact>)cobjects[0]);
                Integer listSize = contacts.size();
                system.debug('*** contacts listSize = ' + listSize);
                if(listSize != 0){
                    for (List<SObject> objList : cobjects) {
                        for (SObject cobj: objList){
                            system.debug('*** findContactFromANI contact = '+ cobj.Id);
                        }
                    }
                    listSize = contacts.size();
                } else {
                    return 'not found';
                }

                if(listSize > 1){
                    return 'multiple found';
                } else if(listSize < 1){
                    return 'not found';
                }

                //list size must be 1
                //update Contact with genesysID
                contacts[0].Genesys_Interaction_Id__c = genesysID;
                try{
                    update contacts[0];
                } catch(DmlException e) {
                    System.debug('findContactFromANI - update Contact' + e.getMessage());
                }
                return contacts[0];

            }
            else{
                return 'not found';
            }
        }
        catch(QueryException e){
            return null;
        }
    }

    @RemoteAction
    global static String findLeadFromGenesysID(String objectForSearch, String startTime, String endTime)
    {
        //system.debug('*** LZ findLeadFromGenesysID between  ' + startTime + ' and ' + endTime);
        system.debug('*** LZ findLeadFromGenesysID ' + objectForSearch);
        String result = '';
        try {
            /*
            if(startTime != '' && startTime != null && endTime !='' && endTime != null)
            {
                DateTime convertedStartTime = convertTime(startTime);       
                DateTime convertedEndTime = convertTime(endTime);   
                if(convertedStartTime != null && convertedEndTime != null)
                {   
                    List<Lead> leads = [SELECT Id FROM Lead WHERE 
                        CreatedDate >= :convertedStartTime AND 
                        CreatedDate <= :convertedEndTime AND Genesys_Interaction_Id__c = :objectForSearch
                        ORDER BY CreatedDate];          
                    
                    
                    Integer listSize = leads.size();
                    system.debug('*** listSize = ' + listSize);
                    if(listSize != 0){
                        //get the newest one
                        result = leads[0].Id;
                    }
                }
            }
            */
            List<Lead> leads = [SELECT Id FROM Lead WHERE Genesys_Interaction_Id__c = :objectForSearch];
            Integer listSize = leads.size();
            system.debug('*** listSize = ' + listSize);
            if(listSize != 0){
                //should only be one
                result = leads[0].Id;
            }
        } catch(QueryException e){
            return result;
        }
        return result;
    }


    @RemoteAction
    global static Object findLeadFromANI(String ANI, String genesysID)
    {
        system.debug('***LZ findLeadFromANI '+ANI);
        //updated for LZ       
        try{            
/*            String formattedANI = ANI;
            if(formattedANI.length()==10)
            {
                system.debug('***LZ formatting required: '+ formattedANI);
                formattedANI = '%' + formattedANI.substring(0,3) + '%' + formattedANI.substring(3,6) + '%' + formattedANI.substring(6,10);
            }                                 
            List<Lead> lobjects = [select name from lead where Phone LIKE :formattedANI ];
            Integer listSize = lobjects.size();
            system.debug('*** listSize = ' + listSize);
            if(listSize > 1){
                return 'multiple found'; 
            }
            if(listSize == 0){
                return 'not found';
            }*/

            List<List<SObject>> lobjects = [FIND :ANI IN PHONE FIELDS RETURNING Lead];
            if (!lobjects.isEmpty()){
                List<Lead> leads= ((List<Lead>)lobjects[0]);
                Integer listSize = leads.size();
                system.debug('*** leads listSize = ' + listSize);
                if(listSize != 0){
                    for (List<SObject> objList : lobjects) {
                        for (SObject lobj: objList){
                            system.debug('*** findObjectFromANI lead= '+lobj.Id);
                        }
                    }
                } else {
                    return 'not found';
                }
                if(listSize > 1){
                    return 'multiple found';
                }

                //list size must be 1
                //update Lead with genesysID
                leads[0].Genesys_Interaction_Id__c = genesysID;
                try{
                    update leads[0];
                } catch(DmlException e) {
                    System.debug('findLeadFromANI - update Lead' + e.getMessage());
                }
                return leads[0];
            } else {
                return 'not found';
            }
        }
        catch(QueryException e){
            return null;
        }
    }


    @RemoteAction
    global static Object findContactFromEmailAddress(String address)
    {
        system.debug('*** findObjectFromEmailAddress' + address);
        try {
            List<Contact> objects = [select name from contact where email= :address ];
            Integer listSize = objects.size();
            if(listSize == 1){
                //if (!objects.isEmpty()) {
                for (Contact obj : objects) {
                    system.debug('*** findContactFromEmailAddress contact = '+ obj.Name);
                    return obj;
                }
            }
            return null;
        }
        catch(QueryException e){
            return null;
        }
    }

    @RemoteAction
    global static Object findContactFromChatAddress(String theName)
    {
        system.debug('*** findObjectFromChatAddress' + theName);
        try {
            List<Contact> objects = [select name from contact where name= :theName];
            Integer listSize = objects.size();
            if(listSize == 1){
                //if (!objects.isEmpty()) {
                for (Contact obj : objects) {
                    system.debug('*** findObjectFromChatAddresscontact = '+ obj.Name);
                    return obj;
                }
            }
            return null;
        }
        catch(QueryException e){
            return null;
        }
    }


    @RemoteAction
    global static Object findContactFromWorkItemAddress(String theName)
    {
        system.debug('*** findContactFromWorkItemAddress' + theName);
        try {
            List<Contact> objects = [select name from contact where name= :theName];
            Integer listSize = objects.size();
            if(listSize == 1){
                //if (!objects.isEmpty()) {
                for (Contact obj : objects) {
                    system.debug('*** findContactFromWorkItemAddress = '+ obj.Name);
                    return obj;
                }
            }
            return null;
        }
        catch(QueryException e){
            return null;
        }
    }


    @RemoteAction
    global static Object findContactFromOpenMediaAddress(String theName)
    {
        system.debug('*** findContactFromOpenMediaAddress' + theName);
        try {
            List<Contact> objects = [select name from contact where name= :theName];
            Integer listSize = objects.size();
            if(listSize == 1){
                //if (!objects.isEmpty()) {
                for (Contact obj : objects) {
                    system.debug('*** findContactFromOpenMediaAddress = '+ obj.Name);
                    return obj;
                }
            }
            return null;
        }
        catch(QueryException e){
            return null;
        }
    }

    @RemoteAction
    global static String findOrderFromNumber(String orderNo, String genesysID){
        system.debug('*** LZ findOrderFromNumber' );
        String result = 'not found';
        String orderID = '';
        String contactID = '';
        List<Order__c> objects = [select Id, Contact__c from Order__c where Name = :orderNo];
        Integer listSize = objects.size();
        if(listSize == 1){
            result = objects[0].Id + ',' + objects[0].Contact__c;
            //update Contact with genesysID
            try{
                Contact myContact = [select Id from Contact where Id = :objects[0].Contact__c];
                myContact.Genesys_Interaction_Id__c = genesysID;
                update myContact;
            } catch(DmlException e) {
                System.debug('findOrderFromNumber - update Contact' + e.getMessage());
            }
        }
        return result;
    }


    @RemoteAction global static String createActivity(Map<String,String> activityMap){
        system.debug('***LZ createActivity' );
        String result = 'not found';

        String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix();
        String casePrefix = Schema.SObjectType.Case.getKeyPrefix();

        system.debug('*** duration = ' + activityMap.get('Call Duration'));
        String callType = activityMap.get('IXN Type');
        String mediaType = activityMap.get('Media Type');
        String d = activityMap.get('DATE');
        system.debug('*** d   '+ d);
        if(d == '0001-01-01 00:00:00')
            d = '';
        String subject = callType + ' ' + mediaType + ' ' + d;
        String objectToUse = '';
        String duration = activityMap.get('Call Duration');
        Integer durationInSecs = 0;
        if(duration != '')
            durationInSecs = Integer.valueOf(duration);

        DateTime startDate=null;
        try{
            startDate = (activityMap.get('StartDate')=='' && activityMap.get('StartDate')==null) ? null : convertTime(activityMap.get('StartDate'));
        }catch(Exception e) {
            system.debug(e);
        }
        system.debug('*** start date = ' + startDate);

        DateTime endDate=null;
        try{
            endDate = (activityMap.get('EndDate')=='' && activityMap.get('EndDate')==null) ? null : convertTime(activityMap.get('EndDate'));
        }catch(Exception e) {
            system.debug(e);
        }

        system.debug('*** end date = ' + endDate);

        if(activityMap.get('sfdc Object Id')!= ''){
            system.debug('*** createActivity sfdc Object Id = ' + activityMap.get('sfdc Object Id'));
            objectToUse = activityMap.get('sfdc Object Id');
        }
        else {
            //do a search
            String field_value = activityMap.get('fieldValue');
            String field_name = activityMap.get('fieldName');
            if(field_value != '' && field_name != ''){
                Object searchObj = g_WorkspaceConnectorController.findObject(field_name,field_value);
                if(searchObj != null){
                    SObject sobj = (SObject) searchObj;
                    objectToUse = sobj.Id;
                }
            }
        }
        system.debug('*** createActivity for object ' + objectToUse);

        String prefix = '';
        if(objectToUse != '')
            prefix = objectToUse.substring(0, 3);
        system.debug('*** prefix = '+prefix);

        if(callType == 'Chat-Inbound')
            callType = 'Chat';
        else
            callType = 'Call';

        String sourceNum = activityMap.get('Source Number');
        String queue = activityMap.get('Queue');
        String DNIS = activityMap.get('DNIS');


        Task t = new Task (
                //Type = 'Call',
                Type = callType,
                Status = 'Completed',
                Subject = subject,
                CallDurationInSeconds = durationInSecs,
                Date_Time_Call_Start__c = startDate,
                Date_Time_Call_End__c = endDate,
                Description = activityMap.get('Comments'),
                CallDisposition = activityMap.get('Disposition'),
                CallObject = activityMap.get('GenesysId'),
                Queue2__c = queue,
                DNIS__c = DNIS,
                Source_Number__c = sourceNum
        );

        String verifiedTime = activityMap.get('VerificationTimeStamp');
        system.debug('*** Verification Time Stamp: ' + verifiedTime);
        String isVerified = activityMap.get('IsVerified');
        system.debug('*** Is Verified: ' + isVerified);
        DateTime convertedVerifiedTime = verifiedTime!=null && verifiedTime!='' ? convertTime(verifiedTime) : null;
        Boolean convertedIsVerified = isVerified!=null && isVerified!='' && (isVerified=='True' || isVerified=='true') ? true : false;
        if(convertedVerifiedTime!=null)
            t.Date_Time_Customer_Verification__c = convertedVerifiedTime;
        t.Is_Customer_Verified__c = convertedIsVerified;
        String callDirection = (activityMap.get('Call Direction')!='Inbound' && activityMap.get('Call Direction')!='Outbound') ? null : activityMap.get('Call Direction');
        if(callDirection!=null)
            t.Inbound_Outbound__c = callDirection;

        if(prefix == accountPrefix || prefix == casePrefix){
            system.debug('*** create task for account or case');
            t.put('WhatId',objectToUse);
        }
        else{
            t.put('WhoId',objectToUse);
        }

        if(prefix == contactPrefix)
        {
            Contact contact= [SELECT AccountId, Id FROM Contact WHERE Id= :objectToUse];
            system.debug('*** create task for contact');
            t.put('WhatId',contact.AccountId);
            contact.Genesys_Interaction_Id__c =  activityMap.get('GenesysId');
            update contact;
        }
        if(prefix == leadPrefix)
        {
            Lead lead= [SELECT Id FROM Lead WHERE Id= :objectToUse];
            system.debug('*** create task for lead');
            lead.Genesys_Interaction_Id__c =  activityMap.get('GenesysId');
            update lead;
        }

        String mySFDCfield = '';
        String mySFDCvalue = '';
        if (activityMap.get('SFDC1field') != '' && (activityMap.get('SFDC1field') != null) && activityMap.get('SFDC1value') != '' && activityMap.get('SFDC1value') != null)
        {
            mySFDCfield = activityMap.get('SFDC1field');
            mySFDCvalue = activityMap.get('SFDC1value');
            system.debug('*** mySFDCfield1 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC2field') != '' && (activityMap.get('SFDC2field') != null) && activityMap.get('SFDC2value') != '' && activityMap.get('SFDC2value') != null)
        {
            mySFDCfield = activityMap.get('SFDC2field');
            mySFDCvalue = activityMap.get('SFDC2value');
            system.debug('*** mySFDCfield2 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC3field') != '' && (activityMap.get('SFDC3field') != null) && activityMap.get('SFDC3value') != '' && activityMap.get('SFDC3value') != null)
        {
            mySFDCfield = activityMap.get('SFDC3field');
            mySFDCvalue = activityMap.get('SFDC3value');
            system.debug('*** mySFDCfield3 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC4field') != '' && (activityMap.get('SFDC4field') != null) && activityMap.get('SFDC4value') != '' && activityMap.get('SFDC4value') != null)
        {
            mySFDCfield = activityMap.get('SFDC4field');
            mySFDCvalue = activityMap.get('SFDC4value');
            system.debug('*** mySFDCfield4 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC5field') != '' && (activityMap.get('SFDC5field') != null) && activityMap.get('SFDC5value') != '' && activityMap.get('SFDC5value') != null)
        {
            mySFDCfield = activityMap.get('SFDC5field');
            mySFDCvalue = activityMap.get('SFDC5value');
            system.debug('*** mySFDCfield5 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }

        try{
            insert t;
        }
        catch(QueryException e){
            return result;
        }
        system.debug('*** Task id = '  +t.Id);
        result = t.Id;
        return result;
    }


    @RemoteAction global static String updateActivity(Map<String,String> activityMap, String activityId){
        system.debug('***LZ updateActivity' );
        String result = 'not updated';
        try {
            String duration = activityMap.get('Call Duration');
            Integer durationInSecs = 0;
            if(duration != '')
                durationInSecs = Integer.valueOf(duration);
            String description = activityMap.get('Comments') + ((activityMap.get('Transcript')!=null && activityMap.get('Transcript')!='') ? '\r\n' + activityMap.get('Transcript') : '');
            String dispo = activityMap.get('Disposition');
            String startTime = activityMap.get('StartDate');
            String endTime = activityMap.get('EndDate');
            String verifiedTime = activityMap.get('VerificationTimeStamp');
            String isVerified = activityMap.get('IsVerified');
            DateTime convertedStartTime = startTime!=null && startTime!='' ? convertTime(startTime): null;
            DateTime convertedEndTime = endTime!=null && endTime!='' ? convertTime(endTime) : null;
            DateTime convertedVerifiedTime = verifiedTime!=null && verifiedTime!='' ? convertTime(verifiedTime) : null;
            Boolean convertedIsVerified = isVerified!=null && isVerified!='' && (isVerified=='True' || isVerified=='true') ? true : false;

            Task taskToUpdate = [SELECT Id,WhoId, Description FROM Task WHERE Id = :activityId LIMIT 1];
            system.debug('*** WhoId = ' + taskToUpdate.WhoId);
            string oldWhoId = taskToUpdate.WhoId;
            String newWhoId = (activityMap.get('sfdc Object Id')== null) ? '' : activityMap.get('sfdc Object Id');
                     //Padma added for D-05342 
            if(newWhoId.startsWithIgnoreCase('00Q')){
                Lead l= [Select Id, isConverted, ConvertedContactId from Lead Where Id=:newWhoId];
                if (l.IsConverted == true){
                    newWhoId=l.ConvertedContactId;
                }
                
            }

            //D-05342 EOC
 			if(taskToUpdate.WhoId == null && newWhoId==''){
                //check for any Leads created during interaction
                List<Lead> recordList;
                if(convertedStartTime != null && convertedEndTime != null)
                {

                    recordList = [SELECT OwnerId,
                            Id,
                            CreatedDate
                    FROM Lead
                    //WHERE OwnerId= :UserInfo.getUserID() AND CreatedDate > 2015-04-07T01:02:03Z];
                    WHERE OwnerId= :UserInfo.getUserID() AND CreatedDate >= :convertedStartTime
                    AND CreatedDate <= :convertedEndTime ORDER BY CreatedDate];


                    Integer listSize = recordList.size();
                    system.debug('*** listSize = ' + listSize);
                    if(listSize != 0){
                        newWhoId = recordList[0].Id;
                    }
                }
            }


            taskToUpdate.CallDurationInSeconds = durationInSecs;

            if(taskToUpdate.Description!=null && taskToUpdate.Description!='')
            {
                /*couldn't get this to work properly, just over write the old note with the new one
                //this to make sure the new description don't include some of what was already in the old description
                String oldString = taskToUpdate.Description.escapeJava();
                String newString = description.escapeJava();
                List<String> finalList = new List<String>();
                 
                String split = '[\r\n]';
                String separator = '\r';
                system.debug('***LZ updateActivity Description - original:' + oldString);               
                system.debug('***LZ updateActivity Description - new:' + newString); 
                
                List<String> oldSet = oldString.split(split);   
                List<String> newSet = newString.split(split);

                Boolean remainingFound=false;
                Integer newSetIndex=0;          
                for(Integer oldIdx=0; oldIdx<oldSet.size() && remainingFound==false; oldIdx++)
                {
                    if(newSet[newSetIndex]==oldSet[oldIdx])
                    {                       
                        remainingFound=true;
                        for(Integer innerIdx=oldIdx+1; innerIdx<oldSet.size() && remainingFound==true && newSetIndex<newSet.size(); innerIdx++)
                        {
                            if(newSet[newSetIndex]!=oldSet[innerIdx])
                                remainingFound=false;
                            newSetIndex++;
                        }
                        if(remainingFound==false)
                        {
                            finalList.add(oldSet[oldIdx]);
                            newSetIndex=0;  
                        }                       
                    }
                    else
                        finalList.add(oldSet[oldIdx]);
                }
                                            
                for(Integer newIdx=0; newIdx<newSet.size(); newIdx++)
                {
                    finalList.add(newSet[newIdx]);
                }

                system.debug('***LZ updateActivity Description - final (' + finalList.size() + '):');
                description='';
                for(Integer lastIdx=0; lastIdx<finalList.size(); lastIdx++)
                {
                    system.debug(finalList[lastIdx].escapeJava());
                    description += finalList[lastIdx] + separator;
                }
                description = description.unescapeJava();
                
                system.debug('***LZ updateActivity new Description:' + description);*/
            }

            if(description != '')
                taskToUpdate.Description = description;
            if(dispo != '')
                taskToUpdate.CallDisposition = dispo;
            if(newWhoId != '')
                taskToUpdate.WhoId = newWhoId;
            if(convertedStartTime!=null)
                taskToUpdate.Date_Time_Call_Start__c = convertedStartTime;
            if(convertedEndTime!=null)
                taskToUpdate.Date_Time_Call_End__c = convertedEndTime;
            if(convertedVerifiedTime!=null)
                taskToUpdate.Date_Time_Customer_Verification__c = convertedVerifiedTime;
            taskToUpdate.Is_Customer_Verified__c = convertedIsVerified;
            String callDirection = (activityMap.get('Call Direction')!='Inbound' && activityMap.get('Call Direction')!='Outbound') ? null : activityMap.get('Call Direction');
            if(callDirection!=null)
                taskToUpdate.Inbound_Outbound__c = callDirection;
            update taskToUpdate;
            result = 'updated';
        } catch(DmlException e) {
            System.debug('updateActivity' + e.getMessage());
        }
        return result;
    }


    @RemoteAction
    global static String createCase(Map<String,String> caseMap)
    {
        system.debug('*** createCase');
        String result = 'case not created';
        String ixnType = caseMap.get('IXN Type');
        String mediaType = caseMap.get('Media Type');
        String subject = ixnType + ' ' + mediaType + ' ' + caseMap.get('DATE');

        Case c = new Case (
                Subject = subject,
                Priority = 'Medium',
                Origin = ixnType
        );


        try{
            insert c;
        }
        catch(QueryException e){
            return result;
        }
        system.debug('*** Case id = '  +c.Id);
        result = c.Id;
        return result;
    }

    @RemoteAction
    global static String addAttachment(String objectId, String descriptionText, String nameText, String mimeType, Blob attachmentBody, String attachmentId)
    {
        system.debug('*** addAttachment to '+objectId);
        try{

            if(attachmentBody != null) {
                Attachment att = getAttachment(attachmentId);

                String newBody = '';
                if(att.Body != null) {
                    newBody = EncodingUtil.base64Encode(att.Body);
                }

                String newAttachmentBody = EncodingUtil.base64Encode(attachmentBody);

                newBody += newAttachmentBody;

                att.Body = EncodingUtil.base64Decode(newBody);
                //att.Body = Blob.valueOf(newBody);

                if(attachmentId == null) {
                    system.debug('*** First time through');
                    att.Name = nameText;
                    att.parentId = objectId;
                }
                upsert att;
                return att.Id;
            } else {
                return 'error';
            }
        }
        catch(QueryException e){
            system.debug('*** addAttachment error ' + e);
            return 'error';
        }
    }

    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
        FROM Attachment
        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }


    @RemoteAction
    global static Object findObject(String searchFieldName, String searchFieldValue){
        system.debug('*** findObject: searchFieldName - ' + searchFieldName +', searchFieldValue - ' + searchFieldValue);
        Object result = null;
        if(searchFieldName == '' || searchFieldValue == '')
            return result;
        String query;
        try{

            query = 'SELECT Id, Name, Phone FROM Account WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
            system.debug('*** Account query = ' + query);
            List<Account> accounts = Database.query(query);
            if (!accounts.isEmpty()){
                Integer listSize = accounts.size();
                if(listSize > 1){
                    return result;
                }
                for (Account a : accounts){
                    system.debug('***  Id = ' + a.Id);
                    system.debug('***  Name = '+ a.Name);
                    system.debug('*** Phone = '+ a.Phone);
                    result = a;
                }
            }
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e);
        }
        //check contact
        try{
            query = 'SELECT Id, Name, Phone FROM Contact WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
            system.debug('*** Contact query = ' + query);
            List<Contact> contacts = Database.query(query);
            if (!contacts.isEmpty()){
                Integer listSize = contacts.size();
                if(listSize > 1){
                    return result;
                }
                for (Contact c: contacts ){
                    system.debug('***  Id = ' + c.Id);
                    system.debug('***  Name = '+ c.Name);
                    system.debug('*** Phone = '+ c.Phone);
                    if(result == null){
                        result = c;
                    }
                    else{
                        //multiple found so return null
                        return null;
                    }
                }
            }
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e);
        }

        //check lead
        try{
            query = 'SELECT Id, Name, Phone FROM Lead WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
            system.debug('*** Contact query = ' + query);
            List<Lead> leads = Database.query(query);
            if (!leads.isEmpty()){
                Integer listSize = leads.size();
                if(listSize > 1){
                    return result;
                }
                for (Lead l: leads ){
                    system.debug('***  Id = ' + l.Id);
                    system.debug('***  Name = '+ l.Name);
                    system.debug('*** Phone = '+ l.Phone);
                    if(result == null){
                        result = l;
                    }
                    else{
                        //multiple found so return null
                        return null;
                    }
                }
            }
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e);
        }

        return result;
    }

    @RemoteAction
    global static Object findObjectFromEmail(String address, String skill, String genesysID){
        system.debug('*** findObjectFromEmail: address - ' + address +', skill - ' + skill);
        if(address == '')
            return null;
        String query;
        try{
            //first try the Customer Login object for the email address
            query = 'SELECT Id, Name, Primary_Contact__c FROM Customer_Login__c WHERE Name = \'' + address + '\'';
            system.debug('*** Customer Login query = ' + query);
            List<Customer_Login__c> customerLogins = Database.query(query);
            if (!customerLogins.isEmpty()){
                Integer listSize = customerLogins.size();
                for (Customer_Login__c c : customerLogins){
                    system.debug('***  Id = ' + c.Id);
                    system.debug('***  Name = '+ c.Name);
                    system.debug('***  Contact = '+ c.Primary_Contact__c);
                }
                if(customerLogins[0].Primary_Contact__c!=null){
                    query = 'SELECT Id, Name, Email FROM Contact WHERE Id = \'' + customerLogins[0].Primary_Contact__c + '\'';
                    system.debug('*** Contact query for Customer Login = ' + query);
                    List<Contact> contacts = Database.query(query);
                    if (!contacts.isEmpty()){
                        listSize = contacts.size();
                        for (Contact c : contacts){
                            system.debug('***  Id = ' + c.Id);
                            system.debug('***  Name = '+ c.Name);
                            system.debug('***  Email = '+ c.Email);
                        }
                        if(listSize==1){
                            Contact myContact = contacts[0];
                            myContact.Genesys_Interaction_Id__c = genesysID;
                            try{
                                update myContact;
                            } catch(DmlException e) {
                                System.debug('findObjectFromEmail - update Contact' + e.getMessage());
                            }
                            return myContact;//return the only match
                        }else if(listSize>1){
                            return 'multiple found';//this should never happen since we use an ID, but they must go to the search page if we had more then one match
                        }
                    }
                }
            }

            //if we didn't get one result with that we need to try the contact objects
            //this will not be done for Sales group - bkk
            if(skill!=null && skill.indexOf('Sales') == -1){
                query = 'SELECT Id, Name, Email FROM Contact WHERE Email = \'' + address + '\'';
                system.debug('*** Contact query = ' + query);
                List<Contact> contacts = Database.query(query);
                if (!contacts.isEmpty()){
                    Integer listSize = contacts.size();
                    for (Contact c : contacts){
                        system.debug('***  Id = ' + c.Id);
                        system.debug('***  Name = '+ c.Name);
                        system.debug('***  Email = '+ c.Email);
                    }
                    if(listSize==1){
                        Contact myContact = contacts[0];
                        myContact.Genesys_Interaction_Id__c = genesysID;
                        try{
                            update myContact;
                        } catch(DmlException e) {
                            System.debug('findObjectFromEmail - update Contact' + e.getMessage());
                        }
                        return myContact;//return the only match
                    }else if(listSize>1){
                        return 'multiple found';//they must go to the search page if we had more then one match
                    }
                }
            }

            if(skill!=null && skill.indexOf('Sales') == 0)//Sales group also checks leads
            {
                //if we didn't get one result with the other two then try the leads
                query = 'SELECT Id, Name, Email FROM Lead WHERE Email = \'' + address + '\'';
                system.debug('*** Lead query = ' + query);
                List<Lead> leads = Database.query(query);
                if (!leads.isEmpty()){
                    Integer listSize = leads.size();
                    for (Lead l : leads){
                        system.debug('***  Id = ' + l.Id);
                        system.debug('***  Name = '+ l.Name);
                        system.debug('***  Email = '+ l.Email);
                    }
                    if(listSize==1){
                        Lead myLead = leads[0];
                        myLead.Genesys_Interaction_Id__c = genesysID;
                        try{
                            update myLead;
                        } catch(DmlException e) {
                            System.debug('findObjectFromEmail - update Lead' + e.getMessage());
                        }
                        return myLead;//return the only match
                    }else if(listSize>1){
                        return 'multiple found';//they must go to the search page if we had more then one match
                    }
                }
            }

            return 'not found';
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e);
        }
        return null;
    }    

/*
   @RemoteAction
    global static String findAccount(String searchFieldName, String searchFieldValue){
        system.debug('*** findAccount: searchFieldName - ' + searchFieldName +', searchFieldValue - ' + searchFieldValue);
        try{

           String query = 'SELECT Id, Name, Phone FROM Account WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
           system.debug('*** findAccount: query = ' + query);            
           List<Account> accounts = Database.query(query);
           //List<Account> accounts = [SELECT Id, Name, Phone FROM Account WHERE Phone = :searchFieldValue]; 
            if (!accounts.isEmpty()){
                Integer listSize = accounts.size();
                if(listSize > 1){
                    return 'multiple found';
                }
                for (Account a : accounts){
                    system.debug('***  Id = ' + a.Id);
                    system.debug('***  Name = '+ a.Name);
                    system.debug('*** Phone = '+ a.Phone);
                    //return json string id  and full name
                    return '{"id":"' + a.Id + '","name":"' + a.Name + '"}';
                }
            }
        }
        catch(QueryException e){
                return 'QueryException ' + e; 
        }
        //check contact
        String query = 'SELECT Id, Name, Phone FROM Contact WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
        system.debug('*** findAccount - contact: query = ' + query);            
        List<Contact> contacts = Database.query(query);
        if (!contacts.isEmpty()){
                Integer listSize = contacts.size();
                if(listSize > 1){
                    return 'multiple found';
                }
                for (Contact c: contacts ){
                    system.debug('***  Id = ' + c.Id);
                    system.debug('***  Name = '+ c.Name);
                    system.debug('*** Phone = '+ c.Phone);
                    //return json string id  and full name
                    return '{"id":"' + c.Id + '","name":"' + c.Name + '"}';
                }
            }
        
        return 'not found';
    }    
*/

    @RemoteAction
    global static String testConnection()
    {
        return 'Active';
    }

    @RemoteAction
    global static String getProfileName() {
        try{
            List<Profile> active_profile_list = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            system.debug('*** profile name = ' + active_profile_list[0].Name);
            return active_profile_list[0].Name;
        }catch(QueryException e){
            system.debug('*** ERROR = ' + e);
        }
        return '';
    }

    @RemoteAction
    global static String getUserId() {
        try{
            return userinfo.getUserId();
        }catch(Exception e){
            system.debug('*** ERROR = ' + e);
        }
        return '';
    }



}