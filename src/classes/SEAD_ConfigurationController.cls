/**
 * Created by jboles on 3/9/2017.
 */

public with sharing class SEAD_ConfigurationController {
    public static string SEADDEFAULT = 'Default';


    @AuraEnabled
    public static SEAD_Configuration__c getConfig() {
        return SEADUtilityLibrary.getConfig();
    }

    @AuraEnabled
    public static List<SEAD_Scoring_Time__c> getScoringChildren(String param, String objectType)

    {
        return SEADUtilityLibrary.getScoringChildren(param, objectType);
    }
    // padma added below methods
    /*
      Author  : Padma S
      Story   : B-17332 & B-16432
      Description : Controller methods for the buttons and links on the SEAD_ConfigurationUpdate  lightning component
    */
    @AuraEnabled
    public static SEAD_Scoring_Time__c saveconfigChild(SEAD_Scoring_Time__c  configChild, String type, string recordId, String objectType) {
        //return SEADUtilityLibrary.getScoringChildren();

        configChild.Minimum__c = configChild.Minimum__c != null ? configChild.Minimum__c : 0;

        //Name =  +objectType - added by Artyom M., Per: Stories: B-16778, B-18406, B-18408, B-18409, B-18410

        configChild.Name = objectType + '_' + type + '_' + configChild.Minimum__c + '-' + configChild.Maximum__c;

        configChild.Record_Type__c = type;

        configChild.Related_To__c = objectType;

        if (recordId != null && recordId != '') {
            update  configchild;
        } else {
            upsert configchild Name;
        }

        return configchild;
    }
    @AuraEnabled
    public static void deleteconfigChild(String parentId) {
        SEAD_Scoring_Time__c childtodel = [Select Id From SEAD_Scoring_Time__c Where Id = :parentId Limit 1][0];
        Delete childtodel;
    }

    // percentage base SEAD custom setting methods
    @AuraEnabled
    public static SEAD_Scoring_Percent__c saveconfigPercent(SEAD_Scoring_Percent__c  configPercent, string type, string recordId, String objectType) {

        configPercent.Minimum__c = configPercent.Minimum__c != null ? configPercent.Minimum__c : 0;

        //Name =  +objectType - added by Artyom M., Per: Stories: B-16778, B-18406, B-18408, B-18409, B-18410
        configPercent.Name = objectType + '_' + type + '_' + configPercent.Minimum__c + '-' + configPercent.Maximum__c;
        configPercent.Record_Type__c = type;
        configPercent.Related_To__c = objectType;


        if (recordId != null && recordId != '') {

            update configPercent;
        } else {
            upsert configPercent Name;
        }
        return configPercent;
    }
    @AuraEnabled

    public static List<SEAD_Scoring_Percent__c> getpercentage(String param, String objectType) {
        return SEADUtilityLibrary.getpercentage(param, objectType);
    }
    @AuraEnabled
    public static void deleteconfigPercent(String perId) {
        SEAD_Scoring_Percent__c toDel = [Select Id From SEAD_Scoring_Percent__c Where Id = :perId Limit 1][0];
        Delete toDel;
    }

    @AuraEnabled
    public static SEAD_Scoring_Time__c gettimeRecord(string Id) {
        SEAD_Scoring_Time__c tr = [SELECT ID, Time_type__c, Name, Maximum__c, Minimum__c, Score__c FROM SEAD_Scoring_Time__c where Id = :Id LIMIT 1][0];
        system.debug('padma tr is ' + tr);
        return tr;
    }
    @AuraEnabled
    public static SEAD_Scoring_Percent__c getpercentRecord(string Id) {
        System.Debug('In method getpercentRecord - ' + Id);
        SEAD_Scoring_Percent__c tr = [SELECT ID, Name, Maximum__c, Minimum__c, Score__c FROM SEAD_Scoring_Percent__c where Id = :Id LIMIT 1][0];
        return tr;

    }
    //EOC padma

    //@Sai - B-40356
    @AuraEnabled
    public static SEAD_Configuration__c updateConfig(SEAD_Configuration__c config, Boolean isOppOnboardScoring) {
        //If isOppOnboardScoring = TRUE, Updating few fields only.
        if (isOppOnboardScoring) {
            system.debug('----isOppOnboardScoring'+isOppOnboardScoring);
            SEAD_Configuration__c seadConfig = new SEAD_Configuration__c();
            seadConfig.Id = config.Id;
            seadConfig.RA__C = config.RA__c;
            seadConfig.Tax__c = config.Tax__c;
            seadConfig.BAP__c = config.BAP__c;
            seadConfig.Compliance__c = config.Compliance__c;
            seadConfig.EIN__c = config.EIN__c;
            seadConfig.Economy__c = config.Economy__c;
            seadConfig.Express_Gold__c = config.Express_Gold__c;
            seadConfig.Standard__c = config.Standard__c;
            seadConfig.TM_search__c = config.TM_search__c;

            update seadConfig;
            return seadConfig;
        }
        update config;
        return config;
    }


    //Sai -B-40356
    @AuraEnabled
    public static SEAD_Configuration__c getConfigByName(String seadConfigName) {
        seadConfigName = seadConfigName == 'LLC' ? 'Default' : seadConfigName;
        return SEAD_Configuration__c.getValues(seadConfigName);
    }
}