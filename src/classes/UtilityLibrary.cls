/*

    Common class with reusable methods
updated : B-38758
*/

public class UtilityLibrary 
{
    public final static String INTEGRATION_USER = 'Integration User';
    public final static String PERMISSION_SET1 = 'Temp_New_Endpoint_Modify_Order_Item';
    public static Time GetElapsedTime(Time startTime, Time endTime)
    {
        if(startTime == null || endTime == null)
            return Time.newInstance(0, 0, 0, 0);

        Integer elapsedHours = endTime.hour() - startTime.hour();
        Integer elapsedMinutes = endTime.minute() - startTime.minute();
        Integer elapsedSeconds = endTime.second() - startTime.second();
        Integer elapsedMiliseconds = endTime.millisecond() - startTime.millisecond();

        return Time.newInstance(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMiliseconds);
    }
    public static Time GetElapsedTime(DateTime startDate, DateTime endDate)
    {
         if(startDate == null || endDate == null)
             return Time.newInstance(0, 0, 0, 0);
         return GetElapsedTime(startDate.time(), endDate.time());
    }
    public static Integer GetElapsedMinutes(DateTime startDate, DateTime endDate)
    {
        return GetElapsedTime(startDate, endDate).minute();
    }
    
    public static Datetime parseIADDatetime(String iadDate)
    {
        Datetime dateField;
        system.debug('iad date ' + iadDate);
        
        iadDate = iadDate.substring(0,19);
        iadDate = iadDate.replace('T', ' ');
        
        dateField =  datetime.valueOf(iadDate);
        
        
        system.debug('iad date ' + iadDate);
        
        return dateField;
    }
    public static Date parseIADDate(String iadDate)
    {
        Date dateField;
        iadDate = iadDate.substring(0,10);
        
        dateField = Date.valueOf(iadDate);
        
        return dateField;
    }
    public static String convertJSDateToIADDate(String jsDate, String origTime)
    {
        if(jsDate!= null && jsDate != '')
        {

            system.debug('jsDate ' + jsDate);
            if(jsDate.indexOf(' ') >-1)
            {
                jsDate = jsDate.substring(0, jsDate.indexOf(' '));
            }

            system.debug('jsDate after ' + jsDate);
            if(origTime== null || origTime == '')
                origTime = 'T00:00:00.000Z';
            Date theDate = Date.parse(jsDate);
            Datetime dt = datetime.newInstance(theDate.year(), theDate.month(),theDate.day());
            system.debug('datetime ' + dt);
            return convertToIADDateNonGMT(dt, origTime);
        }
        return null;

    }
    public static Datetime convertJSDateToIADDateDT(String jsDate)
    {
        if(jsDate!= null && jsDate != '')
        {

            system.debug('jsDate ' + jsDate);
            if(jsDate.indexOf(' ') >-1)
            {
                jsDate = jsDate.substring(0, jsDate.indexOf(' '));
            }
            system.debug('jsDate after ' + jsDate);

            Date theDate = Date.parse(jsDate);
            Datetime dt = datetime.newInstance(theDate.year(), theDate.month(),theDate.day());
            system.debug('datetime ' + dt);
            return dt;
        }
        return null;

    }
    public static String convertToIADDateNonGMT(Datetime sfDate, String origTime)
    {
        if(sfDate != null)
        {
            String dateMod = String.valueOf(DateTime.newInstance(sfDate.date(), sfDate.time()));
            dateMod = dateMod.replace(' ', 'T');
            dateMod = dateMod.replace( dateMod.substringAfter('T'), origTime.substringAfter('T'));

            system.debug('convertToIADDate ' + dateMod);
            return dateMod;
        }
        else
        {
            return null;
        }
    }
    public static String convertToIADDate(Datetime sfDate)
    {
        if(sfDate != null)
        {
            String dateMod = String.valueOf(DateTime.newInstanceGmt(sfDate.date(), sfDate.time()));
            dateMod = dateMod.replace(' ', 'T');
            dateMod = dateMod + 'Z';
            system.debug('convertToIADDate ' + dateMod);
            return dateMod;
        }
        else
        {
            return null;
        }
    }
    public static String convertToIADContactActive(Boolean sfInActive)
    {
        return sfInActive==true?'0':'1';
    }
    public static String convertToIADContactType(String sfContactType)
    {
        if(sfContactType == 'Primary Contact')
            return '1';
        if(sfContactType == 'Authorized Contact')
            return '3';
        return '';
    }
    public static Map<Id, Map<Id, Task>> GetCaseTasksMap(Set<Id> caseIds)
    {
        Map<Id, Map<Id, Task>> caseTasksMap = new Map<Id, Map<Id, Task>>();
        
        Map<Id, Task> allCaseTasks =  new Map<Id, Task>([select id, WhatId, Case_Status__c, RecordTypeId, LastModifiedDate, CreatedDate, Minutes_In_Status__c
                                                        from Task where whatId in: caseIds order by CreatedDate desc]);

        for(Task act : allCaseTasks.values())
        {
            if(!caseTasksMap.containsKey(act.whatId))
            {
                Map<Id, Task> tempActs = new Map<Id, Task>();
                tempActs.put(act.Id, act);
                caseTasksMap.put(act.whatId, tempActs);
            }
            else
            {
                caseTasksMap.get(act.whatId).put(act.Id, act);
            }
        }
        
        return caseTasksMap;
    }
    
    public static String getLocalTime(String dateTimeInString)
    {
         DateTime theDateTime = ((datetime)json.deserialize('"'+dateTimeInString+'"', datetime.class));
         String DATE_TIME_FORMAT = 'MM/dd/yyyy hh:mm a';
         TimeZone tz = UserInfo.getTimeZone();
         String localdateTimeInString = theDateTime.format(DATE_TIME_FORMAT, tz.getId());
         return localdateTimeInString;
    }
    
    public static String getIADDateTime(String dateTimeInString)
    {
         DateTime theDateTime = ((datetime)json.deserialize('"'+dateTimeInString+'"', datetime.class));
         String DATE_TIME_FORMAT = 'MM/dd/yyyy hh:mm a';
         TimeZone tz = UserInfo.getTimeZone();
         String localdateTimeInString = theDateTime.formatGMT(DATE_TIME_FORMAT);
         return localdateTimeInString;
    }
    public static Datetime getIADDateTimeDT(String dateTimeInString)
    {
        DateTime theDateTime = ((datetime)json.deserialize('"'+dateTimeInString+'"', datetime.class));
        
        String DATE_TIME_FORMAT = 'yyyy-MM-dd hh:mm:ss';
        String localdateTimeInString = theDateTime.formatGMT(DATE_TIME_FORMAT);
        
        return Datetime.valueOf(localdateTimeInString);
    }
    public static List<Schema.FieldSetMember> getLeadTealiumUpdateFields() 
    {
        return SObjectType.Lead.FieldSets.Tealium_Tracking.getFields();
    }
    
     /*
     By Artyom M.
	  Per: B-18398, B-22719
	  */
    public static List<Schema.FieldSetMember> getOppTealiumUpdateFields() 
    {
        return SObjectType.Opportunity.FieldSets.Tealium_Tracking.getFields();
    }
    public static List<Schema.FieldSetMember> getContactTealiumUpdateFields() 
    {
        return SObjectType.Contact.FieldSets.Tealium_Tracking.getFields();
    }
    public static Map<String,Decimal> stateToStateIdsMap
    {
        get
        {
            if(stateToStateIdsMap == null)
            {
                stateToStateIdsMap = new Map<String,Decimal>();
                for (StatesMap__c stateMap : [SELECT Name, Is_State__c, State_code__c, State_Id__c FROM StatesMap__c  order by Is_State__c desc, Name Asc])
                {
                    stateToStateIdsMap.put(stateMap.Name,stateMap.State_Id__c);
                }
            }
            return stateToStateIdsMap;
        } 
        set;
    }

    public static Map<Decimal,String> stateIdsToStateMap
    {
        get
        {
            if(stateIdsToStateMap == null)
            {
                stateIdsToStateMap = new Map<Decimal,String>();
                for (StatesMap__c stateMap : [SELECT Name, Is_State__c, State_code__c, State_Id__c FROM StatesMap__c  order by Is_State__c desc, Name Asc])
                {
                    stateIdsToStateMap.put(stateMap.State_Id__c,stateMap.Name);
                }
            }
            return stateIdsToStateMap;
        }
        set;
    }

    public static Map<String,String> stateCodeToStateMap
    {
        get
        {
            if(stateCodeToStateMap == null)
            {
                stateCodeToStateMap = new Map<String,String>();
                for (StatesMap__c stateMap : [SELECT Name, Is_State__c, State_code__c, State_Id__c FROM StatesMap__c  order by Is_State__c desc, Name Asc])
                {
                    stateCodeToStateMap.put(stateMap.State_code__c,stateMap.Name);
                }
            }
            return stateCodeToStateMap;
        }
        set;
    }
    public static Map<String,String> stateToStateCodeMap
    {
        get
        {
            if(stateToStateCodeMap == null)
            {
                stateToStateCodeMap = new Map<String,String>();
                for (StatesMap__c stateMap : [SELECT Name, Is_State__c, State_code__c, State_Id__c FROM StatesMap__c  order by Is_State__c desc, Name Asc])
                {
                    stateToStateCodeMap.put(stateMap.Name,stateMap.State_code__c);
                }
            }
            return stateToStateCodeMap;
        }
        set;
    }
    public static List<SelectOption> paymentReasons
    {
        get
        {
            if(paymentReasons== null)
            {
                paymentReasons= new  List<SelectOption>();
                for (IAD_Payment_Reason__c reason : [SELECT ReasonId__c, Reason__c FROM IAD_Payment_Reason__c order by Reason__c asc])
                {
                    paymentReasons.add(new SelectOption(String.valueOf(reason.ReasonId__c), reason.Reason__c));
                }
            }
            return paymentReasons;
        }
        set;
    }
    public static List<SelectOption> refundReasons
    {
        get
        {
            if(refundReasons== null)
            {
                refundReasons= new  List<SelectOption>();
                for (IAD_Refund_Reason__c reason : [SELECT ReasonId__c, Reason__c FROM IAD_Refund_Reason__c order by Reason__c asc])
                {
                    refundReasons.add(new SelectOption(String.valueOf(reason.ReasonId__c), reason.Reason__c));
                }
            }
            return refundReasons;
        }
        set;
    }
    public static List<SelectOption> expMonths
    {
        get
        {
            if(expMonths== null)
            {
                expMonths= new  List<SelectOption>();
                for(integer i=01; i<=12; i++)
                {
                    String theMonth;
                    if(i<=9)
                        theMonth = '0'+String.valueOf(i);
                    else
                        theMonth = String.valueOf(i);

                    expMonths.add(new SelectOption( String.valueOf(i), theMonth));
                }
            }
            return expMonths;
        }
        set;
    }

    public static List<SelectOption> expYears
    {
        get
        {
            if(expYears== null)
            {
                expYears= new  List<SelectOption>();
                for(integer i= System.today().year() ; i<=System.today().year()+25; i++)
                {
                    String theYear = String.valueOf(i);

                    expYears.add(new SelectOption( theYear, theYear));
                }
            }
            return expYears;
        }
        set;
    }

    public static List<SelectOption> statePicklist
    {
        get
        {
            if(statePicklist== null)
            {
                statePicklist= new  List<SelectOption>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c FROM StatesMap__c order by Is_State__c desc, Name Asc])
                {
                    statePicklist.add(new SelectOption(stateMap.State_code__c, stateMap.Name));
                }
            }
            return statePicklist;
        }
        set;
    }
    public static Map<String,String> profileAccountTypeToNameMap
    {
        get
        {
            if(profileAccountTypeToNameMap == null)
            {
                profileAccountTypeToNameMap = new Map<String,String>();
                for (IAD_Account_Type__mdt accountType : [Select pkAccountType__c, MasterLabel from IAD_Account_Type__mdt])
                {
                    profileAccountTypeToNameMap.put(accountType.pkAccountType__c,accountType.MasterLabel);
                }
            }
            return profileAccountTypeToNameMap;
        }
        set;
    }
    public static Map<String,String> profileNameToAccountTypeMap
    {
        get
        {
            if(profileNameToAccountTypeMap == null)
            {
                profileNameToAccountTypeMap = new Map<String,String>();
                for (IAD_Account_Type__mdt accountType : [Select pkAccountType__c, MasterLabel from IAD_Account_Type__mdt])
                {
                    profileNameToAccountTypeMap.put(accountType.MasterLabel, accountType.pkAccountType__c);
                }
            }
            return profileNameToAccountTypeMap;
        }
        set;
    }
    public static Map<String,String> profileAccountTypeToNameMapCC
    {
        get
        {
            if(profileAccountTypeToNameMapCC == null)
            {
                profileAccountTypeToNameMapCC = new Map<String,String>();
                for (IAD_Account_Type__mdt accountType : [Select pkAccountType__c, MasterLabel from IAD_Account_Type__mdt where IAD_Payment_Type__r.MasterLabel = 'Credit Card' order by MasterLabel asc])
                {
                    profileAccountTypeToNameMapCC.put(accountType.pkAccountType__c,accountType.MasterLabel);
                }
            }
            return profileAccountTypeToNameMapCC;
        }
        set;
    }
    public static Map<String,String> paymentTypeToNameMap
    {
        get
        {
            if(paymentTypeToNameMap == null)
            {
                paymentTypeToNameMap = new Map<String,String>();
                for (IAD_Payment_Type__mdt paymentType : [Select pkPaymentType__c, MasterLabel from IAD_Payment_Type__mdt order by MasterLabel asc])
                {
                    paymentTypeToNameMap.put(paymentType.pkPaymentType__c,paymentType.MasterLabel);
                }
            }
            return paymentTypeToNameMap;
        }
        set;
    }
    public static Map<String,String> profilePaymentNameToTypeMap
    {
        get
        {
            if(profilePaymentNameToTypeMap == null)
            {
                profilePaymentNameToTypeMap = new Map<String,String>();
                for (IAD_Payment_Type__mdt paymentType : [select pkPaymentType__c, MasterLabel from IAD_Payment_Type__mdt])
                {
                    profilePaymentNameToTypeMap.put(paymentType.MasterLabel, paymentType.pkPaymentType__c);
                }
            }
            return profilePaymentNameToTypeMap;
        }
        set;
    }
    public static List<SelectOption> paymentTypes
    {
        get
        {
            if(paymentTypes== null)
            {
                paymentTypes= new  List<SelectOption>();
                Map<String,String> accountMap = profileAccountTypeToNameMapCC;
                for(String key : accountMap.keySet() )
                {
                    String theValue = accountMap.get(key);
                    if(theValue!= null)
                        paymentTypes.add(new SelectOption( key, theValue));
                }

            }
            return paymentTypes;
        }
        set;
    }
    public static Boolean validateEmail(String email)
    {
        Boolean res = true;

        if(email.contains('.'))
        {
            List<String> parts = email.split('\\.');
            system.debug('parts ' +  parts);
            if(parts.size()>2)
                return false;
        }
        if(email.contains('@'))
        {
            List<String> parts = email.split('@');
            system.debug('parts ' +  parts);
            if(parts.size()>2)
                return false;
        }

        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches())
            res = false;
        return res;
    }
    public static Boolean isNotNullOrBlank(String theString)
    {
        if(theString != null && theString != '')
            return true;
        else
            return false;
    }
    /*
    A method to check if string is not null or empty, and if not, return the value.
    Created by: Artyom M.
	Per story: B-24116
    */
    public static String ifNotBlankThenCopy(String theString) {
    	if(theString != null && theString != '') {
    		return theString;
    	}
    	else {
    		return '';
    	}
    }
    
    public static String stripStoreCreditOrProfileId(String theId)
    {
        if(isNotNullOrBlank(theId))
            return theId.replace('pp', '').replace('sc', '');
        else
            return '';
    }
	  public static String generateUpdatedBy()
	  {
	      String email = UserInfo.getUserEmail();
	      Integer index = email.indexOf('@');
	      return email.substring(0, index);
	  }
    
   /* public static String generateUpdatedBy()
  {
      String email = UserInfo.getUserEmail();
        Integer index = email.indexOf('@');
        String createdBy = 'LEGALZOOM\\' + email.substring(0, index);
        return createdBy;
  } */

  /*
        The following method added per story B-21273
        By Artyom M.
        Adding 'Legalzoom\\'  prefix to the username, so it is recognized by OM.
     */
    public static String generateUpdatedBy_withPrefix()
    {
        String email = UserInfo.getUserEmail();
        Integer index = email.indexOf('@');
        String createdBy = 'Legalzoom\\' + email.substring(0, index);
        return createdBy;
    }
        public static String generateUpdatedBy_withPrefixlogin()
    {
        String email = UserInfo.getUserEmail();
        Integer index = email.indexOf('@');
        String createdBy = 'Legalzoom\\\\' + email.substring(0, index);
        return createdBy;
    }
    public static Boolean sendEmail
    {
        get
        {
            if(!Test.isRunningTest())
            {
                Error_Email_Config__mdt[]  errorEmailConfig = [select label, Email_Send__c from Error_Email_Config__mdt where label = 'Team Email Config'];
                if(!errorEmailConfig.isEmpty())
                    sendEmail = errorEmailConfig[0].Email_Send__c;
            }
            return sendEmail;
        }
        set;
    }
    public static IAD_Config__mdt getConfig()
    {
        return [Select Contact_Highlights_Panel_Hours_Threshold__c, Log_Interaction_Days_Threshold__c, Payment_Gateway__c, Payment_Source__c
                from IAD_Config__mdt where DeveloperName='Default' limit 1];
    }
    public static User integrationUser
    {
        get
        {
            if(integrationUser == null)
            {
                List<User> integrationUsers = [SELECT Id FROM User WHERE Name = :INTEGRATION_USER];
                if(!integrationUsers.isEmpty())
                {
                    integrationUser = integrationUsers[0];
                }
            }

            return integrationUser;
        }
        private set;
    }
    // method to retrieve and return all integration users in the system : B-38758
    public static List<Integration_User_Config__mdt> allIntegrationUsers
    {
        get
        {
            if(allIntegrationUsers == null)
            {
                allIntegrationUsers = new List<Integration_User_Config__mdt>();
                List<Integration_User_Config__mdt> integrationUsers = [SELECT User_Id__c, User_Name__c, Full_Name__c, Org_Name__c FROM Integration_User_Config__mdt WHERE Org_Name__c =: IADHelper_ltng.getEnvironmentName()];
                
                if(!integrationUsers.isEmpty())
                {
                    allIntegrationUsers = integrationUsers;
                }
            }

            return allIntegrationUsers;
        }
        private set;
    }
	
	// method to retrieve and return all integration user Ids in the system : B-38758
	public static Set<Id> allIntegrationUserIds
    {
        get
        {
            if(allIntegrationUserIds == null)
            {
                allIntegrationUserIds = new Set<Id>();
                for(Integration_User_Config__mdt integrationUsers : [SELECT User_Id__c, User_Name__c, Full_Name__c, Org_Name__c FROM Integration_User_Config__mdt WHERE Org_Name__c =: IADHelper_ltng.getEnvironmentName()]){
                	allIntegrationUserIds.add(integrationUsers.User_Id__c);	                       
                }
                
                if(!allIntegrationUserIds.isEmpty())
                {
                    allIntegrationUserIds = allIntegrationUserIds;
                }
            }

            return allIntegrationUserIds;
        }
        private set;
    }
    
    //check if a given permission set is assigned to the current User
    public static Boolean isPermissionSetAssigned(Id userId, String permissionSetName)
    {
        List<PermissionSetAssignment> psa = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId =: userId AND PermissionSet.Name =: permissionSetName];
        
        if(psa.size() > 0){
            return true;
        }else{
            return false;
        }
    }
}