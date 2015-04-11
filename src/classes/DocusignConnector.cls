public with sharing class DocusignConnector 
{
	private String integratorsKey = 'BVXX-6536d7d9-116f-47b6-8495-820f72f9f6fc';
    
	private String accountId = 	'e17a0d8e-3120-499d-918e-8ec48e9f077a';//sales' synety account - prod
								//'cd7e6a04-64f4-4cc8-b503-c937d905e0fb';//mohsin's account - trial
	    						//'3c8ad4b9-f88b-45eb-9c48-f89a9c3e4465';//demo account
	private String userId =    	'sales@synety.com';//'mohsin.raza@synety.com';
	private String password = 	'';//'mohsin786110';//'Passw0rd00';

    
    private String webServiceUrl 
        = 'https://www.docusign.net/api/3.0/dsapi.asmx';
        //= 'https://demo.docusign.net/api/3.0/dsapi.asmx';
    
    private String BaseUrl 
        = 'https://www.docusign.net/restapi/v1/';
        //= 'https://demo.docusign.net/restapi/v1/';
    
    public static boolean testResult {get; set;}
    /*
    public Pagereference VoidNow(string envelopeId)
    {
    	DocusignNetApi.DSAPIServiceSoap dsApiSend = new DocusignNetApi.DSAPIServiceSoap();
        dsApiSend.endpoint_x = webServiceUrl;

        //Set Authentication
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        System.debug('Setting authentication to: ' + auth);
      
      	try 
      	{
      	      
	        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
	        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication',auth);
	 
	        
	                
	        
	         
	    	System.debug('Calling the API');
	  
	        DocusignNetApi.VoidEnvelopeStatus status =
	        	dsApiSend.VoidEnvelope(envelopeId, 'Order Cancelled');
	        System.debug('result - ' + string.valueOf(status.VoidSuccess) );
        
   		}
   		catch ( CalloutException e) 
   		{
       		System.debug('Exception - ' + e );
       
       		 
   		}
   		
   		return null;
    }
    */
    
    public boolean VoidNow_RestAPI(string envelopeId)
    {
    	User oUser = [select id, dsfs__DSProSFPassword__c from User 
    					where Email =: userId or
    					UserName = 'mohsin.raza@synety.com.mohsintest' 
    					limit 1];
    	password = oUser.dsfs__DSProSFPassword__c;
    	
    	//Set Authentication
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        System.debug('Setting authentication to: ' + auth);
      
      	try 
      	{     
	        string json = '{"status":"voided","voidedReason":"Order was cancelled"}';
			
			HttpRequest req = new HttpRequest();
			Http http = new Http();
			
			req.setMethod('PUT');
			req.setHeader('X-DocuSign-Authentication',auth);
			req.setBody(json);
			
			String url = BaseUrl + 'accounts/' +
							EncodingUtil.urlEncode(accountId,'UTF-8') +
							'/envelopes/' + EncodingUtil.urlEncode(envelopeId,'UTF-8');
							
			req.setEndpoint(url);
			
			if(!Test.isRunningTest())
			{
				HTTPResponse resp = http.send(req);
				system.debug('response = '+resp.getBody().replace('\n', ''));
				
				if(resp.getStatusCode()==200)
					return true;
				else
					return false;
			}
			else
				return DocusignConnector.testResult;
				
   		}
   		catch ( CalloutException e) 
   		{
       		System.debug('Exception - ' + e );
       		return false;
   		}
   		
   		return false;
    }
    
	@future (callout=true)
	public static void doVoidEnvelope(string oppId, string orderNumber, string ownerId) 
	{
		
		list<dsfs__DocuSign_Status__c> dss = [select id, dsfs__DocuSign_Envelope_ID__c
												from dsfs__DocuSign_Status__c
		    									where dsfs__Opportunity__c =: oppId 
		    									and dsfs__Envelope_Status__c in ('Sent','Delivered')
		    									order by dsfs__Sent_Date_Time__c desc limit 1];
		    									//and dsfs__Envelope_Status__c != 'Completed' limit 1];
        
        if(dss.size() > 0)
        {
        	string envelopeId = dss[0].dsfs__DocuSign_Envelope_ID__c;
			DocusignConnector dsc = new DocusignConnector();
			boolean voidResult = dsc.VoidNow_RestAPI(envelopeId);
			
			if(voidResult==false)
			{
				//create task for manual envelope void		
	            Task t = new Task();
	            t.WhatId = oppId;
	            t.OwnerId = ownerId;
	            t.Status = 'Not Started';
	            t.Priority = 'High';
	            t.Subject = 'Void DocuSign Order Envelope';
	            t.ActivityDate = datetime.now().date();
	            t.Description = 'The system was not able to void the docusign envelope for order # "'+orderNumber+'" due to an error.';
	            t.Description += ' Please cancel the docusign order which is already sent out to the customer by clicking on the following link: https://' + System.URL.getSalesforceBaseUrl().getHost() + '/'+dss[0].Id + ' and click the button that says "Void Envelope" on the page that loads.';
	            
	            Database.DMLOptions dmlo = new Database.DMLOptions();
		        dmlo.EmailHeader.triggerUserEmail = true;
		        database.insert(t, dmlo); 
			}
        }
	} 
}