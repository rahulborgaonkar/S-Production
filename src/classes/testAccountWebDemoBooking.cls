@isTest
private class testAccountWebDemoBooking
{
    @isTest 
    static void testSubmitAction1()
    {
        PageReference pref;
        User user = [SELECT id, name, Email FROM User WHERE name = 'Gary Coventry'];
        account acct = new account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5, ownerid = user.id);
        insert acct;
        contact cnct = new contact(FirstName = 'firstname', Lastname = 'lastname', AccountId = acct.id, Email='rahul.borgaonkar@gmail.com', phone='01010101', Primary_Contact__c = true);
        insert cnct;
        system.debug('account acct - ' + acct);
        system.debug('contact cnct - ' + cnct);
        
        pref = new PageReference('accountWebDemoBooking');
        pref.getParameters().put('id',acct.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acct);
        accountWebDemoBookingController webDemoCon = new accountWebDemoBookingController(stdController);
        Test.startTest();
        webDemoCon.getItems();
        webDemoCon.getManagers();

        account a = (account)stdController.getRecord();
        a.Date_to_Book_Demo__c = Date.parse('27/11/2013');
        system.debug('account a - ' + a);
        webDemoCon.Current_time = '16:00';
        webDemoCon.setAvailable_manager(user.id);
        webDemoCon.available_manager = webDemoCon.getAvailable_manager();
        webDemoCon.gettmp_account();
        webDemoCon.submit();
        Test.stopTest();
    }

    @isTest 
    static void testSubmitAction2()
    {
        PageReference pref;
        User user = [SELECT id, name, Email FROM User WHERE name = 'Gary Coventry'];
        account acct = new account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5, ownerid = user.id);
        insert acct;
        contact cnct = new contact(FirstName = 'firstname', Lastname = 'lastname', AccountId = acct.id, Email='rahul.borgaonkar@gmail.com', phone='01010101', Primary_Contact__c = true);
        insert cnct;
        system.debug('account acct - ' + acct);
        system.debug('contact cnct - ' + cnct);
        
        pref = new PageReference('accountWebDemoBooking');
        pref.getParameters().put('id',acct.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acct);
        accountWebDemoBookingController webDemoCon = new accountWebDemoBookingController(stdController);
        Test.startTest();
        webDemoCon.getItems();
        webDemoCon.getManagers();

        account a = (account)stdController.getRecord();
        a.Date_to_Book_Demo__c = Date.parse('07/11/2013');
        system.debug('account a - ' + a);
        webDemoCon.Current_time = '16:00';

        webDemoCon.setAvailable_manager(user.id);
        webDemoCon.available_manager = webDemoCon.getAvailable_manager();
        webDemoCon.gettmp_account();
        webDemoCon.submit();
        Test.stopTest();
    }


    @isTest 
    static void testCancelAction()
    {
        PageReference pref;
        User user = [SELECT id, name, Email FROM User WHERE name = 'Gary Coventry'];
        account acct = new account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5, ownerid = user.id);
        insert acct;
        contact cnct = new contact(FirstName = 'firstname', Lastname = 'lastname', AccountId = acct.id, Email='rahul.borgaonkar@gmail.com', phone='01010101', Primary_Contact__c = true);
        insert cnct;
        system.debug('account acct - ' + acct);
        system.debug('contact cnct - ' + cnct);
        
        pref = new PageReference('accountWebDemoBooking');
        pref.getParameters().put('id',acct.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acct);
        accountWebDemoBookingController webDemoCon = new accountWebDemoBookingController(stdController);
        Test.startTest();
        webDemoCon.getItems();
        webDemoCon.getManagers();

        account a = (account)stdController.getRecord();
        a.Date_to_Book_Demo__c = Date.parse('27/11/2013');
        system.debug('account a - ' + a);
        webDemoCon.Current_time = '16:00';
        webDemoCon.setAvailable_manager(user.id);
        webDemoCon.available_manager = webDemoCon.getAvailable_manager();
        webDemoCon.gettmp_account();
        webDemoCon.cancel();
        Test.stopTest();
    }


}