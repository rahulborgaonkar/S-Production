trigger OppLineItemBeforeInsertUpdate on OpportunityLineItem (before insert, before update) 
{
    Set<Id> oppIds = new Set<Id>(); 
    for(OpportunityLineItem oli: trigger.New)
    {
        oppIds.add(oli.OpportunityId);
    }
    
    Set<Id> oppIdsAlreadyProcessed = new Set<Id>(); 
    for(Opportunity o: [select Id from Opportunity
                                     where Id in:oppIds and Order_Processed__c = true])
    {
        oppIdsAlreadyProcessed.add(o.Id);
    }
    
    for(OpportunityLineItem oli: trigger.New)
    {
        if(oppIdsAlreadyProcessed.contains(oli.OpportunityId) && ((UserInfo.getUserName().contains('unallocated@synety.com') == false) && (UserInfo.getUserName().contains('mohsin.raza@synety.com') == false) && (UserInfo.getUserName().contains('rahul.borgaonkar@synety.com') == false)))
        {
            oli.addError('Cannot add new product or make change to an existing product detail once order has been processed.');
        }
    }
}