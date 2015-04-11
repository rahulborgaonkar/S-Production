@isTest
private class AccountTriggerTestClass {

    static testMethod void myUnitTest() 
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        acc.bottomline__creditSafeLastRefreshed__c = system.now().date().addDays(-1);
        update acc;
        
        acc.bottomline__creditSafeLimit__c = '1000';
        acc.bottomline__creditSafeLastRefreshed__c = system.now().date();
        update acc;
        
    }
}