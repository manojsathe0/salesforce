trigger Product2 on Product2 (before insert, before update)
{
	Product2Service.productMatchLookupValue(Trigger.new);
}