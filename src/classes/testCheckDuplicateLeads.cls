@isTest
private class testCheckDuplicateLeads
{

    @isTest 
    static void testCheckDuplicateLeads_Method1()
    {
        Lead lead1 = new Lead(Company='BBB PLC', Website='www.bbb.com', Email='test@bbb.com', LastName='BBB');
        Lead lead2 = new Lead(Company='BBB PLC', Website='www.bbb.com', Email='test@bbb.com', LastName='BBB');
        Lead lead3 = new Lead(Company='BBB PLC', Website='', Email='test@bbb.com', LastName='BBB');
        Lead lead4 = new Lead(Company='BBB PLC', Website='', Email='rahul@bbb.com', LastName='BBB');
        Lead lead5 = new Lead(Company='BBB PLC', Website='', Email='', LastName='BBB');
        Lead lead6 = new Lead(Company='BBB PLC', Website='www.bbb.com', Email='', LastName='BBB');
        Lead lead7 = new Lead(Company='BBB PLC', Website='http://ccc.com', Email='', LastName='BBB');
        Lead lead8 = new Lead(Company='BBB PLC LTD', Website='www.bbb.com', Email='', LastName='BBB');
        Lead lead9 = new Lead(Company='BBB PLC LTD', Website='www.bbb.com', Email='rahul@bbb.com', LastName='BBB');
        Lead lead10 = new Lead(Company='BBB PLC LTD', Website='www.bbd.com', Email='rahul@bbd.com', LastName='BBB');
        Lead lead11 = new Lead(Company='bbb PLC', Website='www.BBB.com', Email='test@BBB.com', LastName='BBB');

        Lead[] arrayLead1 = new Lead[] {lead1, lead2, lead3, lead4, lead5, lead6, lead7, lead8, lead9, lead10, lead11};

        try 
        {
            system.debug('FIRST TEST CASE');
            system.debug('FIRST INSERT');
            insert arrayLead1;
        } 
        catch (DmlException e) 
        {
            System.debug('DmlException - ' + e);
        }        

        try 
        {
            system.debug('SECOND TEST CASE');
            Account acct1 = new Account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5);
            Account acct2 = new Account(Name = '[Not Provided]', Website='www.bbb.com', No_of_CRM_Seats__c = 5);
            Account acct3 = new Account(Name = 'CCC PLC', Website='www.ccc.com', No_of_CRM_Seats__c = 5);
            Account acct4 = new Account(Name = 'DDD PLC', Website='www.ddd.com', No_of_CRM_Seats__c = 5);
            Account acct5 = new Account(Name = 'FFF PLC', Website='www.fff.com', No_of_CRM_Seats__c = 5);
            Account acct6 = new Account(Name = 'GGG PLC', Website='www.ggg.com', No_of_CRM_Seats__c = 5);

            Account[] arrayAcct1 = new Account[] {acct1, acct2, acct3, acct4, acct5, acct6};
            insert arrayAcct1;

            Contact cnct1 = new Contact(Lastname = 'aaa_contact', AccountId = acct1.id, Email='');
            Contact cnct2 = new Contact(Lastname = 'bbb_contact', AccountId = acct2.id, Email='test@bbb.com');
            Contact cnct3 = new Contact(Lastname = '[Not Provide]', AccountId = acct3.id, Email='test@ccc.com');
            Contact cnct4 = new Contact(Lastname = 'ddd_contact', AccountId = acct4.id, Email='test@ddd.com');

            Contact[] arrayCnct1 = new Contact[] {cnct1, cnct2, cnct3, cnct4};
            insert arrayCnct1;

            Lead lead12 = new Lead(Company='[Not Provided]', Website='www.rrr.com', Email='test@rrr.com', LastName='rrr_contact1');

            Lead lead13 = new Lead(Company='AAA PLC LTD', Website='www.aaa.com', Email='test@aaa.com', LastName='aaa_contact');
            Lead lead14 = new Lead(Company='[Not Provided]', Website='', Email='test@bbb.com', LastName='[Not Provided]');
            Lead lead15 = new Lead(Company='CCC PLC', Website='', Email='test@ccc.com', LastName='ccc_contact');
            Lead lead16 = new Lead(Company='DDD PLC', Website='www.ddd.com', Email='test@ddd.com', LastName='ddd_contact');
            Lead lead17 = new Lead(Company='FFF PLC', Website='www.fff.com', Email='test@fff.com', LastName='fff_contact');
            Lead lead18 = new Lead(Company='GGG PLC', Website='www.ggg.com', Email='', LastName='[Not Provide]');

            Lead[] arrayLead2 = new Lead[] {lead12, lead13, lead14, lead15, lead16, lead17, lead18};
            insert arrayLead2;
            
        } 
        catch (DmlException e) 
        {
            System.debug('DmlException - ' + e);
        }
    }


    @isTest (seealldata=true)
    static void testCheckDuplicateLeads_Method2()
    {
        Lead lead15 = new Lead(Company='FFF PLC', Website='', Email='test@fff.com', LastName='FFF', status = 'New');
        Lead lead16 = new Lead(Company='FFF PLC', Website='', Email='test@fff.com', LastName='FFF', status = 'New', leadsource = 'Competitor');
        Lead lead17 = new Lead(Company='FFF PLC', Website='www.fff.com', Email='', LastName='FFF', status = 'New', leadsource = 'Competitor');
        Lead lead18 = new Lead(Company='FFF PLC', Website='www.fff.com', Email='', LastName='FFF', status = 'New', leadsource = 'Competitor');

//        Lead[] arrayLead3 = new Lead[] {lead16, lead17, lead18};
//        system.debug('INITIAL INSERT');
//        insert arrayLead3;

        Test.StartTest();
        system.debug('THIRD TEST CASE');
        system.debug('FIRST INSERT');
        insert lead15;
        system.debug('SECOND INSERT');
        insert lead16;
        system.debug('THIRD INSERT');
        insert lead17;
        system.debug('FOURTH INSERT');
        insert lead18;
        Test.StopTest();

    }


    @isTest
    static void testCheckDuplicateLeads_Method3()
    {
        Lead lead = new Lead(Company='FFF PLC', Website='', Email='test@fff.com', LastName='FFF', Status='Qualified');

        try 
        {
            system.debug('FOURTH TEST CASE');
            insert lead;
            system.debug('AFTER INSERT');
            lead.Status = 'Called';            
            update lead;
            system.debug('AFTER UPDATE');

        } 
        catch (DmlException e) 
        {
            System.debug('DmlException - ' + e);
        }
    }

}