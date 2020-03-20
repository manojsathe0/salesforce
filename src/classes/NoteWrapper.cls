public class NoteWrapper implements Comparable
{
		
		public final static String DATE_TIME_FORMAT = 'MM/dd/yyyy hh:mm a';
		public String dateTimeCreatedInString{get;set;}
		public DateTime dateTimeCreated{get;set;}

		public String userName{get;set;}
		public String noteType{get;set;}
		public String status{get;set;}
		public String subject{get;set;}
		public String description{get;set;}
		public String id{get;set;}
		public List<NoteWrapper> caseComments{get;set;} 
		
		public String infoType{get;set;}
		public String caseNumber{get;set;}
		public enum SortField {DateTimeCreated , Name}
		public enum SortDirection {ASCENDING, DESCENDING}		
		
		public static SortDirection SORT_DIR = SortDirection.DESCENDING;
		public static SortField SORT_FIELD = SortField.DateTimeCreated;
		public static String INTEGRATION_USER = 'Integration User';
		public static String THE_SYSTEM = 'System';
		public String processingNumber{get;set;}
		public Boolean isGeneral{get;set;}

		public NoteWrapper(String theObjectId , DateTime theDateTime , String theName , String theType , String theStatus , String theSubject , String theDescription , String theInfoType , String theCaseNumber , String theProcessingNumber , Boolean theIsGeneral)
		{
			caseComments = new List<NoteWrapper>();
			id = theObjectId;
			dateTimeCreatedInString = theDateTime.format(DATE_TIME_FORMAT);
			dateTimeCreated = theDateTime;
			if(theName == INTEGRATION_USER)
				userName = THE_SYSTEM;
			else
				userName = theName;
			noteType = theType;
			status = theStatus;
			subject = theSubject;
			description = theDescription;
			infoType = theInfoType;
			caseNumber = theCaseNumber;
			processingNumber = theProcessingNumber;
			isGeneral = theIsGeneral;
		}

		public Integer compareTo(Object other)
		{
			if (SORT_FIELD == SortField.DateTimeCreated)
			{
				return compareToDateTime(other); 
			}
			else if (SORT_FIELD == SortField.Name)
			{
				return compareToName(other); 
			}
			return 0;
		}

		  
		Integer compareToName(Object other) 
		{
			String otherName = other != null ? ((NoteWrapper)other).userName : '';   
			if (SORT_DIR == sortDirection.ASCENDING)     
				return this.userName.compareTo(otherName);   
			else 
				return otherName.compareTo(this.userName);
		}

		Integer compareToDateTime(Object other) 
		{
		
			DateTime otherDateTime = ((NoteWrapper)other).dateTimeCreated;   
			if(SORT_DIR == sortDirection.DESCENDING)
			{
				long diff = otherDateTime.getTime() - this.dateTimeCreated.getTime();
				return diff > 0 ? 1 : (diff < 0) ? -1 : 0;
			}
			else
			{
				long diff =  this.dateTimeCreated.getTime() - otherDateTime.getTime();
				return diff > 0 ? 1 : (diff < 0) ? -1 : 0;
			}
		}
}