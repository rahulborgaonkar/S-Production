@isTest
private class testWebDemoBookingPerformance
{
    @isTest (SeeAllData=true)
    static void testPage1()    
    {
        PageReference pref;
        pref = new PageReference('WebDemoBookingPerformancePage');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        //ApexPages.Controller Controller = new ApexPages.Controller();
        WebDemoBookingPerformanceClass WebDemoPerf = new WebDemoBookingPerformanceClass();
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
        pref = new PageReference('/apex/webDemoBookingAccounts?status=In Progress&desksalesperson='+usr.name+'&tdt1=01/09/2013&tdt2=');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        Test.startTest();
        WebDemoBookingPerformanceClass WebDemoPerf = new WebDemoBookingPerformanceClass();
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
        pref = new PageReference('/apex/webDemoBookingOpportunities?status=Opportunities&desksalesperson='+usr.name+'&tdt1=01/09/2013&tdt2=');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        Test.startTest();
        WebDemoBookingPerformanceClass WebDemoPerf = new WebDemoBookingPerformanceClass();
        WebDemoPerf.getAccountList();
        WebDemoPerf.getOpportunityList();
        Test.stopTest();
    }

}