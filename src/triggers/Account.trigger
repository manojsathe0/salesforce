trigger Account on Account (before delete, before insert, before update)
{
	
		//Padma @B-25288
	
	if(Trigger.isBefore ){
		if(Trigger.isInsert || Trigger.isUpdate){
			List<Account> acctoupdate = new List<Account>();
			for(Account acc : Trigger.new){
				if(acc.Life_Plan_Company__c !=null && acc.Life_Plan_Company__c !='' && (acc.Life_Plan_Company__c).containsIgnoreCase('Lifeplan')){
					acctoupdate.add(acc);
				}
			} 
			AccountService.updatecompanyname(acctoupdate);			
		}
	}
    if(Trigger.isDelete)
    {
        PreventAttorenyAccountDeletionService.preventAttorenyAccountDeletion(Trigger.Old);
    }
   
}