trigger CaseAfterUpdate on Case (after update)
{
    system.debug('CaseAfterUpdate Trigger new - ' + Trigger.new);
    List<ID> casepassid = new List<ID> ();
    List<ID> casefailid = new List<ID> ();
    List<ID> caseprocess = new List<ID> ();
    List<ID> caseliveid = new List<ID> ();
    List<User> caseowners = new List<User> ();

    for(case c : Trigger.new)
    {
        if(Trigger.oldMap.get(c.id).Case_Owned_By__c != c.Case_Owned_By__c)
        {
            system.debug('Old Value - ' + Trigger.oldMap.get(c.id).Case_Owned_By__c);
            system.debug('New Value - ' + c.Case_Owned_By__c);
            List<User> caseowner = [SELECT Name, Id, usertype, email FROM User where name = :c.Case_Owned_By__c and usertype = 'CSPLitePortal' LIMIT 1];
            system.debug('Case Owner - ' + caseowner);

            if(caseowner.size() > 0)
            {
                system.debug('Case - ' + c);
                String body = 'Please find Case link - https://synetyplc.force.com/'+c.id;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String> {caseowner[0].email});
                mail.setCCAddresses(new List<String> {'michael.prag@synety.com'});
                mail.setSubject('Case ' + c.casenumber + ' is assigned to you');
                mail.setPlainTextBody(body);

                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}, true);
                system.debug('Messaging.SendEmailResult - ' + results);
            }
        }
        if(c.status == 'QA - In Process' && Trigger.oldMap.get(c.id).status != c.status)
        {
            caseprocess.add(c.id);
        }
        if(c.status == 'QA - App QA Passed' && Trigger.oldMap.get(c.id).status != c.status)
        {
            casepassid.add(c.id);
        }
        if(c.status == 'QA - App QA Failed' && Trigger.oldMap.get(c.id).status != c.status)
        {
            casefailid.add(c.id);
        }
        if(c.status == 'App Approved and Live' && Trigger.oldMap.get(c.id).status != c.status)
        {
            caseliveid.add(c.id);
        }

    }
    system.debug('List<ID> casepassid - ' + casepassid);
    system.debug('List<ID> casefailid - ' + casefailid);
    system.debug('List<ID> caseprocess - ' + caseprocess);
    system.debug('List<ID> caseliveid - ' + caseliveid);

    if(caseprocess.size() > 0)
    {
        List<Synety_Plugin__c> sp = [SELECT QA_Status__c FROM Synety_Plugin__c where QA_Ticket_Reference__c = :caseprocess order by Release_Date__c desc LIMIT 1];

        system.debug('List<Synety_Plugin__c> sp - ' + sp);
        if(sp.size() > 0)
        {
            for(Synety_Plugin__c s : sp)
            {
                s.QA_Status__c = 'QA - In Process';
            }
            system.debug('List<Synety_Plugin__c> sp - ' + sp);
            update sp;
        }
    }

    if(casepassid.size() > 0)
    {
        List<Synety_Plugin__c> sp = [SELECT QA_Status__c FROM Synety_Plugin__c where QA_Ticket_Reference__c = :casepassid order by Release_Date__c desc LIMIT 1];

        system.debug('List<Synety_Plugin__c> sp - ' + sp);
        if(sp.size() > 0)
        {
            for(Synety_Plugin__c s : sp)
            {
                s.QA_Status__c = 'QA - App QA Passed';
            }
            system.debug('List<Synety_Plugin__c> sp - ' + sp);
            update sp;
        }
    }

    if(casefailid.size() > 0)
    {
        List<Synety_Plugin__c> sp = [SELECT QA_Status__c, Software_Ready_for_Release__c FROM Synety_Plugin__c where QA_Ticket_Reference__c = :casefailid order by Release_Date__c desc LIMIT 1];

        system.debug('List<Synety_Plugin__c> sp - ' + sp);
        if(sp.size() > 0)
        {
            for(Synety_Plugin__c s : sp)
            {
                s.QA_Status__c = 'QA - App QA Failed';
                //s.QA_Ticket_Reference__c = null;
                s.Software_Ready_for_Release__c = 'No';
            }
            system.debug('List<Synety_Plugin__c> sp - ' + sp);
            update sp;
        }
    }

    if(caseliveid.size() > 0)
    {
        List<Synety_Plugin__c> sp = [SELECT QA_Status__c, Software_Ready_for_Release__c FROM Synety_Plugin__c where QA_Ticket_Reference__c = :caseliveid order by Release_Date__c desc LIMIT 1];

        system.debug('List<Synety_Plugin__c> sp - ' + sp);
        if(sp.size() > 0)
        {
            for(Synety_Plugin__c s : sp)
            {
                s.QA_Ticket_Reference__c = null;
            }
            system.debug('List<Synety_Plugin__c> sp - ' + sp);
            update sp;
        }
    }

}