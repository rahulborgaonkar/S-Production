trigger checkDuplicateLeadsTrigger on Lead (after insert, after update)
{
    Map<Lead, Lead> uniq_leads = new Map<Lead, Lead>();
    Map<Lead, Lead> dup_lead_from_bulk = new Map<Lead, Lead>();
    Map<Lead, Account> lead_got_account_already = new Map<Lead, Account>();
    Map<Lead, Contact> lead_converted_to_contact = new Map<Lead, Contact>();
    Map<Lead, Lead> lead_merged_to_master = new Map<Lead, Lead>();

    system.debug('checkDuplicateLeadsClass.isMergedExecuted - ' + checkDuplicateLeadsClass.isMergedExecuted);
    system.debug('Trigger.new - ' + Trigger.new);

    if(checkDuplicateLeadsClass.isMergedExecuted == false)
    {
        system.debug('FIRST LOOP');

        Integer dup_count = 0;
        Lead nw_lead, unq_lead;    
        for (Lead lead : Trigger.new)
        {
            if((Trigger.isUpdate && lead.OwnerId != Trigger.oldMap.get(lead.Id).OwnerId) || lead.status.equalsIgnoreCase('Called') == true || (String.isnotblank(lead.leadsource) && lead.leadsource.contains('SFDC-')))
            {
                //do nothing
            }
            else
            {
                Lead ret_lead = checkDuplicateLeadsClass.areTheseSameLeads(lead, uniq_leads);
    
                if(ret_lead == lead)
                {
                    uniq_leads.put(lead, lead);
                }
                else
                {
                    dup_lead_from_bulk.put(lead, ret_lead); // Find orig lead and put a task in activity history saying one more lead with this name in the list
                }
            }
        }

        system.debug('uniq_leads - ' + uniq_leads.size());
        system.debug('dup_lead_from_bulk - ' + dup_lead_from_bulk.size());
        system.debug('lead_converted_to_contact - ' + lead_converted_to_contact.size());
        system.debug('lead_got_account_already - ' + lead_got_account_already.size());
        system.debug('lead_merged_to_master - ' + lead_merged_to_master.size());

        system.debug('SECOND LOOP');

        Set<String> leadsLastName = new Set<String> ();
        Set<String> leadsEmail = new Set<String> ();
        Set<String> leadsWebsite = new Set<String> ();
        Set<String> leadsCompany = new Set<String> ();
        Set<String> leadsEmailForWebsite = new Set<String> ();

        for(lead l : uniq_leads.values())
        {
            leadsLastName.add(l.LastName);
            leadsCompany.add(l.company);
            if(String.isNotBlank(l.website))
            {
                //leadsWebsite.add('%.'+l.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www.'));
                leadsWebsite.add(l.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://'));
            }
            if(String.isNotBlank(l.email))
            {
                leadsEmail.add('%'+l.email.substring(l.email.indexof('@')));
                leadsEmailForWebsite.add('%.'+l.email.substring(l.email.indexof('@')+1));
            }
        }

       
        //system.debug('leadsLastName.size() - ' + leadsLastName.size());
        //system.debug('leadsLastName - ' + leadsLastName);

        //system.debug('leadsWebsite.size() - ' + leadsWebsite.size());
        //system.debug('leadsWebsite - ' + leadsWebsite);

        //system.debug('leadsCompany.size() - ' + leadsCompany.size());
        //system.debug('leadsCompany - ' + leadsCompany);

        //system.debug('leadsEmail.size() - ' + leadsEmail.size());
        //system.debug('leadsEmail - ' + leadsEmail);

        //system.debug('Contact - ' + [Select Id, Email, FirstName, LastName, OwnerId from Contact WHERE LastName = :leadsLastName OR Email LIKE :leadsEmail]);
        //system.debug('Contact - ' + [Select Id, Email, FirstName, LastName, OwnerId from Contact WHERE Email LIKE :leadsEmail]);
        //system.debug('Contact2 - ' + [Select Id, Email, FirstName, LastName, OwnerId from Contact WHERE Email LIKE :list_leadsEmail]);

        List<Account> found_accts_contacts = [SELECT Name, Owner.Id, Owner.email, website, (Select Id, Email, FirstName, LastName, OwnerId from Contacts WHERE LastName = :leadsLastName OR Email LIKE :leadsEmail) FROM Account WHERE (Name = :leadsCompany OR Website = :leadsWebsite OR Website LIKE :leadsEmailForWebsite)];

        Map<Contact, Id> new_contact = new Map<Contact, Id> ();    

        for (Lead lead : uniq_leads.keyset())
        {           

            String Website = 'NOWEBSITE';
            if(String.isNotBlank(lead.Website) || lead.Website != null) //RB
            {
                //system.debug('lead.website - ' + lead.website);
                //Website = '.'+ lead.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www.');
                Website = lead.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://');
                
                //if(lead.website.indexof('www') == -1)
                //{
                    //Website = lead.website.removeStart('http://');
                //}
                //else
                //{
                    //Website = '%' + lead.Website.substring(lead.website.indexof('www'));
                //}

            }

            String EmailToWebsite = 'NOEMAIL';
            String EmailToWebsite2 = 'NOEMAIL';
            if(lead.Email != null)
            {
                EmailToWebsite = '.' + lead.Email.substring(lead.Email.indexof('@')+1);
                EmailToWebsite2 = lead.Email.substring(lead.Email.indexof('@')+1);
            }

//            String NotProvided = '%Provide%';

//            Account[] acct = [SELECT Name, Owner.Id, Owner.email, (Select Id, Email, FirstName, LastName, OwnerId from Contacts WHERE LastName = :lead.LastName OR (NOT LastName LIKE :NotProvided) OR Email = :lead.Email) FROM Account WHERE (Name = :lead.company AND (NOT Name LIKE :NotProvided)) OR Website LIKE :Website OR Website LIKE :EmailToWebsite ORDER BY CreatedDate DESC LIMIT 1];

            String lead_lst_nm_email = (lead.LastName == null ? 'NULL' : lead.LastName)+(lead.email == null ? 'NULL' : lead.email);

            for(Account acct : found_accts_contacts)
            {
//                if(acct.size() == 1 && acct[0].Contacts.size() > 0)
                //system.debug('acct.name - ' + acct.name);
                //system.debug('lead.company - ' + lead.company);
                //system.debug('acct.website - ' + acct.website);
                //system.debug('Website - ' + Website);
                //system.debug('emailtowebsite - ' + emailtowebsite);
                //if((acct.name == lead.company || acct.website.contains(Website) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() > 0 )
				//if((acct.name == lead.company || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website)) || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www') == EmailToWebsite2))) && acct.Contacts.size() > 0 )
				//if((acct.name == lead.company || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website)) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() > 0 )
				//if(acct.name == lead.company && ((String.isNotBlank(acct.website) && acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() > 0 )
				if((acct.name == lead.company || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website)) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() > 0 )
                {
                    system.debug('Account and Its contact found');

                    Set<Contact> acct_cnct = new Set<Contact> (acct.Contacts);
                    system.debug('Contact 1- ' + acct_cnct);

                    Map<String, Contact> all_lst_nm_email = new Map<String, Contact>();
    
                    for(Contact cnct : acct_cnct)
                    {
                        cnct.LastName = cnct.LastName == null ? 'NULL' : cnct.LastName;
                        cnct.email = cnct.email == null ? 'NULL' : cnct.email;
                        all_lst_nm_email.put(cnct.LastName+cnct.email, cnct);
    
                    }
                    Contact cnct = all_lst_nm_email.get(lead_lst_nm_email);
                    system.debug('cnct - ' + cnct);
                        
                    if(cnct == null)
                    {
                        system.debug('acct_cnct - ' + acct_cnct);
    
                        for(Contact cnctr : acct_cnct)
                        {
                            //system.debug('lead.LastName - ' + lead.LastName);
                            //system.debug('lead.email - ' + lead.email);
    
                            //system.debug('cnctr.LastName - ' + cnctr.LastName);
                            //system.debug('cnctr.email - ' + cnctr.email);
    
                            if(cnctr.LastName == lead.LastName && (cnctr.email == 'null' || cnctr.email.touppercase().contains('PROVIDE')) && lead.email != null)
                            {
                                system.debug('FIRST IF');
                                system.debug('Account and Its contact found, updating Contact email with Lead Email');
                                cnctr.email = lead.email;
                                lead_converted_to_contact.put(lead, cnctr);
                                uniq_leads.remove(lead);
                                system.debug('cnctr.id - ' + cnctr.id);
                                new_contact.put(cnctr, cnctr.id);
                            }
                            else if(cnctr.email == lead.email && (cnctr.LastName == 'null' || cnctr.LastName.touppercase().contains('PROVIDE')) && lead.LastName != null)
                            {
                                system.debug('SECOND IF');
                                system.debug('Account and Its contact found, updating Contact LastName with Lead LastName');
                                cnctr.LastName = lead.LastName;
                                lead_converted_to_contact.put(lead, cnctr);
                                uniq_leads.remove(lead);
                                system.debug('cnctr.id - ' + cnctr.id);
                                new_contact.put(cnctr, cnctr.id);
                            }
                            else if(lead.lastname != null && (lead.email != null || lead.phone != null))
                            //else if(cnctr.lastname != null && (cnctr.email != null || cnctr.phone != null))
                            {
                                system.debug('THIRD IF');
                                system.debug('Account found, inserting new Contact using Lead');
        
                                Contact tmp_cnct = new Contact();
                                tmp_cnct.Salutation = lead.Salutation;
                                tmp_cnct.Title = lead.Title;
                                tmp_cnct.Phone = lead.Phone;
                                tmp_cnct.MobilePhone = lead.MobilePhone;
                                tmp_cnct.Email = lead.Email;
                                tmp_cnct.Firstname = lead.FirstName;
                                tmp_cnct.Lastname = lead.LastName;
                                tmp_cnct.AccountId = acct.id;
                                tmp_cnct.ownerid = lead.ownerid;
                                tmp_cnct.leadsource = lead.leadsource;                    
                                lead_converted_to_contact.put(lead, tmp_cnct);
                                uniq_leads.remove(lead);
                                new_contact.put(tmp_cnct, tmp_cnct.id);
                                system.debug('new_contact before - ' + new_contact);                    
                            }
                        }
                    }
                    else
                    {
                        system.debug('Account found and contact also found');
                        lead_got_account_already.put(lead, acct);
                        uniq_leads.remove(lead);
                    }
                }
                //else if(acct.size() == 1 && acct.Contacts.size() == 0)
                //else if((acct.name == lead.company || acct.website.contains(Website) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() == 0)
                //else if((acct.name == lead.company || (String.isNotBlank(acct.website) && (acct.website.contains(Website) || acct.website.contains(emailtowebsite)))) && acct.Contacts.size() == 0 )
                //else if((acct.name == lead.company || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website)) || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www') == EmailToWebsite2))) && acct.Contacts.size() == 0 )
				//else if(acct.name == lead.company && ((String.isNotBlank(acct.website) && acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() == 0 )
                else if((acct.name == lead.company || (String.isNotBlank(acct.website) && (acct.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://') == Website)) || acct.website.contains(emailtowebsite)) && acct.Contacts.size() == 0 )
                {
                    if(lead.lastname != null && (lead.email != null || lead.phone != null))
                    {                
                        system.debug('Account found but no contact found');
                        Contact tmp_cnct = new Contact();
                        tmp_cnct.Salutation = lead.Salutation;
                        tmp_cnct.Title = lead.Title;
                        tmp_cnct.Phone = lead.Phone;
                        tmp_cnct.MobilePhone = lead.MobilePhone;
                        tmp_cnct.Email = lead.Email;
                        tmp_cnct.Firstname = lead.FirstName;
                        tmp_cnct.Lastname = lead.LastName;
                        tmp_cnct.AccountId = acct.id;
                        tmp_cnct.ownerid = lead.ownerid;
                        tmp_cnct.leadsource = lead.leadsource;
                        lead_converted_to_contact.put(lead, tmp_cnct);
                        uniq_leads.remove(lead);
                        new_contact.put(tmp_cnct, tmp_cnct.id);
                        system.debug('new_contact before - ' + new_contact);                    
                    }
                    else
                    {
                        system.debug('Account found but lead has no contact details');
                        lead_got_account_already.put(lead, acct);
                        uniq_leads.remove(lead);
                    }
                }
            }
        }

        system.debug('BEFORE UPSERT');
        system.debug('new contact - ' + new_contact);
    
        upsert new List<Contact>(new_contact.keyset());
        system.debug('AFTER UPSERT');

        system.debug('uniq_leads - ' + uniq_leads.size() + ' ' + uniq_leads);
        system.debug('dup_lead_from_bulk - ' + dup_lead_from_bulk.size());
        system.debug('lead_converted_to_contact - ' + lead_converted_to_contact.size() + ' ' + lead_converted_to_contact );
        system.debug('lead_got_account_already - ' + lead_got_account_already.size() + ' ' + lead_got_account_already);
        system.debug('lead_merged_to_master - ' + lead_merged_to_master.size());

        system.debug('THIRD LOOP');

        Map<String, Schema.SObjectField> leadMap = Schema.SObjectType.Lead.fields.getMap();
        Map<String, Boolean> leadupdtMap = new Map<String, Boolean> ();

        for(String field : leadMap.keyset())
        {
            if(leadMap.get(field).getDescribe().isUpdateable() == true && leadMap.get(field).getDescribe().isCustom() == false)
            {
                leadupdtMap.put(field, true);
            }
        }
        system.debug('Map<String, Boolean> leadupdtMap - ' + leadupdtMap);

        List<Lead> all_leads = new List<Lead> ();
        all_leads.addAll(uniq_leads.keyset());
        all_leads.addAll(dup_lead_from_bulk.keyset());
        all_leads.addAll(lead_converted_to_contact.keyset());
        all_leads.addAll(lead_got_account_already.keyset());
        system.debug('all_leads - ' + all_leads.size());

        List<Id> all_leads_id = new List<Id> ();
        for(Lead ld : all_leads)
        {
            all_leads_id.add(ld.id);
        }

        system.debug('all_leads_id.size() - ' + all_leads_id.size());

        Set<String> companies = new Set<String> ();
        Set<String> lastnames = new Set<String> ();
        //Set<String> websites = new Set<String> ();
        //Set<String> emailtowebsites = new Set<String> ();
        Set<String> email = new Set<String> ();

        for(Lead lead : uniq_leads.keyset())
        {
            if(String.isNotBlank(lead.company))
            {
                companies.add(lead.company);
            }
            if(String.isNotBlank(lead.lastname))
            {
                lastnames.add(lead.lastname);
            }

            //if(String.isNotBlank(lead.Website) || lead.Website != null) //RB
            //{
                //system.debug('lead.website - ' + lead.website);
                //String Website = '';
                //if(lead.website.indexof('www') == -1)
                //{
                    //Website = lead.website.removeStart('http://');
                //}
                //else
                //{
                    //Website = lead.Website.substring(lead.website.indexof('www'));
                //}
                //websites.add(Website);
            //}

            //if(String.isNotBlank(lead.email))
            //{
                //String email = '%'+lead.Email.substring(lead.Email.indexof('@'));
                //system.debug('EmailToWebsite - ' + EmailToWebsite);
                //emailtowebsites.add(email);
            //}

            //if(String.isNotBlank(lead.website))
            //{
                //websites.add('%'+lead.website.removeStartIgnoreCase('http://').removeStartIgnoreCase('https://').removeStartIgnoreCase('www.'));
            //}
            if(String.isNotBlank(lead.email))
            {
                //emailtowebsites.add(lead.email);
                email.add(lead.email);
            }
        }

        system.debug('all_leads_id - ' + all_leads_id);
        system.debug('companies - ' + companies);
        //system.debug('websites - ' + websites);
        system.debug('lastnames - ' + lastnames);
        system.debug('email - ' + email);
        //system.debug('emailtowebsites - ' + emailtowebsites);
        //system.debug('emailtowebsites size - ' + emailtowebsites.size());

//        List<Lead> tmpLeads = [SELECT ownerid, annualrevenue, bottomline__creditsafecompanytype__c, bottomline__creditsafelastrefreshed__c, bottomline__creditsafelimit__c, bottomline__creditsafescore__c, bottomline__creditsafescoredescription__c, city, company, country, crm_product_used__c, date_to_book_demo__c, description, donotcall, email, emailbounceddate, emailbouncedreason, fax, firstname, hasoptedoutofemail, hasoptedoutoffax, industry, lastname, lead_type__c, leadsource, lid__linkedin_company_id__c, lid__linkedin_member_token__c, masterrecordid, mobilephone, next_steps_to_be_taken__c, numberofemployees, phone, postalcode, rating, salutation, state, status, street, time_to_book_demo__c, title, website FROM Lead WHERE Id NOT IN :all_leads_id AND isConverted = false AND (Company in :companies OR (lastname in :lastnames AND email in :email)) ORDER BY CreatedDate];
        List<Lead> tmpLeads = [SELECT DoNotCall, HasOptedOutOfFax, HasOptedOutOfEmail, CurrencyIsoCode, OwnerId, EmailBouncedReason, EmailBouncedDate, IsUnreadByOwner, AnnualRevenue, City, Company, Country, Description, Email, Jigsaw, NumberOfEmployees, FirstName, Industry, LastName, LeadSource, MasterRecordId, MobilePhone, Phone, Rating, Salutation, State, Status, Street, Title, Website, PostalCode, Fax FROM Lead  WHERE Id NOT IN :all_leads_id AND isConverted = false AND (NOT LeadSource LIKE 'SFDC-%') AND (Company in :companies AND lastname in :lastnames) ORDER BY CreatedDate];

        system.debug('QUERY OUTPUT - ' + tmpLeads);

        List<ID> master_leads_id = new List<ID>();

        for(Lead lead : uniq_leads.keyset())
        {
            system.debug('To Check for - ' + lead.company);
            Integer merge_count = 0;
            Lead master_lead = null;
            List<Lead> existing_lead = new List<Lead> ();
            List<Lead> leads_to_merge = new List<Lead> ();
            //List<Lead> found_leads = new List<Lead> ();

            String lead_website, tmp_website;
            String lead_email, tmp_email;
            String lead_str, tmp_str;

            if(tmpLeads.size() > 0)
            {
                system.debug('if tmpLeads.size() - ' + tmpLeads.size());
                for(Lead tmp : tmpLeads)
                {
/*
                    system.debug('lead.website - ' + lead.website);
                    system.debug('tmp.website - ' + tmp.website);
                    system.debug('lead.email - ' + lead.email);
                    system.debug('tmp.email - ' + tmp.email);
                    system.debug('');
*/
//                    if((lead.company == tmp.company) || (lead.lastname == tmp.lastname && lead.email == tmp.email))
                    if(lead.company == tmp.company && lead.lastname == tmp.lastname && lead.firstname == tmp.firstname && (lead.email == tmp.email || lead.phone == tmp.phone))
                    {
                        existing_lead.add(tmp);
                    }
                }

                if(existing_lead.size() > 0)
                {
                    master_lead = existing_lead.remove(0);

                    existing_lead.add(lead);
                    for(Lead tmp : existing_lead)
                    {
/*
                        system.debug('lead.website - ' + lead.website);
                        system.debug('tmp.website - ' + tmp.website);
                        system.debug('lead.email - ' + lead.email);
                        system.debug('tmp.email - ' + tmp.email);
                        system.debug('');
*/
                        for(String field : leadupdtMap.keyset())
                        {//RB
                            if((master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && tmp.get(field) != null)
                            {
                                checkDuplicateLeadsClass.isMergedExecuted = true;
/*
                                system.debug('master_lead.id - ' + master_lead.id);
                                system.debug('tmp.id - ' + tmp.id);
                                system.debug('field - ' + field);
                                system.debug('master_lead.get(field) - ' + master_lead.get(field));
                                system.debug('tmp.get(field) - ' + tmp.get(field));
*/
                                master_lead.put(field, tmp.get(field));
                            }
                        }
                        lead_merged_to_master.put(tmp, master_lead);
                    }
                    uniq_leads.remove(lead);
                }
            }
            else
            {
                system.debug('else tmpLeads.size() - ' + tmpLeads.size());
                checkDuplicateLeadsClass.isMergedExecuted = true;
            }

/*
//            existing_lead = found_leads.deepClone(true);

            //existing_lead = [SELECT ownerid, annualrevenue, bottomline__creditsafecompanytype__c, bottomline__creditsafelastrefreshed__c, bottomline__creditsafelimit__c, bottomline__creditsafescore__c, bottomline__creditsafescoredescription__c, city, company, country, crm_product_used__c, date_to_book_demo__c, description, donotcall, email, emailbounceddate, emailbouncedreason, fax, firstname, hasoptedoutofemail, hasoptedoutoffax, industry, lastname, lead_type__c, leadsource, lid__linkedin_company_id__c, lid__linkedin_member_token__c, masterrecordid, mobilephone, next_steps_to_be_taken__c, numberofemployees, phone, postalcode, rating, salutation, state, status, street, time_to_book_demo__c,  title, website FROM Lead WHERE Id NOT IN :all_leads_id AND isConverted = false AND ( Company = :lead.company OR Website = :Website OR Email LIKE :EmailToWebsite) ORDER BY CreatedDate].deepClone(true);

            system.debug('Existing Lead - ' + ' ' + existing_lead.size() + ' ' + existing_lead);

            if(existing_lead.size() > 0)
            {
                //master_lead = existing_lead.remove(0);
                system.debug('Master Lead - ' + master_lead);

                for(Lead lead_exist : existing_lead)
                {
                    system.debug('Lead Exist - ' + ' ' + lead_exist);

                    for(String field : leadupdtMap.keyset())
                    {//RB

                        //if((master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead_exist.get(field) != null)
                        //{
                            //master_lead.put(field, lead.get(field));
                        //}

                        if((lead.get(field) == null || lead.lastname.touppercase().contains('PROVIDE')) && lead_exist.get(field) != null)
                        {
                            lead.put(field, lead_exist.get(field));
                        }

                    }
                    //leads_to_merge.add(lead_exist);
                    //lead_merged_to_master.put(lead_exist, lead);
                    //uniq_leads.remove(lead);

                    if(merge_count < 1)
                    {
                        system.debug('Inside merge IF');
//                        for(String field : leadMap.keyset())
                        for(String field : leadupdtMap.keyset())
                        {//RB
                            //if(leadupdtMap.get(field) == true && (master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead_exist.get(field) != null)
                            //if(leadMap.get(field).getDescribe().isUpdateable() == true && (master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead_exist.get(field) != null)
                            if((master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead_exist.get(field) != null)
                            {
                                master_lead.put(field, lead.get(field));
                            }
                        }
                        leads_to_merge.add(lead_exist);
                        lead_merged_to_master.put(lead_exist, master_lead);
                        uniq_leads.remove(lead);
                        merge_count++;
                    }
                    else
                    {
                        system.debug('FIRST MERGE');
                        merge_count = 0;
                        checkDuplicateLeadsClass.isMergedExecuted = true;
                        leads_to_merge.add(lead_exist);
                        lead_merged_to_master.put(lead_exist, master_lead);
                        uniq_leads.remove(lead);
                        system.debug('master_lead - ' + master_lead);
                        system.debug('leads_to_merge - ' + leads_to_merge);

                        merge master_lead leads_to_merge;
                        leads_to_merge.clear();
                    }

                }

                if(leads_to_merge.size() > 0)
                {
                    system.debug('SECOND MERGE');
                    merge_count = 0;
                    checkDuplicateLeadsClass.isMergedExecuted = true;
                    system.debug('master_lead - ' + master_lead);
                    system.debug('leads_to_merge - ' + leads_to_merge);

                    merge master_lead leads_to_merge;
                }

            }

            if(dup_lead_from_bulk.size() > 0)
            {
                for(Lead dup_lead : dup_lead_from_bulk.keyset())
                {
                    if(lead.id == dup_lead_from_bulk.get(dup_lead).id)
                    {                    
                        dup_lead_from_bulk.remove(dup_lead);
                        dup_lead_from_bulk.put(dup_lead, master_lead);
                    }                        
                }
            }


            if(master_lead != null && lead != null)
            {
                system.debug('THIRD MERGE');
                checkDuplicateLeadsClass.isMergedExecuted = true;
               
                for(String field : leadupdtMap.keyset())
                { //RB

                    //if(leadupdtMap.get(field) == true && (master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead.get(field) != null)
                    //if(leadMap.get(field).getDescribe().isUpdateable() == true && (master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead.get(field) != null)
                    if((master_lead.get(field) == null || master_lead.lastname.touppercase().contains('PROVIDE')) && lead.get(field) != null)
                    {
                        master_lead.put(field, lead.get(field));
                    }
                }

                for(Lead dup_lead : dup_lead_from_bulk.keyset())
                {
                    if(lead.id == dup_lead_from_bulk.get(dup_lead).id)
                    {                    
                        dup_lead_from_bulk.remove(dup_lead);
                        dup_lead_from_bulk.put(dup_lead, master_lead);
                    }                        
                }

                merge master_lead lead;
                lead_merged_to_master.put(lead, master_lead);
                uniq_leads.remove(lead);
                system.debug('master_lead - ' + master_lead);
                system.debug('leads_to_merge - ' + leads_to_merge);
            }
*/
        }

        system.debug('THIRD LOOP END');

        system.debug('uniq_leads - ' + uniq_leads.size());
        system.debug('dup_lead_from_bulk - ' + dup_lead_from_bulk.size());
        system.debug('lead_converted_to_contact - ' + lead_converted_to_contact.size());
        system.debug('lead_got_account_already - ' + lead_got_account_already.size());
        system.debug('lead_merged_to_master.size() - ' + lead_merged_to_master.size());
        system.debug('lead_merged_to_master - ' + lead_merged_to_master);

        if(uniq_leads.size() > 1 && Trigger.isInsert == true)
        {
            String msg = 'Unique Leads found in bulk upload';
            system.debug('In uniq_leads' + uniq_leads);
            checkDuplicateLeadsClass.sendMail(uniq_leads, msg);
        }

        if(dup_lead_from_bulk.size() > 0)
        {
            String msg = 'Duplicate Leads found in bulk upload';
            system.debug('In dup_lead_from_bulk' + dup_lead_from_bulk);
            checkDuplicateLeadsClass.insertTask(dup_lead_from_bulk, msg);
            checkDuplicateLeadsClass.sendMail(dup_lead_from_bulk, msg);

            List<Id> lead_ids = checkDuplicateLeadsClass.getIdsOfLeads(dup_lead_from_bulk);
            system.debug('Ids - ' + lead_ids);
            checkDuplicateLeadsClass.deleteDupilcateLeads(lead_ids);
        }

        if(lead_got_account_already.size() > 0)
        {
            String msg = 'Account/Contact already exists for Leads';
            system.debug('In lead_got_account_already - ' + lead_got_account_already);
            checkDuplicateLeadsClass.insertTask(lead_got_account_already, msg);
            checkDuplicateLeadsClass.sendMail(lead_got_account_already, msg);

            List<Id> lead_ids = checkDuplicateLeadsClass.getIdsOfLeads(lead_got_account_already);
            system.debug('Ids - ' + lead_ids);        
            checkDuplicateLeadsClass.deleteDupilcateLeads(lead_ids);
        }

        if(lead_converted_to_contact.size() > 0)
        {
            String msg = 'Leads converted to Contacts';
            system.debug('In lead_converted_to_contact - ' + lead_converted_to_contact);
            checkDuplicateLeadsClass.insertTask(lead_converted_to_contact, msg);
            checkDuplicateLeadsClass.sendMail(lead_converted_to_contact, msg);

            List<Id> lead_ids = checkDuplicateLeadsClass.getIdsOfLeads(lead_converted_to_contact);
            system.debug('Ids - ' + lead_ids);        
            checkDuplicateLeadsClass.deleteDupilcateLeads(lead_ids);
        }
        
        if(lead_merged_to_master.size() > 0)
        {
            String msg = 'Duplicate Leads found and merged';
            system.debug('In lead_merged_to_master - ' + lead_merged_to_master);
            checkDuplicateLeadsClass.insertTask(lead_merged_to_master, msg);
            checkDuplicateLeadsClass.sendMail(lead_merged_to_master, msg);

            checkDuplicateLeadsClass.updateMasterLeads(lead_merged_to_master);

            List<Id> lead_ids = checkDuplicateLeadsClass.getIdsOfLeads(lead_merged_to_master);
            system.debug('Ids - ' + lead_ids);        
            checkDuplicateLeadsClass.deleteDupilcateLeads(lead_ids);
        }

    }
    else
    {
        system.debug('Not Merge again');
        checkDuplicateLeadsClass.isMergedExecuted = false;
    }
}