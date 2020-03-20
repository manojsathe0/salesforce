@isTest
public class LookupSalesQAControllerTest 
{
	public static User testUser;	
	public static String query;
	
	static void setupData()
	{
		testUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId, true);
	}

    static testMethod void test() 
    {
	   setupData();
       LookupSalesQAController lookup = new LookupSalesQAController();
       lookup.query = 'TestUser';
       lookup.runQuery();
    }
}