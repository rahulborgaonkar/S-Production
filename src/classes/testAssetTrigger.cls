@isTest (SeeAllData=true)
private class testAssetTrigger
{    
    @isTest    
    static void testPage1()
    {        
        List<Product2> p = new List<Product2>([select id, name from product2 where Name = 'Polycom PSU' and currencyisocode = 'GBP' LIMIT 1]);
        system.debug('Product - ' + p);
        Asset__C a1 = new Asset__C(Product__c = p[0].id, Product_Serial_Number__c = '89890089');
        system.debug('Asset_C a1 - ' + a1);
        insert a1;
    }
}