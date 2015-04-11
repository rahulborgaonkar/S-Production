global class CreditCheckBatchController implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    
     //constructor
    public CreditCheckBatchController(){
    
    }
    
    // start method of Batch process
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //if(!Test.isRunningTest())
            return Database.getQueryLocator([select id, Company_Registration_No__c,
                                            Perform_Auto_Credit_Check__c, Request_Credit_Check__c,
                                            NumberOfEmployees,
                                            Turnover__c,
                                            Credit_Limit__c,
                                            Profit__c,
                                            bottomline__creditSafeLimit__c,
                                            bottomline__creditSafeScore__c,
                                            SicDesc,
                                            Date_of_Last_Credit_Check__c,
                                            bottomline__creditSafeLastRefreshed__c,
                                            No_of_CCJs__c,
                                            Total_value_of_CCJs__c,
                                            bottomline__creditSafeCompanyType__c,   
                                            bottomline__creditSafeScoreDescription__c
                                            from Account 
                                            where Perform_Auto_Credit_Check__c = true
                                            and Company_Registration_No__c != null
                                            order by name]);
        /*
        else
            return Database.getQueryLocator([select id from user where Id =: Userinfo.getUserId() order by name]);
        */
    }
    
    // execute mehod of Batch process
    global void execute(Database.BatchableContext BC, List<sObject> batch)
    {
        List<Account> lstAcc = (List<Account>) batch;
        
        //I am assuming that the batch will always run with batch size 1
        CreditSafeConnector o = new CreditSafeConnector();
        if(lstAcc[0].Company_Registration_No__c != '' && 
            lstAcc[0].Company_Registration_No__c != null)
            {
            	
                boolean bResult = o.GetCompanyInformation(lstAcc[0].Company_Registration_No__c,
                                                            lstAcc[0].Id);
                if(bResult)
                {
                	this.populateCreditSafeDataUsingDOM(o.responseXML, lstAcc[0]);
                	
                	lstAcc[0].Request_Credit_Check__c = false;
                	OrderClassController oOrder = new OrderClassController();
                	oOrder.processOppForAccountWaitingOnCreditCheck(lstAcc[0].Id);
		            
                }
                else
                    lstAcc[0].Request_Credit_Check__c = true;
            }
            else
                lstAcc[0].Request_Credit_Check__c = true;
            
            
            lstAcc[0].Perform_Auto_Credit_Check__c = false;
            
            
            update lstAcc;   
    }
    
    map<string, string> mapValues = new map<string, string>();      
	private String walkThrough(DOM.XMLNode node, string parentName) 
	{
	  String result = '\n';
	  if (node.getNodeType() == DOM.XMLNodeType.COMMENT) 
	  {
	    return 'Comment (' +  node.getText() + ')';
	  }
	  
	  if (node.getNodeType() == DOM.XMLNodeType.TEXT) 
	  {
	    return 'Text (' + node.getText() + ')';
	  }
	  
	  if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) 
	  {
	  	string elementName = parentName + '/' + node.getName();
	    result += 'Element: ' + elementName;
	    if (node.getText().trim() != '') 
	    {
	      //result += ', text=' + node.getText().trim();
	      result += '=' + node.getText().trim();
	      
	      if(!mapValues.containsKey(elementName))
	      	mapValues.put(elementName, node.getText().trim());
	      
	    }
	    if (node.getAttributeCount() > 0) 
	    { 
	      for (Integer i = 0; i< node.getAttributeCount(); i++ ) 
	      {
	        result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
	      }  
	    }
	    
	    for (Dom.XMLNode child: node.getChildElements()) 
	    {
	      result += walkThrough(child, parentName + '/' + node.getName());
	    }
	    return result;
	  }
	  return '';  //should never reach here 
	}
  	
  	public void populateCreditSafeDataUsingDOM(string toParse, Account acc)
    {
  		try 
  		{
  			integer NumberOfEmployees = null;
	        string Turnover = null;
	        double Credit_Limit = null;
	        string Profit = null;
	        string creditSafeLimit = '';
	        integer creditSafeScore = null;
	        string SicDesc = '';
	        integer No_of_CCJs = null;
	        string Total_value_of_CCJs = null;
	        string creditSafeCompanyType = '';
	        string creditSafeScoreDescription = '';
        	string sicCode = '';
        	
  			DOM.Document doc = new DOM.Document();      
	    	doc.load(toParse);    
	    	DOM.XMLNode root = doc.getRootElement();
	    	string xmlData = walkThrough(root,'');
	    	system.debug(xmlData);
	    	system.debug(mapValues);
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/baseinformation/sicdescription2007'))
	    		SicDesc = mapValues.get('/xmlresponse/body/companies/company/baseinformation/sicdescription2007');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/financials/financial/miscellaneous/employees'))
	    		NumberOfEmployees = Integer.valueof(mapValues.get('/xmlresponse/body/companies/company/financials/financial/miscellaneous/employees'));
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/financials/financial/profitloss/turnover'))
	    		Turnover = mapValues.get('/xmlresponse/body/companies/company/financials/financial/profitloss/turnover');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/financials/financial/profitloss/turnover'))
	    		Turnover = mapValues.get('/xmlresponse/body/companies/company/financials/financial/profitloss/turnover');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/limits/limitdetail/limit'))
	    	{
	    		Credit_Limit = double.valueof(mapValues.get('/xmlresponse/body/companies/company/limits/limitdetail/limit'));
	    		creditSafeLimit = mapValues.get('/xmlresponse/body/companies/company/limits/limitdetail/limit');
	    	}
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/financials/financial/profitloss/pretax'))
	    		Profit = mapValues.get('/xmlresponse/body/companies/company/financials/financial/profitloss/pretax');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/ratings/ratingdetail/score'))
	    		creditSafeScore = integer.valueof(mapValues.get('/xmlresponse/body/companies/company/ratings/ratingdetail/score'));
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/ratings/ratingdetail/description'))
	    		creditSafeScoreDescription = mapValues.get('/xmlresponse/body/companies/company/ratings/ratingdetail/description');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/baseinformation/companytype'))
	    		creditSafeCompanyType = mapValues.get('/xmlresponse/body/companies/company/baseinformation/companytype');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/ccjsummary/values'))
	    		Total_value_of_CCJs = mapValues.get('/xmlresponse/body/companies/company/ccjsummary/values');
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/ccjsummary/numbers'))
	    		No_of_CCJs = integer.valueof(mapValues.get('/xmlresponse/body/companies/company/ccjsummary/numbers'));
	    	
	    	if(mapValues.containsKey('/xmlresponse/body/companies/company/baseinformation/siccode2007'))
	    		sicCode = mapValues.get('/xmlresponse/body/companies/company/baseinformation/siccode2007');
	    	
	    	
	    	acc.Sic = sicCode;
	    	acc.No_of_CCJs__c = No_of_CCJs;
	        acc.Total_value_of_CCJs__c = Total_value_of_CCJs;
	        //acc.bottomline__creditSafeCompanyType__c = creditSafeCompanyType;
	        acc.Credit_Limit__c = Credit_Limit;
	        acc.Profit__c = Profit;
	        acc.bottomline__creditSafeLimit__c = creditSafeLimit;
	        acc.bottomline__creditSafeScore__c = creditSafeScore;
	        acc.bottomline__creditSafeScoreDescription__c = creditSafeScoreDescription;
	        acc.NumberOfEmployees = NumberOfEmployees; 	
			acc.SicDesc = SicDesc;
	    	acc.bottomline__creditSafeLastRefreshed__c = datetime.now().date();
	    	acc.Date_of_Last_Credit_Check__c = datetime.now().date();
	    	acc.Turnover__c = Turnover;
	    	
	  	} 
	  	catch (System.XMLException e) 
	  	{  // invalid XML
	    	system.debug('Error='+e.getMessage());
	  	}  	
    }
    
    public void populateCreditSafeData(XmlStreamReader reader, Account acc)
    {
    	while(reader.hasNext()) 
       	{
	   		//  Start at the beginning of the book and make sure that it is a book
	   		system.debug('getLocalName='+reader.getLocalName());
	   		//if (reader.getEventType() == XmlTag.START_ELEMENT) 
	   		//{
	   		 	//system.debug('getLocalName='+reader.getLocalName());
	        	if ('sicdescription2007' == reader.getLocalName()) 
	        	{
	        		while(reader.hasNext()) {
				        if (reader.getEventType() == XmlTag.END_ELEMENT) {
				           break;
				        } else if (reader.getEventType() == XmlTag.CHARACTERS) {
				           system.debug('sic desc='+reader.getText());
				        }
				        reader.next();
				     }
	        		
	            	//Pass the book to the parseBook method (below) 
	                //Book book = parseBook(reader);
	                //books.add(book);
	            }
	        //}
	        reader.next();
	   	}
    	
    }
    
    // finish method of Bathc process
    global void finish(Database.BatchableContext BC){

    }
    
    public static testmethod void doTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Perform_Auto_Credit_Check__c = true;
        acc.Company_Registration_No__c = '11111111';
        insert acc;
        
         // run test of batch class
        Test.startTest();
        
        CreditCheckBatchController job1 = new CreditCheckBatchController();
        ID batchprocessid1 = Database.executeBatch(job1,1);

		// run test scheduler
        Datetime dt = Datetime.now().addhours(1);
        String hour = String.valueOf(dt.hour());
        String min = String.valueOf(dt.minute());
        String ss = String.valueOf(dt.second()); 
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        System.debug('-----------nextFireTime---------' + nextFireTime);
        CreditCheckScheduleController s = new CreditCheckScheduleController();
        System.schedule('Job Started At ' + String.valueOf(Datetime.now().addMinutes(2)), nextFireTime, s);
        
        
        Test.stopTest();
        
        /*
        API_Config__c sc = new API_Config__c(); 
        sc.OAuthKey__c = 'ddaae2d2-1f63-4bc4-9380-e9478c321f75';
        sc.OAuthSecret__c = 'ddaae2d2-1f63-4bc4-9380-e9478c321f75';
        sc.UserName__c = '1234567890';
        sc.Customer_Login_Email__c = 'test@test.com';
        sc.Name = UserInfo.getUserId();
        sc.Licensekey__c = '1234567890';
        insert sc;
        
        
        // run test of batch class
        Test.startTest();
        
        // run test scheduler
        Datetime dt = Datetime.now().addhours(1);
        String hour = String.valueOf(dt.hour());
        String min = String.valueOf(dt.minute());
        String ss = String.valueOf(dt.second()); 
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        System.debug('-----------nextFireTime---------' + nextFireTime);
        ScheduleAccessTokenController s = new ScheduleAccessTokenController ();
        System.schedule('Job Started At ' + String.valueOf(Datetime.now().addMinutes(2)), nextFireTime, s);
        
        Call_Update_Queue__c o = new Call_Update_Queue__c ();
        o.Contact_Id__c = '123';
        o.Session_Id__c = 'abcde';
        o.Notes__c = '';
        insert o;

        BatchAccessTokenController job1 = new BatchAccessTokenController();
        ID batchprocessid1 = Database.executeBatch(job1);

        Test.stopTest();
        
        API_Config__c scr = API_Config__c.getinstance(sc.Name);
        System.assert(scr.OAuthToken__c == null);
        System.assert(scr.OAuthTokenSecret__c == null);
        */
    }

}