trigger AssetCalculationTrigger on Asset (after insert, after update, after delete)
{
    system.debug('trigger.old - ' + trigger.old);
    system.debug('trigger.new - ' + trigger.new);
    List <Asset> AssetUpdates;

    if(trigger.isInsert || trigger.isUpdate)
    {
        AssetUpdates = trigger.new;
    }
    if(trigger.isDelete)
    {
        AssetUpdates = trigger.old;
    }
   
    Set <Id> AccIds = new Set <Id> ();
    List <Account> acctList = new List <Account> ();
    system.debug('AssetUpdates - ' + AssetUpdates);

    for (Asset a : AssetUpdates)
    {
        AccIds.add(a.accountid);
    }
    system.debug('AccIds - ' + AccIds);

    List <SObject> toUpdateAccounts = [SELECT AccountId, sum(Quantity) FROM Asset where status = 'CloudCall Service' and accountid in :AccIds group by AccountId];
    system.debug('toUpdateAccounts - ' + toUpdateAccounts);
    for(SObject s : toUpdateAccounts)
    {
        system.debug('s - ' + s.get('accountid') + ' ' + s.get('expr0'));
        Account a = new Account();
        a.id = (Id)s.get('accountid');
        a.Total_Licenses__c = (Decimal)s.get('expr0');
        acctList.add(a);
    }

    system.debug('acctList - ' + acctList);
    update acctList;
}