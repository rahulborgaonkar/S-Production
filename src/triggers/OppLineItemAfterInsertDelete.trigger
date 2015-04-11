trigger OppLineItemAfterInsertDelete on OpportunityLineItem (after delete, after insert) 
{
	
	Set<Id> oppIds = new Set<Id>(); 
	if(Trigger.isInsert)
	{
		for(OpportunityLineItem oli: trigger.New)
		{
			oppIds.add(oli.OpportunityId);
		}
	}
	else
	{
		for(OpportunityLineItem oli: trigger.Old)
		{
			oppIds.add(oli.OpportunityId);
		}
	}
	
	Set<Id> oppIdsWithVOIP = new Set<Id>(); 
	for(OpportunityLineItem oli: [select OpportunityId from OpportunityLineItem
									 where OpportunityId in:oppIds and PricebookEntry.Product2.Requires_VoIP__c = true])
	{
		oppIdsWithVOIP.add(oli.OpportunityId);
	}
	
	List<Opportunity> lstOpps = [select Id, Requires_VoIP__c from Opportunity where Id in: oppIds];
	for(Opportunity o: lstOpps)
	{
		if(oppIdsWithVOIP.contains(o.Id))
			o.Requires_VoIP__c = true;
		else
			o.Requires_VoIP__c = false;
	}
	
	update lstOpps;
}