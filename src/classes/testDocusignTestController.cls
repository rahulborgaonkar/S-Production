@isTest
private class testDocusignTestController
{
    @isTest 
    static void testAction()
    {
        Date dt = Date.today();
        account acct = new account(name = 'Surashri LTD', no_of_crm_seats__c = 5);
        insert acct;
        system.debug('account - ' + acct);
        contact cnct = new contact(lastname = 'Surashri Contact', accountid = acct.id, email='rahul.borgaonkar@synety.com');
        insert cnct;
        system.debug('contact - ' + cnct);
        opportunity opp = new opportunity(name = 'Surashri Opportunity', accountid = acct.id, closedate = dt, stagename = 'Live 14 Day Trial');
        insert opp;
        system.debug('opportunity - ' + opp);
        opportunitycontactrole oppcnct = new opportunitycontactrole(contactid = cnct.id, opportunityid = opp.id, isprimary = true);
        insert oppcnct;
        system.debug('opportunitycontactrole - ' + oppcnct);

        Test.startTest();
        
        PageReference pref;
        pref = new PageReference('trialOrderStartPage');
        system.debug('pref - ' + pref);        
        pref.getParameters().put('id',opp.id);

        Test.setCurrentPage(pref);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        DocusignTestController DTC = new DocusignTestController(stdController);
        DTC.DocusignTestInit();
        DTC.close = true;
        DTC.close();
        DTC.getclose();
        Test.stopTest();
    }
}