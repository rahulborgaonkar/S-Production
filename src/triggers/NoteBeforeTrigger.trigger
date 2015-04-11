trigger NoteBeforeTrigger on Note (before delete, before insert, before update) 
{
    ID currUserId = UserInfo.getUserId();
    User currUser = [SELECT Id, UserRoleId, UserType, Username FROM User WHERE Id = :currUserId];
	system.debug('User currUser - ' + currUser);
	UserRole currRole = new UserRole();
	 
    if(currUser.UserRoleId != null)
    {
    	currRole = [SELECT Id, Name, PortalAccountId FROM UserRole WHERE id = :currUser.UserRoleId];
    }
	system.debug('UserRole currRole - ' + currRole);

    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
    Map<String,String> keyPrefixMap = new Map<String,String>{};
    Set<String> keyPrefixSet = gd.keySet();

    for(String sObj : keyPrefixSet)
    {
        Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
        String tempName = r.getName();
        String tempPrefix = r.getKeyPrefix();
        System.debug('Processing Object['+tempName + '] with Prefix ['+ tempPrefix+']');
        keyPrefixMap.put(tempPrefix,tempName);
    }

//    if((currRole.name == 'QA Engineer' || currUser.UserType == 'CSPLitePortal') && (Trigger.isInsert || Trigger.isUpdate))
    if(currRole.name == 'QA Engineer' && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Note nt : Trigger.new)
        {
            String tPrefix = nt.ParentId;
            tPrefix = tPrefix.subString(0,3);
            string objectName = keyPrefixMap.get(tPrefix);

            if(objectName == 'Synety_Plugin__c')
            {
                system.debug('Wrong User to insert/update/delete');
                nt.addError('You cannot Insert/Update Note File');
            }
        }
    }

//    if((currRole.name == 'QA Engineer' || currUser.UserType == 'CSPLitePortal') && Trigger.isDelete)
    if(currRole.name == 'QA Engineer' && Trigger.isDelete)
	{
        for(Note nt : Trigger.old)
        {
            String tPrefix = nt.ParentId;
            tPrefix = tPrefix.subString(0,3);
            string objectName = keyPrefixMap.get(tPrefix);

            if(objectName == 'Synety_Plugin__c')
            {
                system.debug('Wrong User to insert/update/delete');
                nt.addError('You cannot Delete Note File');
            }
        }
    }
}