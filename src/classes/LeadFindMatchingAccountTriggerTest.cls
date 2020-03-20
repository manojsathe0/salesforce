@isTest
private class LeadFindMatchingAccountTriggerTest {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<Account> a = new List<Account>();
        List<Lead> l = new List<Lead>();
        Boolean evaluate = TRUE;

        for(integer i=1; i<=19; i++) {
            a.add( new Account(Name = 'a......'+i+'test@test.com') );
        }
        insert a;
        
        for(integer i=1; i<=20; i++) {
            l.add( new Lead(FirstName = 'first'+i, LastName = 'last'+i, Company = 'a......'+i+'test@test.com') );
        }
        insert l;
        
        for(Lead ll:[SELECT Company, Account__r.Name FROM Lead WHERE Company LIKE 'a......%test@test.com']) {
			if ((ll.Company <> ll.Account__r.Name) && (ll.Company <> 'a......20test@test.com')) {
				evaluate = FALSE;
			}
			if ((ll.Company == 'a......20test@test.com') && (ll.Account__c <> null)) {
				evaluate = FALSE;
			}
		}
        
        System.assert(evaluate);
    }
}