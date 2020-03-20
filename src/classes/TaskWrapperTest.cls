@isTest
public class TaskWrapperTest 
{
  static testMethod void testDescendingSorting() //Latest First
  {
     List<TaskWrapper> theWrappers = new List<TaskWrapper>();
     theWrappers.add(new TaskWrapper(new Task() , DateTime.newInstance(2012, 10, 5, 12, 30, 2)));//19:30:02//second
     theWrappers.add(new TaskWrapper(new Task() , DateTime.newInstance(2012, 10, 5, 16, 18, 2)));//23:18:02//first
     theWrappers.add(new TaskWrapper(new Task() , DateTime.newInstance(2012, 9, 4, 13, 10, 2)));//20:10:02//fourth
     theWrappers.add(new TaskWrapper(new Task() , DateTime.newInstance(2012, 10, 4, 13, 10, 5)));//20:10:05//third
     
     Test.startTest();
        theWrappers.sort();
     Test.stopTest();
     
     System.assertEquals(DateTime.newInstance(2012, 10, 5, 16, 18, 2), theWrappers[0].taskCreatedDateTime);
     System.assertEquals(DateTime.newInstance(2012, 10, 5, 12, 30, 2), theWrappers[1].taskCreatedDateTime); 
     System.assertEquals(DateTime.newInstance(2012, 10, 4, 13, 10, 5), theWrappers[2].taskCreatedDateTime); 
     System.assertEquals(DateTime.newInstance(2012, 9, 4, 13, 10, 2), theWrappers[3].taskCreatedDateTime);  
  }
}