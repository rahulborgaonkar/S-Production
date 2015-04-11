public class Utility
{
    public static OrgWideEmailAddress salesAdd = null;
    public static OrgWideEmailAddress getSalesAddressRecord()
    {
        if(salesAdd == null)
        {
            salesAdd = [SELECT id, Address FROM OrgWideEmailAddress where address = 'sales@synety.com'];            
        }
        return salesAdd;
    }
    
        
    public static User CSUser = null;
    public static User getCSUserRecord()
    {
        try 
        {
            if(CSUser == null)
            {
                CSUser = 
                        [select Id 
                        from User 
                        where UserName in ('ben.banks@synety.com','mohsin.raza@synety.com.mohsintest')
                        limit 1];
            }
        } 
        catch (Exception ex) 
        {
            System.debug('***Could not find CS user');
        }
        
        return CSUser;
    }
    
    public static User financeUser = null;
    public static User getFinanceUserRecord()
    {
        try 
        {
            if(financeUser == null)
            {
                financeUser = 
                        [select Id 
                        from User 
                        where UserRole.Name = 'Finance Manager'
                        limit 1];
/*
                financeUser = [select Id from User where username = 'ben.banks@synety.com' or username = 'ben.banks@synety.com.mohsintest' limit 1];
*/
            }
        } 
        catch (Exception ex) 
        {
            System.debug('***Could not find Finance user');
        }
        
        return financeUser;
    }
    
    public static string getNextOrderNumber(string accountName, string accountId)
    {
        string newOrderNum = '';
        List<Order_Sequence__c> lstOrdNum = [select id, Last_Number_Used__c from Order_Sequence__c
                                            where Account__c =: accountId];
                                            
        integer newNum = 0;
        
        if(lstOrdNum.size() > 0)
            newNum = Integer.valueof(lstOrdNum[0].Last_Number_Used__c);
            
        newNum = newNum + 1;
        
        string sNewNum = '';
        if(newNum < 10)
            sNewNum = '000' + newNum;
        else if(newNum < 100)
            sNewNum = '00' + newNum;
        else if(newNum < 1000)
            sNewNum = '0' + newNum;
        else
            sNewNum = '' + newNum;
        
        string accPrefix = '';    
        accountName = accountName.replace(' ','');
        if(accountName.length() < 3)
            accPrefix = accountName.toUpperCase();
        else
            accPrefix = accountName.substring(0,3).toUpperCase();
        
        for(integer a=0; a<5; a++)
        {
            integer newRandomNum = (Integer)(Math.random() * 1000);
            string sNewRandomNum = string.valueof(newRandomNum);
            if(newRandomNum < 100)
                sNewRandomNum = '0' + string.valueof(newRandomNum);
            
            newOrderNum = (accPrefix + sNewRandomNum + sNewNum);
            
            List<Opportunity> lOrderNumbers = [select id from Opportunity where Order_Number__c =: newOrderNum];
            if(lOrderNumbers.size() == 0)
            {
                a=5;
                Order_Sequence__c objOrderNum = null;
                if(lstOrdNum.size() > 0)
                    objOrderNum = lstOrdNum[0];
                else
                {
                    objOrderNum = new Order_Sequence__c();
                    objOrderNum.Account__c = accountId;
                }    
                
                objOrderNum.Last_Number_Used__c = newNum;
                
                upsert objOrderNum;
            }
            else
                newOrderNum = '';
            
        }
        
        return newOrderNum;
    }
}