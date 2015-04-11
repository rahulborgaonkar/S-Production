@isTest(seealldata=true)
private class testPortaBillingEmailHandler
{
    @isTest
    static void testFunction_1()
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        envelope.fromAddress = 'rahul.borgaonkar@synety.com';

        EmailTemplate cc_template = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate where Name = 'Confirmation of Credit Card Payment' LIMIT 1];
        system.debug('cc_template - ' + cc_template);

        List<Document> doc_l = [SELECT Body, BodyLength, Id, Name, Type, ContentType FROM Document where (Name = 'Test Invoice' or name = 'zzzNewCustomer - CloudCall Click Trial Order Form.pdf') limit 1];
        system.debug('doc_l - ' + doc_l);
        doc_l[0].name = doc_l[0].name + '.pdf';
        system.debug('doc_l - ' + doc_l[0].name);
        system.debug('doc_l - ' + doc_l[0].body);

        email.toAddresses = new String[] {'rahul.borgaonkar@synety.com'};
        email.Subject = 'Annecto UK Ltd - [ "SYNETY" ] Notice: New Invoice 2819';
        email.PlainTextBody = cc_template.body;

        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.fileName = doc_l[0].name ;
        attachment.body = doc_l[0].body;
        attachment.mimeTypeSubType = doc_l[0].ContentType;
        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment }; 

        PortaBillingEmailHandler emailProcess = new PortaBillingEmailHandler ();
        emailProcess.handleInboundEmail(email, envelope);
    }

    @isTest
    static void testFunction_2()
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        envelope.fromAddress = 'rahul.borgaonkar@synety.com';

        EmailTemplate cc_template = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate where Name = 'Confirmation of Credit Card Payment' LIMIT 1];
        system.debug('cc_template - ' + cc_template);

        List<Document> doc_l = [SELECT Body, BodyLength, Id, Name, Type, ContentType FROM Document where (Name = 'Test Invoice' or name = 'zzzNewCustomer - CloudCall Click Trial Order Form.pdf') limit 1];
        system.debug('doc_l - ' + doc_l);
        doc_l[0].name = doc_l[0].name + '.pdf';
        system.debug('doc_l - ' + doc_l[0].name);
        system.debug('doc_l - ' + doc_l[0].body);

        email.toAddresses = new String[] {'rahul.borgaonkar@synety.com'};
        email.Subject = 'Annecto Ltd - [ "SYNETY" ] Notice: New Invoice 2819';
        email.PlainTextBody = cc_template.body;

        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.fileName = doc_l[0].name ;
        attachment.body = doc_l[0].body;
        attachment.mimeTypeSubType = doc_l[0].ContentType;
        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment }; 

        PortaBillingEmailHandler emailProcess = new PortaBillingEmailHandler ();
        emailProcess.handleInboundEmail(email, envelope);
    }

    @isTest
    static void testFunction_3()
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        envelope.fromAddress = 'rahul.borgaonkar@synety.com';

        EmailTemplate cc_template = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate where Name = 'Confirmation of Credit Card Payment' LIMIT 1];
        system.debug('cc_template - ' + cc_template);

        List<Document> doc_l = [SELECT Body, BodyLength, Id, Name, Type, ContentType FROM Document where (Name = 'Test Invoice' or name = 'zzzNewCustomer - CloudCall Click Trial Order Form.pdf') limit 1];
        system.debug('doc_l - ' + doc_l);
        doc_l[0].name = doc_l[0].name + '.pdf';
        system.debug('doc_l - ' + doc_l[0].name);
        system.debug('doc_l - ' + doc_l[0].body);

        email.toAddresses = new String[] {'rahul.borgaonkar@synety.com'};
        email.Subject = 'Annecto UK Ltd - [ "SYNETY" ] Notice: New Inv 2819';
        email.PlainTextBody = cc_template.body;

        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.fileName = doc_l[0].name ;
        attachment.body = doc_l[0].body;
        attachment.mimeTypeSubType = doc_l[0].ContentType;
        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment }; 

        PortaBillingEmailHandler emailProcess = new PortaBillingEmailHandler ();
        emailProcess.handleInboundEmail(email, envelope);
    }

}