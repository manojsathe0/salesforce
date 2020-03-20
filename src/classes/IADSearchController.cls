global without sharing class IADSearchController
{ 
    public string phoneNum {get;set;} // search keyword, set either by invoking page or via URI
    public string firstName {get;set;} // set by invoking page
    public string lastName {get;set;} // set by invoking page
    public string email {get;set;} // set by invoking page
    
    public string stateOfFormation{get;set;} // set by invoking page
    public string caseNumber{get;set;} // set by invoking page
    public string orderNumber{get;set;} // set by invoking page
    public string processingNumber{get;set;} // set by invoking page
    public string entityName{get;set;} // set by invoking page
    public string profile_override{get;set;} // if we want to override the user profile
  
    
    public string saveURL {get;set;}
    public string openCustomSearch {get;set;}

    public Boolean isSales {get;set;}
    public Boolean runSearch {get;set;}
    
    //PJB: To contain the grouping of results for eachobj id, set via refreshpage
    public static string ixnId {get;set;} // interaction id, set via URI
    public string inServiceCloudConsole {get;set;} // set in constructor
    
    public IADSearchController() 
    {

        String user_profile_name ='';
        List<Profile> active_profile_list = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(active_profile_list.size() > 0)
        {
            user_profile_name = active_profile_list[0].Name;
            system.debug('*** profile name = ' + user_profile_name);
        }
        if(user_profile_name.contains('Sales'))
        {
            isSales = true;
        }
        else
        {
            isSales = true;//temp
        }
        SYSTEM.DEBUG('is sales ' + isSales);
       
        saveURL = System.currentPageReference().getUrl();
        system.debug('*** CustomLookupController saveURL ' + saveURL);
        openCustomSearch = System.currentPageReference().getParameters().get('openCustomSearch');
        system.debug('*** CustomLookupController openCustomSearch ' + openCustomSearch);
        // get the current search string

        //useful for testing:
        //System.currentPageReference().getParameters().put('lkfirst', 'test1');

        //System.currentPageReference().getParameters().put('lklast', 'lname');

        saveURL = System.currentPageReference().getUrl();

        phoneNum = System.currentPageReference().getParameters().get('lksrch');
        firstName = System.currentPageReference().getParameters().get('lkfirst');
        lastName = System.currentPageReference().getParameters().get('lklast');
        email = System.currentPageReference().getParameters().get('lkemail');
        stateOfFormation = System.currentPageReference().getParameters().get('lkformation');
        caseNumber = System.currentPageReference().getParameters().get('lkcase');
        orderNumber = System.currentPageReference().getParameters().get('lkorder');
        processingNumber = System.currentPageReference().getParameters().get('lkprocessing');
        entityName = System.currentPageReference().getParameters().get('lkentity');
        profile_override = System.currentPageReference().getParameters().get('lkprofile');      
        
        ixnId = System.currentPageReference().getParameters().get('ixnId');
        inServiceCloudConsole = System.currentPageReference().getParameters().get('inServiceCloudConsole');
        system.debug('*** CustomLookupController ixnId ' + ixnId);
        system.debug('*** CustomLookupController inServiceCloudConsole '+inServiceCloudConsole);
        system.debug('*** CustomLookupController search for '+phoneNum);      


        runSearch = false;
        if ((phoneNum != '' && phoneNum != null) ||
            (firstName != '' && firstName != null) ||
            (lastName != '' && lastName != null) ||
            (email != '' && email != null) ||
            (stateOfFormation != '' && stateOfFormation != null) ||
            (caseNumber != '' && caseNumber != null) ||
            (orderNumber != '' && orderNumber != null) ||
            (processingNumber != '' && processingNumber != null) ||
            (entityName != '' && entityName != null)
            ) 
        {
            runSearch = true;
        }
        
         system.debug('runSearch '+runSearch);    
    }
    //Contact
    public static List<Schema.FieldSetMember> getContactTableFields() 
    {
        return SObjectType.Contact.FieldSets.g_Table_Fields.getFields();
    }
    public static String getContactTableFieldsSerialized()
    {
        return JSON.serialize(getContactTableFields());
    }
    
    public static String getContactTableFieldsCommaSeparated()
    {
        String retVal = '';
        for(Schema.FieldSetMember fsm : getContactTableFields())
        {
            retVal += fsm.getFieldPath() + ',';
        }
        retVal = retVal.removeEnd(',');
        system.Debug('retVal = ' + retVal);
        return retVal;
    }
    //Order
    public static List<Schema.FieldSetMember> getOrderTableFields() 
    {
        return SObjectType.Order__c.FieldSets.g_Table_Fields.getFields();
    }
    public static String getOrderTableFieldsSerialized()
    {
        return JSON.serialize(getOrderTableFields());
    }
    
    public static String getOrderTableFieldsCommaSeparated()
    {
        String retVal = '';
        for(Schema.FieldSetMember fsm : getOrderTableFields())
        {
            retVal += fsm.getFieldPath() + ',';
        }
        retVal = retVal.removeEnd(',');
        
        return retVal;
    }
    //Order Items
    public static List<Schema.FieldSetMember> getOrderItemsTableFields() 
    {
        return SObjectType.Order_Item__c.FieldSets.g_Table_Fields.getFields();
    }
    public static String getOrderItemsTableFieldsSerialized()
    {
        return JSON.serialize(getOrderItemsTableFields());
    }
    
    public static String getOrderItemsTableFieldsCommaSeparated()
    {
        String retVal = '';
        for(Schema.FieldSetMember fsm : getOrderItemsTableFields())
        {
            retVal += fsm.getFieldPath() + ',';
        }
        retVal = retVal.removeEnd(',');
        
        return retVal;
    }
    //Case
    public static List<Schema.FieldSetMember> getCaseTableFields() 
    {
        return SObjectType.Case.FieldSets.g_Table_Fields.getFields();
    }
    public static String getCaseTableFieldsSerialized()
    {
        return JSON.serialize(getCaseTableFields());
    }
    
    public static String getCaseTableFieldsCommaSeparated()
    {
        String retVal = '';
        for(Schema.FieldSetMember fsm : getCaseTableFields())
        {
            retVal += fsm.getFieldPath() + ',';
        }
        retVal = retVal.removeEnd(',');
        
        return retVal;
    }
    //Lead
    public static List<Schema.FieldSetMember> getLeadTableFields() 
    {
        return SObjectType.Lead.FieldSets.g_Table_Fields.getFields();
    }
    public static String getLeadTableFieldsSerialized()
    {
        return JSON.serialize(getLeadTableFields());
    }
    
    public static String getLeadTableFieldsCommaSeparated()
    {
        String retVal = '';
        for(Schema.FieldSetMember fsm : getLeadTableFields())
        {
            retVal += fsm.getFieldPath() + ',';
        }
        retVal = retVal.removeEnd(',');
        
        return retVal;
    }
    @RemoteAction
    global static String doSOSLSearch(List<String> searchTerms)
    {
        try
        {
            String fName = searchTerms[0];
            String lName = searchTerms[1];
            String phone = searchTerms[2];
            String email = searchTerms[3];
            String oNumber = searchTerms[4];
            String pNumber = searchTerms[5];
            String state = searchTerms[6];
            String entity = searchTerms[7];
            String caseNum = searchTerms[8];

            Boolean isSales = false;


            String searchTerm = '';

            
            try
            {
                if(phone != null && phone != '')
                {
                    String regExp = '[() -]';
                    String formattingRemoved = phone.replaceAll(regExp,'');
                    String formattedPhone = formattingRemoved;
                    if(phone.length()==10)
                        formattedPhone = '(' + phone.substring(0,3) + ') ' + phone.substring(3,6) + '-' + phone.substring(6,10);
                    else if(phone.length()==11)
                    {
                        if(phone.substring(0,1)=='1')
                            formattedPhone = '(' + phone.substring(1,4) + ') ' + phone.substring(4,7) + '-' + phone.substring(7,11);
                        else
                            formattedPhone = phone;
                    }
                    phone = formattedPhone;
                    searchTerms[2] = formattedPhone;
                }
            }
            catch(Exception e)
            {
                //phone exception
                system.debug('phone exception');
            }

            for(String str : searchTerms)
            {
                if(str != '')
                {
                    searchTerm += str + ' AND ';
                }
            }

            if(searchTerm != '' && searchTerm.contains(' AND '))
            {
                searchTerm = searchTerm.removeEnd(' AND ');
            }

            system.debug('searchTerm ' + searchTerm);

            List<List<SObject>> searchList = [FIND :searchTerm IN ALL FIELDS RETURNING 
                Contact(Id, Contact_Type__c, Customer_Login_Email__c, Name, Phone, HomePhone, MobilePhone, OtherPhone, Fax, Email, MailingCity, MailingState 
                    where (FirstName =: fName OR LastName =: lName OR Email =: email OR (Phone =: phone OR HomePhone =: phone OR MobilePhone =: phone OR OtherPhone =: phone )) limit 200) , 
                Order__c(Id, Name, Entity_Name__c, Base_Product_Name__c, User_Order_ID__c, Contact__c, Customer_Login__c, Processing_Status__c, Order_Date_Time_Created__c, State_Of_Formation__c
                    where (Name =: oNumber OR State_Of_Formation__c =: state OR Entity_Name__c =: entity OR Contact__r.FirstName =:fName OR Contact__r.LastName =: lName OR Contact__r.Email =: email OR User_Order_ID__c =:pNumber)  limit 200), 
                Case(Id, CaseNumber, Status, Subject, Priority, CreatedDate, ContactId, AccountId, OwnerID, Processing_Number__c
                    where (CaseNumber =: caseNum OR Contact.FirstName =: fName OR Contact.LastName =:lName OR Contact.Email =: email) limit 200),
                Order_Item__c(Id, Name,  Order__c, User_Order_ID__c, Product_Name__c, Relationship_Type__c, Order_Item_Date_Time_Created__c 
                    where (Order__r.Contact__r.FirstName =: fName OR Order__r.Contact__r.LastName =: lName OR Order__r.Contact__r.Email =: email OR Order__r.Name =: oNumber) limit 200),
                Lead(Id, ConvertedAccountId, LastActivityDate, Status, Contact_Status_TEXT__c, Owner.Alias, Name, Street, FirstName, LastName, Email, Phone 
                    where (FirstName =:fName OR LastName =: lName OR Email =: email) limit 200)];

            List<Contact> contacts = searchList[0];

            system.debug('contact size before ' + contacts.size());

            Set<Id> contactIds = new Set<Id>();
            Set<Id> orderItemIds = new Set<Id>();
            Set<Id> caseIds = new Set<Id>();

            for(Sobject c : searchList[0])
            {
                contactIds.add(c.Id);
            }           
            List<Order__c> orders = searchList[1];
            if(orders.size() > 0)
            {
                for(Order__c rec : orders)
                {
                    contactIds.add(rec.Contact__c);
                }
            }
            List<Case> cases = searchList[2];
            if(cases.size() > 0)
            {
                for(Case rec : cases)
                {
                    contactIds.add(rec.ContactId);
                }
            }
            List<Order_Item__c> orderItems = searchList[3];
            if(orderItems.size() > 0)
            {
                for(Order_Item__c rec : orderItems)
                {
                    orderItemIds.add(rec.Order__c);
                }
            }
            List<Order__c> ordersFromOrderItems = [select Id, Contact__c from Order__c where Id in: orderItemIds];
            if(ordersFromOrderItems.size() > 0)
            {
                for(Order__c rec : ordersFromOrderItems)
                {
                    contactIds.add(rec.Contact__c);
                }
            }

            List<SObject> newContacts = [Select Id, Contact_Type__c, Customer_Login_Email__c, Name, Phone, HomePhone, MobilePhone, OtherPhone, Fax, Email, MailingCity, MailingState from Contact where Id in:contactIds];
            searchList[0].clear();
            searchList[0].addAll(newContacts);
            system.debug('contact size after ' + contacts.size());

            system.debug(searchList);
            return JSON.serialize(searchList);
        }
        catch(Exception e)
        {
            //do whatever error handling we have
            system.debug('***Exception ' + e.getMessage() + ' on ' + e.getLineNumber());
            return '***Exception ' + e.getMessage() + ' on ' + e.getLineNumber();
        }
    }
    @RemoteAction
     global static String performSearch(List<String> searchTerms) 
     {
        try
        {
            system.debug('searchtearms ' + searchTerms);
            
            String firstName = searchTerms[0];
            String lastName = searchTerms[1];
            String phoneNum = searchTerms[2];
            String email = searchTerms[3];
            String orderNumber = searchTerms[4];
            String processingNumber = searchTerms[5];
            String stateOfFormation = searchTerms[6];
            String entityName = searchTerms[7];
            String caseNumber = searchTerms[8];
    
            Boolean isSales = false;
    
    
            String searchTerm = '';
            
            
            List<Order_Item__c>  order_item_results = new List<Order_Item__c>();
            List<Order__c>  order_results = new List<Order__c>();
            List<Case> case_results = new List<Case>();
            List<Contact> contact_results = new List<Contact>();
            List<g_ContactContainer> contactGroupings = new List<g_ContactContainer>();
            List<Lead> lead_results = new List<Lead>();
            Integer contact_count=0;
            Integer lead_count=0;   
            String searchMessage = '';
            
            String listLimit = '200';
            
            Boolean caseSearch = false;
            Boolean itemSearch = false;
            Boolean orderSearch = false;
            Boolean contactSearch = false;
            Boolean leadSearch = false;
            
            List<List<SObject>> objs = null;
            Integer listSize = 0;
            
            String user_profile_name='';
            
            List<Profile> active_profile_list = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            if(active_profile_list.size() > 0)
            {
                user_profile_name = active_profile_list[0].Name;
                system.debug('*** profile name = ' + user_profile_name);
            }
            if(user_profile_name.contains('Sales'))
            {
                isSales = true;
            }
            else
            {
                isSales = false;
            }
                    
            String findString = '';
            String orderWhereItemString = '';
            String orderWhereString = '';
            String caseWhereString = '';
            String leadWhereString = '';
            String contactWhereString = '';
            
            
            if((phoneNum != null && phoneNum != ''))
            {
                if(phoneNum.length()>1)
                {
                    String regExp = '[() -]';
                    String formattingRemoved = phoneNum.replaceAll(regExp,'');
                    findString += ((findString.length()>0) ? ' OR ' : '') + formattingRemoved;          
                    String formattedPhone = phoneNum;
                    if(phoneNum.length()==9)
                        formattedPhone = phoneNum;
                    else if(phoneNum.length()==10)
                        formattedPhone = '(' + phoneNum.substring(0,3) + ') ' + phoneNum.substring(3,6) + '-' + phoneNum.substring(6,10);
                    else if(phoneNum.length()==11)
                    {
                        if(phoneNum.substring(0,1)=='1')
                            formattedPhone = '(' + phoneNum.substring(1,4) + ') ' + phoneNum.substring(4,7) + '-' + phoneNum.substring(7,11);
                        else
                            formattedPhone = phoneNum;
                    }
                    system.Debug('phone: ' + formattedPhone);
                    leadWhereString +=  ((leadWhereString.length()>0) ? ' AND ' : '') + ' Phone=\'' +formattedPhone + '\'';
                    contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' (Phone=\'' + formattedPhone + '\' OR HomePhone=\'' + formattedPhone + '\' OR MobilePhone=\'' + formattedPhone + '\' OR OtherPhone=\'' + formattedPhone + '\' OR Fax=\'' + formattedPhone + '\')';
                    
                    contactSearch=true;
                    leadSearch=true;
                }
            }
            if(firstName!=null && firstName!='')
            {
                if(firstName.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + firstName;
                    orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Contact__r.FirstName=\'' + firstName + '\'';
                    orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Contact__r.FirstName=\'' + firstName + '\'';
                    caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' Contact.FirstName=\'' + firstName + '\'';
                    leadWhereString += ((leadWhereString.length()>0) ? ' AND ' : '') + ' FirstName=\'' + firstName + '\'';
                    contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' FirstName=\'' + firstName + '\'';            
                    
                    contactSearch=true;
                    leadSearch=true;
                }
            }
            if(lastName!=null && lastName!='')
            {
                if(lastName.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + lastName;
                    orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Contact__r.LastName=\'' + lastName + '\'';
                    orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Contact__r.LastName=\'' + lastName + '\'';
                    caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' Contact.LastName=\'' + lastName + '\'';
                    leadWhereString += ((leadWhereString.length()>0) ? ' AND ' : '') + ' LastName=\'' + lastName + '\'';
                    contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' LastName=\'' + lastName + '\'';          
                    
                    contactSearch=true;
                    leadSearch=true;
                }
            }
            if(email!=null && email!='')
            {
                if(email.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + email;
                    orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Contact__r.Email=\'' + email + '\'';
                    orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Contact__r.Email=\'' + email + '\'';
                    caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' Contact.Email=\'' + email + '\'';
                    leadWhereString += ((leadWhereString.length()>0) ? ' AND ' : '') + ' Email=\'' + email + '\'';
                    contactWhereString += ((contactWhereString.length()>0) ? ' AND ' : '') + ' Email=\'' + email + '\'';            
                            
                    contactSearch=true;
                    leadSearch=true;
                }
            }
             system.debug('*** stateOfFormation = ' + stateOfFormation);
              system.debug('*** entityName = ' + entityName);
            if (stateOfFormation != null && stateOfFormation != '' && entityName != null && entityName != '')
            {
                if(stateOfFormation.length()>1 && entityName.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + stateOfFormation;
                    orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' State_of_Formation__c=\'' + stateOfFormation + '\'';         
        
                    findString += ((findString.length()>0) ? ' OR ' : '') + entityName;
                    orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Entity_Name__c=\'' + entityName + '\'';
                    
                    orderSearch=true;
                }
            }
            if (caseNumber != null && caseNumber != '')
            {
                if(caseNumber.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + caseNumber;
                    //caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' CaseNumber like \'%' + caseNumber + '\'';
                    caseWhereString += ((caseWhereString.length()>0) ? ' AND ' : '') + ' CaseNumber=\'' + caseNumber + '\'';
                    
                    caseSearch=true;
                }                   
            }
            if (orderNumber != null && orderNumber != '')
            {
                if(orderNumber.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + orderNumber;
                    orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' Order__r.Name=\'' + orderNumber + '\'';
                    orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' Name=\'' + orderNumber + '\'';
                    
                    orderSearch=true;
                }           
            }      
            if (processingNumber != null && processingNumber != '')
            {
                if(processingNumber.length()>1)
                {
                    findString += ((findString.length()>0) ? ' OR ' : '') + processingNumber;
                    orderWhereItemString += ((orderWhereItemString.length()>0) ? ' AND ' : '') + ' User_Order_ID__c=\'' + processingNumber + '\'';
                    
                    itemSearch=true;
                    
                    // orderWhereString += ((orderWhereString.length()>0) ? ' AND ' : '') + ' User_Order_ID__c=\'' + processingNumber + '\'';
                    
                    // orderSearch=true;
                }           
            }
            system.debug('here after search bools');
            if(findString != '')
            {
                try{    
                        Integer itemIndex=-1;
                        Integer orderIndex=-1;
                        Integer caseIndex=-1;
                        Integer contactIndex=-1;
                        Integer leadIndex=-1;
                        Integer currentIndex=0;
                        String soslString = 'FIND { ' + findString + '} in ALL FIELDS returning ';
                        
                        if(itemSearch)
                        {
                            itemIndex=currentIndex;                 
                            soslString += (currentIndex>0 ? ', ' : '') +' Order_Item__c(Id, '+ getOrderItemsTableFieldsCommaSeparated() + ' where ' + orderWhereItemString + ' LIMIT ' + listLimit + ')';
                            currentIndex++;                 
                        }
                        if(orderSearch)
                        {
                            orderIndex=currentIndex;                    
                            soslString += (currentIndex>0 ? ', ' : '') +' Order__c(Id, Order_Payment_Status__c, '+ getOrderTableFieldsCommaSeparated() + '  where ' + orderWhereString + ' LIMIT ' + listLimit + ')';
                            currentIndex++;                 
                        }
                        if(caseSearch)
                        {
                            caseIndex=currentIndex;                 
                            soslString += (currentIndex>0 ? ', ' : '') +' Case(Id, Contact.Id, Owner.Alias, Queue__c, '+ getCaseTableFieldsCommaSeparated() + '  where ' + caseWhereString + ' LIMIT ' + listLimit + ')';
                            currentIndex++;                 
                        }
                        if(contactSearch)
                        {
                            contactIndex=currentIndex;                  
                            soslString += (currentIndex>0 ? ', ' : '') +' Contact(Id, Account.Name, Owner.Alias, Phone, AssistantPhone, OtherPhone, LastActivityDate, '+ getContactTableFieldsCommaSeparated() + '  where ' + contactWhereString + ' LIMIT ' + listLimit + ')';
                            currentIndex++;                 
                        }
                        if(leadSearch && user_profile_name.indexOf('Sales')==0)
                        {
                            leadIndex=currentIndex;                 
                            soslString += (currentIndex>0 ? ', ' : '') +' Lead(Id, Owner.Alias, ConvertedAccountId, Street, '+ getLeadTableFieldsCommaSeparated() + '  where ' + leadWhereString + ' LIMIT ' + listLimit + ')';
                            currentIndex++;                 
                        }
                        system.debug('*** SOSL String = ' + soslString);
                    
                        objs = search.query(soslString);
                  
                    }catch (QueryException e) {
                        system.debug('*** ERROR = ' + e); 
                    }   
                
                    Set<Id> contactIds = new Set<Id>();
                    Set<Id> orderItemIds = new Set<Id>();
                    Set<Id> caseIds = new Set<Id>();
                    List<Contact> contacts = new List<Contact>();
                    List<Order__c> orders = new List<Order__c>();
                    List<Case> cases = new List<Case>();
                    List<Order_Item__c> orderItems = new List<Order_Item__c>();
                    
                    if(objs != null)
                    {
                        system.debug('objs ' + objs);
                        for(List<SObject> objList : objs)
                        {
                            if(objList instanceof List<Contact> )
                            {
                                contacts = objList;
                            }
                            else if(objList instanceof List<Order__c> )
                            {
                                orders = objList;
                            }
                            else if(objList instanceof List<Case> )
                            {
                                cases = objList;
                            }
                            else if(objList instanceof List<Order_Item__c> )
                            {
                                orderItems = objList;
                            }
                            else
                            {
                                system.debug('here');
                            }
                        }
                    
                        system.debug('contact size before ' + contacts.size());
                        for(Sobject c : contacts)
                        {
                            contactIds.add(c.Id);
                        } 
                        if(orders.size() > 0)
                        {
                            for(Order__c rec : orders)
                            {
                                contactIds.add(rec.Contact__c);
                            }
                        }
                        system.debug('orders size ' + orders.size());
                        if(cases.size() > 0)
                        {
                            for(Case rec : cases)
                            {
                                contactIds.add(rec.ContactId);
                            }
                        }
                        if(orderItems.size() > 0)
                        {
                            for(Order_Item__c rec : orderItems)
                            {
                                orderItemIds.add(rec.Order__c);
                            }
                        }
                        List<Order__c> ordersFromOrderItems = [select Id, Contact__c from Order__c where Id in: orderItemIds];
                        if(ordersFromOrderItems.size() > 0)
                        {
                            for(Order__c rec : ordersFromOrderItems)
                            {
                                contactIds.add(rec.Contact__c);
                            }
                        }
                        
                        
                        List<Contact> newContacts = [Select Id, Contact_Type__c, Customer_Login_Email__c, Name, Phone, HomePhone, MobilePhone, OtherPhone, Fax, Email, MailingCity, MailingState from Contact where Id in:contactIds];
                      
                        Boolean hasContacts = false;
                        for(List<SObject> objList : objs)
                        {
                            if(objList instanceof List<Contact> )
                            {
                                system.debug('clearing contacts');
                                objList = newContacts;
                                hasContacts = true;
                            }
                        }
                        if(!hasContacts)
                        {
                            objs.add(newContacts);
                        }
                        
                        system.debug('contact size after ' + newContacts.size());
                
                        system.debug('*** search complete ' + JSON.serialize(objs));
                    }
                    else
                    {
                        return 'Nothing found';
                    }
                
                    return JSON.serialize(objs);
            }    
            return 'Nothing found';
        }
        catch(Exception e)
        {
            //phone exception
            system.debug('EXCEPTION ' + e.getMessage());
            return 'EXCEPTION ' + e.getMessage();
        }
    }
    public static Contact findContactById(string contactId, String whereClause)
    {
        String contactQuery = 'select Account.Name, Id, Name, FirstName, LastName, MailingStreet, EMail, Contact_Type__c, Customer_Login_Email__c, LastActivityDate, Owner.Alias, Phone, MobilePhone, HomePhone, AssistantPhone, OtherPhone from contact where Id = \'' + contactId + '\'';
        if(whereClause!=null && whereClause!='')
            contactQuery += ' AND ' + whereClause;
        system.debug('*** findContactById Query = ' + contactQuery);
        List<Contact> new_contact_results = Database.query(contactQuery);
                
        if(new_contact_results.size()>0)
            return new_contact_results[0];
        else
            return null;                
    }
    
    //Padma @ @D-06695
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
    //Padma @ @D-06695
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

     
}