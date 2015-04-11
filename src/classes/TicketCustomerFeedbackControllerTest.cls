@isTest
private class TicketCustomerFeedbackControllerTest {

    static testMethod void myUnitTest1() 
    {
    	Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'Name';
        c.email = 'a@b.com';
        c.AccountId = acc.Id;
        insert c;
        
   		Case oCase = new Case();
   		oCase.AccountId = acc.Id;
   		oCase.ContactId = c.Id;
   		oCase.OwnerId = UserInfo.getUserId();
   		insert oCase;
   		
   		oCase.Status = 'Closed';
   		update oCase; 
   		
   		ApexPages.CurrentPage().getParameters().put('i',oCase.Id);
        TicketCustomerFeedbackController obj = new TicketCustomerFeedbackController();
        obj.init();
        obj.getRecommend_SYNETY_to_others();
        obj.getHandle_future_requests();
        obj.objFeedback.Recommend_SYNETY_to_others__c = 'Yes';
        obj.objFeedback.Handle_future_requests__c = 'Yes';
        obj.SubmitForm();
        obj.objFeedback.Speed__c = 3;
        obj.objFeedback.Manner__c = 3;
        obj.objFeedback.Knowledge__c = 3;
        obj.objFeedback.Comments_or_Suggestions__c = 'Test notes';
        obj.SubmitForm();
        
        TicketCustomerFeedbackController.calculateRating(obj.objFeedback); 
    }
    
    static testMethod void myUnitTest2() 
    {
    	Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'Name';
        c.email = 'a@b.com';
        c.AccountId = acc.Id;
        insert c;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.now().date();
        opp.StageName = 'Closed Won';
        opp.Requires_VoIP__c = true;
        opp.OwnerId = UserInfo.getUserId();
        insert opp;
        
   		Case oCase = new Case();
   		oCase.AccountId = acc.Id;
   		oCase.ContactId = c.Id;
   		oCase.OwnerId = UserInfo.getUserId();
   		oCase.Opportunity__c = opp.Id;
   		insert oCase;
   		
   		oCase.Status = 'Closed';
   		update oCase; 
   		
   		ApexPages.CurrentPage().getParameters().put('id',oCase.Id);
        TicketCustomerFeedbackController obj = new TicketCustomerFeedbackController();
        obj.initAccountOwner();
        obj.getRecommend_SYNETY_to_others();
        obj.getHandle_future_requests();
        obj.objFeedback.Recommend_SYNETY_to_others__c = 'Yes';
        obj.objFeedback.Handle_future_requests__c = 'Yes';
        obj.SubmitForm();
        obj.objFeedback.Speed__c = 3;
        obj.objFeedback.Manner__c = 3;
        obj.objFeedback.Knowledge__c = 3;
        obj.objFeedback.Comments_or_Suggestions__c = 'Test notes';
        obj.SubmitForm();
        
        TicketCustomerFeedbackController.calculateRating(obj.objFeedback); 
    }
}