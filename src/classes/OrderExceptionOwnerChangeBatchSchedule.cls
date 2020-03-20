/*
	Created by: Artyom M.
	Per story: B-28448
*/
global class OrderExceptionOwnerChangeBatchSchedule implements schedulable {
    global void execute(SchedulableContext sc) {
<<<<<<< HEAD
        Database.executebatch(new OrderExceptionOwnerChangeBatch(), 50);
=======
        Database.executebatch(new OrderExceptionOwnerChangeBatch(), 200);
>>>>>>> branch 'sead' of https://github.legalzoom.com/enterprise-applications/LZ-Salesforce/
    }
}