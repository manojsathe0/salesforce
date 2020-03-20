/**
 * Created by jboles on 3/13/2017.
 */

public class SEADUtilityLibrary
{
    public static string SEADDEFAULT = 'Default';
    public static string SALES = 'Sales';
    public static final String SALES_SPECIALIST = 'Sales Specialist';

    public static SEAD_Configuration__c getConfig()
    {
    
        if(Test.isRunningTest()){
        
         TestUtils.setupSEAD_config();
        
        }
            String objectName = 'SEAD_Configuration__c';
            String query = 'SELECT id,';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
    
            for(String fieldName : objectFields.keySet())
            {
                if(fieldName.endsWith('__c') && objectFields.get(fieldName).getDescribe().isAccessible())
                    query += ' ' + fieldName + ', ';
            }
            query = query.removeEnd(', ');
            query += ' FROM ' + objectName;
            query += ' WHERE Name = \'' + SEADDEFAULT +  '\' limit 1';
    
            system.debug('query ' + query);
        
            return database.query(query);
          

    }
    
    //Padma @B-17332 & B-16432
    public static List<SEAD_Scoring_Time__c> getScoringChildren(String tabparam, String objectType)   
    {
    	//System.debug('objectType:' + objectType);
        String objectName = 'SEAD_Scoring_Time__c';
        
        String query = 'SELECT id,';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        for(String fieldName : objectFields.keySet())
        {
            if(fieldName.endsWith('__c') && objectFields.get(fieldName).getDescribe().isAccessible())
                query += ' ' + fieldName + ', ';
        }
        query = query.removeEnd(', ');
        query += ' FROM ' + objectName;
        query += ' WHERE Record_Type__c=\'' + tabparam + '\'';
        query += ' AND Related_To__c =\'' + objectType + '\''; //Added by Artyom M., Per: Stories: B-16778, B-18406, B-18408, B-18409, B-18410
        
        system.debug('query ' + query);

        return database.query(query);
    }
     //public static List<SEAD_Scoring_Percent__c> 
    public static List<SEAD_Scoring_Percent__c> getpercentage(string tabparam, String objectType)
    {
        String objectName = 'SEAD_Scoring_Percent__c';
        String query = 'SELECT id,';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        for(String fieldName : objectFields.keySet())
        {
            if(fieldName.endsWith('__c') && objectFields.get(fieldName).getDescribe().isAccessible())
                query += ' ' + fieldName + ', ';
        }
        query = query.removeEnd(', ');
        query += ' FROM ' + objectName;
        query +=' WHERE Record_Type__c=\'' + tabparam +'\'';
        query += ' AND Related_To__c =\'' + objectType + '\''; //Added by Artyom M., Per: Stories: B-16778, B-18406, B-18408, B-18409, B-18410
        

        system.debug('query ' + query);

        return database.query(query);

    }
   public static Map<String, Set<String>> productLineToSkillMap
    {
        get
        {
            if(productLineToSkillMap == null)
            {
                productLineToSkillMap = new Map<String, Set<String>>();

                Set<String> bizSkillSet = new Set<String>();
                bizSkillSet.add('Abandoner-Biz');
                bizSkillSet.add('Mobile-Biz');
                bizSkillSet.add('Social-Biz');

                Set<String> ipSkillSet = new Set<String>();
                ipSkillSet.add('Abandoner-IP');
                ipSkillSet.add('Mobile-IP');
                ipSkillSet.add('Social-IP');

                Set<String> psSkillSet = new Set<String>();
                psSkillSet.add('Abandoner-PS');
                psSkillSet.add('Mobile-PS');
                psSkillSet.add('Social-PS');

                productLineToSkillMap.put('Business Formations', bizSkillSet);
                productLineToSkillMap.put('Attorney Services', bizSkillSet);
                productLineToSkillMap.put('Legal Forms', bizSkillSet);
                productLineToSkillMap.put('Intellectual Property', ipSkillSet);
                productLineToSkillMap.put('Personal Services', psSkillSet);
            }
            return productLineToSkillMap;
        }
        set;
    }
}