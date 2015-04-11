public class checkDuplicateLeadsClass
{
    public static boolean isMergedExecuted = false;

    public static Lead areTheseSameLeads(Lead nw_lead, Map<Lead, Lead> uniq_leads)
    {
        Integer webSiteCounter = 0;
        Integer mailCounter = 0;

        system.debug('areTheseSameLeads');

        for(Lead unq_lead : uniq_leads.keySet())
        {
            String new_lead, uniq_lead;            
            String nw_web, nw_email, unq_web, unq_email;

         //RB
            /*system.debug('nw_lead.website - ' + nw_lead.website);
            system.debug('nw_lead.email - ' + nw_lead.email);
            system.debug('unq_lead.website - ' + unq_lead.website);
            system.debug('unq_lead.email - ' + unq_lead.email);*/
         //RB
/*
            if(nw_lead.website != null && nw_lead.email != null)
            {//RB            
                nw_web = (String.isNotBlank(nw_lead.website) ? (nw_lead.Website.indexof('www') == -1 ? nw_lead.Website.removeStart('http://') : nw_lead.Website.substring(nw_lead.Website.indexof('www'))) : 'NULL');
                unq_web = (String.isNotBlank(unq_lead.website) ? (unq_lead.Website.indexof('www') == -1 ? unq_lead.Website.removeStart('http://') : unq_lead.Website.substring(unq_lead.Website.indexof('www'))) : 'NULL');
                nw_email = nw_lead.email;
                unq_email = (String.isNotBlank(unq_lead.email) ? unq_lead.email : 'NULL');
                
                new_lead = nw_lead.Company+nw_web+nw_email+nw_lead.LastName;
                uniq_lead = unq_lead.Company+unq_web+unq_email+unq_lead.LastName;
            }                
            else if(nw_lead.website == null && nw_lead.email != null)
            {//RB
                nw_email = nw_lead.email;
                unq_email = (String.isNotBlank(unq_lead.email) ? unq_lead.email : 'NULL');

                new_lead = nw_lead.Company+nw_email+nw_lead.LastName;
                uniq_lead = unq_lead.Company+unq_email+unq_lead.LastName;
            }
            else if(nw_lead.website != null && nw_lead.email == null)
            {//RB
                nw_web = (String.isNotBlank(nw_lead.website) ? (nw_lead.Website.indexof('www') == -1 ? nw_lead.Website.removeStart('http://') : nw_lead.Website.substring(nw_lead.Website.indexof('www'))) : 'NULL');
                unq_web = (String.isNotBlank(unq_lead.website) ? (unq_lead.Website.indexof('www') == -1 ? unq_lead.Website.removeStart('http://') : unq_lead.Website.substring(unq_lead.Website.indexof('www'))) : 'NULL');

                new_lead = nw_lead.Company+nw_web+nw_lead.LastName;
                uniq_lead = unq_lead.Company+unq_web+unq_lead.LastName;
            }
            else if(nw_lead.website == null && nw_lead.email == null)
            {
                new_lead = nw_lead.Company+nw_lead.LastName;
                uniq_lead = unq_lead.Company+unq_lead.LastName;
            }            
*/
            nw_email = '';
            if(String.isNotBlank(nw_lead.email))
            {
                nw_email = nw_lead.email;
            }
            nw_web = '';
            if(String.isNotBlank(nw_lead.website))
            {
                nw_web = nw_lead.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www.');
            }

            unq_email = '';
            if(String.isNotBlank(unq_lead.email))
            {
                unq_email = unq_lead.email;
            }
            unq_web = '';
            if(String.isNotBlank(unq_lead.website))
            {
                unq_web = unq_lead.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www.');
            }

            new_lead = nw_lead.company+nw_lead.lastname+nw_email+nw_web;
            uniq_lead = unq_lead.company+unq_lead.lastname+unq_email+unq_web;
            
            if(new_lead == uniq_lead)
            {
                return unq_lead;
            }
        }            
        return nw_lead;
    }

    public static void sendMail(Map<Lead, Lead> leads, String Message)
    {    
        String lead_list = 'Company,FirstName,LastName,Email,Phone,Website,LeadSource,Lead Link\n';

        List<String> Email = new List<String> ();
        if(Userinfo.getLastName() == 'Account')
        {
            Email.add('cherise.hardy@synety.com');
        }
        else
        {
            Email.add(Userinfo.getUserEmail());
        }
        Email.add('rahul.borgaonkar@synety.com');
        Email.add('uk-telemarketing-team@synety.com');
                
        for(Lead lead : leads.keySet())
        {
            lead_list = lead_list + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + ',https://na11.salesforce.com/'+leads.get(lead).id + '\n';
        }
        //lead_list = Message + '\n' + lead_list;

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Leads Data.csv');
        efa.setBody(Blob.valueof(lead_list));
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSenderDisplayName('Synety PLC');
        mail.setToAddresses(new List<String>(Email));
        mail.setSubject('Important Message! - ' + Message + ' (Total Records - ' + leads.keySet().size() + ')');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        mail.setPlainTextBody(Message + '\n\nPlease Check Attachment for more details\n\nThanks,\n\nSynety');

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        system.debug('Mail Result - ' + results);
    }

    public static void sendMail(Map<Lead, Account> leads, String Message)
    {    
        String lead_list = 'Company,FirstName,LastName,Email,Phone,Website,LeadSource,Account Link\n';

        List<String> Email = new List<String> ();
        if(Userinfo.getLastName() == 'Account')
        {
            Email.add('cherise.hardy@synety.com');
        }
        else
        {
            Email.add(Userinfo.getUserEmail());
        }
        Email.add('rahul.borgaonkar@synety.com');
        Email.add('uk-telemarketing-team@synety.com');
                
        for(Lead lead : leads.keySet())
        {
            lead_list = lead_list + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + ',https://na11.salesforce.com/'+leads.get(lead).id + '\n';
        }
        //lead_list = Message + '\n' + lead_list;
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Leads Data.csv');
        efa.setBody(Blob.valueof(lead_list));

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSenderDisplayName('Synety PLC');
        mail.setToAddresses(new List<String>(Email));
        mail.setSubject('Important Message! - ' + Message + ' (Total Records - ' + leads.keySet().size() + ')');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        mail.setPlainTextBody(Message + '\n\nPlease Check Attachment for more details\n\nThanks,\n\nSynety');

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        system.debug('Mail Result - ' + results);
    }

    public static void sendMail(Map<Lead, Contact> leads, String Message)
    {    
        String lead_list = 'Company,FirstName,LastName,Email,Phone,Website,LeadSource,Contact Link\n';

        List<String> Email = new List<String> ();
        if(Userinfo.getLastName() == 'Account')
        {
            Email.add('cherise.hardy@synety.com');
        }
        else
        {
            Email.add(Userinfo.getUserEmail());
        }
        Email.add('rahul.borgaonkar@synety.com');
        Email.add('uk-telemarketing-team@synety.com');
        
        for(Lead lead : leads.keySet())
        {
            lead_list = lead_list + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + ',https://na11.salesforce.com/'+leads.get(lead).id + '\n';
        }
        //lead_list = Message + '\n' + lead_list;
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Leads Data.csv');
        efa.setBody(Blob.valueof(lead_list));

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSenderDisplayName('Synety PLC');
        mail.setToAddresses(new List<String>(Email));
        mail.setSubject('Important Message! - ' + Message + ' (Total Records - ' + leads.keySet().size() + ')');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        mail.setPlainTextBody(Message + '\n\nPlease Check Attachment for more details\n\nThanks,\n\nSynety');
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        system.debug('Mail Result - ' + results);
    }

    public static void insertTask(Map<Lead, Lead> dup_leads, String Message)
    {
        List<Task> lead_tasks = new List<Task>();
        for(Lead lead : dup_leads.keySet())
        {
            Lead orig_lead = dup_leads.get(lead);
            Task task = new Task();
            task.WhoId = orig_lead.id;
            task.WhatId = null;
            //task.Subject = Message;
            task.Subject = Message + '\n';
            task.Subject = task.Subject + 'Company,FirstName,LastName,Email,Phone,Website,LeadSource\n';
            task.Subject = task.Subject + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + '\n';

            task.status = 'Completed';
//            task.description = 'Lead with (' + orig_lead.company + ') name already found';
            task.description = Message + '\n';
            task.description = task.description + 'Company,FirstName,LastName,Email,Phone,Website,LeadSource\n';
            task.description = task.description + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + '\n';

            lead_tasks.add(task);
        }
        system.debug('Task - ' + lead_tasks);
        insert lead_tasks;
        system.debug('After Insert');
    }


    public static void insertTask(Map<Lead, Account> dup_leads, String Message)
    {
        List<Task> lead_tasks = new List<Task>();

        system.debug('Account dup lead - ' + dup_leads);
        for(Lead lead : dup_leads.keySet())
        {
            Account account = dup_leads.get(lead);

            Task task = new Task();
            task.WhoId = null;
            task.WhatId = account.id;
            //task.Subject = Message;
            task.Subject = Message + '\n';
            task.Subject = task.Subject + 'Company,FirstName,LastName,Email,Phone,Website,LeadSource\n';
            task.Subject = task.Subject + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + '\n';

            task.status = 'Completed';
            //task.description = 'Account with Lead name (' + account.name + ') already exists';
            task.description = Message + '\n';
            task.description = task.description + 'Company,FirstName,LastName,Email,Phone,Website,LeadSource\n';
            task.description = task.description + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + '\n';

            lead_tasks.add(task);
        }

        system.debug('Task - ' + lead_tasks);
        insert lead_tasks;
    }

    public static void insertTask(Map<Lead, Contact> dup_leads, String Message)
    {
        List<Task> lead_tasks = new List<Task>();

        system.debug('Contact dup lead - ' + dup_leads);
        for(Lead lead : dup_leads.keySet())
        {
            Contact contct = dup_leads.get(lead);

            Task task = new Task();
            task.WhoId = contct.id;
            task.WhatId = null;
            task.Subject = Message + '\n';
            task.Subject = task.Subject + 'Company,FirstName,LastName,Email,Phone,Website,LeadSource\n';
            task.Subject = task.Subject + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + '\n';

            task.status = 'Completed';
            //task.description = 'Lead converted to Contact (' + contct.name + ')';
            task.description = Message + '\n';
            task.description = task.description + 'Company,FirstName,LastName,Email,Phone,Website,LeadSource\n';
            task.description = task.description + lead.company + ',' + lead.firstname + ',' + lead.lastname + ',' + lead.email + ',' + lead.phone + ',' + lead.website + ',' + lead.leadsource + '\n';
            lead_tasks.add(task);
        }

        system.debug('Task - ' + lead_tasks);
        insert lead_tasks;
    }

    
    public static List<Id> getIdsOfLeads(Map<Lead, Lead> dup_leads)
    {
        List<Id> Ids = new List<Id>();
        for(Lead lead : dup_leads.keySet())
        {
            Ids.add(lead.id);        
        }       
        return Ids;
    }

    public static List<Id> getIdsOfLeads(Map<Lead, Account> dup_leads)
    {
        List<Id> Ids = new List<Id>();
        for(Lead lead : dup_leads.keySet())
        {
            Ids.add(lead.id);        
        }       
        return Ids;
    }
    
    public static List<Id> getIdsOfLeads(Map<Lead, Contact> dup_leads)
    {
        List<Id> Ids = new List<Id>();
        for(Lead lead : dup_leads.keySet())
        {
            Ids.add(lead.id);        
        }       
        return Ids;
    }

    public static void updateMasterLeads(Map<Lead, Lead> master_leads)
    {            
        if(master_leads.size() > 0)
        {
            checkDuplicateLeadsClass.isMergedExecuted = true;

            Set<lead> master_leads_set = new Set<lead> ();
            master_leads_set.addAll(master_leads.values());
            List<lead> master_leads_list = new List<lead> ();
            master_leads_list.addAll(master_leads_set);

            system.debug('About to update - ' + master_leads_list);
            Database.SaveResult[] ml = Database.update(master_leads_list);
            system.debug('Update Master Leads Result - ' + ml);
        }            
    }

    @future //future method can accept only standard data types
    public static void deleteDupilcateLeads(List<Id> list_ids)
    {            
        List<Lead> dup_leads = [SELECT Id FROM Lead WHERE id in :list_ids];
        if(dup_leads.size() > 0)
        {
            system.debug('About to delete - ' + dup_leads);
            Database.DeleteResult[] dr = Database.delete(dup_leads);
            system.debug('Delete Result - ' + dr);
        }            
    }
}