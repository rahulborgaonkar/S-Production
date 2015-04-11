global class PortaBillingEmailHandler implements Messaging.InboundEmailHandler 
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        if(email.subject.contains('Credit Card Payment') || email.subject.contains('Notice: New Invoice') || email.subject.contains('A payment has been posted to your account'))
        {
            system.debug('Email toAddress - ' + email.toAddresses);
            system.debug('Email ccAddress - ' + email.ccAddresses);
            system.debug('envelope - ' + envelope);
            
            List<String> sub = email.subject.split('-');
            system.debug('Subject - ' + sub[0].remove('Sandbox:').removeStart(' ').removeEnd(' '));
            String sub_cus = sub[0].remove('Sandbox:').removeStart(' ').removeEnd(' ');

            List<API_Customer__c> api_cust = [SELECT i_customer__c, Name, Login__c, Email__c, CompanyName__c, CreationDate__c  FROM API_Customer__c where name = :sub_cus limit 1];
            List<Contact> cnct = new List<Contact> ();

            PortaBilling_Email_History__c pbeh = new PortaBilling_Email_History__c();
            if(api_cust.size() == 1)
            {
                system.debug('List<API_Customer__c> - ' + api_cust);
                pbeh.i_customer__c = api_cust[0].i_customer__c;
                cnct = [SELECT id, accountid FROM contact where Account.i_customer__c = :api_cust[0].i_customer__c.format().remove(',') and email = :api_cust[0].email__c limit 1];
            }

            if(cnct.size() == 1)
            {
                system.debug('Insert ic_Account Id');
                system.debug('List<Contact> - ' + cnct);
                pbeh.account__c = cnct[0].accountid;
            }
            else
            {
                system.debug('Insert without Account Id');
                pbeh.Notes__c = 'i_customer or Account not found for ' + sub_cus;
            }

            pbeh.Email_To_Address__c = email.toAddresses[0];
            pbeh.Name = email.subject;
            pbeh.Email_Content__c = email.plainTextBody;
            insert pbeh;

            if(email.binaryAttachments != null)
            {
                Attachment attach=new Attachment();  
                attach.Body = email.binaryAttachments[0].body;  
                attach.Body = email.binaryAttachments[0].body;  
                attach.Name = email.binaryAttachments[0].filename;
                attach.ContentType = email.binaryAttachments[0].mimeTypeSubType;
                attach.ParentID = pbeh.id;
                insert attach;
            }

        }
        else
        {
            system.debug('Error - Mail not found');
        }

        return result;
    }
}