trigger UpdateOrderFormCheckComplete on Opp_Order_Check_List__c (after insert) 
{
    for(Opp_Order_Check_List__c o: Trigger.New)
    {
        Opportunity ObjOpp = [select id, Next_Steps__c, Platform__c,
        						account.Company_Registration_No__c, account.Business_Type__c 
        						from Opportunity where Id =: o.Name limit 1];
        
        if(ObjOpp.account.Company_Registration_No__c == null || 
        	ObjOpp.account.Company_Registration_No__c == '' ||
        	ObjOpp.account.Business_Type__c == null ||
        	ObjOpp.account.Business_Type__c == '')
        {
        	Account acc = objOpp.Account;
        	List<Order_Check_Form__c> lst_checkForm = [SELECT Company_Registration_No__c, Business_Type__c
                        						FROM Order_Check_Form__c 
                        						where Opportunity__c =: o.Name];
            
            Order_Check_Form__c checkForm = new Order_Check_Form__c();  
            if(lst_checkForm.size() > 0)
            	checkForm = lst_checkForm[0];
            	
            acc.Company_Registration_No__c = checkForm.Company_Registration_No__c;
            acc.Business_Type__c = checkForm.Business_Type__c;
            update acc;
        }
        
        objOpp.Next_Steps__c = 'Customer - Network checks completed - Awaiting DocuSign';
        objOpp.Order_Check_Form_Completed__c = true;
        objOpp.Conga_Workflow_Trigger__c = true;
        if(objOpp.Platform__c == 'US')
        {
        	objOpp.Platform_Text__c = 'US';
        }
        else
        {
        	objOpp.Platform_Text__c = 'UK';
        }

        update objOpp;
        
        //delete o;
    }
}