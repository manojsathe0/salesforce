public class ComplianceReviewService
{
    public static Map<ID, Compliance_Review__c> oldComplianceCorrectivePlanMap = new Map<ID, Compliance_Review__c>();
    public static Set<ID> setReps = new Set<ID>();
    public static final String WRITTEN_WARNING_PERIOD = 'Written Warning Period';
    public static final String DAY_VIOLATIONS = 'Day Violations';
    public static final String CORRECTIVE_PLAN_UPL_COACHING = 'Corrective Plan UPL Coaching';
    public static final String SECOUND_WRITTEN_WARNING = '2nd Written';
    public static final String TERMINATION = 'Termination';
    public static final String REP_COACHING_COMPLETE_STATUS = 'Rep Coaching Completed';
    public static Boolean extendedCorrectDate = false;
    
    public static void setSalesRepManagerField(List<Compliance_Review__c> lstReviews)
    {
        setNewRepSET(lstReviews);
        Map<ID, User> mapRepIdToUser = new Map<ID, User>([SELECT Id, ManagerId FROM User WHERE Id IN :setReps]);

        for(Compliance_Review__c cr : lstReviews)
        {
            if(mapRepIdToUser.get(cr.Representative__c) != null)
            {
                User rep = mapRepIdToUser.get(cr.Representative__c);
                if(rep.ManagerId != null) 
                {
                    cr.Sales_Rep_Manager__c = rep.ManagerId;
                }
            }  
        }
    }
    
    public static void setNewRepSET(List<Compliance_Review__c> lstReviews)
    {
        for(Compliance_Review__c cr : lstReviews)
        {
            if(cr.Representative__c != null) 
            {
                setReps.add(cr.Representative__c);
            }
        }
    }
    
    public static void lastCorrectivePlan(List<Compliance_Review__c> compliance)
    {
        List<Compliance_Review__c> oldComplianceForCountList = new List<Compliance_Review__c>();
        setNewRepSET(compliance);
        Compliance_Review_Status__c repCoachingCompletedStatus = Compliance_Review_Status__c.getInstance(REP_COACHING_COMPLETE_STATUS);
        List<Compliance_Review__c> oldCompliancelist = new List<Compliance_Review__c>([SELECT Compliance_Review__c.ID, 
                                                      Compliance_Review__c.Representative__c,
                                                      Compliance_Review__c.Name,
                                                      Compliance_Review__c.Status__c,
                                                      Compliance_Review__c.UPL_Violation__c,
                                                      Compliance_Review__c.Unethical_Business_Practice_Violation__c,
                                                      Compliance_Review__c.Disclaimer_Violation__c,
                                                      Compliance_Review__c.Unauthorized_Discount_Violation__c,
                                                      Compliance_Review__c.Customer_Verification_Violation__c,
                                                      Compliance_Review__c.Tax_Advice_Violation__c,
                                                      Compliance_Review__c.Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.Corrective_Plan_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.Corrective_Plan_Discounts__c,
                                                      Compliance_Review__c.Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.Corrective_Plan_Security__c,
                                                      Compliance_Review__c.Corrective_Plan_Service__c,
                                                      Compliance_Review__c.LCP_UPL__c,
                                                      Compliance_Review__c.LCP_UPL_Reference__c,
                                                      Compliance_Review__c.LCP_UPL_Start_Date__c,
                                                      Compliance_Review__c.LCP_UPL_Coaching__c,
                                                      Compliance_Review__c.LCP_UPL_Coaching_Date__c,
                                                      Compliance_Review__c.LCP_UPL_Coaching_Reference__c,
                                                      Compliance_Review__c.LCP_Unethical_Business_Practice__c,
                                                      Compliance_Review__c.LCP_Unethical_Business_Practice_Ref__c,
                                                      Compliance_Review__c.LCP_Unethical_Practice_Start_Date__c,
                                                      Compliance_Review__c.LCP_Outbound_Disclaimer__c,
                                                      Compliance_Review__c.LCP_Outbound_Disclaimer_Reference__c,
                                                      Compliance_Review__c.LCP_Outbound_Disclaimer_Start_Date__c,
                                                      Compliance_Review__c.LCP_Security__c,
                                                      Compliance_Review__c.LCP_Security_Reference__c,
                                                      Compliance_Review__c.LCP_Security_Start_Date__c,
                                                      Compliance_Review__c.LCP_Discounts__c,
                                                      Compliance_Review__c.LCP_Discounts_Reference__c,
                                                      Compliance_Review__c.LCP_Discounts_Start_Date__c,
                                                      Compliance_Review__c.LCP_Taxation__c,
                                                      Compliance_Review__c.LCP_Taxation_Reference__c,
                                                      Compliance_Review__c.LCP_Taxation_Start_Date__c,
                                                      Compliance_Review__c.LCP_Service__c,
                                                      Compliance_Review__c.LCP_Service_Reference__c,
                                                      Compliance_Review__c.LCP_Service_Start_Date__c,
                                                      Compliance_Review__c.LCP_Written_Warning_Number__c,
                                                      Compliance_Review__c.LCP_Written_Warning_Reference__c,
                                                      Compliance_Review__c.CP_Written_Warning_Number_Formula__c,
                                                      Compliance_Review__c.LCP_Fee__c,
                                                      Compliance_Review__c.LCP_Fee_Reference__c,
                                                      Compliance_Review__c.LCP_Fee_StartDate__c,
                                                      Compliance_Review__c.Fee_Violation__c,
                                                      Compliance_Review__c.Corrective_Plan_Fee__c,
                                                      Compliance_Review__c.CCS_Corrective_Plan_UPL__c,
                                                      Compliance_Review__c.CCS_LCP_UPL__c,    
                                                      Compliance_Review__c.CCS_LCP_UPL_Reference__c, 
                                                      Compliance_Review__c.CCS_LCP_UPL_Start_Date__c,
                                                      Compliance_Review__c.CCS_Corrective_Plan_UPL_Coaching__c,
                                                      Compliance_Review__c.CCS_LCP_UPL_Coaching__c,    
                                                      Compliance_Review__c.CCS_LCP_UPL_Coaching_Reference__c, 
                                                      Compliance_Review__c.CCS_LCP_UPL_Coaching_Start_Date__c, 
                                                      Compliance_Review__c.CCS_Corrective_Plan_Disclaimer__c,
                                                      Compliance_Review__c.CCS_LCP_Disclaimer__c,    
                                                      Compliance_Review__c.CCS_LCP_Disclaimer_Reference__c, 
                                                      Compliance_Review__c.CCS_LCP_Disclaimer_Start_Date__c,
                                                      Compliance_Review__c.CCS_LCP_2nd_Disclaimer__c,    
                                                      Compliance_Review__c.CCS_LCP_2nd_Disclaimer_Reference__c, 
                                                      Compliance_Review__c.CCS_LCP_2nd_Disclaimer_Start_Date__c,
                                                      Compliance_Review__c.CCS_Corrective_Plan_2nd_Disclaimer__c,
                                                      Compliance_Review__c.CCS_Corrective_Plan_Security__c,
                            Compliance_Review__c.CCS_LCP_Security__c,
                            Compliance_Review__c.CCS_LCP_Security_Reference__c,
                            Compliance_Review__c.CCS_LCP_Security_Start_Date__c,
                                                      Compliance_Review__c.CCS_Corrective_Plan_Taxation__c,
                                                      Compliance_Review__c.CCS_LCP_Taxation__c,
                                                      Compliance_Review__c.CCS_LCP_Taxation_Referenece__c,
                                                      Compliance_Review__c.CCS_LCP_Taxation_Start_Date__c,
                                                      Compliance_Review__c.CreatedDate,
                                                      Compliance_Review__c.Extended_Corrective_Plan_Start_Date__c,
                                                      Compliance_Review__c.Cp_2nd_Contact_Disclaimer__c,
                                                      Compliance_Review__c.LCP_2nd_Contact_Disclaime__c,
                                                      Compliance_Review__c.LCP_2nd_Contact_Disclaimer_Reference__c,
                                                      Compliance_Review__c.LCP_2nd_Contact_Disclaimer_startDate__c


                                               FROM Compliance_Review__c 
                                               WHERE Compliance_Review__c.Representative__c IN: setReps
                                               AND ((Compliance_Review__c.Status__c =: repCoachingCompletedStatus.Compliance_Status__c))
                                               order by Compliance_Review__c.CreatedDate ASC]);
                                               
        if(oldCompliancelist.size() > 0)
        {
            for(Compliance_Review__c compOld : oldCompliancelist)
            {
                oldComplianceCorrectivePlanMap.put(compOld.Representative__c, compOld); 
            }
        }
        
        Compliance_Review_Number_Of_DayMonth__c writtenWarningPeriod = Compliance_Review_Number_Of_DayMonth__c.getInstance(WRITTEN_WARNING_PERIOD);
        Compliance_Review_Number_Of_DayMonth__c dayValidations = Compliance_Review_Number_Of_DayMonth__c.getInstance(DAY_VIOLATIONS);
        Compliance_Review_Number_Of_DayMonth__c dayCorrectivePlanUPLCoaching = Compliance_Review_Number_Of_DayMonth__c.getInstance(CORRECTIVE_PLAN_UPL_COACHING);
        Compliance_Review_Last_Corrective_Plan__c dayViolationsStatus = Compliance_Review_Last_Corrective_Plan__c.getInstance(DAY_VIOLATIONS);
        Compliance_Review_Last_Corrective_Plan__c writtenWarningPeriodStatus = Compliance_Review_Last_Corrective_Plan__c.getInstance(WRITTEN_WARNING_PERIOD);
        Compliance_Review_Last_Corrective_Plan__c terminationtStatus = Compliance_Review_Last_Corrective_Plan__c.getInstance(TERMINATION);
        for(Compliance_Review__c newCompliance : compliance)
        {
            if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c) != null)
            {
                System.debug('>>>>> oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c) != null : '+oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c));
                System.debug('>>>>> oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL__c : '+oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL__c);
                System.debug('>>>>> oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c : '+oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                
                //LCP UPL
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL__c;
                            newCompliance.LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL__c;
                        newCompliance.LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL__c;
                            newCompliance.LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Reference__c;
                            newCompliance.LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL__c;
                        newCompliance.LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Reference__c;
                        newCompliance.LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Start_Date__c;
                    }
                }
                
                //CCS LCP UPL 
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.CCS_LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL__c;
                            newCompliance.CCS_LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.CCS_LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL__c;
                        newCompliance.CCS_LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.CCS_LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.CCS_LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL__c;
                            newCompliance.CCS_LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Reference__c;
                            newCompliance.CCS_LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.CCS_LCP_UPL__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL__c;
                        newCompliance.CCS_LCP_UPL_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Reference__c;
                        newCompliance.CCS_LCP_UPL_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Start_Date__c;
                    }
                }
                
                //LCP UPL Coaching
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL_Coaching__c != null)
                {
                    
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL_Coaching__c;
                            newCompliance.LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_UPL_Coaching_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL_Coaching__c;
                        newCompliance.LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_UPL_Coaching_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_UPL_Coaching__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching__c;
                            newCompliance.LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Reference__c;
                            newCompliance.LCP_UPL_Coaching_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching__c;
                        newCompliance.LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Reference__c;
                        newCompliance.LCP_UPL_Coaching_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_UPL_Coaching_Date__c;
                    }
                }
                
                //CCS LCP UPL Coaching
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL_Coaching__c != null)
                {
                    
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.CCS_LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL_Coaching__c;
                            newCompliance.CCS_LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_UPL_Coaching_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.CCS_LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL_Coaching__c;
                        newCompliance.CCS_LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.CCS_LCP_UPL_Coaching_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_UPL_Coaching__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.CCS_LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching__c;
                            newCompliance.CCS_LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Reference__c;
                            newCompliance.CCS_LCP_UPL_Coaching_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.CCS_LCP_UPL_Coaching__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching__c;
                        newCompliance.CCS_LCP_UPL_Coaching_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Reference__c;
                        newCompliance.CCS_LCP_UPL_Coaching_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_UPL_Coaching_Start_Date__c;
                    }
                }
                
                //LCP Unethical Business Practice
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CP_Unethical_Business_Practice__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_Unethical_Business_Practice__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CP_Unethical_Business_Practice__c;
                            newCompliance.LCP_Unethical_Business_Practice_Ref__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Unethical_Practice_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_Unethical_Business_Practice__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CP_Unethical_Business_Practice__c;
                        newCompliance.LCP_Unethical_Business_Practice_Ref__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_Unethical_Practice_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CP_Unethical_Business_Practice__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Business_Practice__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Business_Practice_Ref__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Practice_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Practice_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_Unethical_Business_Practice__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Business_Practice__c;
                            newCompliance.LCP_Unethical_Business_Practice_Ref__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Business_Practice_Ref__c;
                            newCompliance.LCP_Unethical_Practice_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Practice_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_Unethical_Business_Practice__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Business_Practice__c;
                        newCompliance.LCP_Unethical_Business_Practice_Ref__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Business_Practice_Ref__c;
                        newCompliance.LCP_Unethical_Practice_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Unethical_Practice_Start_Date__c;
                    }
                }

                //lcp fee disclaimer
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c;
                            newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c;
                                newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c;
                            newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c))
                    {
                        newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c;
                        newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Fee__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_StartDate__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_StartDate__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c;
                            newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_Reference__c;
                            newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_StartDate__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c;
                                newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_Reference__c;
                                newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_StartDate__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c;
                            newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_Reference__c;
                            newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_StartDate__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c))
                    {
                        newCompliance.LCP_Fee__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee__c;
                        newCompliance.LCP_Fee_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_Reference__c;
                        newCompliance.LCP_Fee_StartDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Fee_StartDate__c;
                    }
                }
                system.debug('start ---------- @nd Disclaimer');
                //lcp outbound 2nd contact disclaimer
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c;
                            newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c;
                                newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c;
                            newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c))
                    {
                        newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c;
                        newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Cp_2nd_Contact_Disclaimer__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_startDate__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_startDate__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c;
                            newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_Reference__c;
                            newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_startDate__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c;
                                newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_Reference__c;
                                newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_startDate__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c;
                            newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_Reference__c;
                            newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_startDate__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c))
                    {
                        newCompliance.LCP_2nd_Contact_Disclaime__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaime__c;
                        newCompliance.LCP_2nd_Contact_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_Reference__c;
                        newCompliance.LCP_2nd_Contact_Disclaimer_startDate__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_2nd_Contact_Disclaimer_startDate__c;
                    }
                }

                //CCS lcp outbound 2nd contact disclaimer
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c != null) 
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c;
                                newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c))
                    {
                        newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c;
                        newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_2nd_Disclaimer__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Reference__c;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c;
                                newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Reference__c;
                                newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Reference__c;
                            newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c))
                    {
                        newCompliance.CCS_LCP_2nd_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer__c;
                        newCompliance.CCS_LCP_2nd_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Reference__c;
                        newCompliance.CCS_LCP_2nd_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_2nd_Disclaimer_Start_Date__c;
                    }
                }
                    
                //LCP Outbound Disclaimer
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Outbound_Disclaimer__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_Outbound_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Outbound_Disclaimer__c;
                            newCompliance.LCP_Outbound_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Outbound_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_Outbound_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Outbound_Disclaimer__c;
                        newCompliance.LCP_Outbound_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_Outbound_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Outbound_Disclaimer__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.LCP_Outbound_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer__c;
                            newCompliance.LCP_Outbound_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Reference__c;
                            newCompliance.LCP_Outbound_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.LCP_Outbound_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer__c;
                        newCompliance.LCP_Outbound_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Reference__c;
                        newCompliance.LCP_Outbound_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Outbound_Disclaimer_Start_Date__c;
                    }
                }
                
                //CCS LCP Outbound Disclaimer
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Disclaimer__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.CCS_LCP_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Disclaimer__c;
                            newCompliance.CCS_LCP_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.CCS_LCP_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Disclaimer__c;
                        newCompliance.CCS_LCP_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.CCS_LCP_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Disclaimer__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Start_Date__c);
                    Date todayDate = System.today();
                    Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                    if(monthDiff == writtenWarningPeriod.Number__c)
                    {
                        System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                        if(todayDate.day() <= oldCompCreatedDate.day())
                        {
                            newCompliance.CCS_LCP_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer__c;
                            newCompliance.CCS_LCP_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Reference__c;
                            newCompliance.CCS_LCP_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Start_Date__c;
                        }
                    }
                    else if(monthDiff < writtenWarningPeriod.Number__c)
                    {
                        newCompliance.CCS_LCP_Disclaimer__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer__c;
                        newCompliance.CCS_LCP_Disclaimer_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Reference__c;
                        newCompliance.CCS_LCP_Disclaimer_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Disclaimer_Start_Date__c;
                    }
                }
                    
                //LCP Security
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c;
                            newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c;
                                newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c;
                            newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c))
                    {
                        newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c;
                        newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Security__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c;
                            newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Reference__c;
                            newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c;
                                newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Reference__c;
                                newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c;
                            newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Reference__c;
                            newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Start_Date__c;  
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c))
                    {
                        newCompliance.LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security__c;
                        newCompliance.LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Reference__c;
                        newCompliance.LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Security_Start_Date__c;
                    }
                }
                
                //CCS LCP Security
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c;
                            newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c;
                                newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c;
                            newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c))
                    {
                        newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c;
                        newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Security__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c;
                            newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Reference__c;
                            newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c;
                                newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Reference__c;
                                newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c;
                            newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Reference__c;
                            newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Start_Date__c;  
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c))
                    {
                        newCompliance.CCS_LCP_Security__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security__c;
                        newCompliance.CCS_LCP_Security_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Reference__c;
                        newCompliance.CCS_LCP_Security_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Security_Start_Date__c;
                    }
                }
                    
                //LCP Taxation
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c;
                            newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c;
                                newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c;
                            newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c))
                    {
                        newCompliance.LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c;
                        newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Taxation__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Reference__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c;
                            newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Reference__c;
                            newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c;
                                newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Reference__c;
                                newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c;
                            newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Reference__c;
                            newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c))
                    {
                        newCompliance.LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation__c;
                        newCompliance.LCP_Taxation_Reference__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Reference__c;
                        newCompliance.LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).LCP_Taxation_Start_Date__c;
                    }
                }

                //CCS LCP Taxation
                if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.CCS_LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c;
                            newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.CCS_LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c;
                                newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                                newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.CCS_LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c;
                            newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                            newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c))
                    {
                        newCompliance.CCS_LCP_Taxation__c= oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c;
                        newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Id;
                        newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).Corrective_Plan_Start_Date__c;
                    }
                }
                else if(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_Corrective_Plan_Taxation__c == null && 
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Referenece__c != null &&
                        oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Start_Date__c != null)
                {
                    Date oldCompCreatedDate = Date.valueOf(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Start_Date__c);
                    Date todayDate = System.today();
                    //90 Days Violation
                    if(dayViolationsStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c))
                    {
                        Integer days = oldCompCreatedDate.daysBetween(todayDate);
                        if(days <= dayValidations.Number__c)
                        {
                            newCompliance.CCS_LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c;
                            newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Referenece__c;
                            newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Start_Date__c;
                        }
                    }
                    //6 Months Violation
                    else if(writtenWarningPeriodStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c))
                    {
                        Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
                        if(monthDiff == writtenWarningPeriod.Number__c)
                        {
                            System.debug('>>>>> todayDate.day() : '+todayDate.day()+' <= oldCompCreatedDate.day() : '+oldCompCreatedDate.day());
                            if(todayDate.day() <= oldCompCreatedDate.day())
                            {
                                newCompliance.CCS_LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c;
                                newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Referenece__c;
                                newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Start_Date__c;
                            }
                        }
                        else if(monthDiff < writtenWarningPeriod.Number__c)
                        {
                            newCompliance.CCS_LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c;
                            newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Referenece__c;
                            newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Start_Date__c;
                        }
                    }
                    //Termination
                    else if(terminationtStatus.LCP_Status__c.contains(oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c))
                    {
                        newCompliance.CCS_LCP_Taxation__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation__c;
                        newCompliance.CCS_LCP_Taxation_Referenece__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Referenece__c;
                        newCompliance.CCS_LCP_Taxation_Start_Date__c = oldComplianceCorrectivePlanMap.get(newCompliance.Representative__c).CCS_LCP_Taxation_Start_Date__c;
                    }
                }                
            }
        }
        
        //Count Written Warning
        if(oldCompliancelist.size() > 0)
        {
            countWrittenWarning(compliance, oldCompliancelist);
        } 
    }
    
    
    public static void ExtendCorrectiveDate(List<Compliance_Review__c> newCompliance, Map<ID, Compliance_Review__c> oldCompMap)
    {      
    system.debug(newCompliance+'-----'+oldCompMap); 
        Set<ID> allref = new Set<ID> ();
        Set<ID> terminationref = new Set<ID> ();
        List<Compliance_Review__c> extendedlist = new List<Compliance_Review__c>();
        
        for(Compliance_Review__c newComp: newCompliance)
        {
          system.debug(newComp.Status__c +'-----'+REP_COACHING_COMPLETE_STATUS);
          if(newComp.Status__c == REP_COACHING_COMPLETE_STATUS  && newComp.Status__c != oldCompMap.get(newComp.id).Status__c)
          {
            system.debug('true');
          }
          else
          {
            system.debug('false');
          }
          if(newComp.Status__c == REP_COACHING_COMPLETE_STATUS)
            if(newComp.Status__c != oldCompMap.get(newComp.id).Status__c )
            {
                //UPL
                if(newComp.Corrective_Plan_UPL__c == SECOUND_WRITTEN_WARNING || newComp.Corrective_Plan_UPL__c == TERMINATION)
                {
                    allref.add(newComp.LCP_UPL_Reference__c);
                }
                if(newComp.Corrective_Plan_UPL__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_UPL_Reference__c);
                }
                
                //CCS UPL
                if(newComp.CCS_Corrective_Plan_UPL__c == SECOUND_WRITTEN_WARNING || newComp.CCS_Corrective_Plan_UPL__c == TERMINATION)
                {
                    allref.add(newComp.CCS_LCP_UPL_Reference__c);
                }
                if(newComp.CCS_Corrective_Plan_UPL__c == TERMINATION)
                {
                    terminationref.add(newComp.CCS_LCP_UPL_Reference__c);
                }
                
                //UPL Coaching
                if(newComp.Corrective_Plan_UPL_Coaching__c == SECOUND_WRITTEN_WARNING || newComp.Corrective_Plan_UPL_Coaching__c == TERMINATION)
                {
                    allref.add(newComp.LCP_UPL_Coaching_Reference__c);
                }
                if(newComp.Corrective_Plan_UPL__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_UPL_Coaching_Reference__c);
                }
                
                //CCS UPL Coaching
                if(newComp.CCS_Corrective_Plan_UPL_Coaching__c == SECOUND_WRITTEN_WARNING || newComp.CCS_Corrective_Plan_UPL_Coaching__c == TERMINATION)
                {
                    allref.add(newComp.CCS_LCP_UPL_Coaching_Reference__c);
                }
                if(newComp.CCS_Corrective_Plan_UPL__c == TERMINATION)
                {
                    terminationref.add(newComp.CCS_LCP_UPL_Coaching_Reference__c);
                }
                
                //Unethical Business Practice
                if(newComp.CP_Unethical_Business_Practice__c == SECOUND_WRITTEN_WARNING || newComp.CP_Unethical_Business_Practice__c == TERMINATION)
                {
                    allref.add(newComp.LCP_Unethical_Business_Practice_Ref__c);
                }
                if(newComp.CP_Unethical_Business_Practice__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_Unethical_Business_Practice_Ref__c);
                }
                
                // Outbound Disclaimer
                if(newComp.Corrective_Plan_Outbound_Disclaimer__c == SECOUND_WRITTEN_WARNING || newComp.Corrective_Plan_Outbound_Disclaimer__c == TERMINATION)
                {
                    allref.add(newComp.LCP_Outbound_Disclaimer_Reference__c);
                }
                if(newComp.Corrective_Plan_Outbound_Disclaimer__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_Outbound_Disclaimer_Reference__c);
                }
                
                // CCS Outbound Disclaimer
                if(newComp.CCS_Corrective_Plan_Disclaimer__c == SECOUND_WRITTEN_WARNING || newComp.CCS_Corrective_Plan_Disclaimer__c == TERMINATION)
                {
                    allref.add(newComp.CCS_LCP_Disclaimer_Reference__c);
                }
                if(newComp.CCS_Corrective_Plan_Disclaimer__c == TERMINATION)
                {
                    terminationref.add(newComp.CCS_LCP_Disclaimer_Reference__c);
                }

                // Outbound 2nd Disclaimer
                if(newComp.Cp_2nd_Contact_Disclaimer__c == SECOUND_WRITTEN_WARNING || newComp.Cp_2nd_Contact_Disclaimer__c == TERMINATION)
                {
                    allref.add(newComp.LCP_2nd_Contact_Disclaimer_Reference__c);
                }
                if(newComp.Cp_2nd_Contact_Disclaimer__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_2nd_Contact_Disclaimer_Reference__c);
                }

                // CCS Outbound 2nd Disclaimer
                if(newComp.CCS_Corrective_Plan_2nd_Disclaimer__c == SECOUND_WRITTEN_WARNING || newComp.CCS_Corrective_Plan_2nd_Disclaimer__c == TERMINATION)
                {
                    allref.add(newComp.CCS_LCP_2nd_Disclaimer_Reference__c);
                }
                if(newComp.CCS_Corrective_Plan_2nd_Disclaimer__c == TERMINATION)
                {
                    terminationref.add(newComp.CCS_LCP_2nd_Disclaimer_Reference__c);
                }

                // Fee
                if(newComp.Corrective_Plan_Fee__c == SECOUND_WRITTEN_WARNING || newComp.Corrective_Plan_Fee__c == TERMINATION)
                {
                    allref.add(newComp.LCP_Fee_Reference__c);
                }
                if(newComp.Corrective_Plan_Fee__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_Fee_Reference__c);
                }
                
                //Security
                if(newComp.Corrective_Plan_Security__c == SECOUND_WRITTEN_WARNING || newComp.Corrective_Plan_Security__c == TERMINATION)
                {
                    allref.add(newComp.LCP_Security_Reference__c);
                }
                if(newComp.Corrective_Plan_Security__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_Security_Reference__c);
                }
                
                //CCS Security
                if(newComp.CCS_Corrective_Plan_Security__c == SECOUND_WRITTEN_WARNING || newComp.CCS_Corrective_Plan_Security__c == TERMINATION)
                {
                    allref.add(newComp.CCS_LCP_Security_Reference__c);
                }
                if(newComp.CCS_Corrective_Plan_Security__c == TERMINATION)
                {
                    terminationref.add(newComp.CCS_LCP_Security_Reference__c);
                }
                
                //Taxation
                if(newComp.Corrective_Plan_Taxation__c == SECOUND_WRITTEN_WARNING || newComp.Corrective_Plan_Taxation__c == TERMINATION)
                {
                    allref.add(newComp.LCP_Taxation_Reference__c);
                }
                if(newComp.Corrective_Plan_Taxation__c == TERMINATION)
                {
                    terminationref.add(newComp.LCP_Taxation_Reference__c);
                }
                
                // CCS Taxation
                if(newComp.CCS_Corrective_Plan_Taxation__c == SECOUND_WRITTEN_WARNING || newComp.CCS_Corrective_Plan_Taxation__c == TERMINATION)
                {
                    allref.add(newComp.CCS_LCP_Taxation_Referenece__c);
                }
                if(newComp.CCS_Corrective_Plan_Taxation__c == TERMINATION)
                {
                    terminationref.add(newComp.CCS_LCP_Taxation_Referenece__c);
                }
        
            }
        }
    if(!terminationref.isEmpty())
        for (
                Compliance_Review__c terComp:[
                                                SELECT  LCP_UPL_Reference__c,
                                      CCS_LCP_UPL_Reference__c,
                                                        LCP_UPL_Coaching_Reference__c,
                                                        LCP_2nd_Contact_Disclaimer_Reference__c,
                                                        CCS_LCP_2nd_Disclaimer_Reference__c,
                                      CCS_LCP_UPL_Coaching_Reference__c,
                                                        LCP_Unethical_Business_Practice_Ref__c,
                                                        LCP_Outbound_Disclaimer_Reference__c,
                                      CCS_LCP_Disclaimer_Reference__c,
                                                        LCP_Security_Reference__c,
                                      CCS_LCP_Security_Reference__c,
                                                        LCP_Discounts_Reference__c,
                                                        LCP_Taxation_Reference__c,
                                      CCS_LCP_Taxation_Referenece__c,
                                                        
                                                        Corrective_Plan_UPL__c,
                                      CCS_Corrective_Plan_UPL__c,
                                                        Corrective_Plan_UPL_Coaching__c,
                                      CCS_Corrective_Plan_UPL_Coaching__c,
                                                        CP_Unethical_Business_Practice__c,
                                                        Corrective_Plan_Outbound_Disclaimer__c,
                                      CCS_Corrective_Plan_2nd_Disclaimer__c,
                                                        Cp_2nd_Contact_Disclaimer__c,
                                      CCS_LCP_2nd_Disclaimer__c,               
                                      CCS_Corrective_Plan_Disclaimer__c,
                                                        Corrective_Plan_Security__c,
                                      CCS_Corrective_Plan_Security__c,
                                                        Corrective_Plan_Discounts__c,
                                                        Corrective_Plan_Taxation__c,
                                      CCS_Corrective_Plan_Taxation__c,
                                                         
                                                        LCP_Fee__c,
                                                        LCP_Fee_Reference__c,
                                                        Corrective_Plan_Fee__c
                                                FROM Compliance_Review__c 
                                                WHERE ID IN :terminationref])
        {
            //UPL
            if(terComp.Corrective_Plan_UPL__c == SECOUND_WRITTEN_WARNING || terComp.Corrective_Plan_UPL__c == TERMINATION)
            {
                allref.add(terComp.LCP_UPL_Reference__c);
            }
            //CCS UPL
            if(terComp.CCS_Corrective_Plan_UPL__c == SECOUND_WRITTEN_WARNING || terComp.CCS_Corrective_Plan_UPL__c == TERMINATION)
            {
                allref.add(terComp.CCS_LCP_UPL_Reference__c);
            }
            
            //UPL Coaching
            if(terComp.Corrective_Plan_UPL_Coaching__c == SECOUND_WRITTEN_WARNING || terComp.Corrective_Plan_UPL_Coaching__c == TERMINATION)
            {
                allref.add(terComp.LCP_UPL_Coaching_Reference__c);
            }
            
            //CCS UPL Coaching
            if(terComp.CCS_Corrective_Plan_UPL_Coaching__c == SECOUND_WRITTEN_WARNING || terComp.CCS_Corrective_Plan_UPL_Coaching__c == TERMINATION)
            {
                allref.add(terComp.CCS_LCP_UPL_Coaching_Reference__c);
            }
            
            //Unethical Business Practice
            if(terComp.CP_Unethical_Business_Practice__c == SECOUND_WRITTEN_WARNING || terComp.CP_Unethical_Business_Practice__c == TERMINATION)
            {
                allref.add(terComp.LCP_Unethical_Business_Practice_Ref__c);
            }

            // Outbound Disclaimer
            if(terComp.Corrective_Plan_Outbound_Disclaimer__c == SECOUND_WRITTEN_WARNING || terComp.Corrective_Plan_Outbound_Disclaimer__c == TERMINATION)
            {
                allref.add(terComp.LCP_Outbound_Disclaimer_Reference__c);
            }
            
            // CCS Outbound Disclaimer
            if(terComp.CCS_Corrective_Plan_Disclaimer__c == SECOUND_WRITTEN_WARNING || terComp.CCS_Corrective_Plan_Disclaimer__c == TERMINATION)
            {
                allref.add(terComp.CCS_LCP_Disclaimer_Reference__c);
            }

            // 2nd Disclaimer
            if(terComp.Cp_2nd_Contact_Disclaimer__c == SECOUND_WRITTEN_WARNING || terComp.Cp_2nd_Contact_Disclaimer__c == TERMINATION)
            {
                allref.add(terComp.LCP_2nd_Contact_Disclaimer_Reference__c);
            }

            // CCS 2nd Disclaimer
            if(terComp.CCS_Corrective_Plan_2nd_Disclaimer__c == SECOUND_WRITTEN_WARNING || terComp.CCS_Corrective_Plan_2nd_Disclaimer__c == TERMINATION)
            {
                allref.add(terComp.CCS_LCP_2nd_Disclaimer_Reference__c);
            }

            //Security
            if(terComp.Corrective_Plan_Security__c == SECOUND_WRITTEN_WARNING || terComp.Corrective_Plan_Security__c == TERMINATION)
            {
                allref.add(terComp.LCP_Security_Reference__c);
            }
            
            //CCS Security
            if(terComp.CCS_Corrective_Plan_Security__c == SECOUND_WRITTEN_WARNING || terComp.CCS_Corrective_Plan_Security__c == TERMINATION)
            {
                allref.add(terComp.CCS_LCP_Security_Reference__c);
            }


            //Taxation
            if(terComp.Corrective_Plan_Taxation__c == SECOUND_WRITTEN_WARNING || terComp.Corrective_Plan_Taxation__c == TERMINATION)
            {
                allref.add(terComp.LCP_Taxation_Reference__c);
            }
            
            //CCS Taxation
            if(terComp.CCS_Corrective_Plan_Taxation__c == SECOUND_WRITTEN_WARNING || terComp.CCS_Corrective_Plan_Taxation__c == TERMINATION)
            {
                allref.add(terComp.CCS_LCP_Taxation_Referenece__c);
            }
            
            //Fee
            if(terComp.Corrective_Plan_Fee__c == SECOUND_WRITTEN_WARNING || terComp.Corrective_Plan_Fee__c == TERMINATION)
            {
                allref.add(terComp.LCP_Fee_Reference__c);
            }
        }
      
      if(!allref.isEmpty())
        for (Compliance_Review__c allComp:[Select id, Extended_Corrective_Plan_Start_Date__c from Compliance_Review__c where id IN :allref])
        {
            allComp.Extended_Corrective_Plan_Start_Date__c = System.Now();
            extendedlist.add(allComp);
        }
        update extendedlist;
    }  
    
    public static void countWrittenWarning(List<Compliance_Review__c> newCompliance, List<Compliance_Review__c> oldComplianceCorrectivePlanList)
    {
        //Get Custom setting
        Compliance_Review_Status__c repCoachingCompletedStatus = Compliance_Review_Status__c.getInstance(REP_COACHING_COMPLETE_STATUS);
        Compliance_Review_Number_Of_DayMonth__c writtenWarningPeriod = Compliance_Review_Number_Of_DayMonth__c.getInstance(WRITTEN_WARNING_PERIOD);       
        System.debug('>>>>> newCompliance : '+newCompliance);
        System.debug('>>>>> oldComplianceCorrectivePlanList : '+oldComplianceCorrectivePlanList);
        Map<id, Integer> ReptoNum = new Map<id, Integer>();
        Map<id, String> ReptoString = new Map<id, String>();
        
        for (Compliance_Review__c oldComp: oldComplianceCorrectivePlanList)
        {
          system.debug(oldComp);
            system.debug(oldComp.Corrective_Plan_Start_Date__c);
            system.debug(Date.valueOf(oldComp.Corrective_Plan_Start_Date__c));
            Date oldCompCreatedDate = Date.valueOf(oldComp.Corrective_Plan_Start_Date__c);
            
            if (oldComp.Extended_Corrective_Plan_Start_Date__c != null)
            {
                oldCompCreatedDate = date.valueOf(oldComp.Extended_Corrective_Plan_Start_Date__c);  
            }
            system.debug(oldCompCreatedDate);
            Date todayDate = System.today();
            Integer monthDiff = oldCompCreatedDate.monthsBetween(todayDate);
            System.debug('>>>>> oldCompCreatedDate : '+oldCompCreatedDate);
            System.debug('>>>>> monthDiff : '+monthDiff);
            if(monthDiff == writtenWarningPeriod.Number__c)
            {
                if(todayDate.day() <= oldCompCreatedDate.day())
                {
                    if (oldComp.CP_Written_Warning_Number_Formula__c > 0)
                    {
                        if (ReptoNum.get(oldComp.Representative__c) == null)
                        {
                            ReptoNum.put(oldComp.Representative__c, 1);
                            ReptoString.put(oldComp.Representative__c, oldComp.Name);
                        }
                        else 
                        {
                            ReptoNum.put(oldComp.Representative__c,ReptoNum.get(oldComp.Representative__c) + 1);
                            ReptoString.put(oldComp.Representative__c, ReptoString.get(oldComp.Representative__c)+', '+oldComp.Name);
                        }
                    }
                }   
            }
            else if(monthDiff < writtenWarningPeriod.Number__c) 
            {
                    
                if (oldComp.CP_Written_Warning_Number_Formula__c > 0)
                {
                    if (ReptoNum.get(oldComp.Representative__c) == null)
                    {                               
                        ReptoNum.put(oldComp.Representative__c,1);
                        ReptoString.put(oldComp.Representative__c, oldComp.Name);          
                    }
                    else 
                    {       
                        ReptoNum.put(oldComp.Representative__c,ReptoNum.get(oldComp.Representative__c) + 1);
                        ReptoString.put(oldComp.Representative__c, ReptoString.get(oldComp.Representative__c)+', '+oldComp.Name);
                    }               
                }
            }
        } 
        
       for (Compliance_Review__c newComp: newCompliance)
       {
            if (ReptoNum.get(newComp.Representative__c) != null){
            newComp.LCP_Written_Warning_Number__c = ReptoNum.get(newComp.Representative__c);
            newComp.CCS_Written_Warning_Number__c = ReptoNum.get(newComp.Representative__c);  
            }
            newComp.LCP_Written_Warning_Reference__c = ReptoString.get(newComp.Representative__c);
            newComp.CCS_Written_Warning_Reference__c = ReptoString.get(newComp.Representative__c);
       }  
    } 
}