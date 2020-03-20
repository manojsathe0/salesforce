@isTest
public class ShowDetailControllerTest {

    public static Profile_Map_App_ID__c  profileMapAppID;
    public static Account accObj;
    public static Order__c orderObj;
    public static final String SYS_ADMIN = 'System Administrator';
    public static final String TSID = '02uG00000001wKo';
    static Contact testContact;
    static Order_Item__c testOrderItem;
    static void setupData()
    {
        //create Profile_Map_App_ID__c record
        profileMapAppID = new Profile_Map_App_ID__c();
        profileMapAppID.Name = SYS_ADMIN;
        profileMapAppID.Profile_Name__c = SYS_ADMIN;
        profileMapAppID.TSID__c = TSID;
        
        
        //Create Account record
        accObj = TestUtils.createAccounts(1, 'testAccount1234', true)[0];
        testContact = TestUtils.createContacts(1 , 'TestLastName' , accObj.Id , true)[0];
        //Create Order record
        orderObj = TestUtils.createOrders(1 , null , false)[0];
        orderObj.OrderID__c = 'SF-Test-001';
        orderObj.User_Order_ID__c = '567890';
        orderObj.Contact__c = testContact.Id; 
        insert orderObj;
        
        testOrderItem = TestUtils.createOrderItems(1 , orderObj.Id , false)[0];
        testOrderItem.User_Order_ID__c = '567890';
        insert testOrderItem;


        Salesforce_Host_URL__c sfBasedURL = new Salesforce_Host_URL__c();
        sfBasedURL.Name = 'Salesforce Based URL';
        sfBasedURL.Host_URL__c = 'https://www.salesforce.com';
        insert sfBasedURL;

        insert profileMapAppID;

    }

    static testMethod void controllerTest() 
    {
        setupData();
        
        Test.startTest();
               
            User adminUser = TestUtils.createUser('User', TestUtils.SYSADMIN_PROFILE_ID);
            adminUser.LastName = 'UserAdmin';
            adminUser.FirstName = 'Test';
            
            System.runAs(adminUser)
            {
                 // Add parameters to page URL
                ApexPages.currentPage().getParameters().put('UserOrder', '567890');
                
                ShowDetailController controller = new ShowDetailController(); 
            }
            
        Test.stopTest();
        Profile_Map_App_ID__c getProfileMapAppId = Profile_Map_App_ID__c.getInstance(SYS_ADMIN);
        System.assertEquals(SYS_ADMIN, getProfileMapAppId.Profile_Name__c);
        System.assertEquals(TSID, getProfileMapAppId.TSID__c);
        
        List<Order_Item__c> theItems = [SELECT Order__r.Contact__c , Order__c FROM Order_Item__c WHERE User_Order_ID__c = '567890' LIMIT 1];
        System.assertEquals(1, theItems.size());

    }
}