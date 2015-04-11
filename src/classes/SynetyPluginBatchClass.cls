global class SynetyPluginBatchClass implements Database.Batchable<sObject>, Database.Stateful
{
    global final string query;
    global final List<Id> acct_ids = new List<Id> ();
    global final Synety_Plugin__c sp;
    set<string> maillist = new set<string> ();

    OrgWideEmailAddress ir = new OrgWideEmailAddress();
    global SynetyPluginBatchClass (string q, List<Id> ids, Synety_Plugin__c s)
    {
        query = q;
        acct_ids.addAll(ids);
        sp = s;
        ir = [SELECT id, displayname, address FROM OrgWideEmailAddress WHERE Address = 'support@synety.com' LIMIT 1];
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('In Start - ' + query);
        system.debug('Ids - ' + acct_ids);
        system.debug('Query Output - ' + Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        system.debug('In Execute');
        system.debug('sObject - ' + scope);
        system.debug('Synety_Plugin__c - ' + sp);
        system.debug('New_Features__c - ' + sp.New_Features__c);
        
        for(sobject s : scope)
        {
            system.debug('sObject Email - ' + s.get('email'));

            String name = (string)s.get('name');
            List<String> email = new List<String>();
            maillist.add((string)s.get('email'));
            email.add((string)s.get('email'));

            EmailTemplate aat_template = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate where Name = 'Synety Plugin Updates' LIMIT 1];
            String subject = aat_template.subject;
            subject = subject.replace('{!Synety_Plugin__c.CRM__c}',  sp.CRM__c);
            system.debug('Subject - ' + subject);

            String body = aat_template.body;
            body = body.replace('{!Contact.Name}',  name);
            body = body.replace('{!Synety_Plugin__c.Release_Date__c}',  sp.Release_Date__c.format());
            body = body.replace('{!Synety_Plugin__c.Plugin_Version_Number__c}', (! String.isblank(sp.Plugin_Version_Number__c) ? sp.Plugin_Version_Number__c : 'Not Applicable'));
            body = body.replace('{!Synety_Plugin__c.CRM__c}', (! String.isblank(sp.CRM__c ) ? sp.CRM__c : 'Not Applicable'));
            body = body.replace('{!Synety_Plugin__c.Install_Link__c}', (! String.isblank(sp.Install_Link__c) ? sp.Install_Link__c : 'Not Applicable'));
            body = body.replace('{!Synety_Plugin__c.Install_Instructions__c}', (! String.isblank(sp.Install_Instructions__c ) ? sp.Install_Instructions__c : 'Not Applicable'));
            body = body.replace('{!Synety_Plugin__c.New_Features__c}', (! String.isblank(sp.New_Features__c) ? sp.New_Features__c : 'Not Applicable'));
            body = body.replace('{!Synety_Plugin__c.Bugs_Fixed__c}', (! String.isblank(sp.Bugs_Fixed__c) ? sp.Bugs_Fixed__c : 'Not Applicable'));
            system.debug('Body - ' + body);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(ir.id);
            mail.setToAddresses(email);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            system.debug('Mail - ' + mail);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}, false);
            system.debug('Messaging.SendEmailResult - ' + results);
        }
    }

    global void finish(Database.BatchableContext BC)
    {
        system.debug('In Finish');
        Note sp_note = new Note();
        sp_note.ParentId = sp.Id;
        sp_note.Title = 'Update Status for Version ' + sp.Plugin_Version_Number__c;
        sp_note.Body = 'The last mail update sent on ' + sp.Release_Date__c;
        insert sp_note;

        list<Messaging.EmailFileAttachment> eftlist = new list<Messaging.EmailFileAttachment>();

        if(maillist.size() > 0)
        {
            Messaging.EmailFileAttachment eft1 = new Messaging.EmailFileAttachment();
            eft1.setContentType('text/plain');
            eft1.setFileName('Mail List.txt');
            eft1.setBody(Blob.valueof(string.join(new List<String>(maillist), '\n')));
            eftlist.add(eft1);
        }
        system.debug('eftlist - ' + eftlist);

        User toaddress = new User();
        list<string> toaddresses  = new list<string> ();

        toaddress = [SELECT id, Email FROM User where (username = 'rahul.borgaonkar@synety.com.mohsintest' or username = 'mark.seemann@synety.com')];
        toaddresses.add(toaddress.email);

        toaddresses.add(UserInfo.getUserEmail());
        system.debug('toaddresses - ' + toaddresses);
        
        EmailTemplate template = new EmailTemplate();
        String subject, plainTextBody;

        template = [SELECT id, subject, htmlvalue, body FROM EmailTemplate WHERE Name = 'Synety Plugin Stats Template'];
        system.debug('EmailTemplate - ' + template);
        subject = template.subject;
        subject = subject.replace('{!Today}', datetime.now().format());
        system.debug('subject - ' + subject);

        plainTextBody = template.Body;
        plainTextBody = plainTextBody.replace('{!Synety_Plugin__c.Plugin_Version__c}', sp.Plugin_Version__c);
        plainTextBody = plainTextBody.replace('{!Synety_Plugin__c.Plugin_Version_Number__c}', sp.Plugin_Version_Number__c);
        plainTextBody = plainTextBody.replace('{!sp_mailcount}', maillist.size().format());
        system.debug('plainTextBody - ' + plainTextBody);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setOrgWideEmailAddressId(ir.id);
        mail.setToAddresses(toaddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);
        mail.setFileAttachments(eftlist);

        system.debug('Mail - ' + mail);

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}, false);
        system.debug('Messaging.SendEmailResult - ' + results);
    }
}