trigger SynetyPluginAfterTrigger on Synety_Plugin__c (after update)
{
    system.debug('SynetyPluginAfterTrigger Trigger new - ' + Trigger.new);
    List<ID> caseid = new List<ID> ();

    for(Synety_Plugin__c sp : Trigger.new)
    {
        if(sp.QA_Status__c == 'App Approved and Live' && sp.Software_Ready_for_Release__c == 'Yes')
        {
            caseid.add(sp.QA_Ticket_Reference__c);
        }
    }
    system.debug('List<ID> caseid - ' + caseid);

    if(caseid.size() > 0)
    {
        List<case> cs = [SELECT Status FROM Case where id = :caseid LIMIT 1];

        system.debug('List<case> cs - ' + cs);

        if(cs.size() > 0)
        {
            for(case c : cs)
            {
                c.status = 'App Approved and Live';
            }
            system.debug('List<case> cs - ' + cs);
            update cs;
        }
    }
}