@isTest
private class testApprovedIndexEmailHandler
{
    @isTest
    static void testFunction()
    {
        List<String> EmailId = new List<String> ();

        String mailBody = '<p>Your first name: Dr Suresh</p>';
        mailBody = mailBody + '<p>Your surname: Kumar</p>';
        mailBody = mailBody + '<p>Your Email Address: sureshchemeran@gmail.com</p>';
        mailBody = mailBody + '<p>Daytime phone number: 7886 589 069</p>';
        mailBody = mailBody + '<p>Postcode: ME14 1EW</p>';
        mailBody = mailBody + '<p>Your job role:</p>';
        mailBody = mailBody + '<p>Your company name: Marsham Street Surgery</p>';
        mailBody = mailBody + '<p>Industry:</p>';

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        envelope.fromAddress = 'rahul.borgaonkar@synety.com';

        email.toAddresses = new String[] {'approvedindexemailservice@bww5l10q5ikyirak2bzmx8x11athhg3d4thvcxn2hzol0srg1.z-p99wmaa.cs11.apex.sandbox.salesforce.com'};
        email.Subject = '[Approved Index:] New Qualified Lead for Approved Index Plus / Telephone Systems / Small Networks. Ref 661045';
        email.htmlBody = mailBody;

        ApprovedIndexEmailHandler emailProcess = new ApprovedIndexEmailHandler();
        emailProcess.handleInboundEmail(email, envelope);

    }
}