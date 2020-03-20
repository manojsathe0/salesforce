/**
 * Created by jboles on 4/26/2017.
 */

public class OptInService
{
    public static void deleteOptIns(List<Opt_In_Cart_Item__c> toDeleteList)
    {
        Database.DeleteResult[] drList = Database.delete(toDeleteList, false);

        String errorMessage = '';
        for (Database.DeleteResult dr : drList)
        {

            if (dr.isSuccess())
            {
                System.debug('Successfully deleted Opt_In_Cart_Item__c. Opt_In_Cart_Item__c id: ' + dr.getId());
            }
            else
            {
                for(Database.Error err : dr.getErrors())
                {
                    errorMessage+='\n' + err.getStatusCode() + ': ' + err.getMessage();
                    errorMessage+='Opt_In_Cart_Item__c fields that affected this error: ' + err.getFields();
                }
            }
        }
        if(toDeleteList.size()>0)
            Database.emptyRecycleBin(toDeleteList);

        if(errorMessage!= '')
        {
            SendExceptionEmail.sendDeleteExceptionEmail(errorMessage , 'Opt In / Cart Item');
        }
    }
}