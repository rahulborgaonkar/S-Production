@isTest
private class testCloneWebDemoBookingPerf
{
    @isTest (SeeAllData=true)
    static void testPage1()    
    {
        PageReference pref;
        pref = new PageReference('cloneWebDemoBookingPerfPage');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        //ApexPages.Controller Controller = new ApexPages.Controller();
        cloneWebDemoBookingPerfClass WebDemoPerf = new cloneWebDemoBookingPerfClass();
        Test.startTest();
        WebDemoPerf.getMonths();
        WebDemoPerf.getBookingDetails();
        WebDemoPerf.getBarChart();
        WebDemoPerf.getLineChart();
        WebDemoPerf.getCRMBarChart();
        WebDemoPerf.getCRMPieChart();
        WebDemoPerf.getBookingSummary();
        Test.stopTest();
    }

    @isTest (SeeAllData=true)
    static void testPage2()
    {
        User usr = [select name from user where username in ('rahul.borgaonkar@synety.com.mohsintest', 'paul.mason@synety.com') LIMIT 1];
        system.debug('User - ' + usr);
        PageReference pref;
        pref = new PageReference('/apex/cloneWebDemoBookingAcc?status=In Progress&desksalesperson='+usr.name+'&tdt1=01/09/2013');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        Test.startTest();
        cloneWebDemoBookingPerfClass WebDemoPerf = new cloneWebDemoBookingPerfClass();
        WebDemoPerf.getAccountList();
        WebDemoPerf.getOpportunityList();
        Test.stopTest();
    }

    @isTest (SeeAllData=true)
    static void testPage3()
    {
        User usr = [select name from user where username in ('rahul.borgaonkar@synety.com.mohsintest', 'paul.mason@synety.com') LIMIT 1];
        system.debug('User - ' + usr);
        PageReference pref;
        pref = new PageReference('/apex/cloneWebDemoBookingOpp?status=Opportunities&desksalesperson='+usr.name+'&tdt1=01/09/2013');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        Test.startTest();
        cloneWebDemoBookingPerfClass WebDemoPerf = new cloneWebDemoBookingPerfClass();
        WebDemoPerf.getAccountList();
        WebDemoPerf.getOpportunityList();
        Test.stopTest();
    }

}