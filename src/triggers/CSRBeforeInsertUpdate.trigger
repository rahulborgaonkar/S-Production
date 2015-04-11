trigger CSRBeforeInsertUpdate on Customer_Service_Rating__c (before insert, before update) 
{
	for(Customer_Service_Rating__c csr: Trigger.New)
	{
		csr = TicketCustomerFeedbackController.calculateRating(csr);
	}
}