public with sharing class TicketCustomerFeedbackController {
	
	public static Customer_Service_Rating__c calculateRating(Customer_Service_Rating__c csr)
	{
		Map<string, double> picklistRating = new Map<string, double>();
		picklistRating.put('No',0);
		picklistRating.put('Maybe',3);
		picklistRating.put('Yes',5);
		 
		double score = 0;
		double maxScore = 0;
		
		score += csr.Knowledge__c;
		maxScore += 5;
		
		score += csr.Manner__c;
		maxScore += 5;
		
		score += csr.Speed__c;
		maxScore += 5;
		
		score += picklistRating.get(csr.Recommend_SYNETY_to_others__c);
		maxScore += 5;
		
		score += picklistRating.get(csr.Handle_future_requests__c);
		maxScore += 5;
		
		csr.Overall_Rating_Score__c = score;
		csr.Rating_Score_Max__c = maxScore;
		
		return csr;
	}
	
	public boolean isCompleted{get; set;}
	public boolean isAllowed{get; set;}
    
    public List<SelectOption> getRecommend_SYNETY_to_others() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Customer_Service_Rating__c.Recommend_SYNETY_to_others__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
    public List<SelectOption> getHandle_future_requests() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select...'));
        
        Schema.DescribeFieldResult fieldResult = Customer_Service_Rating__c.Handle_future_requests__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
           
        return options;
    }
    
	public Case objCase {get; set;}
    public Customer_Service_Rating__c objFeedback {get; set;}
    public string caseId {get; set;}
    
    public void init()
    {
        isCompleted = false;
        isAllowed = true;
        caseId = ApexPages.CurrentPage().getParameters().get('i');
        if(caseId != null && caseId != '')
        {
            list<Case> lObjCase = [select id, CaseNumber, account.name, accountid, owner.name,
            							contact.Name, contactid, OwnerId, contact.AccountId
                                        from Case where Id =: caseId limit 1];
            
            if(lObjCase.size() > 0)
            {
                objCase = lObjCase[0];
                string accountName = objCase.Account.Name;
                string accountId = objCase.AccountId;
                
                list<Customer_Service_Rating__c> lstRatings = 
                        [SELECT Account__c,Case__c,Comments_or_Suggestions__c,
                        		Contact__c,CreatedDate,Handle_future_requests__c,Id,
                        		Knowledge__c,Manner__c,Name,Overall_Rating_Score_Percent__c,
                        		Overall_Rating_Score__c,Rating_Score_Max__c,
                        		Recommend_SYNETY_to_others__c,Speed__c,Ticket_Owner__c
                        	FROM Customer_Service_Rating__c 
                        	where Case__c =: caseId
                        	and Rated_By__c = 'Customer'];
                        	
                if(string.valueOf(objCase.OwnerId).startsWith('00G'))
                {
                	isCompleted = true;
                	return;
                }
					                
                if(lstRatings.size() > 0)
                {
                    isCompleted = true;
                    objFeedback = lstRatings[0];
                }
                else
                {
                    objFeedback = new Customer_Service_Rating__c(Case__c = caseId, 
                    											Name = objCase.CaseNumber,
                    											Account__c = objCase.AccountId,
                    											//Contact__c = objCase.ContactId,
                    											//Ticket_Owner__c = objCase.OwnerId,
                    											Speed__c = 0,
                    											Knowledge__c = 0,
                    											Manner__c = 0);
                    //if(!string.valueOf(objCase.OwnerId).startsWith('00G'))
                   	objFeedback.Ticket_Owner__c = objCase.OwnerId;
                   	objFeedback.Rated_By__c = 'Customer';
                   	
                   	system.debug('objCase.Contact.AccountId='+objCase.Contact.AccountId);
                   	if(objCase.Contact.AccountId != null)
                   		objFeedback.Contact__c = objCase.ContactId;
                    
                    system.debug('objFeedback.Contact__c='+objFeedback.Contact__c);	
                }
            }
        }        
        else
        {
            //show message that url is incorrect
            objCase = null;
        }    
    }
    
    public void initAccountOwner()
    {
        isCompleted = false;
        isAllowed = true;
        
        caseId = ApexPages.CurrentPage().getParameters().get('id');
        if(caseId != null && caseId != '')
        {
            list<Case> lObjCase = [select id, CaseNumber, account.name, accountid, owner.name,
            							contact.Name, contactid, OwnerId, contact.AccountId,
            							Opportunity__c, Opportunity__r.Order_Number__c,
            							Opportunity__r.OwnerId
                                        from Case where Id =: caseId limit 1];
            
            if(lObjCase.size() > 0)
            {
                objCase = lObjCase[0];
                string accountName = objCase.Account.Name;
                string accountId = objCase.AccountId;
                
                list<Customer_Service_Rating__c> lstRatings = 
                        [SELECT Account__c,Case__c,Comments_or_Suggestions__c,
                        		Contact__c,CreatedDate,Handle_future_requests__c,Id,
                        		Knowledge__c,Manner__c,Name,Overall_Rating_Score_Percent__c,
                        		Overall_Rating_Score__c,Rating_Score_Max__c,
                        		Recommend_SYNETY_to_others__c,Speed__c,Ticket_Owner__c
                        	FROM Customer_Service_Rating__c 
                        	where Case__c =: caseId
                        	and Rated_By__c = 'Account Owner'];
                        	
                if(objCase.Opportunity__c == null)
                {
                	isAllowed = false;
                	return;
                }
                
                if(objCase.Opportunity__r.OwnerId != UserInfo.getUserId())
                {
                	isAllowed = false;
                	return;
                }
                
					                
                if(lstRatings.size() > 0)
                {
                    isCompleted = true;
                    objFeedback = lstRatings[0];
                }
                else
                {
                    objFeedback = new Customer_Service_Rating__c(Case__c = caseId, 
                    											Name = objCase.CaseNumber,
                    											Account__c = objCase.AccountId,
                    											//Contact__c = objCase.ContactId,
                    											//Ticket_Owner__c = objCase.OwnerId,
                    											Speed__c = 0,
                    											Knowledge__c = 0,
                    											Manner__c = 0);
                    //if(!string.valueOf(objCase.OwnerId).startsWith('00G'))
                   	objFeedback.Ticket_Owner__c = objCase.OwnerId;
                   	objFeedback.Rated_By__c = 'Account Owner';
                   	
                   	system.debug('objCase.Opportunity__r.OwnerId='+objCase.Opportunity__r.OwnerId);
                   	if(objCase.Opportunity__r.OwnerId != null)
                   		objFeedback.Account_Manager__c = objCase.Opportunity__r.OwnerId;
                    
                    	
                }
            }
        }        
        else
        {
            //show message that url is incorrect
            objCase = null;
        }    
    }
    
    
    public boolean validateForm()
    {
    	boolean errors = false;
        
        boolean nextSectionCompleted = true;	
        if(objFeedback.Knowledge__c == 0 || 
        	objFeedback.Speed__c == 0 ||
        	objFeedback.Manner__c == 0 ||
        	objFeedback.Handle_future_requests__c == '' ||
        	objFeedback.Recommend_SYNETY_to_others__c == '' ||
        	objFeedback.Comments_or_Suggestions__c == '' ||
        	objFeedback.Comments_or_Suggestions__c == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'This rating form cannot be submitted because its not complete.');
            ApexPages.addMessage(myMsg);
            errors = true;
        }
        
        return errors;
    }
    
    public PageReference SubmitForm()
    {
        if(objCase != null && isCompleted == false)
        {
            
            if(!validateForm())
            {
            	upsert objFeedback;
            	objFeedback = TicketCustomerFeedbackController.calculateRating(objFeedback); 
                isCompleted = true;
                
                PageReference pg = null;
                if(objFeedback.Account_Manager__c != null)
                {
               		pg = New PageReference('/apex/TicketAccountOwnerFeedbackThankyou?id=' + objCase.Id );
                }
                else
            	{	    
                	pg = New PageReference('/orders/TicketCustomerFeedbackThankyou?i=' + objCase.Id );
            	}
            	
            	pg.setRedirect(true);
            	return pg;
                
            }
            else
            {
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                //    'The feedback cannot be submitted due to the errors listed above.');
                //ApexPages.addMessage(myMsg);
            }            
        }
        
        return null;
    }

}