trigger OppAfterUpdate on Opportunity (after update) 
{
    //OrgWideEmailAddress salesAdd = [SELECT id, Address FROM OrgWideEmailAddress where address = 'sales@synety.com'];
    OrgWideEmailAddress salesAdd = Utility.getSalesAddressRecord();
    
    list<Messaging.SingleEmailMessage> emailMessages = new list<Messaging.SingleEmailMessage>();
    map<string,string> orderNumbers = new map<string,string>();
    Group provisionQueue;
    try 
    {
        provisionQueue = 
                [select Id 
                from Group 
                where Type = 'Queue' 
                and Name = 'Provisioning Queue' 
                limit 1];

    } 
    catch (Exception ex) 
    {
        System.debug('***Could not find Provisioning Queue');
    }
    
    /*
    User financeUser;
    try 
    {
        financeUser = 
                [select Id 
                from User 
                where UserRole.Name = 'Finance Manager'
                limit 1];

    } 
    catch (Exception ex) 
    {
        System.debug('***Could not find Finance user');
    }
    */
    User financeUser = Utility.getFinanceUserRecord();
    User CSUser = Utility.getCSUserRecord();
    
    List<Case> lstOrderCases = new List<Case>();
    List<Task> lstOrderTasks = new List<Task>();
    
    for(opportunity opp: trigger.new)
    {
        Account acc = [select Id, Name, Phone, (select name, email, phone from contacts)  from Account where Id =: opp.AccountId limit 1];
        
        if(Trigger.oldMap.get(opp.id).Next_Steps__c != opp.Next_Steps__c 
            && opp.Next_Steps__c == 'Customer - Credit check complete - Awaiting Provisioning')
        {
            if (provisionQueue != null) 
            {
                String fullURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.id;

                system.debug('Account Contact Details - ' + acc.contacts);
                system.debug('Opportunity Contact Details - ' + opp.Opportunity_Contact__c);
                Contact primaryContact = new Contact ();

                for(Contact cnt : acc.contacts)
                {
                    if(cnt.id == opp.Opportunity_Contact__c)
                    {
                        system.debug('Found matching contact - ' + cnt);
                        primaryContact = cnt;
                    }
                }

                system.debug('Primary Contact Details - ' + primaryContact);

                // Create a new Case assigned to the Accountancy Queue
                Case c = new Case(
                    OwnerId = provisionQueue.Id,
                    Priority = 'High',
                    Type = 'Provisioning',
                    Reason = 'Provisioning: New Customer Provisioning',
                    Status = 'New',
                    AccountId = opp.AccountId,
                    Opportunity__c = opp.Id,
                    Opportunity_Owner__c = opp.OwnerId,
                    ContactId = primaryContact.Id,
                    //Subject = 'New Order Provisioning Request for order number ' + opp.Order_Number__c,
                    Subject = 'Customer Provisioning - ' + acc.Name, 
                    Description = 'Please provision a order for order number ' + opp.Order_Number__c 
                                + '. Please click on the following link to view order ' + fullURL
                );
                
                lstOrderCases.add(c);
                
                Task t = new Task();
                t.WhatId = opp.Id;
                t.OwnerId = opp.OwnerId;
                t.Subject = 'Order Passed to Provisioning Team';
                t.Status = 'Completed';
                t.Description = 'Order # '+opp.Order_Number__c+' has been passed onto the provisioning team @ '+System.now().format('dd-MM-yyyy hh:mm:ss a')+'.';
                t.ActivityDate = datetime.now().date();
                
                lstOrderTasks.add(t);
                
                
                orderNumbers.put(opp.Id, opp.Order_Number__c);
                                
            }            
        }
        
        if(Trigger.oldMap.get(opp.id).Next_Steps__c != opp.Next_Steps__c 
            && opp.Next_Steps__c == 'Customer - Credit check complete - Awaiting owner review')
        {
            Task t = new Task();
            t.WhatId = opp.Id;
            t.OwnerId = opp.OwnerId;
            t.Subject = 'Order Review';
            t.Priority = 'High';
            t.Status = 'Not Started';
            t.Description = 'Order # '+opp.Order_Number__c+' is ready to be passed onto the provisioning team. Please review the order, enter notes for the provisioning team and pass it to them by clicking the button on order that says "Pass Order to Provisioning".';
            t.ActivityDate = datetime.now().date();
            
            lstOrderTasks.add(t);
        }
        
        if(Trigger.oldMap.get(opp.id).Next_Steps__c != opp.Next_Steps__c 
            && opp.Next_Steps__c == 'Customer - Order DocuSigned - Awaiting BACS payment')
        {
            if (financeUser != null) 
            {
                Task t = new Task();
                t.WhatId = opp.Id;
                t.OwnerId = financeUser.Id;
                t.Subject = 'BACS Payment for Order';
                t.Priority = 'High';
                t.Status = 'Not Started';
                t.Description = 'Order # '+opp.Order_Number__c+' requires payment by BACS. Please check to see if this is received and change the Next Steps to "Customer - Credit Check Complete - Awaiting owner review".';
                t.ActivityDate = datetime.now().date();
                
                lstOrderTasks.add(t);
            }
        }
        
        if(Trigger.oldMap.get(opp.id).Next_Steps__c != opp.Next_Steps__c 
            && opp.Next_Steps__c == 'Customer - Provisioned' && opp.Date_Order_Provisioned__c == null)
        {
            List<Contact> con = new List<Contact>();
            
            if(opp.Opportunity_Contact__c != null)
                con = [select Name, Phone from Contact where Id =: opp.Opportunity_Contact__c limit 1];
            else
                con = [select Name, Phone from Contact where AccountId =: acc.Id limit 1];
            
            if (CSUser != null) 
            {
                Task t = new Task();
                t.WhatId = opp.Id;
                
                string comments = 'Please call this newly provisioned customer to see how their service is running. Here are the details.\r\n';
                if(opp.Order_Number__c != null)
                    comments += 'Order #: '+opp.Order_Number__c +'\r\n';
                    
                if(con.size() > 0)
                {
                    t.WhoId = con[0].Id;
                    comments += 'Customer Name: '+acc.Name+'\r\nContact Name: '+con[0].Name+'\r\nContact Phone: '+con[0].Phone;
                }
                else
                {
                    comments += 'Customer Name: '+acc.Name+'\r\nPhone: '+acc.Phone;
                }   
                
                t.Description = comments;
                t.OwnerId = CSUser.Id;
                t.Subject = 'Call newly provisioned customer';
                t.Priority = 'High';
                t.Status = 'Not Started';
                t.ActivityDate = datetime.now().date().addDays(7);
                t.ReminderDateTime = DateTime.newInstance(t.ActivityDate, Time.newInstance(10, 0, 0, 0));
                t.IsReminderSet = true;
                
                lstOrderTasks.add(t);
            }
        }
        
        if((Trigger.oldMap.get(opp.id).On_going_Payment_Method__c != opp.On_going_Payment_Method__c || Trigger.oldMap.get(opp.id).Next_Steps__c != opp.Next_Steps__c) 
            && opp.On_going_Payment_Method__c == 'Direct Debit' && opp.Next_Steps__c == 'Customer - Provisioned')
        {
            if (financeUser != null) 
            {
                Task t = new Task();
                t.WhatId = opp.Id;
                t.OwnerId = financeUser.Id;
                t.Subject = 'Set-up customer on Direct Debit';
                t.Status = 'Not Started';
                t.Description = 'Customer "'+acc.Name+'" wishes to pay on-going by direct debit. Please set them up on DD.';
                t.ActivityDate = datetime.now().date();
                
                lstOrderTasks.add(t);
            }
        }
        
        /*
        if(Trigger.oldMap.get(opp.id).Order_Docusigned__c != opp.Order_Docusigned__c 
            && opp.Order_Docusigned__c == true && 
            )
        {
            Task t = new Task();
            t.WhatId = opp.Id;
            t.OwnerId = opp.OwnerId;
            t.Subject = 'Order form DocuSigned';
            t.Status = 'Completed';
            t.Description = 'DocuSigned order form received @ '+datetime.now()+'.';
            t.ActivityDate = datetime.now().date();
            
            lstOrderTasks.add(t);
        }
        */
        
    }
    
    if (provisionQueue != null && lstOrderCases.size() > 0) 
    {
        insert lstOrderCases;
        
        for(Case c: lstOrderCases)
        {
            string orderNumber = orderNumbers.get(c.Opportunity__c);
            String oppURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Opportunity__c;
            String caseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
            
            string emailBody = 'Order # '+orderNumber+
                                    ' is ready to be provisioned. Click on the following links and perform the necessary tasks.<br /><br />'+
                                    'Order URL: '+oppURL+'<br />'+
                                    'Ticket URL: '+caseURL+'<br />';
                    
                     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'provisioning-team@synety.com','oliver.simpson@synety.com','ben.banks@synety.com','mohsin.raza@synety.com'};//{'mohsin.raza@synety.com'}; 
            mail.setOrgWideEmailAddressId(salesAdd.Id);
            mail.setSubject('New order for provisioning');
            mail.setToAddresses(toAddresses);
            mail.setBccSender(false);
            mail.setWhatId(c.Opportunity__c);
            mail.setSaveAsActivity(true);
            mail.setHtmlBody(emailBody);
            mail.setUseSignature(false);
            
            emailMessages.add(mail);
        }
        
        
    }
    
    if (lstOrderTasks.size() > 0) 
    {
        //insert lstOrderTasks;
        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.EmailHeader.triggerUserEmail = true;
        database.insert(lstOrderTasks, dmlo);
    }
    
    if(emailMessages.size() > 0)
    {
        // Send the email you have created.
        Messaging.sendEmail(emailMessages);
    }
    
}