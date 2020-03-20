public class DNCService_ltng  extends IADServiceBase_ltng {
    
   
     public final static String PostDNCNumber = 'PostDncnumber';
     public  static string phonenumbertoadd ;
    @AuraEnabled public static boolean dncinternal{get;set;}
    @AuraEnabled public static boolean dncpermission{get;set;}
     public  static list<contact> contactlist = new list<contact>();
     public  static list<DNC_Request__c> dnclist = new list<DNC_Request__c>();
     
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
     @Auraenabled public static DNcContractBeans_ltng.DNCaddNumberResponse Dncresponse{get;set;}
     public DNCService_ltng ()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(PostDNCNumber);
       
        
        initEndpoints(endpoints);
       
    }
    
   
    //@B-35598 by Artyom
    @future(callout=true)
    public static void numberToInternalList(String phoneNumber) {
        System.Debug('Inside numberToInternalList');
        DNCService_ltng serviceInit = new DNCService_ltng();
        DNcContractBeans_ltng.DNCaddNumberResponse DNCResponseBean = new DNcContractBeans_ltng.DNCaddNumberResponse(); 
        
        DNCContractBeans_ltng.DNCaddNumber DNCrequestBean = new DNCContractBeans_ltng.DNCaddNumber();
        DNCrequestBean.PhoneNumber = phoneNumber;
        String JSONPayload = JSON.serialize(DNCrequestBean);
        
        IADServiceBase_ltng.initWrapper(DNCService_ltng.PostDNCNumber);
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(PostDNCNumber).endPointConfig.link__c);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PostDNCNumber, JSONPayload);
        
        APIRequestResponseWrapper_ltng DNCRequestResponse = IADServiceBase_ltng.APItoWrapper.get(PostDNCNumber);
        
        try {
            if (String.isNotBlank(DNCRequestResponse.responseData)) {
                if (DncRequestResponse.checkIsValidResponse()) {
                    System.debug('Success');
                    /*
                    DNCResponseBean = (DNcContractBeans_ltng.DNCaddNumberResponse) JSON.deserialize(DncRequestResponse.responseData, DNcContractBeans_ltng.DNCaddNumberResponse.class);
                    DNC_Request__c DNCRequestRecordToInsert = new DNC_Request__c();
                    DNCRequestRecordToInsert.Phone_Number__c = phoneNumber;
                    DNCRequestRecordToInsert.Request_Result__c = DNCResponseBean.status;
                    insert DNCRequestRecordToInsert;
                    */
                }
            }
        }
        catch(Exception e) {
            System.debug('Failed with: ' + e);
        }
    
    }
    
}