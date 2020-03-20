trigger CustomerLogin on Customer_Login__c (after insert) 
{
	ContactService.populateCustomerLoginEmail(Trigger.new);
}