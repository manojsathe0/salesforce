@isTest 
public class CT_BaseTriggerHandlerTest 
{
   static testMethod void test_CT_BaseTriggerHandler()
    {
        CT_BaseTriggerHandler ctrl = new CT_BaseTriggerHandler();
        Boolean test = ctrl.IsTriggerContext;
        test = ctrl.IsTriggerContext;
        test = ctrl.IsVisualforcePageContext;
        test = ctrl.IsWebServiceContext;
        test = ctrl.IsExecuteAnonymousContext;
    }
}