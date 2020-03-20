trigger LeadFindMatchingAccount on Lead (before insert) {
	//Padma @B-33310
	/*Set<String> leadEmailSet = new Set<String>();
	List<Lead> leadList = new List<Lead>();
	Map<String, Id> leadAcctMap = new Map<String, Id>();
	String matchAccountId; 

	for (Lead l: trigger.new) {
		leadEmailSet.add(l.Company);
		leadList.add(l);
	}
	
    Account[] acctList = [SELECT Id, Name FROM Account WHERE Name in : leadEmailSet ORDER BY Name];
	if (acctList.size() > 0) {
		for (Lead l: leadList) {
			for (Account a: acctList) {
				if (l.Company == a.Name) {
					leadAcctMap.put(l.Company,a.Id);
					break;
				}
			}
		}
	}

	for (Lead l: trigger.new) {
		l.Account__c = leadAcctMap.containsKey(l.Company) ? leadAcctMap.get(l.Company) : NULL;
	}
	*/
}