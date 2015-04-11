@isTest
private class testWebDemoBooking
{
    @isTest 
    static void testSubmitAction1()
    {
        PageReference pref;
        Lead new_lead =  new Lead(Company='BBB PLC', LastName='BBB');

        insert new_lead;
        pref = new PageReference('webDemoBooking');
        system.debug('pref - ' + pref);        
        pref.getParameters().put('id',new_lead.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(new_lead);
        webDemoBookingClass webDemoCon = new webDemoBookingClass(stdController);
        Test.startTest();
        webDemoCon.initialize();
        webDemoCon.getItems();
        webDemoCon.getManagers();
        Lead lead = (Lead)stdController.getRecord();
        lead.Date_to_Book_Demo__c = Date.parse('17/09/2013');
        lead.FirstName = 'bbb';
        lead.email = 'rahul.borgaonkar@synety.com';
        lead.phone = '0123456789';
        webDemoCon.setAvailable_manager('005G0000002siOA');
        webDemoCon.available_manager = webDemoCon.getAvailable_manager();
        webDemoCon.setCurrent_time('16:00');
        webDemoCon.current_time = webDemoCon.getCurrent_time();
        webDemoCon.submit();
        Test.stopTest();
    }

    @isTest 
    static void testSubmitAction2()
    {
        Test.startTest();

        PageReference pref;

        User user = [SELECT name, Email, TeleMarketing_Auto_Assignment_Counter__c, TeleMarketing_Auto_Assignment_Flag__c FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true ORDER BY TeleMarketing_Auto_Assignment_Counter__c, name LIMIT 1]; 

        Account acct = new Account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5);
        acct.ownerid = user.id;
        insert acct;

        system.debug('acct owner - ' + acct.ownerid);

        Contact cnct = new Contact(Lastname = 'aaa_contact', AccountId = acct.id, Email='rsb@aaa.com');
        cnct.Web_Demo_Booking_Date_Time__c = DateTime.newInstance(date.valueof('2013-10-13'), Time.newInstance(15, 0, 0, 0));
        cnct.ownerid = user.id;
        
        insert cnct;

        system.debug('cnct owner - ' + cnct.ownerid);
        
        Task task = new Task(); 
        task.WhoId = cnct.id; 
        task.WhatId = acct.id; 
        task.Subject = 'Web Demo'; 
        task.status = 'In Progress'; 
        task.description = 'Lead converted to Account'; 
        task.ReminderDateTime = DateTime.newInstance(date.valueof('2013-10-13'), Time.newInstance(15, 0, 0, 0));
        task.IsReminderSet = true; 
        task.ownerid = user.id;
        insert task;
        
        system.debug('task owner - ' + task.ownerid);

        Lead new_lead =  new Lead(Company='BBB PLC', LastName='BBB', status = 'New', leadsource = 'New Lead');
        new_lead.ownerid = user.id;
        insert new_lead;
        
        pref = new PageReference('webDemoBooking');
        system.debug('pref - ' + pref);        
        pref.getParameters().put('id',new_lead.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(new_lead);
        webDemoBookingClass webDemoCon = new webDemoBookingClass(stdController);

        webDemoCon.getItems();
        Lead lead = (Lead)stdController.getRecord();
        lead.Date_to_Book_Demo__c = Date.parse('13/10/2013');
        lead.FirstName = 'ddd';
        lead.LastName = 'DDD';
        lead.email = 'rahul.borgaonkar@synety.com';
        lead.phone = '0123456789';
        webDemoCon.setAvailable_manager(user.id);
        webDemoCon.available_manager = webDemoCon.getAvailable_manager();
        webDemoCon.setCurrent_time('15:00');
        webDemoCon.current_time = webDemoCon.getCurrent_time();
        webDemoCon.submit();
        Test.stopTest();
    }

    @isTest 
    static void testCancelAction()
    {
        PageReference pref;
        Lead new_lead =  new Lead(Company='BBB PLC', LastName='BBB');
        new_lead.FirstName = 'bbb';
        new_lead.Date_to_Book_Demo__c = Date.parse('17/06/2013');

        new_lead.email = 'rahul.borgaonkar@synety.com';
        new_lead.phone = '0123456789';

        insert new_lead;        
        pref = new PageReference('webDemoBooking');
        system.debug('pref - ' + pref);        
        pref.getParameters().put('id',new_lead.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(new_lead);
        webDemoBookingClass webDemoCon = new webDemoBookingClass(stdController);
        Test.startTest();
        webDemoCon.getItems();
        webDemoCon.current_time = '06:45';
        webDemoCon.cancel();
        Test.stopTest();
    }
}