@isTest (SeeAllData=true)
private class testTeamProductivity
{
    @isTest 
    static void testCallout_1()
    {
        // Set mock callout class 
        system.debug('InSide testTeamProductivity testCallout(');
        Test.setMock(HttpCalloutMock.class, new testTeamProductivityMockHttpResponse());
        teamProductivityClass tpc = new teamProductivityClass();
        HttpResponse res = tpc.getAllSynetyAccountCallData('8 2013');
        system.debug('Response - ' + res);

        system.debug('res.getHeaderKeys - ' + res.getHeaderKeys());
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        String actualValue = res.getBody();
        String expectedValue = '[{"TotalCharges":0.06000,"CategoryId":-1,"Direction":0,"i_account":4541,"NumberOfCalls":8,"TotalDuration":507},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":1,"i_account":4541,"NumberOfCalls":4,"TotalDuration":316},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":2,"i_account":4541,"NumberOfCalls":1,"TotalDuration":3},{"TotalCharges":13.38000,"CategoryId":-1,"Direction":0,"i_account":529,"NumberOfCalls":362,"TotalDuration":96048},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":1,"i_account":529,"NumberOfCalls":184,"TotalDuration":34585},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":2,"i_account":529,"NumberOfCalls":114,"TotalDuration":6187},{"TotalCharges":0.00000,"CategoryId":1,"Direction":0,"i_account":529,"NumberOfCalls":7,"TotalDuration":1684},{"TotalCharges":0.00000,"CategoryId":1,"Direction":1,"i_account":529,"NumberOfCalls":3,"TotalDuration":191},{"TotalCharges":0.00000,"CategoryId":2,"Direction":0,"i_account":529,"NumberOfCalls":22,"TotalDuration":7124},{"TotalCharges":0.00000,"CategoryId":2,"Direction":1,"i_account":529,"NumberOfCalls":2,"TotalDuration":13},{"TotalCharges":0.00000,"CategoryId":3,"Direction":0,"i_account":529,"NumberOfCalls":10,"TotalDuration":2338},{"TotalCharges":0.00000,"CategoryId":20,"Direction":0,"i_account":529,"NumberOfCalls":29,"TotalDuration":19028},{"TotalCharges":0.00000,"CategoryId":20,"Direction":1,"i_account":529,"NumberOfCalls":1,"TotalDuration":7},{"TotalCharges":0.00000,"CategoryId":20,"Direction":2,"i_account":529,"NumberOfCalls":1,"TotalDuration":3},{"TotalCharges":2.84000,"CategoryId":68,"Direction":0,"i_account":529,"NumberOfCalls":104,"TotalDuration":30012},{"TotalCharges":0.00000,"CategoryId":68,"Direction":2,"i_account":529,"NumberOfCalls":1,"TotalDuration":459},{"TotalCharges":0.00000,"CategoryId":69,"Direction":0,"i_account":529,"NumberOfCalls":1,"TotalDuration":329},{"TotalCharges":0.00000,"CategoryId":88,"Direction":0,"i_account":529,"NumberOfCalls":7,"TotalDuration":211},{"TotalCharges":0.00000,"CategoryId":101,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":12},{"TotalCharges":0.00000,"CategoryId":118,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":51},{"TotalCharges":0.00000,"CategoryId":120,"Direction":0,"i_account":529,"NumberOfCalls":6,"TotalDuration":274},{"TotalCharges":0.00000,"CategoryId":140,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":46}]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        PageReference pref = new PageReference('teamProductivityDashboard');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        Test.StartTest();
        teamProductivityClass teamProd = new teamProductivityClass();
        teamProd.current_department = 'Support';
        teamProd.getDepartments();
        teamProd.getMonths();
        teamProd.getChangedMonth();
        teamProd.getReportData();
        teamProd.getBarChart();
        teamProd.getEmailPieChart();
        teamProd.getTaskPieChart();
        Test.StopTest();

    }

    @isTest 
    static void testCallout_2()
    {
        // Set mock callout class 
        system.debug('InSide testTeamProductivity testCallout(');
        Test.setMock(HttpCalloutMock.class, new testTeamProductivityMockHttpResponse());
        teamProductivityClass tpc = new teamProductivityClass();
        HttpResponse res = tpc.getAllSynetyAccountCallData('8 2013');
        system.debug('Response - ' + res);

        system.debug('res.getHeaderKeys - ' + res.getHeaderKeys());
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        String actualValue = res.getBody();
        String expectedValue = '[{"TotalCharges":0.06000,"CategoryId":-1,"Direction":0,"i_account":4541,"NumberOfCalls":8,"TotalDuration":507},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":1,"i_account":4541,"NumberOfCalls":4,"TotalDuration":316},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":2,"i_account":4541,"NumberOfCalls":1,"TotalDuration":3},{"TotalCharges":13.38000,"CategoryId":-1,"Direction":0,"i_account":529,"NumberOfCalls":362,"TotalDuration":96048},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":1,"i_account":529,"NumberOfCalls":184,"TotalDuration":34585},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":2,"i_account":529,"NumberOfCalls":114,"TotalDuration":6187},{"TotalCharges":0.00000,"CategoryId":1,"Direction":0,"i_account":529,"NumberOfCalls":7,"TotalDuration":1684},{"TotalCharges":0.00000,"CategoryId":1,"Direction":1,"i_account":529,"NumberOfCalls":3,"TotalDuration":191},{"TotalCharges":0.00000,"CategoryId":2,"Direction":0,"i_account":529,"NumberOfCalls":22,"TotalDuration":7124},{"TotalCharges":0.00000,"CategoryId":2,"Direction":1,"i_account":529,"NumberOfCalls":2,"TotalDuration":13},{"TotalCharges":0.00000,"CategoryId":3,"Direction":0,"i_account":529,"NumberOfCalls":10,"TotalDuration":2338},{"TotalCharges":0.00000,"CategoryId":20,"Direction":0,"i_account":529,"NumberOfCalls":29,"TotalDuration":19028},{"TotalCharges":0.00000,"CategoryId":20,"Direction":1,"i_account":529,"NumberOfCalls":1,"TotalDuration":7},{"TotalCharges":0.00000,"CategoryId":20,"Direction":2,"i_account":529,"NumberOfCalls":1,"TotalDuration":3},{"TotalCharges":2.84000,"CategoryId":68,"Direction":0,"i_account":529,"NumberOfCalls":104,"TotalDuration":30012},{"TotalCharges":0.00000,"CategoryId":68,"Direction":2,"i_account":529,"NumberOfCalls":1,"TotalDuration":459},{"TotalCharges":0.00000,"CategoryId":69,"Direction":0,"i_account":529,"NumberOfCalls":1,"TotalDuration":329},{"TotalCharges":0.00000,"CategoryId":88,"Direction":0,"i_account":529,"NumberOfCalls":7,"TotalDuration":211},{"TotalCharges":0.00000,"CategoryId":101,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":12},{"TotalCharges":0.00000,"CategoryId":118,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":51},{"TotalCharges":0.00000,"CategoryId":120,"Direction":0,"i_account":529,"NumberOfCalls":6,"TotalDuration":274},{"TotalCharges":0.00000,"CategoryId":140,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":46}]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        PageReference pref = new PageReference('teamProductivityDashboard');
        system.debug('pref - ' + pref);
        Test.setCurrentPage(pref);
        Test.StartTest();
        teamProductivityClass teamProd = new teamProductivityClass();
        teamProd.old_month = '6 2013';
        teamProd.current_department = 'TeleSales';
        teamProd.getDepartments();
        teamProd.getMonths();
        teamProd.getChangedMonth();
        teamProd.getReportData();
        teamProd.getBarChart();
        teamProd.getEmailPieChart();
        teamProd.getTaskPieChart();
        Test.StopTest();
    }

}