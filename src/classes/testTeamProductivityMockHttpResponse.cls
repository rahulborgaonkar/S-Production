@isTest
global class testTeamProductivityMockHttpResponse implements HttpCalloutMock 
{
    // Implement this interface method    
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();

        system.debug('InSide testTeamProductivityMockHttpResponse respond');
        system.debug('HTTPRequest req - ' + req);

        res.setHeader('Content-Type', 'application/json');


        if(req.getendpoint().contains('Accounts') == true)
        {
            system.debug('HTTPRequest req Accounts - ' + req.getendpoint());
            //System.assertEquals('https://api.synety.com/customers/mark.seemann@synety.com/Accounts', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody('[{"AccountNumber":"441164244026","Password":"Casper00","i_account":4541,"i_customer":2,"CanDownloadRecordings":true,"CanDownloadAllRecordings":false,"Login":null,"Firstname":"Mark","Surname":"Seemann","NotificationToken":null,"Departments":null},{"AccountNumber":"441164244011","Password":"t93r15pw35qkvlmz","i_account":529,"i_customer":2,"CanDownloadRecordings":true,"CanDownloadAllRecordings":false,"Login":"441164244011","Firstname":"Hannah","Surname":"Weinberg","NotificationToken":null,"Departments":null}]');
        }
        else if(req.getendpoint().contains('CallStatistics') == true)
        {
            system.debug('HTTPRequest req CallStatistics - ' + req.getendpoint());
            //System.assertEquals('https://api.synety.com/customers/mark.seemann@synety.com/CallStatistics?from=2013-08-01&to=2013-08-31', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody('[{"i_account":529,"NumberOfCalls":860,"TotalCallTime":198602,"NumberOfMissedCalls":272,"TotalCharges":16.22000},{"i_account":4541,"NumberOfCalls":13,"TotalCallTime":826,"NumberOfMissedCalls":14,"TotalCharges":0.06000}]');
        }
        else if(req.getendpoint().contains('CallCategoriesAnalysis') == true)
        {
            system.debug('HTTPRequest req CallCategoriesAnalysis - ' + req.getendpoint());
            //System.assertEquals('https://api.synety.com/customers/mark.seemann@synety.com/CallCategoriesAnalysis?from=2013-08-01&to=2013-08-31', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody('[{"TotalCharges":0.06000,"CategoryId":-1,"Direction":0,"i_account":4541,"NumberOfCalls":8,"TotalDuration":507},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":1,"i_account":4541,"NumberOfCalls":4,"TotalDuration":316},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":2,"i_account":4541,"NumberOfCalls":1,"TotalDuration":3},{"TotalCharges":13.38000,"CategoryId":-1,"Direction":0,"i_account":529,"NumberOfCalls":362,"TotalDuration":96048},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":1,"i_account":529,"NumberOfCalls":184,"TotalDuration":34585},{"TotalCharges":0.00000,"CategoryId":-1,"Direction":2,"i_account":529,"NumberOfCalls":114,"TotalDuration":6187},{"TotalCharges":0.00000,"CategoryId":1,"Direction":0,"i_account":529,"NumberOfCalls":7,"TotalDuration":1684},{"TotalCharges":0.00000,"CategoryId":1,"Direction":1,"i_account":529,"NumberOfCalls":3,"TotalDuration":191},{"TotalCharges":0.00000,"CategoryId":2,"Direction":0,"i_account":529,"NumberOfCalls":22,"TotalDuration":7124},{"TotalCharges":0.00000,"CategoryId":2,"Direction":1,"i_account":529,"NumberOfCalls":2,"TotalDuration":13},{"TotalCharges":0.00000,"CategoryId":3,"Direction":0,"i_account":529,"NumberOfCalls":10,"TotalDuration":2338},{"TotalCharges":0.00000,"CategoryId":20,"Direction":0,"i_account":529,"NumberOfCalls":29,"TotalDuration":19028},{"TotalCharges":0.00000,"CategoryId":20,"Direction":1,"i_account":529,"NumberOfCalls":1,"TotalDuration":7},{"TotalCharges":0.00000,"CategoryId":20,"Direction":2,"i_account":529,"NumberOfCalls":1,"TotalDuration":3},{"TotalCharges":2.84000,"CategoryId":68,"Direction":0,"i_account":529,"NumberOfCalls":104,"TotalDuration":30012},{"TotalCharges":0.00000,"CategoryId":68,"Direction":2,"i_account":529,"NumberOfCalls":1,"TotalDuration":459},{"TotalCharges":0.00000,"CategoryId":69,"Direction":0,"i_account":529,"NumberOfCalls":1,"TotalDuration":329},{"TotalCharges":0.00000,"CategoryId":88,"Direction":0,"i_account":529,"NumberOfCalls":7,"TotalDuration":211},{"TotalCharges":0.00000,"CategoryId":101,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":12},{"TotalCharges":0.00000,"CategoryId":118,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":51},{"TotalCharges":0.00000,"CategoryId":120,"Direction":0,"i_account":529,"NumberOfCalls":6,"TotalDuration":274},{"TotalCharges":0.00000,"CategoryId":140,"Direction":0,"i_account":529,"NumberOfCalls":2,"TotalDuration":46}]');
        }

        res.setStatusCode(200);
        return res;
    }
}