public class DocusignTestController 
{
    public Boolean close = false;    
    public Id oppId;
    public DocusignTestController(ApexPages.StandardController stdController)
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

    public void DocusignTestInit()
    {
        system.debug('Inside DocusignTestController');
        List<Opportunity> opp = [select Docusign_Test_Trigger__c, opportunity_contact__c, accountId from opportunity where id = :oppId limit 1];
        system.debug('Opportunity - ' + opp);
        List<OpportunityContactRole> oppcnct = [select contactId from OpportunityContactRole where opportunityid = :oppId and IsPrimary = true limit 1];
        system.debug('OpportunityContactRole - ' + oppcnct);
        if(opp.size() > 0 && oppcnct.size() > 0)
        {
            opp[0].Docusign_Test_Trigger__c = true;
            system.debug('Opportunity - ' + opp);
            update opp;
        }
    }
}