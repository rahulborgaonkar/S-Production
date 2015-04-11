trigger AssetTrigger on Asset__c (before insert, before update)
{
    List<Id> prod_id = new List<Id> ();
    Map<Id, Product2> asset_prod = new Map<Id, Product2>();
    system.debug('trigger.new - ' + trigger.new);
    for(Asset__c a : trigger.new)
    {
        prod_id.add(a.product__c);
    }

    system.debug('prod_id - ' + prod_id);
    asset_prod = new Map<Id, Product2>([SELECT productcode, description FROM Product2 where id = :prod_id]);

    for(Asset__c a : trigger.new)
    {
        Id i = a.product__c;
        system.debug('asset_prod - ' + asset_prod.get(i));
        Product2 p = asset_prod.get(i);
        a.ProductCode__c = p.productcode;
        a.ProductDescription__c = p.description;
    }
}