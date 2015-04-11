@isTest
public class testUpdateAccountCloudCallSection
{
    @isTest
    public static void TestdoPostMethod1()
    {
        List <updateAccountCloudCallSectionClass.updateAccount> accts = new List <updateAccountCloudCallSectionClass.updateAccount> ();

        updateAccountCloudCallSectionClass.updateAccount uA1 = new updateAccountCloudCallSectionClass.updateAccount();
        
        uA1.i_customer = '77';
        uA1.CompanyName = 'Genius Payroll LTD';
        uA1.Email = 'nik@geniusmoney.co.uk';
        uA1.Login = 'alvin@geniusmoney.co.uk';
        uA1.ContactName = 'Genius Payroll LTD'; 
        uA1.CreationDate = datetime.valueof('2011-12-12 11:26:00');
        uA1.Last_month_minutes = 382;
        uA1.SIP_Account_last_used = datetime.valueof('2013-07-17 20:44:00');
        uA1.type = 1;
        accts.add(uA1);

        updateAccountCloudCallSectionClass.updateAccount uA2= new updateAccountCloudCallSectionClass.updateAccount();

        uA2.i_customer = '1711';
        uA2.CompanyName = 'Ashley Kate HR';
        uA2.Email = 'naomi.asher@ashleykatehr.com';
        uA2.Login = 'naomi.asher@ashleykatehr.com';
        uA2.ContactName = 'Ashley Kate HR'; 
        uA2.CreationDate = datetime.valueof('2013-07-05 09:13:00');
        uA2.Last_month_minutes = 58;
        uA2.SIP_Account_last_used = datetime.valueof('2013-07-17 09:10:00');
        uA1.type = 1;
        accts.add(uA2);
        
        Boolean retVal = updateAccountCloudCallSectionClass.doPost(accts);
        
        system.assert(true, retVal);
    }

    @isTest
    public static void TestdoPostMethod2()
    {
        List <updateAccountCloudCallSectionClass.updateAccount> accts = new List <updateAccountCloudCallSectionClass.updateAccount> ();

        updateAccountCloudCallSectionClass.updateAccount uA1 = new updateAccountCloudCallSectionClass.updateAccount();

        uA1.i_customer = '77';
        uA1.CompanyName = 'Genius Payroll LTD';
        uA1.Email = 'nik@geniusmoney.co.uk';
        uA1.Login = 'alvin@geniusmoney.co.uk';
        uA1.ContactName = 'Genius Payroll LTD'; 
        uA1.CreationDate = datetime.valueof('2011-12-12 11:26:00');
        uA1.TotalCallTime = 382;
        uA1.SIP_Account_last_used = datetime.valueof('2013-07-17 20:44:00');
        uA1.type = 2;
        
        accts.add(uA1);
        Boolean retVal = updateAccountCloudCallSectionClass.doPost(accts);
        
        system.assert(true, retVal);
    }

    @isTest
    public static void TestdoPostMethod3()
    {
        Account acct1 = new Account(Name = 'Ashley Kate HR', Website='www.ashleykatehr.com', No_of_CRM_Seats__c = 5);
        insert acct1;
        List<Account> acct = [SELECT name, i_customer__c, SIP_Account_first_used__c, SIP_Account_last_used__c, Last_month_minutes__c, This_month_minutes__c FROM account WHERE name = :acct1.name LIMIT 1]; 

        acct[0].This_month_minutes__c = null;
        system.debug('acct[0] - ' + acct[0]);
        update acct;

        List <updateAccountCloudCallSectionClass.updateAccount> accts = new List <updateAccountCloudCallSectionClass.updateAccount> ();

        updateAccountCloudCallSectionClass.updateAccount uA2 = new updateAccountCloudCallSectionClass.updateAccount();
        
        uA2.i_customer = '1711';
        uA2.CompanyName = 'Ashley Kate HR';
        uA2.Email = 'naomi.asher@ashleykatehr.com';
        uA2.Login = 'naomi.asher@ashleykatehr.com';
        uA2.ContactName = 'Ashley Kate HR'; 
        uA2.CreationDate = datetime.valueof('2013-07-05 09:13:00');
        uA2.TotalCallTime = 58;
        uA2.SIP_Account_last_used = datetime.valueof('2013-07-17 09:10:00');
        uA2.type = 2;

        accts.add(uA2);
        Boolean retVal = updateAccountCloudCallSectionClass.doPost(accts);
        
        system.assert(true, retVal);
    }

    @isTest
    public static void TestdoPostMethod4()
    {
        List <updateAccountCloudCallSectionClass.updateAccount> accts = new List <updateAccountCloudCallSectionClass.updateAccount> ();

        updateAccountCloudCallSectionClass.updateAccount uA2 = new updateAccountCloudCallSectionClass.updateAccount('', '', '', '', '' , '', datetime.valueof('0000-00-00 00:00:00'), 0, 0, datetime.valueof('0000-00-00 00:00:00'), 3);
        
        uA2.i_customer = '1711';
        uA2.CompanyName = 'Ashley Kate HR';
        uA2.Email = 'naomi.asher@ashleykatehr.com';
        uA2.Login = 'naomi.asher@ashleykatehr.com';
        uA2.ContactName = 'Ashley Kate HR'; 
        uA2.CreationDate = datetime.valueof('2013-07-05 09:13:00');
        uA2.last_month_minutes = 10000;
        uA2.TotalCallTime = 8000;
        uA2.SIP_Account_last_used = datetime.valueof('2013-07-17 09:10:00');

        accts.add(uA2);
        Boolean retVal = updateAccountCloudCallSectionClass.doPost(accts);
        
        system.assert(true, retVal);
    }
}