trigger UpdateWebDemoBookingDateTimeTrigger on Task (after insert, after update)
{
    system.debug('In Task Trigger');
    system.debug('Trigger.old - ' + Trigger.old);
    system.debug('Trigger.new - ' + Trigger.new);
    List<Id> taskwhoid = new List<Id>();
    List<Contact> dtchg_cnct = new List<Contact>();
    List<Account> pardot_acct = new List<Account>();
    List<Lead> pardot_ld = new List<Lead>();
    List<Contact> pardot_cnct = new List<Contact>();

    system.debug('Trigger.new.size() - ' + Trigger.new.size());

    for(Task tsk : Trigger.new)
    {
        if(Trigger.isUpdate == true && tsk.reminderDateTime != null && tsk.whoid != null && tsk.subject.equalsIgnoreCase('Web Demo') == true)
        {
            system.debug('Task - ' + tsk);
            List<Contact> cnct = [SELECT web_demo_booking_date_time__c FROM contact WHERE id = :tsk.whoid LIMIT 1];
            if(cnct.size() > 0)
            {
                system.debug('web_demo_booking_date_time changed for - ' + cnct);
                cnct[0].web_demo_booking_date_time__c = tsk.reminderDateTime;
                dtchg_cnct.add(cnct[0]);
            }
        }

        if(Trigger.isInsert == true && (tsk.whatid != null || tsk.whoid != null))
        {
            system.debug('In Insert');
            system.debug('Task tsk - ' + tsk.ownerid);
            Map<Id, User> users = new Map<Id, User> ([SELECT Id, Username, Name FROM User where userroleid in (SELECT Id FROM UserRole where name in ('Account Managers', 'Desk Sales Agent')) and isactive = true]);
            system.debug('users - ' + users);

            if(users.containskey(tsk.ownerid) == true)
            {
                if(tsk.whatid != null && String.valueof(tsk.whatid).substring(0,3) == '001')
                {
                    system.debug('Found Account - ' + tsk.whatid);
                    List<Account> acct = [select id , name, Activity_Updates_For_Pardot__c, Activity_User_For_Pardot__c, Activity_Date_For_Pardot__c from account where id = :tsk.whatid];
                    if(acct.size() > 0)
                    {
                        system.debug('Account acct - ' + acct);
                        acct[0].Activity_User_For_Pardot__c = users.get(tsk.ownerid).name;
                        acct[0].Activity_Updates_For_Pardot__c = tsk.subject;
                        acct[0].Activity_Date_For_Pardot__c = tsk.createddate;
                        pardot_acct.add(acct[0]);
                    }

                }
                if(tsk.whoid != null && String.valueof(tsk.whoid).substring(0,3) == '00Q')
                {
                    system.debug('Found Lead - ' + tsk.whoid);
                    List<Lead> ld = [select id , name, Activity_Updates_For_Pardot__c, Activity_User_For_Pardot__c, Activity_Date_For_Pardot__c from lead where id = :tsk.whoid];
                    if(ld.size() > 0)
                    {
                        system.debug('Lead ld - ' + ld);
                        ld[0].Activity_User_For_Pardot__c = users.get(tsk.ownerid).name;
                        ld[0].Activity_Updates_For_Pardot__c = tsk.subject;
                        ld[0].Activity_Date_For_Pardot__c = tsk.createddate;
                        pardot_ld.add(ld[0]);
                    }
                }
                if(tsk.whoid != null && String.valueof(tsk.whoid).substring(0,3) == '003')
                {
                    system.debug('Found contact - ' + tsk.whoid);
                    List<Contact> cnct = [select id , name, Activity_Updates_For_Pardot__c, Activity_User_For_Pardot__c, Activity_Date_For_Pardot__c from contact where id = :tsk.whoid];
                    if(cnct.size() > 0)
                    {
                        system.debug('Contact cnct - ' + cnct);
                        cnct[0].Activity_User_For_Pardot__c = users.get(tsk.ownerid).name;
                        cnct[0].Activity_Updates_For_Pardot__c = tsk.subject;
                        cnct[0].Activity_Date_For_Pardot__c = tsk.createddate;
                        pardot_cnct.add(cnct[0]);
                    }
                }
                
            }
        }

        if(Trigger.isInsert == true && tsk.status == 'Pardot Assigned Task')
        {
            system.debug('In Insert');
            system.debug('Task tsk - ' + tsk);
            String contactLink = '\n\n';
            String taskLink, mailBody;
            
            List<String> sendTo = new List<String>();
            
            for(User deskUsers : [SELECT Username, email FROM User where userroleid in (SELECT Id FROM UserRole where name in ('Desk Sales Agent')) and isactive = true])
            {
                sendTo.add(deskUsers.email);
            }

            if(tsk.whoid != null)
            {
                contactLink = 'For Contacts Details Please click here - https://na11.salesforce.com/' + tsk.whoid + '\n\n';
            }

            taskLink = 'For Task Details Please click here - https://na11.salesforce.com/' + tsk.id + '\n\n';

            system.debug('contactLink - ' + contactLink);

            mailBody = 'Telesales Guys,\n\n';
            mailBody = mailBody + 'Pardot has triggered a task\n\n';
            mailBody = mailBody + taskLink;
            if(contactLink != null)
            {
                mailBody = mailBody + contactLink;
            }
            mailBody = mailBody + 'Thanks\n\n\n';
            mailBody = mailBody + 'SYNETY Marketing Team\n';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('SYNETY Marketing Team');
            mail.setToAddresses(sendTo);
            mail.setSubject('New Pordot Task Created - Please Action');

            mail.setPlainTextBody(mailBody);
            system.debug('Messaging.SingleEmailMessage mail - ' + mail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    if(dtchg_cnct.size() > 0)
    {
        system.debug('dtchg_cnct - ' + dtchg_cnct);
        List<Database.SaveResult> sr = database.update(dtchg_cnct);
        system.debug('Database.SaveResult - ' + sr);
    }
    
    if(pardot_acct.size() > 0)
    {
        system.debug('pardot_acct - ' + pardot_acct);
        List<Database.SaveResult> sr_acct = database.update(pardot_acct);
        system.debug('Database.SaveResult - ' + sr_acct);
    }

    if(pardot_ld.size() > 0)
    {
        system.debug('pardot_ld - ' + pardot_ld);
        List<Database.SaveResult> sr_ld = database.update(pardot_ld);
        system.debug('Database.SaveResult - ' + sr_ld);
    }
    if(pardot_cnct.size() > 0)
    {
        system.debug('pardot_cnct - ' + pardot_cnct);
        List<Database.SaveResult> sr_cnct = database.update(pardot_cnct);
        system.debug('Database.SaveResult - ' + sr_cnct);
    }

}