@isTest
private class testCaseCommentAfterTrigger 
{
    @isTest(seealldata = true)
    static void myUnitTest() 
    {
		User u = [SELECT id, Name FROM User where name = 'API Team'];
		Case c = new Case(ownerid = u.id, status = 'New', origin = 'Email: api@synety.com', type = 'Development (API Team)', case_owned_by__c = 'Rahul Borgaonkar');
		insert c;
		CaseComment cc = new CaseComment(parentid = c.id, CommentBody = 'Hello 1', IsPublished = true);
		insert cc;
    }
}