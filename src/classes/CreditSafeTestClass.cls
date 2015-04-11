@isTest
private class CreditSafeTestClass {

    static testMethod void myUnitTest() 
    {
        CreditSafeService.CreditsafeServicesSoap o = new CreditSafeService.CreditsafeServicesSoap();
        CreditSafeService.GetData_element o1 = new CreditSafeService.GetData_element();
        CreditSafeService.GetDataTest_element o2 = new CreditSafeService.GetDataTest_element();
        CreditSafeService.ClearCacheResponse_element o3 = new CreditSafeService.ClearCacheResponse_element();
        CreditSafeService.GetDataResponse_element o4 = new CreditSafeService.GetDataResponse_element();
        CreditSafeService.ClearCache_element o5 = new CreditSafeService.ClearCache_element();
        CreditSafeService.GetDataTestResponse_element o6 = new CreditSafeService.GetDataTestResponse_element();
        
        
     	o.ClearCache();
     	o.GetData('');
     	o.GetDataTest('');   
    }
}