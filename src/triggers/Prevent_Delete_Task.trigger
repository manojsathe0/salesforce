trigger Prevent_Delete_Task on Task (before delete)
{
   List<Prevent_Delete_Task__c> allowedProfiles = Prevent_Delete_Task__c.getall().values();
   List<Profile>  currentProfile = [select Name from Profile where Id =:  UserInfo.getProfileId()];
   
   Set<String> profilesToAllowDelete = new Set<String>();
   for(Prevent_Delete_Task__c fi :allowedProfiles)
   {
		profilesToAllowDelete.add(fi.Name);
   }
   
   if(!profilesToAllowDelete.contains(currentProfile[0].Name))
   {	
	   for(Task task :Trigger.old)
	   {
			 task.addError('User can not delete this task record');
	   }
   }
}