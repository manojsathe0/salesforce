/**
     *  @author         Saikiran Salla - ssalla@legalzoom.com
     *  @description    Implementation class for checking DNC phone number in LZInternal List, and updates Contact/Lead records based on reason/Result code.
     *  @history        2019-March-26   -   Created
*/

public class DNC_CheckDNCList_Impl {

    //Gets Contact and Lead's Phone fields
    public static List<Schema.FieldSetMember> getFields(String objectName) {
        if (objectName == DNC_Utility.CONTACT)
            return SObjectType.Contact.FieldSets.Phone_Fields.getFields();

        if (objectName == DNC_Utility.LEAD)
            return SObjectType.Lead.FieldSets.Phone_Fields.getFields();

        return null;
    }


    public static void checkDNCList(String objectName, List<sObject> sObjList) {

        List<String> FIELDS = new List<String>();
        Boolean isInternalList = false;
        Boolean isWireless = false;
        Boolean isKnownLitigator = false;
        Boolean isInvalid = false;
        Boolean isBlocked = false;

        List<Id> postRecToDNCList = new List<Id>();

        List<DNC_Check__c> dncCheckInsetList = new List<DNC_Check__c>();

        Map<Id, Set<String>> recIDPhonesMap = new Map<Id, Set<String>>();
        List<sObject> sObjContactOrLeadUpdateList = new List<sObject>();


        for (Schema.FieldSetMember fs : getFields(objectName)) {
            FIELDS.add(fs.getFieldPath());
        }

        //Process them (Individually)
        for (sObject sobj : sObjList) {
            Set<String> phoneList = new Set<String>();
            for (String fld : FIELDS) {
                if (sobj.get(fld) != null)
                    phoneList.add(sobj.get(fld).toString());
            }
            recIDPhonesMap.put(sobj.Id, DNC_Utility.cleanPhoneNumber(phoneList));
        }

        DNC_CheckPhone_Library.MainResponse mainRes = new DNC_CheckPhone_Library.MainResponse();

        //Make a callout - Sync

        //Initialize Endpoints -- Which gets endpoint details from Custom Metadata.
        IADServiceBase_ltng init = new IADServiceBase_ltng();
        IADServiceBase_ltng.initEndpoints(new List<String> {DNC_Utility.EPNAME});
        //Initializing Callout and make a callout
        IADServiceBase_ltng.initWrapper(DNC_Utility.EPNAME);

        //Format Here before proceeding.
        for (Id recId : recIDPhonesMap.keySet()) {

            isInternalList = false;
            isWireless = false;
            isKnownLitigator = false;
            isInvalid = false;
            isBlocked = false;

            //Get Each phone number from Record
            for (String ph : recIDPhonesMap.get(recId)) {
                //Once it is found in DNC Internal List, Skip the flow
                if (!isInternalList) {
                    String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(DNC_Utility.EPNAME).endPointConfig.link__c).replace('{phoneNumber}', ph);

                    IADServiceBase_ltng.makeRequestMulti(calloutURL, DNC_Utility.EPNAME, '');

                    //get response
                    APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(DNC_Utility.EPNAME);
                    if (response.checkIsValidResponse()) {

                        if (String.isNotBlank(response.responseData)) {
                            mainRes = (DNC_CheckPhone_Library.MainResponse) JSON.deserialize(DNC_Utility.parseReservedKeywords(response.responseData), DNC_CheckPhone_Library.MainResponse.class);

                            if (mainRes.phoneNumber != null) {
                                String reason = DNC_Utility.cleanAndextractReasonCode(mainRes.phoneNumber.Reason);
                                if (mainRes.phoneNumber.ResultCode == 'P') {
                                    isInternalList = true;
                                    //Put all phone numbers for this record to Internal List only if it is CONTACT
                                    if (objectName == DNC_Utility.CONTACT)
                                        postRecToDNCList.add(recId);
                                }
                                if (mainRes.phoneNumber.ResultCode == 'W' || reason == 'W')
                                    isWireless = true;
                                if (mainRes.phoneNumber.ResultCode == 'D' && reason == 'litigator')
                                    isKnownLitigator = true;
                                if (mainRes.phoneNumber.ResultCode == 'I' || mainRes.phoneNumber.ResultCode == 'M')
                                    isInvalid = true;
                                if (mainRes.phoneNumber.ResultCode == 'B')
                                    isBlocked = true;
                            }
                            dncCheckInsetList.add(DNCController_ltng.createDNCCheck(recId, 'Success', isInternalList, ph));
                        }
                    } else {
                        dncCheckInsetList.add(DNCController_ltng.createDNCCheck(recId, 'Failed', isInternalList, ph));
                    }
                }
            }
            sObject sj = recId.getSObjecttype().newsObject(recId);
            sj.put('Internal_List__c', isInternalList);
            sj.put('Wireless__c', isWireless);
            sj.put('Known_Litigator__c', isKnownLitigator);
            sj.put('Invalid_Malformed__c', isInvalid);
            sj.put('Blocked__c', isBlocked);

            sObjContactOrLeadUpdateList.add(sj);
        }

        //If any result code is "P" and reason is NULL, then post them to DNC Internal List
        if (!postRecToDNCList.isEmpty() && !Test.isRunningTest()) {
            //2nd arg is false, i.e. do not update record Contact/Lead in the method.
            //It would be true in "DuplicateChecker.cls" class, because it should update Contact/Lead independantly.
            DNCController_ltng.PostDNCNumberBulk(postRecToDNCList, false);
        }

        if (!sObjContactOrLeadUpdateList.isEmpty())
            DNC_Utility.dmlSobjectList(DNC_Utility.DML_UPDATE, sObjContactOrLeadUpdateList);

        //B-38909 - Insert dncCheckInsetList if it is not empty
        //It has list of DNC_Check__c records which phone number is in InternalList or error in API call.
        if (!dncCheckInsetList.isEmpty()) {
            DNC_Utility.dmlSobjectList(DNC_Utility.DML_INSERT, dncCheckInsetList);
        }
    }
}