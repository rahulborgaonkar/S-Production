public class trialOrderStartController
{
    public Boolean close = false;    
    public Id oppId;
    public trialOrderStartController(ApexPages.StandardController stdController)
    {
        system.debug('In Constructor');
        oppId = ApexPages.currentPage().getParameters().get('id');
    }

    public Boolean getClose()
    {
        system.debug('getdoClose - ' + close);
        return close;
    }

    public PageReference close()
    {
        close = true;
        return null;
    }

    public void trialOrderInit()
    {
        system.debug('Inside trialOrderStartController');
        List<Opportunity> opp = [select trial_order_workflow_trigger__c, opportunity_contact__c, accountId from opportunity where id = :oppId limit 1];
        system.debug('Opportunity - ' + opp);
        List<OpportunityContactRole> oppcnct = [select contactId from OpportunityContactRole where opportunityid = :oppId and IsPrimary = true limit 1];
        system.debug('OpportunityContactRole - ' + oppcnct);
        if(opp.size() > 0 && oppcnct.size() > 0)
        {
            opp[0].opportunity_contact__c = oppcnct[0].Contactid;
            update opp;

            EmailTemplate et = [SELECT Id, Name FROM EmailTemplate where name = 'CRM Trial - thank-you-for-applying'];
            system.debug('EmailTemplate - ' + et);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
            mail.setTargetObjectId(oppcnct[0].contactid);// Who you are sending the email to
            mail.setTemplateId(et.id);// The email template ID used for the email
            mail.setWhatId(opp[0].id);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSenderDisplayName('SYNETY PLC');
            mail.setSaveAsActivity(false);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('Before Update Opportunity - ' + opp);
            opp[0].trial_order_workflow_trigger__c = true;
            opp[0].stagename = 'Live 14 Day Trial';
            system.debug('Opportunity - ' + opp);
            update opp;
        }
    }
}