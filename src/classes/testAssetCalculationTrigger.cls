@isTest
private class testAssetCalculationTrigger
{    
    @isTest    
    static void testCase1()
    {        
        Account acct = new Account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5);
        insert acct;
        Asset ast = new Asset(Name = 'CloudCall Click', Quantity = 10, accountid = acct.id);
        insert ast;
        
        system.debug('Account - ' + acct);
    }
}