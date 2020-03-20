public with sharing class DataHolder_CaseWrapper
{
	public CaseInfo theCase;
	public List<EmailMessage> emailMessages;
	public List<Task> tasks;
	
	public DataHolder_CaseWrapper(Case c ,  List<EmailMessage> eMessages, List<Task> theTasks)
	{
		theCase = new CaseInfo();
		populateCaseInfo(c);
		emailMessages = eMessages;
		tasks = theTasks;
	}
	
	public void populateCaseInfo(Case c)
	{
	  theCase.id = c.id;
	  theCase.Subject = c.Subject;
	  theCase.SuppliedName = c.SuppliedName;
	  theCase.SuppliedEmail = c.SuppliedEmail;
	  theCase.SuppliedPhone = c.SuppliedPhone;
	  theCase.SuppliedCompany = c.SuppliedCompany;
	  theCase.Type = c.Type;
	  theCase.Status = c.Status;
	  theCase.Reason = c.Reason;
	  theCase.Origin = c.Origin;
	  theCase.Priority = c.Priority;
	  theCase.Description = c.Description;
	  theCase.IsClosed = c.IsClosed;
	  theCase.ClosedDate = c.ClosedDate;
	  theCase.IsEscalated = c.IsEscalated;
	  theCase.CustomerId = c.Customer_Id__c;
	  
	}
	
	
	public class CaseInfo
	{
	  public Id id;
	  public String Subject;
	  public String SuppliedName;
	  public String SuppliedEmail;
	  public String SuppliedPhone;
	  public String SuppliedCompany;
	  public String Type;
	  public String Status;
	  public String Reason;
	  public String Origin;
	  public String Priority;
	  public String Description;
	  public Boolean IsClosed;
	  public Datetime ClosedDate;
	  public Boolean IsEscalated;
	  public String CustomerId;
	}
}