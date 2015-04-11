global class ApprovedIndexEmailHandler implements Messaging.InboundEmailHandler 
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        //system.debug('Messaging.InboundEmailResult result - ' + result);
        system.debug('Messaging.InboundEmail email - ' + email);
        system.debug('Messaging.InboundEnvelope envelope - ' + envelope.fromAddress);

        XmlStreamReader xmlRec = new XmlStreamReader(email.htmlBody);
        List<String> listXmlRec = email.htmlBody.split('<p>');
        system.debug('List<String> listXmlRec.size() - ' + listXmlRec.size());

//info@email.approvedindex.co.uk
        if((email.fromAddress == 'rahul.borgaonkar@synety.com' || email.fromAddress == 'info@email.approvedindex.co.uk') && listXmlRec.size() > 0)
        {
            Account ai_acct = new Account ();
            ai_acct.type = 'Customer Prospect';
            ai_acct.name = 'Account Converted from Approved Index ' + String.valueof(DateTime.Now());
            ai_acct.currencyisocode = 'GBP';
            ai_acct.Lead_Source__c = 'Approved Index';
            ai_acct.No_of_CRM_Seats__c = 0;

            Contact ai_cnct = new Contact ();
            ai_cnct.lastname = 'Contact Converted from Approved Index ' + String.valueof(DateTime.Now());
            ai_cnct.currencyisocode = 'GBP';
        
            for(String s : listXmlRec)
            {
                system.debug('String s - ' + s.replaceAll('<[^<]*>',''));
                s = s.replaceAll('<[^<]*>','');
                if(s.contains('Your first name:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_cnct.firstname = sl[1];
                    }
                }
                else if(s.contains('Your surname:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_cnct.lastname = sl[1];
                    }
                }
                else if(s.contains('Your Email Address:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_cnct.email = sl[1];
                    }
                }
                else if(s.contains('Daytime phone number:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_cnct.phone = sl[1];
                        ai_acct.phone = sl[1];
                    }

                }
                else if(s.contains('Postcode:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_cnct.mailingpostalcode = sl[1];
                        ai_acct.billingpostalcode = sl[1];
                    }
                }
                else if(s.contains('Your job role:'))
                {
                    List<String> sl = s.split(':');
                    system.debug('sl - ' + sl);
                    system.debug('sl.size() - ' + sl.size());
                    if(sl.size() >= 2)
                    {
                        ai_cnct.title = sl[1];
                    }
                }
                else if(s.contains('Your company name:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_acct.name = sl[1];
                    }
                }
                else if(s.contains('Industry:'))
                {
                    List<String> sl = s.split(':');
                    if(sl.size() >= 2)
                    {
                        ai_acct.industry= sl[1];
                    }
                }
            }

            system.debug('plain text body - ' + email.plainTextBody);

            if(String.isNotBlank(email.plainTextBody))
            {
                ai_acct.description = email.plainTextBody.substring(email.plainTextBody.indexof('Approved Index Notes:') + 'Approved Index Notes:'.length());
            }

            if((string.isnotblank(ai_acct.name) == true && ai_acct.name.contains('Account Converted from Approved Index') != true) || (string.isnotblank(ai_cnct.name) == true && ai_cnct.name.contains('Contact Converted from Approved Index') != true))
            {
                system.debug('insert ai_acct - ' + ai_acct);
                insert ai_acct;
                ai_cnct.accountid = ai_acct.id;
                insert ai_cnct;
        
                List<String> EmailId = new List<String> ();
                EmailId.add('jay.roberts@synety.com');
                EmailId.add('paul.mason@synety.com');
                EmailId.add('rahul.borgaonkar@synety.com');
        
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSenderDisplayName('Synety PLC');
                mail.setToAddresses(new List<String>(EmailId));
                mail.setSubject('Approved Index Lead conversion details');
                String mailBody = 'Hi\n\nApproved Index Lead is converted to Account\n\nPlease use link to get the Account details\n\n';
                mailBody = mailBody + 'https://na11.salesforce.com/'+ai_acct.id;
                mailBody = mailBody + '\n\nThanks';
                mail.setPlainTextBody(mailBody);

                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                system.debug('Mail Result - ' + results);
            }

        }
        return result;
    }
}