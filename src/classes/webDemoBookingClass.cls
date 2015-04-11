public class webDemoBookingClass
{
    Lead current_lead;
    Account current_account;
    Contact current_contact;
    User current_lead_owner;
    public Boolean doclose = false;    

    Database.SaveResult accountResult;
    Database.SaveResult contactResult;
    transient Database.DeleteResult leadResult;
        
    ApexPages.StandardController control; 

    public String current_time;
    public String available_manager;
    List<SelectOption> manager_options = new List<SelectOption>();

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

    public String getCurrent_time()
    {
        system.debug('getCurrent_time');
        return current_time;
    }

    public void setCurrent_time(String curr_time)
    {
        system.debug('setCurrent_time');
        current_time = curr_time;
    }

    public webDemoBookingClass(ApexPages.StandardController stdController)
    {
        system.debug('In Constructor');
        control = stdController;
        Lead tmp_lead = (Lead)control.getRecord();
        tmp_lead.Date_to_Book_Demo__c = Date.today();
    }
    
    public void initialize()
    {
        system.debug('In initialize');
        User user = [SELECT name, Email, TeleMarketing_Auto_Assignment_Counter__c, TeleMarketing_Auto_Assignment_Flag__c FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true ORDER BY TeleMarketing_Auto_Assignment_Counter__c, name LIMIT 1];

        List<User> managers = new List<User>([SELECT name FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true ORDER BY TeleMarketing_Auto_Assignment_Counter__c, name LIMIT 1]);

        for(User u : managers)
        {
            manager_options.add(new SelectOption(u.id, u.name));
        }
    }

    public List<SelectOption> getManagers() 
    {
        system.debug('In getItems');

        return manager_options;
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

    public static Datetime getLocalDateTime(Datetime z)
    {    
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());
        return l;
    }

    public PageReference cancel()
    {
        system.debug('Inside Cancel');
        doclose = true;
        return null;
    }

    public PageReference submit()
    {
        system.debug('Inside Submit ' + current_lead);
        checkDuplicateLeadsClass.isMergedExecuted = true;
        system.debug('Available Manager - ' + available_manager);

        system.debug('Inside AccountContactLeadData');
        current_lead = [SELECT Company, FirstName, LastName, Email, Website, Phone, MobilePhone, OwnerId, NumberOfEmployees, Date_to_Book_Demo__c, Status, Next_Steps_to_be_taken__c, LeadSource FROM lead WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
       
//        User user = [SELECT name, Email, TeleMarketing_Auto_Assignment_Counter__c, TeleMarketing_Auto_Assignment_Flag__c FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true ORDER BY TeleMarketing_Auto_Assignment_Counter__c, name LIMIT 1];
        User user = [SELECT name, Email, TeleMarketing_Auto_Assignment_Counter__c, TeleMarketing_Auto_Assignment_Flag__c FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true AND Id = :available_manager];
        current_lead_owner = [SELECT Name FROM User WHERE Id = :current_lead.ownerId];
            
        Lead tmp_lead = (Lead)control.getRecord();

        system.debug('current_lead_owner - ' + current_lead_owner);
        system.debug('tmp_lead - ' + tmp_lead);
        system.debug('current_time - ' + current_time);

        String day = tmp_lead.Date_to_Book_Demo__c.day().format();
        String month = tmp_lead.Date_to_Book_Demo__c.month().format();
        String year = tmp_lead.Date_to_Book_Demo__c.year().format().remove(',');
        String[] lead_tm = current_time.split(':', 2);
        Integer hr = Integer.valueof(lead_tm[0]);
        Integer mn = Integer.valueof(lead_tm[1]);
        Datetime BookingDT = Date.valueof(year+'-'+month+'-'+day);
        BookingDT = BookingDT.addhours(hr);
        BookingDT = BookingDT.addminutes(mn);
        system.debug('BookingDT - ' + BookingDT);

        DateTime GMTDT = DateTime.newInstance(BookingDT.dategmt(), BookingDT.timegmt());
        system.debug('GMTDT - ' + GMTDT);

        Datetime LOCALDT = webDemoBookingClass.getLocalDateTime(System.now()); 
        system.debug('LOCALDT - ' + LOCALDT);

        List<Contact> all_contact = [SELECT name, Web_Demo_Booking_Date_Time__c, (SELECT Status, Description, ReminderDateTime FROM Tasks WHERE status = 'In Progress' AND subject = 'Web Demo' AND ownerid = :user.id limit 1) FROM contact where ownerid = :user.id AND Web_Demo_Booking_Date_Time__c = :GMTDT];

        system.debug('all_contact - ' + all_contact);

        if((all_contact.size() == 0) && (BookingDT >= LOCALDT))
        {
            user.TeleMarketing_Auto_Assignment_Counter__c++;

            update user;
            system.debug('User - ' + user);
    
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(tmp_lead.id);

            lc.setConvertedStatus('Qualified');
            lc.setDoNotCreateOpportunity(true);
            lc.setOwnerId(user.id);

            system.debug('Database.LeadConvert lc - ' + lc);

            Database.LeadConvertResult lcr = Database.convertLead(lc);
            system.debug('LeadConvertResult - ' + lcr);

            current_account = [SELECT Name, Phone, Next_Steps_to_be_taken__c, Partner_Company_Name__c, Partner_Sales_Person__c, type, No_of_CRM_Seats__c FROM Account WHERE id = :lcr.getAccountId()];
            current_account.Phone = tmp_lead.Phone;
            current_account.WebSite = current_lead.Website;        
            current_account.Next_Steps_to_be_taken__c = 'Customer – Call prospect to qualify and book demo';
            current_account.Partner_Company_Name__c = 'Synety PLC';
            current_account.Partner_Sales_Person__c = current_lead_owner.Name;
            current_account.type = 'Customer Prospect';
            current_account.No_of_CRM_Seats__c = current_lead.NumberOfEmployees == null ? 0 : current_lead.NumberOfEmployees ;
            current_account.Date_to_Book_Demo__c = Date.today();
            current_account.Lead_Source__c = current_lead.LeadSource;
            
            system.debug('Before Update current_account - ' + current_account + ' ' + current_lead.ownerId);

            accountResult = Database.update(current_account);
            system.debug('accountResult - ' + accountResult);

            current_contact = [SELECT Web_Demo_Booking_Date_Time__c FROM Contact WHERE id = :lcr.getContactId()];
            current_contact.Phone = tmp_lead.Phone;
            current_contact.MobilePhone = current_lead.MobilePhone;
            current_contact.Email = tmp_lead.Email;
            current_contact.Firstname = tmp_lead.FirstName;
            current_contact.Lastname = tmp_lead.LastName;
            current_contact.Web_Demo_Booking_Date_Time__c = GMTDT;
            current_contact.Primary_Contact__c = true;
            current_contact.LeadSource = current_lead.LeadSource;
            
            Database.SaveResult contactResult = Database.update(current_contact);
            system.debug('Database.SaveResult contactResult - ' + contactResult);

            Task current_task = new Task();
            current_task.WhoId = current_contact.id;
            current_task.WhatId = current_account.id;
            current_task.Subject = 'Web Demo';
            current_task.status = 'In Progress';
            current_task.description = 'Lead ' + current_lead.company + ' converted to Account';
            current_task.ActivityDate = GMTDT.date();
            current_task.ReminderDateTime = GMTDT;
            current_task.IsReminderSet = true;
            current_task.ownerid = user.id;

            Database.SaveResult taskResult = Database.insert(current_task);
            system.debug('Database.SaveResult taskResult - ' + taskResult);
        
            EmailTemplate et = [SELECT Id, Name FROM EmailTemplate where name = 'webDemoBookingEmail'];

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
            mail.setTargetObjectId(current_contact.id);// Who you are sending the email to
            mail.setTemplateId(et.id);// The email template ID used for the email
            mail.setToAddresses(new String[]{user.email});
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
            Map<Id, User> managers = new Map<Id, User>([SELECT name FROM User WHERE TeleMarketing_Auto_Assignment_Flag__c = true  AND id != :user.id ]);
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
                for(User u : managers.values())
                {
                    manager_options.add(new SelectOption(u.id, u.name));
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Web Demo is already booked for this Date and Time OR Past date is used\nPlease consider another Date & Time or Assign it to Another Account Manager');
                ApexPages.addMessage(myMsg); 
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Web Demo is already booked for all managers for this Date and Time\nPlease change the time');
                ApexPages.addMessage(myMsg); 
            }
            system.debug('manager_options - ' + manager_options);
        }
        return null;        
    }
}