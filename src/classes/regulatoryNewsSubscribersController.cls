public class regulatoryNewsSubscribersController 
{
    public static Boolean doclose = false;    

    public Boolean getdoClose()
    {
        system.debug('getdoClose - ' + doclose);
        return doclose;
    }

    public void setdoClose(Boolean doClos)
    {
        doclose = doclos;
        system.debug('setdoClose - ' + doclose);        
    }

    public PageReference init()
    {
        system.debug('init function');
        contact cnct = [SELECT id, Regulatory_News_Subscriber__c FROM Contact where id = :ApexPages.currentPage().getParameters().get('id')];
        if(cnct.Regulatory_News_Subscriber__c == false)
        {
            doclose = true;
        }
        return null;
    }

    public PageReference confirm()
    {
        system.debug(ApexPages.currentPage().getParameters().get('id'));
        contact cnct = [SELECT id, email, name, Regulatory_News_Subscriber__c FROM Contact where id = :ApexPages.currentPage().getParameters().get('id')];
        cnct.Regulatory_News_Subscriber__c = false;
        update cnct;
        doclose = true;

		system.debug('Contact - ' + cnct);

        OrgWideEmailAddress ir = [SELECT id, displayname, address FROM OrgWideEmailAddress WHERE Address = 'ir@synety.com'];
        EmailTemplate template = [SELECT id, subject, htmlvalue, body FROM EmailTemplate WHERE Name = 'Regulatory News Subscribers Leaving Template'];

		String subject = template.subject;

		String htmlBody = template.HtmlValue;
		htmlBody = htmlBody.replace('{!Contact.Name}', cnct.name);

        list<string> toemail = new list<string> ();
        toemail.add(ir.address);
        toemail.add(cnct.email);
        
        Id cnctid = cnct.id;
        
        system.debug('Contact ID - ' + cnctid);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(ir.id);
        mail.setToAddresses(toemail);
		mail.setSubject(subject);
		mail.setHtmlBody(htmlBody);        

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}, false);
        system.debug('Messaging.SendEmailResult - ' + results);

        return null;
    }
}