trigger LeadBeforeTrigger on Lead (before insert) 
{
	for( Lead l : Trigger.new)
	{
		if(String.isnotblank(l.leadsource) && l.leadsource.contains('SFDC-'))
		{
			l.crm_product__c = '001G000000t020N';
		}
	}
}