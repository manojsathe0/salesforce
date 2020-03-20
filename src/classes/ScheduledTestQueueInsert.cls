global class ScheduledTestQueueInsert implements Schedulable{
    global void execute(SchedulableContext ctx){
        ApexClass[] allClasses = [SELECT Id FROM ApexClass WHERE NamespacePrefix = ''];
        ApexTestQueueItem[] qItems = new ApexTestQueueItem[]{};
        for(ApexClass cls : allClasses){
            qItems.add(new ApexTestQueueItem(ApexClassId=cls.Id));
        }
        // Cant insert these inside a test class
        if(!Test.isRunningTest()){
            insert qItems;
        }
    }
}