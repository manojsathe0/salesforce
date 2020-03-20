public with sharing class PreventAttorneyContactDeletionService
{
	public final static String DELETE_PREVENT_MESSAGE = 'You are not allowed to delete Attorney Contact';
	public static void preventAttorenyContactDeletion(List<Contact> oldContacts)
	{
		List<User> currentUser = [SELECT Id , Profile.Name FROM User WHERE Id = : UserInfo.getUserId()];
		
		Map<Id , Contact> contactsWithAccountName = new Map<Id,Contact>([SELECT Id , Account.Name FROM Contact WHERE Id IN :oldContacts]);
		
		for(Contact theContact : oldContacts)
		{
			Contact contactWithAccName = contactsWithAccountName.get(theContact.Id);
			if(contactWithAccName != null)
			{
				if(contactWithAccName.Account != null)
				{
					if(contactWithAccName.Account.Name == PreventAttorenyAccountDeletionService.GenericAttorenyAccountName && 
					!PreventAttorenyAccountDeletionService.AllowedAttorenyDeleteProfiles.contains(currentUser[0].Profile.Name))
					{
						theContact.addError(DELETE_PREVENT_MESSAGE);
					}
				}
			}
		}
	}
	
}