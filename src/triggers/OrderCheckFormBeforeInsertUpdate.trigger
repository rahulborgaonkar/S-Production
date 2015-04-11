trigger OrderCheckFormBeforeInsertUpdate on Order_Check_Form__c (before insert, before update) 
{
    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress 
                           where DisplayName = 'SYNETY Provisioning Team' limit 1];
    EmailTemplate templateId = [Select id from EmailTemplate where name = 'Serviced Office Network Instructions'];
    
    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
    
    for(Order_Check_Form__c oForm: Trigger.New)
    {
        if(oForm.Serviced_Site_Network_Info_Sent__c == false && 
            oForm.Use_Voip__c == 'Yes' && oForm.Type__c == 'Serviced Office')
        {
            Opportunity opp = [select id, Opportunity_Contact__c from Opportunity 
                                where id =: oForm.Opportunity__c];
                                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateID(templateId.Id); 
            mail.setSaveAsActivity(true);
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setTargetObjectId(opp.Opportunity_Contact__c);
            mail.setWhatId(oForm.Opportunity__c);
            allmsg.add(mail);
            
            oForm.Serviced_Site_Network_Info_Sent__c = true;
            
            
            
        }
        
        if(Trigger.isUpdate)
        {
            if(oForm.Copy_Attachment__c == true && Trigger.oldMap.get(oForm.Id).Copy_Attachment__c == false)
            {
                List<Attachment> att = [select id, Body, Name from Attachment 
                                        where ParentId =: oForm.Id];
                if(att.size()>0)
                {
                    Attachment newAttach = new Attachment();
                    newAttach.Name = att[0].Name;
                    newAttach.Body = att[0].Body;
                    newAttach.ParentId = oForm.Opportunity__c;
                    
                    insert newAttach;
                    
                    delete att[0];
                }
            }
        }
    }
    
    if(allmsg.size() > 0)
        Messaging.sendEmail(allmsg,false);
}