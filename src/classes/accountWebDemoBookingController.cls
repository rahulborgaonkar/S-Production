public class accountWebDemoBookingController
{
    public String current_time{get;set;}
    public String available_manager{get;set;}
    List<SelectOption> manager_options = new List<SelectOption>();
    public Boolean doclose = false;    
    ApexPages.StandardController control;
    Account curr_account{get; set;}
    
    public Account gettmp_account()
    {
        curr_account = (account)control.getRecord();
        curr_account = [Select Id, ownerid, Date_to_Book_Demo__c, (Select Id, firstName, lastname, email, phone, Web_Demo_Booking_Date_Time__c From Contacts where primary_contact__c = true) From Account where id = :curr_account.id];
        system.debug('gettmp_account account - ' + curr_account);
        system.debug('gettmp_account contact - ' + curr_account.contacts);
        return curr_account;
    }

    public accountWebDemoBookingController(ApexPages.StandardController stdController) 
    {
        system.debug('In Constructor');
        control = stdController;
        Account account = (account)control.getRecord();
        account.Date_to_Book_Demo__c = Date.today();
        account = [Select Id, ownerid From Account where id = :account.id];
        User user = [SELECT name, Email, TeleMarketing_Auto_Assignment_Counter__c, TeleMarketing_Auto_Assignment_Flag__c FROM User WHERE id = :account.ownerid];
        List<User> managers = new List<User>([SELECT name FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true and name != :user.name ORDER BY TeleMarketing_Auto_Assignment_Counter__c, name]);

        manager_options.add(new SelectOption(user.id, user.name));

        for(User u : managers)
        {
            manager_options.add(new SelectOption(u.id, u.name));
        }
    }

    public static Datetime getLocalDateTime(Datetime z)
    {    
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());
        return l;
    }

    public Boolean getdoClose()
    {
        system.debug('getdoClose - ' + doclose);
        return doclose;
    }

    public void setdoClose(Boolean doClos)
    {
        doclose = doclos;
        system.debug('setdoClose - ' + doclose);        
    }

    public PageReference submit()
    {
        system.debug('Inside Submit');
        system.debug('curr_account - ' + curr_account);
        system.debug('curr_account.contacts[0] - ' + curr_account.contacts[0]);
        Account account = (account)control.getRecord();
        system.debug('account - ' + account);
        curr_account.Date_to_Book_Demo__c = account.Date_to_Book_Demo__c;

        String day = curr_account.Date_to_Book_Demo__c.day().format();
        String month = curr_account.Date_to_Book_Demo__c.month().format();
        String year = curr_account.Date_to_Book_Demo__c.year().format().remove(',');
        String[] lead_tm = current_time.split(':', 2);
        Integer hr = Integer.valueof(lead_tm[0]);
        Integer mn = Integer.valueof(lead_tm[1]);
        Datetime BookingDT = Date.valueof(year+'-'+month+'-'+day);
        BookingDT = BookingDT.addhours(hr);
        BookingDT = BookingDT.addminutes(mn);
        system.debug('BookingDT - ' + BookingDT);

        DateTime GMTDT = DateTime.newInstance(BookingDT.dategmt(), BookingDT.timegmt());
        system.debug('GMTDT - ' + GMTDT);

        Datetime LOCALDT = accountWebDemoBookingController.getLocalDateTime(System.now());
        system.debug('LOCALDT - ' + LOCALDT);

        List<User> user = new List<User> ();
        List<Contact> all_contact = new List<Contact> ();
        
        user = [SELECT name, Email, TeleMarketing_Auto_Assignment_Counter__c, TeleMarketing_Auto_Assignment_Flag__c FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true AND Id = :available_manager];
        system.debug('user - ' + user);

        if(user.size() == 1)
        {
            all_contact = [SELECT name, Web_Demo_Booking_Date_Time__c, (SELECT Status, Description, ReminderDateTime FROM Tasks WHERE status = 'In Progress' AND subject = 'Web Demo' AND ownerid = :user[0].id limit 1) FROM contact where ownerid = :user[0].id AND Web_Demo_Booking_Date_Time__c = :GMTDT];
            system.debug('all_contact - ' + all_contact);
        }
        system.debug('user size - ' + user.size());
        system.debug('all_contact size - ' + all_contact.size());

        if((all_contact.size() == 0) && (BookingDT >= LOCALDT) && user.size() == 1)
        {
            curr_account.Next_Steps_to_be_taken__c = 'Customer – Call prospect to qualify and book demo';
            curr_account.Partner_Company_Name__c = 'Synety PLC';
            curr_account.Partner_Sales_Person__c = userinfo.getname();
            curr_account.ownerid = available_manager;
            Database.SaveResult accountResult = Database.update(curr_account);
            system.debug('accountResult - ' + accountResult);

            curr_account.contacts[0].ownerid = available_manager;
            curr_account.contacts[0].Web_Demo_Booking_Date_Time__c = GMTDT;
            Database.SaveResult contactResult = Database.update(curr_account.contacts[0]);
            system.debug('Database.SaveResult contactResult - ' + contactResult);

            Task current_task = new Task();
            current_task.WhoId = curr_account.contacts[0].id;
            current_task.WhatId = curr_account.id;
            current_task.Subject = 'Web Demo';
            current_task.status = 'In Progress';
            current_task.description = 'Account ' + curr_account.name + ' Web Demo Booked';
            current_task.ActivityDate = GMTDT.date();
            current_task.ReminderDateTime = GMTDT;
            current_task.IsReminderSet = true;
            current_task.ownerid = user[0].id;

            Database.SaveResult taskResult = Database.insert(current_task);
            system.debug('Database.SaveResult taskResult - ' + taskResult);            

            EmailTemplate et = [SELECT Id, Name FROM EmailTemplate where name = 'webDemoBookingEmail'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
            mail.setTargetObjectId(curr_account.contacts[0].id);// Who you are sending the email to
            mail.setTemplateId(et.id);// The email template ID used for the email
            mail.setToAddresses(new String[]{user[0].email});
            mail.setWhatId(current_task.id);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSenderDisplayName('SYNETY PLC');
            mail.setSaveAsActivity(false);  

            system.debug('Messaging.SingleEmailMessage mail - ' + mail);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            doclose = true;
        }
        else
        {
            Map<Id, User> managers = new Map<Id, User>([SELECT name FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true]);
            system.debug('managers id - ' + managers.keyset());
            Set<Contact> available_managers = new Set<Contact>([SELECT ownerid, name, (SELECT ownerid FROM Tasks WHERE status = 'In Progress' AND subject = 'Web Demo') FROM contact where ownerid = :managers.keyset() AND Web_Demo_Booking_Date_Time__c = :GMTDT]);
            system.debug('available_managers - ' + available_managers);
            for(Contact c : available_managers)
            {
                system.debug('available_managers - ' + c);
                managers.remove(c.ownerid);
            }
            system.debug('available_manager_ids - ' + managers);
            if(managers.size() > 0)
            {
                manager_options.clear();
                for(User u : managers.values())
                {
                    manager_options.add(new SelectOption(u.id, u.name));
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Web Demo is already booked for this Date and Time OR Past date is used.Please consider another Date & Time.');
                ApexPages.addMessage(myMsg);
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'OR');
                ApexPages.addMessage(myMsg);
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Assign it to Another Account Manager as Current Account owner is not a Account Manager');
                ApexPages.addMessage(myMsg);
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Web Demo is already booked for all managers for this Date and Time. Please change the time');
                ApexPages.addMessage(myMsg);
            }
            system.debug('manager_options - ' + manager_options);
        }

        return null;
    }

    public PageReference cancel()
    {
        system.debug('Inside Cancel');
        doclose = true;
        return null;
    }
    
    public List<SelectOption> getItems() 
    {
        system.debug('In getItems');

        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 0; i < 24; i++)
        {
            String first = (i.format().length() == 1 ? '0'+ i.format() : i.format()) + ':00';
            String second = (i.format().length() == 1 ? '0'+ i.format() : i.format()) + ':30';
            options.add(new SelectOption(first, first));
            options.add(new SelectOption(second, second));
        }

        return options;
    }

    public List<SelectOption> getManagers() 
    {
        system.debug('In getItems');

        return manager_options;
    }

    public String getAvailable_manager()
    {
        system.debug('getAvailable_manager');
        return Available_manager;
    }

    public void setAvailable_manager(String avail_mngr)
    {
        system.debug('setAvailable_manager');
        Available_manager = avail_mngr;
    }

}