@isTest
private class testSynetyPlugin
{

    @isTest(seealldata=true)
    static void testCallout_5()
    {
        Synety_Plugin__c test_sp1 = new Synety_Plugin__c(Name='Act! Click', CRM__c='Act!', QA_Status__c = 'QA - App Test Requested', Plugin_Version__c = 'CloudCall Click for Act!', Plugin_Version_Number__c = '1.1.1.12', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com',   Release_Code__c = 'Paste Link');
                
        insert test_sp1;
        system.debug('Synety_Plugin__c test_sp1 - ' + test_sp1);

        PageReference pref = new PageReference('SynetyPluginReport');
        ApexPages.StandardController stdController = new ApexPages.StandardController(test_sp1);
        SynetyPluginController spc = new SynetyPluginController(stdController);

        Test.setCurrentPage(pref);
        Test.startTest();
        spc.getUsers();
        spc.getPluginSummary();
        spc.getChangedMonth();
        Test.stopTest();
    }


    @isTest
    static void testCallout_4()
    {
        Synety_Plugin__c test_sp1 = new Synety_Plugin__c(Name='Act! Click', CRM__c='Act!', QA_Status__c = 'QA - App Test Requested', Plugin_Version__c = 'CloudCall Click for Act!', Plugin_Version_Number__c = '1.1.1.12', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com',   Release_Code__c = 'Paste Link');
        
        insert test_sp1;
        system.debug('Synety_Plugin__c test_sp1 - ' + test_sp1);
        PageReference pref = new PageReference('SynetyPluginDisplay');
        ApexPages.StandardController stdController = new ApexPages.StandardController(test_sp1);
        SynetyPluginController spc = new SynetyPluginController(stdController);

        Test.setCurrentPage(pref);
        Test.startTest();
        spc.display();
        Note nt = new Note();
        nt.ParentId = test_sp1.id;
        nt.title = 'AAA';
        insert nt;
        
        Attachment att = new Attachment();
        att.ParentId = test_sp1.id;
        att.name = 'BBB';
        att.body = Blob.valueof('ABCD');
        insert att;
        Test.stopTest();
    }


    @isTest
    static void testCallout_3()
    {
        List<Synety_Plugin__c> list_sp = new List<Synety_Plugin__c> ();
        
        Synety_Plugin__c test_sp1 = new Synety_Plugin__c(Name='Salesforce', CRM__c='Salesforce', Plugin_Version__c = 'Professional, Enterprise, Unlimited', Plugin_Version_Number__c = '3.85', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com');
        Synety_Plugin__c test_sp2 = new Synety_Plugin__c(Name='Act! Click', CRM__c='Act!', Plugin_Version__c = 'CloudCall Click for Act!', Plugin_Version_Number__c = '1.1.1.12', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com');
        Synety_Plugin__c test_sp3 = new Synety_Plugin__c(Name='Click Goldmine', CRM__c='Goldmine', Plugin_Version__c = 'CloudCall Click for Goldmine', Plugin_Version_Number__c = '0.7.3', License_Key__c='bcf6f1cb-0c0c-404d-99a2-9d52ac654cd8', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com');
        list_sp.add(test_sp1);
        list_sp.add(test_sp2);
        list_sp.add(test_sp3);
        
        insert list_sp;
        system.debug('Synety_Plugin__c test_sp - ' + list_sp);
        PageReference pref = new PageReference('SynetyPluginReview');
        Synety_Plugin__c test_sp4 = new Synety_Plugin__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(test_sp4);
        SynetyPluginController spc = new SynetyPluginController(stdController);

        Test.setCurrentPage(pref);
        Test.startTest();
        spc.initialise();
        spc.selectedPlugin = '-None-';
        spc.getPlugins();
        spc.getCRM();
        system.debug('New plugin spc.pluginVersionNumber - ' + spc.pluginVersionNumber);
        spc.newcancel();
        Test.stopTest();
    }


    @isTest
    static void testCallout_2()
    {
        List<Synety_Plugin__c> list_sp = new List<Synety_Plugin__c> ();
        
        Synety_Plugin__c test_sp1 = new Synety_Plugin__c(Name='Salesforce', CRM__c='Salesforce', QA_Status__c = 'App Approved and Live', Plugin_Version__c = 'Professional, Enterprise, Unlimited', Plugin_Version_Number__c = '3.85', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com');
        Synety_Plugin__c test_sp2 = new Synety_Plugin__c(Name='Act! Click', CRM__c='Act!', QA_Status__c = 'App Approved and Live', Plugin_Version__c = 'CloudCall Click for Act!', Plugin_Version_Number__c = '1.1.1.12', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com');
        Synety_Plugin__c test_sp3 = new Synety_Plugin__c(Name='Click Goldmine', CRM__c='Goldmine', QA_Status__c = 'App Approved and Live', Plugin_Version__c = 'CloudCall Click for Goldmine', Plugin_Version_Number__c = '0.7.3', License_Key__c='bcf6f1cb-0c0c-404d-99a2-9d52ac654cd8', Bugs_Fixed__c='', Release_Date__c = Datetime.now(), Install_Instructions__c='Install', Install_Link__c='www.synety.com');
        list_sp.add(test_sp1);
        list_sp.add(test_sp2);
        list_sp.add(test_sp3);
        
        insert list_sp;
        system.debug('Synety_Plugin__c test_sp - ' + list_sp);
        PageReference pref = new PageReference('SynetyPluginReview');
        Synety_Plugin__c test_sp4 = new Synety_Plugin__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(test_sp4);
        SynetyPluginController spc = new SynetyPluginController(stdController);

        Test.setCurrentPage(pref);
        Test.startTest();
        spc.initialise();
        spc.selectedPlugin = 'Salesforce';
        spc.getPlugins();
        spc.getCRM();
        spc.releaseOption = 'Paste Link';
        spc.installLink = 'www.synety.com';
        spc.releaseFunctionMethod();

        spc.releaseDate = Datetime.now();
        system.debug('New plugin spc.pluginVersionNumber - ' + spc.pluginVersionNumber);
        spc.newsave();

        system.debug('Synety_Plugin__c test_sp4 - ' + test_sp4);
        Case test_cs = [SELECT status FROM Case where id = :test_sp4.QA_Ticket_Reference__c];
        system.debug('Case test_cs - ' + test_cs);
        test_cs.Status = 'QA - In Process';
        update test_cs;

        test_cs.Status = 'QA - App QA Passed';
        update test_cs;

        test_sp4.Software_Ready_for_Release__c = 'Yes';
        update test_sp4;

        Test.stopTest();
       
    }


    @isTest 
    static void testCallout_1()
    {
        integer counter = 5;
        Synety_Plugin__c test_sp = new Synety_Plugin__c(Bugs_Fixed__c='Bugs Fix', CRM__c='Salesforce', Release_Date__c = Datetime.now(), Plugin_Version__c = 'Salesforce', Plugin_Version_Number__c = '1', Install_Instructions__c='Install', Install_Link__c='www.synety.com', License_Key__c='979d8d44-a88f-44b1-823f-68a2d1d1ae04', Name='Act! Click');
        insert test_sp;
        system.debug('Synety_Plugin__c - ' + test_sp);

        list<account> bulkaccounts = new list<account>();
        list<contact> bulkcontacts = new list<contact>();
        list<API_Audit_Trail__c> bulkaat = new list<API_Audit_Trail__c>();
        
        for(integer i = 0; i < counter; i++)
        {
            string act_nm = 'test account ' + i;
            bulkaccounts.add(new account(name=act_nm, i_customer__c=i.format()));
        }
        insert bulkaccounts;
        system.debug('list<account> - ' + bulkaccounts);

        for(integer i = 0; i < counter; i++)
        {
            string fn = 'test firstname ' + i;
            string ln = 'test lastname ' + i;
            bulkcontacts.add(new contact(firstname=fn, lastname=ln, email='rahul.borgaonkar@synety.com', primary_contact__c = true, accountid = bulkaccounts[i].id));
            i++;
        }
        insert bulkcontacts;
        system.debug('list<contact> - ' + bulkcontacts);
        
        for(integer i = 0; i < counter; i++)
        {
            bulkaat.add(new API_Audit_Trail__c(Account__c=bulkaccounts[i].id, Application_Name__c = 'ACT! Plugin', License_Key__c = '979d8d44-a88f-44b1-823f-68a2d1d1ae04', Request_Count__c = 20, Request_Date__c = date.today(), i_customer__c = integer.valueof(bulkaccounts[i].i_customer__c)));
        }
        insert bulkaat;
        system.debug('list<API_Audit_Trail__c> - ' + bulkaat);
        PageReference pref = new PageReference('SynetyPluginPage');
        pref.getParameters().put('id',test_sp.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(test_sp);
        SynetyPluginController spc = new SynetyPluginController(stdController);
        
        Test.setCurrentPage(pref);
        Test.startTest();
        spc.autorun();
        spc.maillist();
        test_sp.Release_Date__c = Datetime.now().addHours(2);
        test_sp.Plugin_Version_Number__c = '2';
        update test_sp;
        Test.stopTest();
    }
}