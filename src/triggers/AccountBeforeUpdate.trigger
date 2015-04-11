trigger AccountBeforeUpdate on Account (before update) 
{
    for(Account acc: Trigger.New)
    {
        if(acc.bottomline__creditSafeLastRefreshed__c != Trigger.oldMap.get(acc.Id).bottomline__creditSafeLastRefreshed__c)
        {
            acc.Date_of_Last_Credit_Check__c = acc.bottomline__creditSafeLastRefreshed__c;
            if(acc.bottomline__creditSafeLimit__c!= null)
                acc.Credit_Limit__c = double.valueof(acc.bottomline__creditSafeLimit__c.replace(',','').replace('£',''));
            else
                acc.Credit_Limit__c = null;
        }
    }
}