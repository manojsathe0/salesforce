/**
 * Created by jboles on 4/25/2017.
 */

public class MyAccountActivityService
{
    public static void deleteMyAccountActivities(List<My_Account_Activity__c> toDeleteList)
    {
        Database.DeleteResult[] drList = Database.delete(toDeleteList, false);

        String errorMessage = '';
        for (Database.DeleteResult dr : drList)
        {

            if (dr.isSuccess())
            {
                System.debug('Successfully deleted My_Account_Activity__c. My_Account_Activity__c id: ' + dr.getId());
            }
            else
            {
                for(Database.Error err : dr.getErrors())
                {
                    errorMessage+='\n' + err.getStatusCode() + ': ' + err.getMessage();
                    errorMessage+='My_Account_Activity__c fields that affected this error: ' + err.getFields();
                }
            }
        }
        if(toDeleteList.size()>0)
            Database.emptyRecycleBin(toDeleteList);

        if(errorMessage!= '')
        {
            SendExceptionEmail.sendDeleteExceptionEmail(errorMessage , 'My Account Activity');
        }
    }
}