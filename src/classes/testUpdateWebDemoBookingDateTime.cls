@isTest
private class testUpdateWebDemoBookingDateTime
{
    @isTest
    static void testPage()
    {
        Test.startTest();
        Account acct1 = new Account(Name = 'QQQ PLC Ltd', Website='www.qqq.com', No_of_CRM_Seats__c = 5);

        Account[] arrayAcct = new Account[] {acct1};
        insert arrayAcct;

        Contact cnct1 = new Contact(Lastname = 'qqq_contact', AccountId = acct1.id, Email='rsb@qqq.com');

        Contact[] arrayCnct = new Contact[] {cnct1};
        insert arrayCnct;

        Task task1 = new Task(WhoId=cnct1.id, WhatId = acct1.id, Subject='Web Demo', Status='In Progress', description='Lead ' + acct1.name + ' converted to Account', ReminderDateTime = DateTime.newInstance(date.valueof('2014-02-27'), Time.newInstance(8, 30, 0, 0)), IsReminderSet = true, ownerid=UserInfo.getUserId());
        Task[] arrayTask = new Task[] {task1};

        insert arrayTask;
        
        task1.ReminderDateTime = DateTime.newInstance(date.valueof('2014-02-27'), Time.newInstance(10, 30, 0, 0));

        update arrayTask;
        Test.stopTest();
    }
    
    @isTest
    static void testPage2()
    {
        Test.startTest();
        Account acct1 = new Account(Name = 'AAA PLC Ltd', Website='www.aaa.com', No_of_CRM_Seats__c = 5);

        Account[] arrayAcct = new Account[] {acct1};
        insert arrayAcct;

        Contact cnct1 = new Contact(Lastname = 'aaa_contact', AccountId = acct1.id, Email='rsb@aaa.com');

        Contact[] arrayCnct = new Contact[] {cnct1};
        insert arrayCnct;

        Task task1 = new Task(WhoId=cnct1.id, Subject='Pardot Task', Status='Pardot Assigned Task', ownerid=UserInfo.getUserId());
        Task[] arrayTask = new Task[] {task1};

        insert arrayTask;
        Test.stopTest();
    }
}