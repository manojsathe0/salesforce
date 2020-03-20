public class DncStatusController {

    @auraenabled
    public static boolean checkinternallist(id recordid) {
        String objectName = recordid.getSObjectType().getDescribe().getName();
        if (objectName == DNC_Utility.CONTACT)
            return [SELECT Internal_List__c FROM Contact WHERE Id = : recordid].Internal_List__c;

        if (objectName == DNC_Utility.LEAD)
            return [SELECT Internal_List__c FROM Lead WHERE Id = : recordid].Internal_List__c;

        if (objectName == DNC_Utility.ORDER)
            return [SELECT Contact__r.Internal_List__c FROM Order__c WHERE Id = : recordid].Contact__r.Internal_List__c;
        return false;
    }
}