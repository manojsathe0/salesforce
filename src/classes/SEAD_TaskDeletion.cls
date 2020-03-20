global class SEAD_TaskDeletion implements Database.Batchable<sObject>, Database.Stateful
{
    public String errorMessage = '';
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'select id from Task where Marked_for_Delete__c = true limit 50000';

        system.debug('Task Deletion Query ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Task> tasksToDelete)
    {
        handleErrors(tasksToDelete);
    }
    global void handleErrors(List<Task> tasksToDelete)
    {
        try
        {
            Database.DeleteResult[] drList = Database.delete(tasksToDelete, false);

            for (Database.DeleteResult dr : drList)
            {

                if (dr.isSuccess())
                {
                    System.debug('Successfully deleted task. Task id: ' + dr.getId());
                }
                else {
                    for(Database.Error err : dr.getErrors())
                    {
                        errorMessage+='\n' + err.getStatusCode() + ': ' + err.getMessage();
                        errorMessage+='Task fields that affected this error: ' + err.getFields();
                    }
                }
            }

            Database.emptyRecycleBin(tasksToDelete);

        }
        catch(Exception e )
        {
            system.debug('Exception ' + e.getMessage());

            SendExceptionEmail.sendBatchExceptionEmail(e , 'SEAD_TaskDeletion');
        }
    }

    global void finish(Database.BatchableContext bc)
    {
        System.debug('done');
        if(errorMessage!= '')
        {
            SendExceptionEmail.sendDatabaseBatchExceptionEmail(errorMessage , 'SEAD_TaskDeletion');
        }
    }

}