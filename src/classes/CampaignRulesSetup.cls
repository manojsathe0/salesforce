@isTest
public class CampaignRulesSetup 
{
       
    public static List<Product2> testProducts;
    public static Product_Line__c businessFormationProductLine; 
    public static Id relationshipTypeId;

    public static List<Campaign> testCampaigns;
    public static List<Campaign_Rule__c> testCampaignRules;
     
    public static Campaign abandonerCampaign;
    public static Campaign raOutboundCampaign;
    public static Campaign businessLicenseOutboundCampaign;
    public static Campaign tmSearchOutboundCampaign;
    public static Campaign sixMonthBizCampaign;
    public static Campaign mobileCampaign;
    public static Campaign tmsCampaign;
    public static Campaign inboundCampaign;
    public static Campaign epBundelUpsellCampaign;


    public static Processing_Status__c sentToCustomerProcessingStatus;
    public static Processing_Status__c awaitingSignatureProcessingStatus;
  
        
    public static void setupCampaignWithRules()
    {
        businessFormationProductLine = TestUtils.createProductLines(1 , '' , false)[0];
        businessFormationProductLine.Name = CampaignConstants.BUSINESS_FORMATIONS;
        insert businessFormationProductLine;
        

        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , CampaignConstants.THE_PROCESS , true)[0].Id;

        testProducts = TestUtils.createProducts(7 , '', false); 
        testProducts[0].Name = CampaignConstants.FIRST_BASE_PRODUCT;
        testProducts[0].LZ_Product_ID__c = 1;
        testProducts[0].Product_Line__c = businessFormationProductLine.Id;
        testProducts[0].Relationship_Type__c = relationshipTypeId;

        testProducts[1].Name = CampaignConstants.TM_SEARCH;
        testProducts[1].LZ_Product_ID__c = 2;
        testProducts[1].Relationship_Type__c = relationshipTypeId;

        testProducts[2].Name = CampaignConstants.TRADEMARK_GOLD;
        testProducts[2].Product_Line__c = businessFormationProductLine.Id;
        testProducts[2].LZ_Product_ID__c = 3;
        testProducts[2].Relationship_Type__c = relationshipTypeId;

        testProducts[3].Name = CampaignConstants.REGISTERED_AGENT;
        testProducts[3].LZ_Product_ID__c = 4;
        testProducts[3].Relationship_Type__c = relationshipTypeId;

        testProducts[4].Name = CampaignConstants.BUSINESS_LICENSES;
        testProducts[4].LZ_Product_ID__c = 5;
        testProducts[4].Relationship_Type__c = relationshipTypeId;

        testProducts[5].Name = CampaignConstants.BOA;
        testProducts[5].LZ_Product_ID__c = 6;
        testProducts[5].Relationship_Type__c = relationshipTypeId;
        
        
        Process__c theProcess = TestUtils.createProcesses(1 , CampaignConstants.LIVING_TRUST , false)[0];
        theProcess.Name = CampaignConstants.LIVING_TRUST; //method adds 0 at the end of the name.So resetting.
        insert theProcess;
        
        testProducts[6].Name = CampaignConstants.LIVING_TRUST;
        testProducts[6].LZ_Product_ID__c = 7;
        testProducts[6].Process__c = theProcess.Id;
        testProducts[6].Relationship_Type__c = relationshipTypeId;
             
                
        insert testProducts;
        
        sentToCustomerProcessingStatus = new Processing_Status__c();
        sentToCustomerProcessingStatus.Name = CampaignConstants.SENT_TO_CUSTOMER;
        sentToCustomerProcessingStatus.LZ_Processing_Status_ID__c = '1';
       
        awaitingSignatureProcessingStatus = new Processing_Status__c();
        awaitingSignatureProcessingStatus.Name = CampaignConstants.AWAITING_SIGNATURE;
        awaitingSignatureProcessingStatus.LZ_Processing_Status_ID__c = '2';
      
        insert new List<Processing_Status__c>{sentToCustomerProcessingStatus , awaitingSignatureProcessingStatus};

        testCampaigns = new List<Campaign>();

        abandonerCampaign = TestUtils.createCampaigns(1 , '' , '12&34&|' , '12|',false)[0];
        abandonerCampaign.Name = CampaignConstants.ABANDONER_DRIP;
        abandonerCampaign.Category__c = CampaignConstants.PRE_PURCHASE;

        raOutboundCampaign = TestUtils.createCampaigns(1,  '' , '12&3&', '12|' , false)[0];
        raOutboundCampaign.Name = CampaignConstants.RA_OUTBOUND_UPSELL;
        raOutboundCampaign.Category__c = CampaignConstants.MAGIC_TIME;


        businessLicenseOutboundCampaign =  TestUtils.createCampaigns(1, '', '12&3&', '1' ,  false)[0];
        businessLicenseOutboundCampaign.Name = CampaignConstants.BIZ_LICENSE_OUTBOUND_UPSELL;
        businessLicenseOutboundCampaign.Category__c = CampaignConstants.POST_PURCHASE;
        

        tmSearchOutboundCampaign =  TestUtils.createCampaigns(1, '', '12&', '1' , false)[0];
        tmSearchOutboundCampaign.Name = CampaignConstants.TM_SEARCH_OUTBOUND_UPSELL;
        tmSearchOutboundCampaign.Category__c = CampaignConstants.POST_PURCHASE;
        


        sixMonthBizCampaign =  TestUtils.createCampaigns(1, '', '12&3&', '1' , false)[0];
        sixMonthBizCampaign.Name = CampaignConstants.SIX_MONTH_BIZ_CHECKUP;
        sixMonthBizCampaign.Category__c = CampaignConstants.CUSTOMER_COMPLETE;
                
        mobileCampaign = TestUtils.createCampaigns(1, '' , '12|' , '12|3|4|' ,false)[0];
        mobileCampaign.Name = CampaignConstants.MOBILE;
        mobileCampaign.Category__c = CampaignConstants.PRE_PURCHASE;

        tmsCampaign = TestUtils.createCampaigns(1, '' , '1' , '1' ,false)[0];
        tmsCampaign.Name = CampaignConstants.TMS;
        tmsCampaign.Category__c = CampaignConstants.PRE_PURCHASE;

        inboundCampaign = TestUtils.createCampaigns(1, '' , '1' , '1' ,false)[0];
        inboundCampaign.Name = CampaignConstants.INBOUND;
        inboundCampaign.Category__c = CampaignConstants.PRE_PURCHASE;

        epBundelUpsellCampaign = TestUtils.createCampaigns(1, '' , '12&4&' , '1' ,false)[0];
        epBundelUpsellCampaign.Name = CampaignConstants.EP_UPSELL_CAMPAIGN;
        epBundelUpsellCampaign.Category__c = CampaignConstants.POST_PURCHASE;


        testCampaigns.add(abandonerCampaign);
        testCampaigns.add(raOutboundCampaign);
        testCampaigns.add(businessLicenseOutboundCampaign);
        testCampaigns.add(tmSearchOutboundCampaign);
        testCampaigns.add(sixMonthBizCampaign);
        testCampaigns.add(mobileCampaign);
        testCampaigns.add(tmsCampaign);
        testCampaigns.add(inboundCampaign);
        testCampaigns.add(epBundelUpsellCampaign);

        insert testCampaigns;

        testCampaignRules = new List<Campaign_Rule__c>();
        //Abandoner/Drip Campaign Rules
        Campaign_Rule__c abandonerCampaignFirstEntryRule = TestUtils.createCampaignRules(1, abandonerCampaign.Id , null , '1', false)[0];
        abandonerCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        abandonerCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        abandonerCampaignFirstEntryRule.Field_To_Evaluate__c = CampaignConstants.THE_NAME;
        abandonerCampaignFirstEntryRule.Object__c = CampaignConstants.THE_LEAD;

        
        testCampaignRules.add(abandonerCampaignFirstEntryRule);     
        
        

        Campaign_Rule__c abandonerCampaignSecondEntryRule = TestUtils.createCampaignRules(1, abandonerCampaign.Id , null , '2', false)[0];
        abandonerCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        abandonerCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        abandonerCampaignSecondEntryRule.Field_To_Evaluate__c = CampaignConstants.THE_PHONE;
        abandonerCampaignSecondEntryRule.Object__c = CampaignConstants.THE_LEAD;
        
        testCampaignRules.add(abandonerCampaignSecondEntryRule);

        Campaign_Rule__c abandonerCampaignThirdEntryRule = TestUtils.createCampaignRules(1, abandonerCampaign.Id , null , '3', false)[0];
        abandonerCampaignThirdEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        abandonerCampaignThirdEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        abandonerCampaignThirdEntryRule.Field_To_Evaluate__c = CampaignConstants.THE_NAME;
        abandonerCampaignThirdEntryRule.Object__c = CampaignConstants.THE_CONTACT;
        
        testCampaignRules.add(abandonerCampaignThirdEntryRule);     
        
        Campaign_Rule__c abandonerCampaignFourthEntryRule = TestUtils.createCampaignRules(1, abandonerCampaign.Id , null , '4', false)[0];
        abandonerCampaignFourthEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        abandonerCampaignFourthEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        abandonerCampaignFourthEntryRule.Field_To_Evaluate__c = CampaignConstants.HOME_PHONE;
        abandonerCampaignFourthEntryRule.Object__c = CampaignConstants.THE_CONTACT;
        
        testCampaignRules.add(abandonerCampaignFourthEntryRule);

        
        Campaign_Rule__c abandonerCampaignFirstExitRule = TestUtils.createCampaignRules(1, abandonerCampaign.Id , null , '1', false)[0];
        abandonerCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        abandonerCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        abandonerCampaignFirstExitRule.Has_Purchased__c = true;
    
        
        testCampaignRules.add(abandonerCampaignFirstExitRule);  

        Campaign_Rule__c abandonerCampaignSecondExitRule = TestUtils.createCampaignRules(1, abandonerCampaign.Id , null , '2', false)[0];
        abandonerCampaignSecondExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.DAYS_RULE);
        abandonerCampaignSecondExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        abandonerCampaignSecondExitRule.Number_Of_Days__c = 7;
        abandonerCampaignSecondExitRule.Days_To_Look__c = CampaignConstants.MEMBER_SINCE;
        testCampaignRules.add(abandonerCampaignSecondExitRule);     
            

        //RA Outbound Upsell Campaign Rules


        Campaign_Rule__c raOutboundCampaignFirstEntryRule = TestUtils.createCampaignRules(1, raOutboundCampaign.Id , null , '1', false)[0];
        raOutboundCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        raOutboundCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        raOutboundCampaignFirstEntryRule.Base_Product_Line__c = CampaignConstants.BUSINESS_FORMATIONS;
        raOutboundCampaignFirstEntryRule.Has_Purchased__c = true;
        testCampaignRules.add(raOutboundCampaignFirstEntryRule);
        

        Campaign_Rule__c raOutboundCampaignSecondEntryRule = TestUtils.createCampaignRules(1,  raOutboundCampaign.Id, null , '2', false)[0];
        raOutboundCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        raOutboundCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        raOutboundCampaignSecondEntryRule.Child_Product_Name__c = CampaignConstants.REGISTERED_AGENT;
        raOutboundCampaignSecondEntryRule.Has_Purchased__c = false;
        testCampaignRules.add(raOutboundCampaignSecondEntryRule);

        Campaign_Rule__c  raOutboundCampaignThirdEntryRule = TestUtils.createCampaignRules(1,  raOutboundCampaign.Id , null , '3', false)[0];
        raOutboundCampaignThirdEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        raOutboundCampaignThirdEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        raOutboundCampaignThirdEntryRule.Field_To_Evaluate__c = CampaignConstants.CONTACT_STATE;
        raOutboundCampaignThirdEntryRule.Field_Value__c = 'CA'+'||'+'TX';
        testCampaignRules.add(raOutboundCampaignThirdEntryRule);

        raOutboundCampaignThirdEntryRule.Object__c = CampaignConstants.THE_ORDER;

        Campaign_Rule__c  raOutboundCampaignFirstExitRule = TestUtils.createCampaignRules(1,  raOutboundCampaign.Id , null , '1', false)[0];
        raOutboundCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.STATUS_RULE);
        raOutboundCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        raOutboundCampaignFirstExitRule.Status__c = CampaignConstants.AWAITING_SIGNATURE;
        testCampaignRules.add(raOutboundCampaignFirstExitRule);


        Campaign_Rule__c  raOutboundCampaignSecondExitRule = TestUtils.createCampaignRules(1,  raOutboundCampaign.Id , null , '2', false)[0];
        raOutboundCampaignSecondExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        raOutboundCampaignSecondExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        raOutboundCampaignSecondExitRule.Has_Purchased__c = true;
        raOutboundCampaignSecondExitRule.Child_Product_Name__c = CampaignConstants.REGISTERED_AGENT;
        testCampaignRules.add(raOutboundCampaignSecondExitRule);


        //Business License Outbound Upsell Cmapaign Rules
        Campaign_Rule__c businessLicenseOutboundCampaignFirstEntryRule = TestUtils.createCampaignRules(1, businessLicenseOutboundCampaign.Id , null , '1', false)[0];
        businessLicenseOutboundCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        businessLicenseOutboundCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        businessLicenseOutboundCampaignFirstEntryRule.Base_Product_Line__c = CampaignConstants.BUSINESS_FORMATIONS;
        businessLicenseOutboundCampaignFirstEntryRule.Has_Purchased__c = true;
        testCampaignRules.add(businessLicenseOutboundCampaignFirstEntryRule);
        

        Campaign_Rule__c businessLicenseOutboundCampaignSecondEntryRule = TestUtils.createCampaignRules(1,  businessLicenseOutboundCampaign.Id, null , '2', false)[0];
        businessLicenseOutboundCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        businessLicenseOutboundCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        businessLicenseOutboundCampaignSecondEntryRule.Child_Product_Name__c = CampaignConstants.BUSINESS_LICENSES;
        businessLicenseOutboundCampaignSecondEntryRule.Has_Purchased__c = false;
        testCampaignRules.add(businessLicenseOutboundCampaignSecondEntryRule);

        Campaign_Rule__c  businessLicenseOutboundCampaignThirdEntryRule = TestUtils.createCampaignRules(1,  businessLicenseOutboundCampaign.Id , null , '3', false)[0];
        businessLicenseOutboundCampaignThirdEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.STATUS_RULE);
        businessLicenseOutboundCampaignThirdEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        businessLicenseOutboundCampaignThirdEntryRule.Number_Of_Days__c = 14;
        businessLicenseOutboundCampaignThirdEntryRule.Status__c = CampaignConstants.SENT_TO_CUSTOMER;
        testCampaignRules.add(businessLicenseOutboundCampaignThirdEntryRule);


        Campaign_Rule__c businessLicenseOutboundCampaignFirstExitRule = TestUtils.createCampaignRules(1,  businessLicenseOutboundCampaign.Id, null , '1', false)[0];
        businessLicenseOutboundCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        businessLicenseOutboundCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        businessLicenseOutboundCampaignFirstExitRule.Child_Product_Name__c = CampaignConstants.BUSINESS_LICENSES;
        businessLicenseOutboundCampaignFirstExitRule.Has_Purchased__c = true;
        testCampaignRules.add(businessLicenseOutboundCampaignFirstExitRule);


        //Trademark Search Outbound Upsell Campaign Rules


        Campaign_Rule__c tmSearchOutboundCampaignFirstEntryRule = TestUtils.createCampaignRules(1, tmSearchOutboundCampaign.Id , null , '1', false)[0];
        tmSearchOutboundCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        tmSearchOutboundCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        tmSearchOutboundCampaignFirstEntryRule.Base_Product_Name__c = CampaignConstants.TM_SEARCH;
        tmSearchOutboundCampaignFirstEntryRule.Has_Purchased__c = true;
        testCampaignRules.add(tmSearchOutboundCampaignFirstEntryRule);
        

        Campaign_Rule__c tmSearchOutboundCampaignSecondEntryRule = TestUtils.createCampaignRules(1,  tmSearchOutboundCampaign.Id, null , '2', false)[0];
        tmSearchOutboundCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.STATUS_RULE);
        tmSearchOutboundCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        tmSearchOutboundCampaignSecondEntryRule.Number_Of_Days__c = 14;
        tmSearchOutboundCampaignSecondEntryRule.Status__c = CampaignConstants.SENT_TO_CUSTOMER;
        testCampaignRules.add(tmSearchOutboundCampaignSecondEntryRule);
        

        Campaign_Rule__c tmSearchOutboundCampaignFirstExitRule = TestUtils.createCampaignRules(1,  tmSearchOutboundCampaign.Id, null , '1', false)[0];
        tmSearchOutboundCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        tmSearchOutboundCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        tmSearchOutboundCampaignFirstExitRule.Child_Product_Name__c = CampaignConstants.TRADEMARK_GOLD;
        tmSearchOutboundCampaignFirstExitRule.Has_Purchased__c = true;
        testCampaignRules.add(tmSearchOutboundCampaignFirstExitRule);


        //Six Month Biz Checkup Campaign Rules


        Campaign_Rule__c sixMonthBizCampaignFirstEntryRule = TestUtils.createCampaignRules(1, sixMonthBizCampaign.Id , null , '1', false)[0];
        sixMonthBizCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        sixMonthBizCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        sixMonthBizCampaignFirstEntryRule.Base_Product_Line__c = CampaignConstants.BUSINESS_FORMATIONS;
        sixMonthBizCampaignFirstEntryRule.Has_Purchased__c = true;
        testCampaignRules.add(sixMonthBizCampaignFirstEntryRule);

        Campaign_Rule__c sixMonthBizCampaignSecondEntryRule = TestUtils.createCampaignRules(1, sixMonthBizCampaign.Id , null , '2', false)[0];
        sixMonthBizCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.STATUS_RULE);
        sixMonthBizCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        sixMonthBizCampaignSecondEntryRule.Number_Of_Days__c = 180;
        sixMonthBizCampaignSecondEntryRule.Status__c = CampaignConstants.SENT_TO_CUSTOMER;
        testCampaignRules.add(sixMonthBizCampaignSecondEntryRule);

        Campaign_Rule__c sixMonthBizCampaignThirdEntryRule = TestUtils.createCampaignRules(1, sixMonthBizCampaign.Id , null , '3', false)[0];
        sixMonthBizCampaignThirdEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        sixMonthBizCampaignThirdEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        sixMonthBizCampaignThirdEntryRule.Child_Product_Name__c = CampaignConstants.BOA;
        sixMonthBizCampaignThirdEntryRule.Has_Purchased__c = false;
        testCampaignRules.add(sixMonthBizCampaignThirdEntryRule);


        Campaign_Rule__c sixMonthBizCampaignFirstExitRule = TestUtils.createCampaignRules(1,  sixMonthBizCampaign.Id, null , '1', false)[0];
        sixMonthBizCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        sixMonthBizCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        sixMonthBizCampaignFirstExitRule.Child_Product_Name__c = CampaignConstants.BOA;
        sixMonthBizCampaignFirstExitRule.Has_Purchased__c = true;
        testCampaignRules.add(sixMonthBizCampaignFirstExitRule);

        //Mobile Campaigns
        Campaign_Rule__c mobileCampaignFirstEntryRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '1' , false)[0];
        mobileCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        mobileCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        mobileCampaignFirstEntryRule.Field_To_Evaluate__c = CampaignConstants.LEAD_SOURCE;
        mobileCampaignFirstEntryRule.Field_Value__c = CampaignConstants.MOBILE;
        mobileCampaignFirstEntryRule.Object__c = CampaignConstants.THE_LEAD;
        testCampaignRules.add(mobileCampaignFirstEntryRule);

        Campaign_Rule__c mobileCampaignSecondEntryRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '2' , false)[0];
        mobileCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        mobileCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        mobileCampaignSecondEntryRule.Field_To_Evaluate__c = CampaignConstants.LEAD_SOURCE;
        mobileCampaignSecondEntryRule.Field_Value__c = CampaignConstants.MOBILE;
        mobileCampaignSecondEntryRule.Object__c = CampaignConstants.THE_CONTACT;
        testCampaignRules.add(mobileCampaignSecondEntryRule);

        Campaign_Rule__c mobileCampaignFirstExitRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '1' , false)[0];
        mobileCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        mobileCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        mobileCampaignFirstExitRule.Has_Purchased__c = true;
        testCampaignRules.add(mobileCampaignFirstExitRule);

        Campaign_Rule__c mobileCampaignSecondExitRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '2' , false)[0];
        mobileCampaignSecondExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        mobileCampaignSecondExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        mobileCampaignSecondExitRule.Field_To_Evaluate__c = CampaignConstants.CONTACT_STATUS;
        mobileCampaignSecondExitRule.Field_Value__c = CampaignConstants.VM_FINAL;
        mobileCampaignSecondExitRule.Object__c = CampaignConstants.THE_CONTACT;
        testCampaignRules.add(mobileCampaignSecondExitRule);

        Campaign_Rule__c mobileCampaignThirdExitRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '3' , false)[0];
        mobileCampaignThirdExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        mobileCampaignThirdExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        mobileCampaignThirdExitRule.Field_To_Evaluate__c = CampaignConstants.LEAD_CONTACT_STATUS;
        mobileCampaignThirdExitRule.Field_Value__c = CampaignConstants.VM_FINAL;
        mobileCampaignThirdExitRule.Object__c = CampaignConstants.THE_LEAD;
        testCampaignRules.add(mobileCampaignThirdExitRule);

        Campaign_Rule__c mobileCampaignFourthExitRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '4' , false)[0];
        mobileCampaignFourthExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.DAYS_RULE);
        mobileCampaignFourthExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        mobileCampaignFourthExitRule.Number_Of_Days__c = 30;
        mobileCampaignFourthExitRule.Days_To_Look__c = CampaignConstants.LEAD_CONTACT_MODIFIED;
        testCampaignRules.add(mobileCampaignFourthExitRule);

        //TMS campaign
        Campaign_Rule__c tmsCampaignFirstEntryRule = TestUtils.createCampaignRules(1, tmsCampaign.Id, null, '1' , false)[0];
        tmsCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        tmsCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        tmsCampaignFirstEntryRule.Field_To_Evaluate__c = CampaignConstants.CAMPAIGN;
        tmsCampaignFirstEntryRule.Field_Value__c = CampaignConstants.TMS;
        tmsCampaignFirstEntryRule.Object__c = CampaignConstants.THE_LEAD;
        testCampaignRules.add(tmsCampaignFirstEntryRule);

        Campaign_Rule__c tmsCampaignFirstExitRule = TestUtils.createCampaignRules(1, tmsCampaign.Id, null, '1' , false)[0];
        tmsCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.DAYS_RULE);
        tmsCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        tmsCampaignFirstExitRule.Number_Of_Days__c = 0;
        tmsCampaignFirstExitRule.Days_To_Look__c = CampaignConstants.LEAD_CONTACT_MODIFIED;
        testCampaignRules.add(tmsCampaignFirstExitRule);

        //Inbound Campaign
        Campaign_Rule__c inboundCampaignFirstEntryRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '1' , false)[0];
        inboundCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        inboundCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        inboundCampaignFirstEntryRule.Field_To_Evaluate__c = CampaignConstants.INBOUND_OUTBOUND;
        inboundCampaignFirstEntryRule.Field_Value__c = CampaignConstants.INBOUND;
        inboundCampaignFirstEntryRule.Object__c = CampaignConstants.TASK;
        testCampaignRules.add(inboundCampaignFirstEntryRule);


        Campaign_Rule__c inboundCampaignFirstExitRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '1' , false)[0];
        inboundCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.PRODUCT_RULE);
        inboundCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        inboundCampaignFirstExitRule.Has_Purchased__c = true;
        testCampaignRules.add(inboundCampaignFirstExitRule);    

        Campaign_Rule__c inboundCampaignSecondExitRule = TestUtils.createCampaignRules(1, mobileCampaign.Id , null , '2' , false)[0];
        inboundCampaignSecondExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.DAYS_RULE);
        inboundCampaignSecondExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        inboundCampaignSecondExitRule.Number_Of_Days__c = 30;
        inboundCampaignSecondExitRule.Days_To_Look__c = CampaignConstants.MEMBER_SINCE;
        testCampaignRules.add(inboundCampaignSecondExitRule);
      
       
        
        //EP Bundle Upsell Campaign
        
        Campaign_Rule__c epBundelUpsellCampaignFirstEntryRule = TestUtils.createCampaignRules(1,  epBundelUpsellCampaign.Id , null , '1', false)[0];
        epBundelUpsellCampaignFirstEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        epBundelUpsellCampaignFirstEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        epBundelUpsellCampaignFirstEntryRule.Field_To_Evaluate__c  = 'Process__c';
        epBundelUpsellCampaignFirstEntryRule.Field_Value__c  = CampaignConstants.LIVING_TRUST;
        epBundelUpsellCampaignFirstEntryRule.Object__c = CampaignConstants.THE_ORDER;
        
        testCampaignRules.add(epBundelUpsellCampaignFirstEntryRule);
        

        Campaign_Rule__c epBundelUpsellCampaignSecondEntryRule = TestUtils.createCampaignRules(1,  epBundelUpsellCampaign.Id , null , '2', false)[0];
        epBundelUpsellCampaignSecondEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        epBundelUpsellCampaignSecondEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        epBundelUpsellCampaignSecondEntryRule.Field_To_Evaluate__c  = 'Order_Payment_Status_Text__c';
        epBundelUpsellCampaignSecondEntryRule.Field_Value__c  = 'Approved';
        epBundelUpsellCampaignSecondEntryRule.Object__c = CampaignConstants.THE_ORDER;
        testCampaignRules.add(epBundelUpsellCampaignSecondEntryRule);
        

       
        Campaign_Rule__c epBundelUpsellCampaignFourthEntryRule = TestUtils.createCampaignRules(1,  epBundelUpsellCampaign.Id , null , '4', false)[0];
        epBundelUpsellCampaignFourthEntryRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.GENERAL_RULE);
        epBundelUpsellCampaignFourthEntryRule.Entry_Exit__c = CampaignConstants.THE_ENTRY;
        epBundelUpsellCampaignFourthEntryRule.Field_To_Evaluate__c  = 'Is_Sales_Order__c';
        epBundelUpsellCampaignFourthEntryRule.Field_Value__c  = 'False';
        epBundelUpsellCampaignFourthEntryRule.Object__c = CampaignConstants.THE_ORDER;
        testCampaignRules.add(epBundelUpsellCampaignFourthEntryRule);
        
        
        Campaign_Rule__c epBundelUpsellCampaignFirstExitRule = TestUtils.createCampaignRules(1, epBundelUpsellCampaign.Id, null, '1' , false)[0];
        epBundelUpsellCampaignFirstExitRule.RecordTypeId = CampaignEngine.developerNameToRecordTypeId.get(CampaignEngine.DAYS_RULE);
        epBundelUpsellCampaignFirstExitRule.Entry_Exit__c = CampaignConstants.THE_EXIT;
        epBundelUpsellCampaignFirstExitRule.Number_Of_Days__c = 7;
        epBundelUpsellCampaignFirstExitRule.Days_To_Look__c = 'Last Sales Activity';
        testCampaignRules.add(epBundelUpsellCampaignFirstExitRule);
        
        
        
        
        insert testCampaignRules;
         
        /*CampaignMemberStatus removedStatusForAbandoner = new CampaignMemberStatus(campaignId = abandonerCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);
        
        CampaignMemberStatus removedStatusForRAOutbound = new CampaignMemberStatus(campaignId = raOutboundCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);
        
        CampaignMemberStatus removedStatusForBusinessLicense = new CampaignMemberStatus(campaignId = businessLicenseOutboundCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);
        
        CampaignMemberStatus removedStatusForTMSearch = new CampaignMemberStatus(campaignId = tmSearchOutboundCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);
        
        CampaignMemberStatus removedStatusForSixMonthBiz = new CampaignMemberStatus(campaignId = sixMonthBizCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);
        
        CampaignMemberStatus removedStatusForMobile = new CampaignMemberStatus(campaignId = mobileCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);

        CampaignMemberStatus removedStatusForTMS = new CampaignMemberStatus(campaignId = tmsCampaign.Id,
        Label= CampaignConstants.REMOVED, IsDefault=false, HasResponded=false, SortOrder=3);


        insert new List<CampaignMemberStatus>{removedStatusForTMSearch , removedStatusForRAOutbound ,
                    removedStatusForBusinessLicense , removedStatusForAbandoner ,removedStatusForSixMonthBiz , removedStatusForMobile , removedStatusForTMS};
        */

    }

}