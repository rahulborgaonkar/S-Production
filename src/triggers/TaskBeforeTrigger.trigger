trigger TaskBeforeTrigger on Task (before delete, before insert, before update) 
{
    system.debug('Inside TaskBeforeTrigger');
    List<ID> whatid = new List<ID> ();
	List<Case> cases = new List<Case> ();  
	if(Trigger.isInsert || Trigger.isUpdate)
	{
	    for(Task t : Trigger.new)
    	{
        	if(t.synety__Call_Session_Id__c != null && t.whatid != null && t.subject.contains('SYNETY Call') && String.valueOf(t.whatid).substring(0,3) == '500')
        	{
            	whatid.add(t.whatid);
        	}
    	}
    	system.debug('List<ID> whatid - ' + whatid);

    	if(whatid.size() > 0)
    	{
    		cases = [SELECT id, last_update_date_and_time__c FROM case where id = :whatid LIMIT 1];
    		system.debug('List<Case> cases - ' + cases);
		}

    	if(cases.size() > 0)
    	{
        	for(Case c : cases)
        	{
            	c.last_update_date_and_time__c = DateTime.Now();
        	}
    		update cases;
    	}
	}
}