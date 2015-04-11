public with sharing class OrderClassController
{
    public Opportunity objOpp {get; set;}
    public Account objAcc {get; set;}
    
    public PageReference goBack()
    {
    	string oppId = ApexPages.CurrentPage().getParameters().get('Id');
        if(oppId != null && oppId != '')
        {
        	return new PageReference('/'+oppId);
        }
    	
		return null;
    }
    
    public PageReference completeOrder()
    {
    	string oppId = ApexPages.CurrentPage().getParameters().get('Id');
        if(oppId != null && oppId != '')
        {
            objOpp = [select id, name, account.name, accountid, account.Date_of_Last_Credit_Check__c,
            			account.Request_Credit_Check__c, Credit_Check_Completed__c,
            			account.Perform_Auto_Credit_Check__c, account.Business_Type__c,
            			Order_Number__c, Order_Docusigned__c, Order_Processed__c,
            			Conga_Workflow_Trigger__c, OwnerId, Opportunity_contact__r.Email ,
            			Opportunity_Contact__c
            			from Opportunity where Id =: oppId limit 1];
           
            string orderNumber = objOpp.Order_Number__c;
            
            Task t = new Task();
            t.WhatId = oppId;
            t.OwnerId = objOpp.OwnerId;
            t.Status = 'Completed';
            t.Subject = 'Order Provision Complete';
            t.ActivityDate = datetime.now().date();
            t.Description = 'Order # "'+orderNumber+'" has been completed by ' + UserInfo.getName() + ' on '+System.now().format('dd-MM-yyyy hh:mm:ss a')+'.';
            
   			objOpp.Next_Steps__c='Customer - Provisioned'; 
   			objOpp.StageName = 'Closed Won'; 
            update objOpp;
            
            Database.DMLOptions dmlo = new Database.DMLOptions();
	        dmlo.EmailHeader.triggerUserEmail = true;
	        database.insert(t, dmlo); 
	        
	        return new PageReference('/'+oppId);
        }
    	return null;    	
    }
    
    public PageReference cancelOrder()
    {
    	string oppId = ApexPages.CurrentPage().getParameters().get('Id');
        if(oppId != null && oppId != '')
        {
            objOpp = [select id, name, account.name, accountid, account.Date_of_Last_Credit_Check__c,
            			account.Request_Credit_Check__c, Credit_Check_Completed__c,
            			account.Perform_Auto_Credit_Check__c, account.Business_Type__c,
            			Order_Number__c, Order_Docusigned__c, Order_Processed__c,
            			Conga_Workflow_Trigger__c, OwnerId, Opportunity_contact__r.Email,
            			Opportunity_Contact__c, Owner.Name, Owner.Email, Owner.Phone,
            			Opportunity_contact__r.Name
            			from Opportunity where Id =: oppId limit 1];
           
            string orderNumber = objOpp.Order_Number__c;
            
            if(objOpp.Conga_Workflow_Trigger__c && objOpp.Order_Docusigned__c)
            {
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'This order cannot be cancelled because it has already been accepted and signed by the customer.');
            	ApexPages.addMessage(myMsg);
            	return null;
            }
            
            Task t = new Task();
            t.WhatId = oppId;
            t.OwnerId = objOpp.OwnerId;
            t.Status = 'Not Started';
            t.Subject = 'Order Cancelled';
            t.ActivityDate = datetime.now().date();
            t.Description = 'Order # "'+orderNumber+'" has been cancelled by ' + UserInfo.getName() + ' @ '+System.now().format('dd-MM-yyyy hh:mm:ss a')+'. Please log the reason for order cancellation on the order record.';
            
            boolean doVoid = false;
            if(objOpp.Conga_Workflow_Trigger__c)
            {
            	doVoid = true;
            }
            
            objOpp.Order_Number__c=null; 
   			objOpp.Order_Docusigned__c=false;  
   			objOpp.Conga_Workflow_Trigger__c=false;  
   			objOpp.Credit_Check_Completed__c=false;  
   			objOpp.Order_Check_Form_Completed__c=false;  
   			objOpp.Order_Processed__c=false;  
   			objOpp.Next_Steps__c='Customer - Order Cancelled';
   			objOpp.StageName = 'Closed Cancelled';  
   			objOpp.CloseDate = Datetime.now().date();
            update objOpp;
            
            if(doVoid)
            {
            	//void envelope
				DocusignConnector.doVoidEnvelope(oppId, orderNumber, objOpp.OwnerId);
            }
            
            List<Order_Check_Form__c> ocf = [select id from Order_Check_Form__c 
            									where Opportunity__c =: oppId];
            if(ocf.size() > 0)
            	delete ocf;
            
            
            string emailBody = 'Hi '+objOpp.Opportunity_contact__r.Name+
							 	',<br /><br />Order # '+orderNumber+
			                 	' has been cancelled. Please contact your account manager for further details.<br /><br />'+
			                	objOpp.Owner.Name+'<br />SYNETY Group plc<br /><br />'+
			                	'Email: '+objOpp.Owner.Email+'<br />';
			if(objOpp.Owner.Phone != null)
				emailBody += 'Phone: '+objOpp.Owner.Phone+'<br /><br />SMARTER COMMUNICATIONS';
			else
				emailBody += '<br />SMARTER COMMUNICATIONS';
			                	
            OrgWideEmailAddress salesAdd = [SELECT id, Address FROM OrgWideEmailAddress where address = 'sales@synety.com'];
             
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {objOpp.Opportunity_Contact__r.Email}; 
			//mail.setCCAddresses(new String[] {'mohsin.raza@synety.com'} );
			mail.setOrgWideEmailAddressId(salesAdd.Id);
			mail.setReplyTo(objOpp.Owner.Email);
			mail.setSubject('Current Order Cancelled');
			mail.setBccSender(false);
			mail.setTargetObjectId(objOpp.Opportunity_Contact__c);
			mail.setWhatId(oppId);
			mail.setSaveAsActivity(true);
			mail.setHtmlBody(emailBody);
			mail.setUseSignature(false);
			
			// Send the email you have created.
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


            Database.DMLOptions dmlo = new Database.DMLOptions();
	        dmlo.EmailHeader.triggerUserEmail = true;
	        database.insert(t, dmlo); 
	        
	        return new PageReference('/'+oppId);
        }
    	return null;    	
    }
    
    public PageReference processOrder()
    {
        string oppId = ApexPages.CurrentPage().getParameters().get('Id');
        if(oppId != null && oppId != '')
        {
            objOpp = [select id, name, account.name, accountid, account.Date_of_Last_Credit_Check__c,
            			account.Request_Credit_Check__c, Credit_Check_Completed__c,
            			account.Perform_Auto_Credit_Check__c, account.Business_Type__c, platform__c 
            			from Opportunity where Id =: oppId limit 1];
            
            string accountName = objOpp.Account.Name;
            string accountId = objOpp.AccountId;
            string newOrderNumber = Utility.getNextOrderNumber(accountName, accountId);
            
            OpportunityContactRole objOCR = [Select ContactId from OpportunityContactRole 
                                            where OpportunityId=: oppId and IsPrimary = true
                                            limit 1];
       		
       		if(objOpp.Account.Date_of_Last_Credit_Check__c != null &&
       		 	objOpp.Account.Date_of_Last_Credit_Check__c >= system.now().addMonths(-2))
       		 	{
       		 		objOpp.Credit_Check_Completed__c = true;
       		 	}
       		 	else
       		 	{
       		 		objOpp.Credit_Check_Completed__c = false;
       		 		Account acc = objOpp.Account;
       		 		
       		 		if(acc.Business_Type__c == 'International Business (Inc)' ||
       		 			acc.Business_Type__c == 'Sole Trader / Partership')
   		 			{
   		 				acc.Perform_Auto_Credit_Check__c = false;
   		 				acc.Request_Credit_Check__c = true;
   		 			}
   		 			else
   		 			{
   		 				acc.Perform_Auto_Credit_Check__c = true;
   		 			}
   		 			
       		 		update acc;
       		 	}
            objOpp.Next_Steps__c= 'Customer - awaiting network check form completion';
        	if(objOpp.Platform__c == 'US')
        	{
        		objOpp.Platform_Init__c = 'US';
        	}
        	else
        	{
        		objOpp.Platform_Init__c = 'UK';
        	}

            objOpp.Opportunity_Contact__c = objOCR.ContactId;
            objOpp.Order_Number__c = newOrderNumber;
            objOpp.Order_Processed__c = true;
            update objOpp;
            
            Task t = new Task();
            t.WhatId = oppId;
            t.OwnerId = UserInfo.getUserId();
            t.Status = 'Completed';
            t.Subject = 'Order Processed';
            t.Description = 'Order for opportunity "'+objOpp.name+'" has been processed by ' + UserInfo.getName() + '. The new order number is ' + newOrderNumber + '. The email for the order check form has been sent to the customer. Here is the link to the form. http://synety.force.com/orders/OrderCheckForm?i='+oppId;
            t.ActivityDate = datetime.now().date();
            insert t;
            
            return new PageReference('/'+oppId);
            
        }
        
        else
        {
            return new PageReference('/home/home.jsp');
        }
    
        return null;
    }
    
    public PageReference creditCheckComplete()
    {
        string accId = ApexPages.CurrentPage().getParameters().get('Id');
        if(accId != null && accId != '')
        {
            objAcc = [select id, name from Account where Id =: accId limit 1];
	        objAcc.Request_Credit_Check__c = false;
	        update objAcc;
	        
	        processOppForAccountWaitingOnCreditCheck(accId);
	        
            return new PageReference('/'+accId);            
        }
        
        else
        {
            return new PageReference('/home/home.jsp');
        }
    
        return null;
    }
    
    public void processOppForAccountWaitingOnCreditCheck(string accId)
    {
    	
        
        List<Opportunity> lstOpps = [select id, Next_Steps__c from Opportunity 
        							where AccountId =: accId
        							and Order_Processed__c = true
        							and Credit_Check_Completed__c = false];
                                    //and Next_Steps__c = 'Customer - Order DocuSigned - Awaiting credit check'];
                                    
        if(lstOpps.size() > 0)
        {
            for(Opportunity opp: lstOpps)
            {
                //opp.Next_Steps__c = 'Customer - Credit check complete - Awaiting Provisioning';
                opp.Credit_Check_Completed__c = true;
            }
            
            update lstOpps;
        }
    }
}