global with sharing class TaskWrapper implements Comparable
{
  public Task theTask{get;set;}
  public DateTime taskCreatedDateTime{get;set;}
  
  public TaskWrapper(Task task , DateTime theTime)
  {
    theTask = task;
    taskCreatedDateTime = theTime;
  }
  
  global Integer compareTo(Object other)
  {
     DateTime otherDateTime = ((TaskWrapper)other).taskCreatedDateTime;   
     long diff = otherDateTime.getTime() - this.taskCreatedDateTime.getTime();
     return diff > 0 ? 1 : (diff < 0) ? -1 : 0;
  }
}