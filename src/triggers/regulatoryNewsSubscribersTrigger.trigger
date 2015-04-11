trigger regulatoryNewsSubscribersTrigger on Synety_com_News__c (after insert, after update)
{
    system.debug('In Synety_com_News__c trigger');

    Boolean isPublished = false;
    Synety_com_News__c rns_news = trigger.new[0];
    system.debug('rns_news - ' + rns_news);
    String rns_query = 'SELECT id, name, email, Regulatory_News_Subscriber__c FROM Contact where Regulatory_News_Subscriber__c = true';

    if(trigger.isInsert)
    {
        if((rns_news.News_Type__c == 'RNS' || rns_news.News_Type__c == 'RNS Reach') && rns_news.Published__c == true)
        {
            system.debug('Run Query - ' + rns_query);
            regulatoryNewsSubscribersBatchClass batchApex = new regulatoryNewsSubscribersBatchClass (rns_query, rns_news);
            ID batchprocessid = Database.executeBatch(batchApex, 10);
        }
    }
    else if(trigger.isUpdate)
    {
        if((trigger.old[0].News_Type__c != trigger.new[0].News_Type__c) || (trigger.old[0].Published__c != trigger.new[0].Published__c))
        {
            if((rns_news.News_Type__c == 'RNS' || rns_news.News_Type__c == 'RNS Reach') && rns_news.Published__c == true)
            {
                system.debug('Run Query - ' + rns_query);
                regulatoryNewsSubscribersBatchClass batchApex = new regulatoryNewsSubscribersBatchClass (rns_query, rns_news);
                ID batchprocessid = Database.executeBatch(batchApex, 10);
            }
        }
    }
    else
    {
        system.debug('No change in News_Type__c');
    }
}