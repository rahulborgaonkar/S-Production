global class regulatoryNewsSubscribersBatchClass implements Database.Batchable<sObject>, Database.Stateful
{
    global final string query;
    global final Synety_com_News__c rns_news;
    integer rns_mailcount;
    integer rowcount;
    list<string> maillist = new list<string> ();
    list<string> contactlist = new list<string> ();

    global regulatoryNewsSubscribersBatchClass (string q, Synety_com_News__c r)
    {
        query = q;
        rns_news = r;
        rns_mailcount = 0;
        rowcount = 0;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('In Start - ' + query);
        system.debug('Query Output - ' + Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        list<id> rns_ids = new list<id> ();
        system.debug('Selected contacts - ' + scope);
        rowcount = rowcount + scope.size();

        for (sObject s : scope)
        {
            system.debug('email - ' + s.get('email'));
            rns_ids.add((id) s.get('id'));
        }
        system.debug('rns_ids - ' + rns_ids);

        OrgWideEmailAddress ir = [SELECT id, displayname, address FROM OrgWideEmailAddress WHERE Address = 'ir@synety.com'];

        EmailTemplate template = [SELECT id, subject, htmlvalue, body FROM EmailTemplate WHERE Name = 'Regulatory News Subscribers Template'];

        for(sobject s : scope)
        {
			system.debug('sobject - ' + s);

        	String subject = template.subject;
        	subject = subject.replace('{!Today}', date.today().format());

        	String htmlBody = template.HtmlValue;
        	htmlBody = htmlBody.replace('{!Synety_com_News__c.News_Type__c}', rns_news.news_type__c);
        	//String lmd = rns_news.lastmodifieddate.format('dd MMMMM yyyy') + ' at ' + rns_news.lastmodifieddate.format('HH:mm a');
        	String lmd = rns_news.Article_Datetime__c.format('dd MMMMM yyyy') + ' at ' + rns_news.Article_Datetime__c.format('HH:mm a');
        	htmlBody = htmlBody.replace('{!Synety_com_News__c.LastModifiedDate}', lmd);
        	htmlBody = htmlBody.replace('{!Synety_com_News__c.Name}', rns_news.name);
        	htmlBody = htmlBody.replace('{!Synety_com_News__c.Article_Excerpt__c}', rns_news.article_excerpt__c);
            htmlBody = htmlBody.replace('{!Contact.FirstName}', (string)s.get('name'));
            htmlBody = htmlBody.replace('URL', 'https://synety.secure.force.com/orders/regulatoryNewsSubscribersUnsubscribePage?id='+(string)s.get('id'));
           
			system.debug('htmlBody - ' + htmlBody);

            list<string> bccaddresses = new list<string> ();
            if(string.isnotblank((string)s.get('email')))
            {
                bccaddresses.add((string)s.get('email'));
            }
            system.debug('bccaddresses - ' + bccaddresses);
            system.debug('bccaddresses.size() - ' + bccaddresses.size());

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(ir.id);
            mail.setBCCAddresses(bccaddresses);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            
            if(bccaddresses.size() > 0)
            {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}, false);
                system.debug('Messaging.SendEmailResult - ' + results);
                if(results[0].issuccess() == true)
                {
                    maillist.add(bccaddresses[0]);
                    rns_mailcount++;
                    system.debug('loop rns_mailcount - ' + rns_mailcount);
                }
            }
            else
            {
                contactlist.add((string)s.get('name'));
            }

        }
    }

    global void finish(Database.BatchableContext BC)
    {
        Synety_com_News__c rns_news_tmp = [SELECT Article__c, Article_Date__c, Article_Excerpt__c, Name, News_Type__c, Published__c, Id FROM Synety_com_News__c where id = :rns_news.id];
        system.debug('rns_news_tmp - ' + rns_news_tmp);

        system.debug('rns_mailcount - ' + rns_mailcount);
        system.debug('rowcount - ' + rowcount);

        system.debug('maillist - ' + maillist);
        system.debug('contactlist - ' + contactlist);

        list<Messaging.EmailFileAttachment> eftlist = new list<Messaging.EmailFileAttachment>();

        if(maillist.size()> 0)
        {
            Messaging.EmailFileAttachment eft1 = new Messaging.EmailFileAttachment();
            eft1.setContentType('text/plain');
            eft1.setFileName('Mail List.txt');
            eft1.setBody(Blob.valueof(string.join(maillist, '\n')));
            eftlist.add(eft1);
        }

        if(contactlist.size() > 0)
        {
            Messaging.EmailFileAttachment eft2 = new Messaging.EmailFileAttachment();
            eft2.setContentType('text/plain');
            eft2.setFileName('Contact List.txt');
            eft2.setBody(Blob.valueof(string.join(contactlist, '\n')));
            eftlist.add(eft2);
        }
        
        OrgWideEmailAddress ir = [SELECT id, displayname, address FROM OrgWideEmailAddress WHERE Address = 'ir@synety.com'];
        list<string> iraddress = new list<string> ();
        iraddress.add(ir.address);

        User toaddress = [SELECT id, Email FROM User where (username = 'rahul.borgaonkar@synety.com.mohsintest' or username = 'paul.williams@synety.com')];
        //User toaddress = [SELECT id, Email FROM User where (username = 'rahul.borgaonkar@synety.com.mohsintest' or username = 'rahul.borgaonkar@synety.com')];
        list<string> toaddresses = new list<string> ();
        toaddresses.add(toaddress.email);
        toaddresses.add('rahul.borgaonkar@synety.com');
        
        EmailTemplate template = [SELECT id, subject, htmlvalue, body FROM EmailTemplate WHERE Name = 'Regulatory News Subscribers Stats Template'];

        String subject = template.subject;
        subject = subject.replace('{!Today}', date.today().format());

        String plainTextBody = template.Body;
        plainTextBody = plainTextBody.replace('{!Synety_com_News__c.Name}', rns_news_tmp.Name);
        plainTextBody = plainTextBody.replace('{!rns_mailcount}', rns_mailcount.format());
        plainTextBody = plainTextBody.replace('{!rns_failcount}', (rowcount - rns_mailcount).format());

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(ir.id);
        mail.setToAddresses(toaddresses);
        mail.setCCAddresses(iraddress); //don't remove, commented for testing purpose
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);
        mail.setFileAttachments(eftlist);

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}, false);
        system.debug('Messaging.SendEmailResult - ' + results);
    }
}