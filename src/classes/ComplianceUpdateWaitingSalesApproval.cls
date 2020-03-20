public with sharing class ComplianceUpdateWaitingSalesApproval 
{
	public static final String AWAITING_STATUS = 'Awaiting Status';
	public static final String AWAITING_APPROVAL_DAY = 'Awaiting Approval Day';
	public static List<Compliance_Review__c> updateCompList = new List<Compliance_Review__c>();
	
	public static void doScheduling()
	{
    	try
    	{
    		Compliance_Review_Status__c awaitingStatus = Compliance_Review_Status__c.getInstance(AWAITING_STATUS);
            List<String> awaitingStatusList = awaitingStatus.Compliance_Status__c.split(', ');
	    	List<Compliance_Review__c> complianceList = [SELECT Compliance_Review__c.Id, 
	    													    Compliance_Review__c.Status__c,
	    														Compliance_Review__c.Awaiting_Sales_Approval_Date_Time__c,
	    														Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c
		    											 FROM Compliance_Review__c
		    											 WHERE Compliance_Review__c.Status__c IN: awaitingStatusList
    											 		 AND Compliance_Review__c.Awaiting_Sales_Approval_Date_Time__c != null
    											 		 AND Compliance_Review__c.Sent_Email_Waiting_Sales_Approval_3_Days__c = false
	    											];
	    	List<Holiday> holidayList = [SELECT Id, Name, ActivityDate FROM Holiday ];					
	    	if(complianceList.size() > 0)
	    	{
	    		Integer days;
	    		Integer hasHoliday = 0;
	    		for(Compliance_Review__c comp : complianceList)
	    		{
	    			if(awaitingStatus.Compliance_Status__c.contains(comp.Status__c) && comp.Awaiting_Sales_Approval_Date_Time__c != null && comp.Sent_Email_Waiting_Sales_Approval_3_Days__c == false)
	    			{
	    				days = findNoOfDays(Date.valueOf(comp.Awaiting_Sales_Approval_Date_Time__c), System.today());
	    				Compliance_Review_Number_Of_DayMonth__c awaitingApprovalDay = Compliance_Review_Number_Of_DayMonth__c.getInstance(AWAITING_APPROVAL_DAY);
    					if(holidayList.size() > 0)
    					{
    						//Holiday in Salesforce
		    				for(Holiday h : holidayList)
		    				{
		    					if(h.ActivityDate >= Date.valueOf(comp.Awaiting_Sales_Approval_Date_Time__c)  && h.ActivityDate <= System.today())
		    					{
		    						hasHoliday++;
		    					}
		    				}
    						//if this period has one or more holiday. days minus num of holiday
    						days = days - hasHoliday;
    						hasHoliday = 0; //reset
    						if(days == awaitingApprovalDay.Number__c)
    						{
    							comp.Sent_Email_Waiting_Sales_Approval_3_Days__c = true;
    							updateCompList.add(comp);
    						}
    					}
    					else
    					{	//if this period hasn't holiday
    						if(days == awaitingApprovalDay.Number__c)
    						{
    							comp.Sent_Email_Waiting_Sales_Approval_3_Days__c = true;
    							updateCompList.add(comp);
    						}
    					}
	    			}
	    		}
	    		update updateCompList;
	    	}
    	}
    	catch(System.Exception e)
    	{
    		System.debug(e.getMessage());
    	}
    }
    
    public static Integer findNoOfDays( Date startDate , Date endDate ) 
    {
	     Integer NoOfDays = 0;
	     Date tempStartDate = startDate;
	     for( integer i = 1; tempStartDate <= endDate; i ++ ) 
	     {
	       if(tempStartDate.daysBetween(tempStartDate.toStartofWeek()) == 0 ||
	          tempStartDate.daysBetween(tempStartDate.toStartofWeek()) == -6)
	       {
	           tempStartDate = tempStartDate.adddays(1);
	           continue;
	       }
	       NoOfDays = NoOfDays+1;
	       tempStartDate = tempStartDate.adddays(1);
	     }
     	return NoOfDays;
	}
}