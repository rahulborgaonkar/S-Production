@isTest
private class TestiContactMessageStatistics {

    static testMethod void myUnitTest() 
    {
    	Lead l = new Lead();
    	l.LastName = 'Test';
    	l.Company = 'Test Account';
		l.status = 'New';
		l.leadsource = 'New Lead';
    	l.OwnerId = UserInfo.getUserId();
    	insert l;
    	
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'Name';
        c.email = 'a@b.com';
        c.AccountId = acc.Id;
        l.OwnerId = UserInfo.getUserId();
        insert c;
/*        
        iContactforSF__iContact_Sent_Message__c messageSent = 
        	[select id from iContactforSF__iContact_Sent_Message__c limit 1];
        
        iContactforSF__iContact_Message_Statistic__c ms = new iContactforSF__iContact_Message_Statistic__c();
        ms.iContactforSF__iContact_Sent_Message__c = messageSent.Id;
        ms.Name = 'Test';
        ms.iContactforSF__Contact__c = c.Id;
        insert ms; 
        
        ms = new iContactforSF__iContact_Message_Statistic__c();
        ms.iContactforSF__iContact_Sent_Message__c = messageSent.Id;
        ms.Name = 'Test';
        ms.iContactforSF__Lead__c = l.Id;
        insert ms; 
*/        
    }
}