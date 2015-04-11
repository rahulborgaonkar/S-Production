@isTest
private class testRegulatoryNewsSubscribers
{
    @isTest 
    static void testCallout_1()
    {
        list<contact> bulksubscribers = new list<contact>();        
        for(integer i = 1; i <= 10; i++)
        {
            string fn = 'test firstname ' + i;
            string ln = 'test lastname ' + i;
            bulksubscribers.add(new contact(firstname=fn, lastname=ln, email='rahul.borgaonkar@synety.com', Regulatory_News_Subscriber__c = true));
        }
        insert bulksubscribers;
        
        PageReference pref = new PageReference('regulatoryNewsSubscribersUnsubscribePage');
        pref.getParameters().put('id',bulksubscribers[0].id);
        regulatoryNewsSubscribersController rns = new regulatoryNewsSubscribersController();

        Test.setCurrentPage(pref);
        Test.startTest();
        Synety_com_News__c rns_news = new Synety_com_News__c(Article__c = 'Synety News', Article_Datetime__c = System.today(), Article_Excerpt__c = 'Synety News Excerpt', News_Type__c = 'Rns Reach', Published__c = true);
        insert rns_news;
        rns_news.News_Type__c = 'RNS';
        update rns_news;

        rns.init();
        rns.setdoclose(true);
        rns.getdoclose();
        rns.confirm();
        bulksubscribers[0].Regulatory_News_Subscriber__c = false;
        update bulksubscribers[0];
        rns.init();
        Test.stopTest();
    }
}