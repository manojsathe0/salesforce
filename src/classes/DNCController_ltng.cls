/**
      * @Author: Saikiran Salla - ssalla@legalzoom.com
      * @Description: Refactored previous code and used sObjects
      * @Refactored Methods: PostDncIntetnal, checkdncinternal
      * @Date:  04/01/2019
**/

public class DNCController_ltng {
    public static String LEAD = 'Lead__c';
    public final static String POSTDNCNUMBER = 'PostDncnumber';

    //public static string phonenumber {get; set;}
    @auraenabled public static DNCService_ltng  dncservice {get; set;}

    //It makes POST Callout and adds the given record phone numbers to the DNC Internal List
    //Once got Success Response, Creates DNC_Request__c and Updates Cntact/Lead record
    @Auraenabled
    public static DNCService_ltng PostDncIntetnal(string recordid , string selectedValue , string otherreason) {
        List<String> fields = new List<String>();
        Id recId = Id.valueOf(recordid);
        Set<String> phoneNumList = new Set<String>();
        List<sObject> sObjectUpdateList = new List<sObject>();
        List<DNC_Request__c> dncRequestInsertList = new List<DNC_Request__c>();
        String objectName = recId.getSObjectType().getDescribe().getName();
        String reason = String.isBlank(otherreason) ? selectedValue : otherreason;
        sObject sObj;
        Boolean isAnyPhSuccess = false;
        dncservice = new DNCService_ltng();

        String query = 'SELECT ';
        String queryWhere = ' WHERE Id =: recId';

         if (objectName == DNC_Utility.ORDER) {
            system.debug('-----Yquery:' + query);
            Order__c ord = [SELECT Id, Contact__c FROM Order__c WHERE Id = : recId];
            recId = ord.Contact__c;
            objectName = DNC_Utility.CONTACT;
        }

        if (objectName == DNC_Utility.CONTACT || objectName == DNC_Utility.LEAD) {
            //Getting Contact and Lead fields from "Phone_Fields" field set
            for (Schema.FieldSetMember fs : DNC_CheckDNCList_Impl.getFields(objectName)) {
                query = query + fs.getFieldPath() + ', ';
                fields.add(fs.getFieldPath());
            }
            query = query + ' Id FROM ' + objectName + queryWhere;
            system.debug('-----Yquery2:' + query);
            sObj = Database.query(query);
        }

        //Get PhoneNumbers
        String ph;
        for (String fld : fields) {
            if (sObj.get(fld) != null) {
                ph = sObj.get(fld).toString();
                phoneNumList.add(ph);
            }
        }

        if (phoneNumList.isEmpty()) {
            IADServiceBase_ltng.populateErrorMessage('No phone number exists');
            DNCService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            return  dncservice;
        }

        //Make a callout for each phone number and process records.
        for (String phNumber : phoneNumList) {

            //get response
            APIRequestResponseWrapper_ltng response = MakeDNCCallout(phNumber);


            if (response.checkIsValidResponse()) {

                //Populate Success Message and it will be showed as toast in component.
                IADServiceBase_ltng.populateSuccessMessage('Number Added to DNC Internal List');

                DNcContractBeans_ltng.DNCaddNumberResponse mainResponse = (DNcContractBeans_ltng.DNCaddNumberResponse ) JSON.deserialize(response.responseData, DNcContractBeans_ltng.DNCaddNumberResponse.class);
                if (mainResponse.status == 'Success') {
                    isAnyPhSuccess = true;
                    dncRequestInsertList.add(DNCRequestRecord(phNumber, reason, mainResponse.status, recId));
                } else {
                    IADServiceBase_ltng.populateErrorMessage('Failure in Response');
                    dncRequestInsertList.add(DNCRequestRecord(phNumber, reason, mainResponse.status, recId));
                }
            } else {
                IADServiceBase_ltng.populateErrorMessage('Failure to store number');
                dncRequestInsertList.add(DNCRequestRecord(phNumber, reason, 'Failure', recId));
            }
            //Populated Message and it will be retrieved in component and showed as toast.
            DNCService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }


        //If any one phone number is success then, upadte the contact as Success.
        //All phone numbers are failed to submit, then update the contact as Failure.
        if (isAnyPhSuccess)
            sObjectUpdateList.add(UpdateRecord(recId, TRUE, reason, 'Success'));
        else
            sObjectUpdateList.add(UpdateRecord(recId, FALSE, reason, 'Failure'));

        try {
            if (!dncRequestInsertList.isEmpty()) {
                DNC_Utility.dmlSobjectList(DNC_Utility.DML_INSERT, dncRequestInsertList);
            }
            if (!sObjectUpdateList.isEmpty()) {
                DNC_Utility.dmlSobjectList(DNC_Utility.DML_UPDATE, sObjectUpdateList);
            }
        } catch (Exception e) {
            IADServiceBase_ltng.populateErrorMessage(e);
            DNCService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            system.debug('-----YFailed DML: ' + e.getMessage() + ' cause of: ' + e.getCause());
        }

        return dncservice;
    }


    public static APIRequestResponseWrapper_ltng MakeDNCCallout( String phNumber) {

        DNCContractBeans_ltng.DNCaddNumber dncrequestbean = new DNCContractBeans_ltng.DNCaddNumber();
        dncrequestbean.phoneNumber = phNumber.replaceAll('[^0-9]+', '');

        IADServiceBase_ltng.initWrapper(POSTDNCNUMBER);

        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(POSTDNCNUMBER).endPointConfig.link__c);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTDNCNUMBER, JSON.serialize(dncrequestbean));

        //get response
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTDNCNUMBER);
        return response;

    }

    //Just update the DNC_Request__c Object only, not Contact/Lead.
    //Contact/Lead will be upadted in Batch job DNC_CheckDNCList_Batch, DNC_CheckDNCList_Impl
    //@param recIdList ==> List of Contact/Lead Id's
    //@param updateRecord ==> it should be "False" when calling from batch DNC_CheckDNCList_Batch, DNC_CheckDNCList_Impl
    //              "True" when calling from DuplicateChecker.cls
    public static void PostDNCNumberBulk(List<Id> recIdList, Boolean isUpdateRecord) {
        dncservice = new DNCService_ltng();
        Boolean isAnyPhSuccessInRecord = false;

        List<DNC_Request__c> dncRequestInsertList = new List<DNC_Request__c>();
        List<sObject> sObjContactOrLeadUpdateList = new List<sObject>();            //List of Contact or Lead records

        String objectName = recIdList[0].getSObjectType().getDescribe().getName();

        String query = 'SELECT ';
        String queryWhere = ' WHERE Id IN: recIdList';

        List<String> fieldList = new List<String>();

        //Get phone fields from Fieldset
        for (Schema.FieldSetMember fs : DNC_CheckDNCList_Impl.getFields(objectName)) {
            query = query + fs.getFieldPath() + ', ';
            fieldList.add(fs.getFieldPath());
        }

        //Build a query
        query = query + ' Id FROM ' + objectName + queryWhere;

        List<sObject> recordList = Database.query(query);

        //Process each record
        for (sObject sobj : recordList) {
            isAnyPhSuccessInRecord = false;
            //Each record, get each phone number.
            for (String fld : fieldList) {

                String ph = sobj.get(fld) != null ? sobj.get(fld).toString() : null;

                if (String.isNotBlank(ph)) {
                    //get response
                    APIRequestResponseWrapper_ltng response = MakeDNCCallout(ph);

                    //If response is valid then process, else, insert DNC_Request__c record as failure.
                    if (response.checkIsValidResponse()) {

                        DNcContractBeans_ltng.DNCaddNumberResponse mainResponse = (DNcContractBeans_ltng.DNCaddNumberResponse ) JSON.deserialize(response.responseData, DNcContractBeans_ltng.DNCaddNumberResponse.class);
                        //Insert DNC Request record, based on Status.
                        //Contact is not updating here, because it is calling from DNC_CheckDNCList_impl class, and that is from Batch class.
                        //Updating contact is already hadling in batch.
                        if (mainResponse.status == 'Success') {
                            isAnyPhSuccessInRecord = true;
                            dncRequestInsertList.add(DNCRequestRecord(ph, '', mainResponse.status, sObj.Id));
                        } else {
                            IADServiceBase_ltng.populateErrorMessage('Failure in Response');
                            dncRequestInsertList.add(DNCRequestRecord(ph, '', mainResponse.status, sObj.Id));
                        }
                    } else {
                        IADServiceBase_ltng.populateErrorMessage('Failure to store number');
                        dncRequestInsertList.add(DNCRequestRecord(ph, '', 'Failure', sObj.Id));
                    }
                }
            }
            if (isAnyPhSuccessInRecord)
                sObjContactOrLeadUpdateList.add(UpdateRecord(sObj.Id, TRUE, '', 'Success'));
        }

        try {
            if (!dncRequestInsertList.isEmpty()) {
                DNC_Utility.dmlSobjectList(DNC_Utility.DML_INSERT, dncRequestInsertList);
            }
            if (!sObjContactOrLeadUpdateList.isEmpty() && isUpdateRecord) {
                DNC_Utility.dmlSobjectList(DNC_Utility.DML_UPDATE, sObjContactOrLeadUpdateList);
            }
        } catch (Exception e) {
            system.debug('-----YFailed DML: ' + e.getMessage() + ' cause of: ' + e.getCause());
        }

    }

    private static DNC_Request__c DNCRequestRecord(String ph, String reason, String result, Id recId) {
        DNC_Request__c dncReq = new DNC_Request__c();
        dncReq.Phone_Number__c = ph;
        dncReq.Request_Channel__c = reason;
        dncReq.Request_Result__c = result;
        dncReq.Agent__c = UserInfo.getUserId();
        dncReq.Contact_Lead_Id__c = recId;
        return dncReq;
    }

    private static sObject UpdateRecord(Id recId, Boolean internalList, String reqChannel, String reqStatus) {

        sObject sj = recId.getSObjectType().newsObject(recId);
        String objectName = recId.getSObjectType().getDescribe().getName();

        sj.put('Internal_List__c', internalList);
        if (objectName == DNC_Utility.CONTACT)
            sj.put('DNS_Request_Channel__c', reqChannel);
        else
            sj.put('DNC_Request_Channel__c', reqChannel);
        sj.put('DNC_Request_Status__c', reqStatus);
        return sj;
    }


    @Auraenabled
    public static DNCService_ltng  checkdncinternal(string recordid ) {

        String query = '';
        Id recId = Id.valueOf(recordid);
        String objectName = recId.getSObjectType().getDescribe().getName();
        sObject record;
        Boolean internalvalue;

        dncservice = new DNCService_ltng();
        DNCService_ltng.dncinternal = false;
        DNCService_ltng.dncpermission = false;
        List<PermissionSetAssignment> permissionsetdnc = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = :UserInfo.getUserId() AND PermissionSet.Name = 'DNC_Button_View'];

        if (permissionsetdnc.size() > 0) {
            DNCService_ltng.dncpermission = true;
        }

        if (objectName == DNC_Utility.CONTACT || objectName == DNC_Utility.LEAD )
            query = 'SELECT Id, Internal_List__c FROM ' + objectName + ' WHERE Id =: recordid';
        
        if (objectName == DNC_Utility.ORDER)
            query = 'SELECT Id, Contact__r.Internal_List__c FROM ' + objectName + ' WHERE Id =: recordid';

        if (query == '')
            return dncservice;

        record = Database.query(query);

        if (record != null) {
            internalvalue = objectName == DNC_Utility.ORDER ? Boolean.valueOf(record.getSobject('Contact__r').get('Internal_list__c')) : Boolean.valueOf(record.get('Internal_List__c'));
        }

        DNCService_ltng.dncinternal = internalvalue;
        return dncservice;
    }

    public static void closeopportunitiesdnc(List<contact> newContacts) {
        set<id> contactids = new set<id>();
        List<opportunity> oppupdate = new List<opportunity>();
        for (contact newcontact : newContacts) {
            if (newcontact.Internal_List__c) {
                contactids.add(newcontact.id);
            }
        }

        List<Opportunity>  opportunityrelatedtocontact = [select StageName, owner.name from Opportunity where contact__r.id in :contactids AND contact__r.Contact_Type__c != 'B2B Account Contact'];
        for (Opportunity opp : opportunityrelatedtocontact) {
            if (opp.owner.name.contains('Integration')) {
                opp.StageName = 'Closed Lost' ;
                opp.Closed_Lost_Reason_LTN__c = 'Do Not Call';
                oppupdate.add(opp);
            }
        }
        update oppupdate;
    }

    //@sai - B-38878
    //Creates DNC_Check__c record, and not performing DML.
    public static DNC_Check__c createDNCCheck(Id recId, String status, Boolean isInternalList, String phone) {
        String objectName = recId.getSObjectType().getDescribe().getName();
        DNC_Check__c dncCheck = new DNC_Check__c();
        dncCheck.Contact__c = objectName == DNC_Utility.CONTACT ? recId : null;
        dncCheck.Lead__c = objectName == DNC_Utility.LEAD ? recId : null;
        dncCheck.Status__c = Status;
        dncCheck.Date_of_check__c = Date.today();
        dncCheck.Internal_List__c = isInternalList;
        dncCheck.Phone_Number__c = phone;
        return dncCheck;
    }
}