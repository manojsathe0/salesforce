@isTest
public class ChangeCaseOwnerToQueueControllerTest
{
    static List<Case> testCases;
    static User testUser;
    static String LAST_NAME = 'Bonjovi';
    
    static void setupData()
    {
        testUser = TestUtils.createUser(LAST_NAME, TestUtils.STANDARD_PROFILE_ID , true);
        testCases = TestUtils.createCases(5, false);
        for(Case theCase : testCases)
        {
            theCase.Assigned_User__c = testUser.Id;
        }
        
        insert testCases;
    }
    
    static testMethod void testSaveMethodForResetAssignedUser()
    {
        setupData();
        
        PageReference pageRef = Page.ChangeCaseOwnerToQueue;
        Test.setCurrentPage(pageRef);
        
        ApexPages.Standardsetcontroller stdSetController = new ApexPages.Standardsetcontroller(testCases);
        stdSetController.setSelected(testCases);
        ChangeCaseOwnerToQueueController theExtension = new ChangeCaseOwnerToQueueController(stdSetController);
        
        Test.startTest();
            theExtension.isResetAssignedUser = true;
            theExtension.Save();
            theExtension.Save1();
        Test.stopTest();
        
        List<Case> updatedCases = [SELECT Id , Assigned_User__c FROM Case WHERE Id IN :testCases];
        for(Case theCase : updatedCases)
        {
            System.assertEquals(null , theCase.Assigned_User__c , 'Assigned User field  should have been Nulled out');
        }
        
    
    }
}