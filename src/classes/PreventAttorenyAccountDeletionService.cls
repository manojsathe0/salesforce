public with sharing class PreventAttorenyAccountDeletionService
{
	public final static String DELETE_PREVENT_MESSAGE = 'You are not allowed to delete Attorney Account';
	public static void preventAttorenyAccountDeletion(List<Account> oldAccounts)
	{
		List<User> currentUser = [SELECT Id , Profile.Name FROM User WHERE Id = : UserInfo.getUserId()];
		for(Account theAccount : oldAccounts)
		{
			if(theAccount.Name == GenericAttorenyAccountName && !AllowedAttorenyDeleteProfiles.contains(currentUser[0].Profile.Name))
			{
				theAccount.addError(DELETE_PREVENT_MESSAGE);
			}
		}
	}
	
	public static String GenericAttorenyAccountName
	{
		get
		{
			if(null == GenericAttorenyAccountName)
			{
				List<Generic_Attorney_Account_Name__c> genericAttorenyAccounts = Generic_Attorney_Account_Name__c.getAll().values();
				if(!genericAttorenyAccounts.isEmpty())
					GenericAttorenyAccountName = genericAttorenyAccounts[0].Name;
			}
			
			return GenericAttorenyAccountName;
		}
	}
	
	public static Set<String> AllowedAttorenyDeleteProfiles
	{
		get
		{
			if(null == AllowedAttorenyDeleteProfiles)
			{
				AllowedAttorenyDeleteProfiles = new Set<String>();
				List<Attoreny_Account_Contact_Delete_Profile__c> deletionAllowedProfiles = Attoreny_Account_Contact_Delete_Profile__c.getAll().values();
				if(!deletionAllowedProfiles.isEmpty())
					AllowedAttorenyDeleteProfiles.add(deletionAllowedProfiles[0].Name);
			}
			
			return AllowedAttorenyDeleteProfiles;
		}
	}
}