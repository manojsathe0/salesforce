//@author : CloudTrigger Inc.
//@date : 11/17/2011
//@description :	class providing public interfaces; software development "best practices" prescribe coding to interfaces INSTEAD of concrete
//					implementations of classes, so these interfaces provide the "contracts" which are coded to.
public with sharing class CT_ITriggerHandler
{
    public virtual interface IBaseTriggerHandler
    {
        void OnAfterInsert(SObject[] newSObjects);
        void OnAfterUpdate(SObject[] oldSObjects, SObject[] updatedSObjects, map<ID, SObject> SObjectMap);

/*      NOTE: if these event methods are ever needed, they should NOT be uncommented here in "IBaseTriggerHandler" because
		it would impact all classes implementing these interfaces that are already in use.  Instead, put the methods in new
		'child' (derived) interfaces [see below] as needed
		
		void OnBeforeInsert(SObject[] newSObjects);
		void OnBeforeUpdate(SObject[] oldSObjects, SObject[] updatedSObjects, map<ID, SObject> SObjectMapNew, map<ID, SObject> SObjectMapOld);
        void OnBeforeDelete(SObject[] SObjectsToDelete, map<ID, SObject> SObjectMap);
        void OnAfterDelete(SObject[] deletedSObjects, map<ID, SObject> SObjectMap);
        void OnUndelete(SObject[] restoredSObjects);
*/
    }

    public interface IAccountTriggerHandler extends IBaseTriggerHandler
    {
    }

    public interface ICaseTriggerHandler extends IBaseTriggerHandler
    {
    	void OnBeforeInsert(SObject[] newSObjects);
    }

    public interface IContactTriggerHandler extends IBaseTriggerHandler
    {
    }

}