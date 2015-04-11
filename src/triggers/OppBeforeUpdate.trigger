trigger OppBeforeUpdate on Opportunity (before update) 
{
	for(opportunity opp: trigger.new)
    {
    	/*
    	if(Trigger.oldMap.get(opp.id).CloseDate != opp.CloseDate 
            && opp.Order_Processed__c)
        */
        
		system.debug('Trigger.oldMap.get(opp.id).CloseDate - ' + Trigger.oldMap.get(opp.id).CloseDate);
		system.debug('opp.CloseDate - ' + opp.CloseDate);
		
        if(Trigger.oldMap.get(opp.id).CloseDate != opp.CloseDate 
            && opp.Next_Steps__c == 'Customer - Provisioned')
        {
        	opp.CloseDate.addError('You cannot change the close date of an order once it has been provisioned.');
        }
        
    	if(Trigger.oldMap.get(opp.id).Next_Steps__c != opp.Next_Steps__c 
            && opp.Next_Steps__c == 'Customer - Provisioned')
        {
        	opp.CloseDate = System.today();
        	opp.Date_Order_Provisioned__c = System.today();
        }
    }
}