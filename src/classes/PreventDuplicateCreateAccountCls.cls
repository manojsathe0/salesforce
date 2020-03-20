public class PreventDuplicateCreateAccountCls{
    
    static Set<String> accNameSet;
    static Account accResult;
    static String URL_SF;
    static String errorMess;
    
    public static void preventDuplicateAccount(List<Account> accTrg){
        try{
            //If User profile not match profile permission
            if(CheckProfileData()==0){
                accNameSet = new Set<String>();
                for(Account acc : accTrg){
                    accNameSet.add(acc.Name);
                }
                List<Account> lstAccts = [select Id, Name, Customer_ID__c from Account where Account.Name IN: accNameSet ORDER BY Customer_ID__c DESC NULLS LAST, CreatedDate DESC limit 1];
                if(lstAccts.size() > 0) accResult = lstAccts[0];
                for(Account acc : accTrg){
                    if(accResult != null){
                        URL_SF = '<a href=\''+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + accResult.Id + '\'>Click here to view the account.'+'</a>';
                        acc.Name.addError('An account '+accResult.Name+' already exists. '+ URL_SF, false);
                        setErrorMessage('An account '+accResult.Name+' already exists. '+ URL_SF);
                    }
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
    }
    
    public static Integer CheckProfileData(){
        Integer numProfiles;
        String profileName = [SELECT Id, Name FROM Profile Where Id =:Userinfo.getProfileId()].Name;
        List<Account_Permission_Duplicate__c> accPermisDupliList = [SELECT Id, Name FROM Account_Permission_Duplicate__c WHERE Name = :profileName];
        if(accPermisDupliList.size() > 0){
            numProfiles = accPermisDupliList.size();
            return numProfiles; 
        /*}else if(accPermisDupliList.size() == 0){
            numProfiles = accPermisDupliList.size();
            return numProfiles; */
        }
        return 0;
    }
    
    public static void setErrorMessage(String errMessage){
        errorMess = errMessage;
    }
    
    public static String getErrorMessage(){
        return errorMess;
    }
}