var isCTIOn = false;
function listViewPhoneController() 
{
	this.fieldIdsFound = false;
	
    this.replacePhoneNumbers = function() {
		
		var j$ = jQuery.noConflict(true);
		var phIndex = 0;
		
		var packageName = window.location.href.substring( window.location.href.indexOf('https://') + 8, window.location.href.indexOf('.'));
		if(packageName == "bottomline")
			return;
																												   
		j$(document).ready(function()
		{
			/*
			if(true)
			{
				
				removejscssfile("/soap/ajax/14.0/apex.js", "js");
				removejscssfile("/soap/ajax/14.0/connection.js", "js");
				var th = parent.document.getElementsByTagName('head')[0];
				var s = parent.document.createElement('script');
				s.setAttribute("id", "connectionJS123456");
				s.setAttribute('type', 'text/javascript');
				s.setAttribute('src', '/soap/ajax/29.0/connection.js');
				th.appendChild(s);
				
				window.setTimeout(function(){
					var result = sforce.connection.describeGlobal(); 
					var sobjects = result.getArray("sobjects");  
					alert(sobjects.length); 
					console.debug(result);
				}, 1000);
				
			}
			*/
			
			
			var ctiDiv = null;
			if(document.getElementsByClassName) 
				ctiDiv = document.getElementsByClassName('openCTISoftphoneModule sidebarModule');
			else
				ctiDiv = getElementsByClassName(document.body, "openCTISoftphoneModule sidebarModule");
			
			//alert(ctiDiv.length);	
			if(ctiDiv != null && ctiDiv.length > 0)
				isCTIOn = true;
			
			//getting phone number fields for the object in context and saving it in an array
			var objDesc=''; 
			var objectPefix = window.location.href.substring( window.location.href.indexOf('.com/') + 5, window.location.href.indexOf('.com/') + 8 );
			
			var objectId = '';
			if(window.location.href.length >= (window.location.href.indexOf('.com/') + 20))
				objectId = window.location.href.substring( window.location.href.indexOf('.com/') + 5, window.location.href.indexOf('.com/') + 20 );
			
			this.fieldIdsFound = false;
			var sobjects = new Array();
			var doAddConnectionJS = false;
			
			var baseURL = window.location.href.substring( 0, window.location.href.indexOf('.com/') + 5);
			
			if(doAddConnectionJS)
			{
				var th = parent.document.getElementsByTagName('head')[0];
				var s = parent.document.createElement('script');
				s.setAttribute("id", "connection12345");
				s.setAttribute('type', 'text/javascript');
				s.setAttribute('src', '/soap/ajax/29.0/connection.js');
				th.appendChild(s);
			}
			
			try
			{
				var result = sforce.connection.describeGlobal();
				sobjects = result.getArray("sobjects");
				if(sobjects.length == 0)
					sobjects = result.getArray("types");
			}
			catch(err)
			{
				if(err.toString().indexOf("sf:API_CURRENTLY_DISABLED") != -1
					|| err.toString().indexOf("sf:API_DISABLED_FOR_ORG") != -1
					|| err.toString().indexOf("sf:API") != -1)
				{
					isAPIEnabled = false;
				}
				
				//"{faultcode:'sf:API_CURRENTLY_DISABLED', faultstring:'API_CURRENTLY_DISABLED: API is disabled for this User', detail:{UnexpectedErrorFault:{exceptionCode:'API_CURRENTLY_DISABLED', exceptionMessage:'API is disabled for this User', }, }, }")
				
				//{faultcode:'sf:API_DISABLED_FOR_ORG', faultstring:'API_DISABLED_FOR_ORG: API is not enabled for this Organization or Partner', detail:{UnexpectedErrorFault:{exceptionCode:'API_DISABLED_FOR_ORG', exceptionMessage:'API is not enabled for this Organization or Partner', }, }, }
				
			}
			
			if(isAPIEnabled)
			{
				for (var i=0; i<sobjects.length; i++) 
				{    
					if(sobjects[i].keyPrefix == objectPefix) 
					{ 
						var result1 = sforce.connection.describeSObject(sobjects[i].name); 
						
						if(objectPefix == "00T")
						{
							phoneFieldsName[phIndex] = "Phone";
							phoneFieldsLabel[phIndex] = "Phone";
							phIndex++;
						}
						for (var a=0; a<result1.fields.length; a++) 
						{    
							
							var field = result1.fields[a];    
							//objDesc+=field.name + ":" + field.label + ":" + field.type + '<br />';  
							
							if(objectPefix == "500" && (field.name == "SuppliedPhone" && field.label == "Phone"))
							{
								phoneFieldsName[phIndex] = "SuppliedPhone";
								phoneFieldsLabel[phIndex] = "Contact Phone";
								phIndex++;
							}
							else if(objectPefix == "003" && (field.name == "MobilePhone" && field.label == "Mobile Phone"))
							{
								phoneFieldsName[phIndex] = "MobilePhone";
								phoneFieldsLabel[phIndex] = "Mobile Phone";
								phIndex++;
								phoneFieldsName[phIndex] = "MobilePhone";
								phoneFieldsLabel[phIndex] = "Mobile";
								phIndex++;
							}
							else if(field.type == "phone")
							{
								if((field.name == "Fax" && field.label == "Business Fax") && objectPefix == "003")
								{
									phoneFieldsName[phIndex] = "Fax";
									phoneFieldsLabel[phIndex] = "Fax";
								}
								else if((field.name == "Fax" && field.label == "Account Fax") && objectPefix == "001")
								{
									phoneFieldsName[phIndex] = "Fax";
									phoneFieldsLabel[phIndex] = "Fax";
								}
								else if((field.name == "Phone" && field.label == "Business Phone") && objectPefix == "003")
								{
									phoneFieldsName[phIndex] = "Phone";
									phoneFieldsLabel[phIndex] = "Phone";
								}
								else if((field.name == "Phone" && field.label == "Account Phone") && objectPefix == "001")
								{
									phoneFieldsName[phIndex] = "Phone";
									phoneFieldsLabel[phIndex] = "Phone";
								}
								else if((field.name == "MobilePhone" && field.label == "Mobile Phone") && objectPefix == "00Q")
								{
									phoneFieldsName[phIndex] = "MobilePhone";
									phoneFieldsLabel[phIndex] = "Mobile";
								}
								else
								{
									phoneFieldsName[phIndex] = field.name;
									phoneFieldsLabel[phIndex] = field.label;
								}
								phIndex++;
							}
						}
						
						//document.getElementById('objectDesc').innerHTML=objDesc; 
					}  
				}
			}
			else
			{
				var s = j$('html');
				var sih = s[0].innerHTML;
				var iIndex = sih.indexOf('"shownColumns":');
				if(iIndex!=-1)
				{
					var iToEnd = sih.indexOf('}]',iIndex);
					var columnJSON = sih.substring(iIndex+15, iToEnd+2);
					var jsonObject = JSON.parse(columnJSON);
					
					for(i=0; i<jsonObject.length; i++)
					{
						if(jsonObject[i].fieldType == 'PHONE' || 
							jsonObject[i].fieldType == 'FAX')
						{
							phoneFieldsName[phIndex] = jsonObject[i].fieldId;
							phoneFieldsLabel[phIndex] = jsonObject[i].label;
							phIndex++;		
						}
					}
					
					/*
					alert(jsonObject.length);
					alert(jsonObject[0].fieldId);
					alert(jsonObject[0].fieldType);
					alert(jsonObject[5].fieldType);
					alert(jsonObject[5].label);
					alert(jsonObject[5].columnName);
					*/
				}

			}
			
			//alert(phoneFieldsName.length);
			
			if(isAPIEnabled && !isCTIOn)
			{
				objDesc='';  
							
				//Getting section table from record detail page
				//var tables = document.getElementsByClassName('detailList');
				var tables = null;
				if(document.getElementsByClassName) 
					tables = document.getElementsByClassName('detailList');
				else
					tables = getElementsByClassName(document.body, "detailList");
					
				//alert(tables.length);
				//alert(objectId);
				for( var i = 0; i < tables.length; i++) 
				{ 
					var cols = tables[i].getElementsByTagName('td');
					//alert(cols.length);
					
					for( var j = 0; j < cols.length; j++) 
					{
						if(cols[j].className == 'labelCol')
						{
							var isPhoneField = false;
							for(var a=0; a<phoneFieldsLabel.length; a++)
							{
								if(phoneFieldsLabel[a] == cols[j].innerHTML)
								{
									isPhoneField = true;
									break;
								}
							}
							
							if(isPhoneField)
							{
								//objDesc+= cols[j].innerHTML + '=';
								j++;
								
								//objDesc+= cols[j].innerHTML + '<br />';
								//if(cols[j].innerHTML != '&nbsp;' && cols[j].innerHTML != '')
								//{
									var phoneElem = '';
									if(cols[j].innerHTML.indexOf('div') >= 0)
									{
										var divElem = cols[j].getElementsByTagName('div');
										phoneElem = divElem[0];//.innerHTML; = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+objectId+'\', \''+divElem[0].innerHTML +'\');">'+divElem[0].innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';									
									}
									else
									{
										phoneElem = cols[j];//.innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+objectId+'\', \''+cols[j].innerHTML +'\');">'+cols[j].innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
									}
								//}
								
								if(phoneElem.innerHTML != '&nbsp;' && phoneElem.innerHTML != '')
								{
									if(objectPefix == "500")
									{
										var caseresult = sforce.connection.query("Select ContactId from Case where id = '"+objectId+"'");
										var caserecord = caseresult.getArray("records");
										//alert(caserecord);
										var contactId = caserecord[0].ContactId;
										  
										phoneElem.innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+contactId+'\', \''+ phoneElem.innerHTML +'\', \''+ objectId +'\');">'+phoneElem.innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
									}
									else
										phoneElem.innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+objectId+'\', \''+phoneElem.innerHTML +'\');">'+phoneElem.innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
								}
							}
							
						}
						//objDesc+= i + ',' + j + '=' +cols[j].innerHTML + '<br />';  			
					}
				}
			}
			else if(!isCTIOn)
			{
				//creating field list for record detail page
				var s = j$('html');
				var sih = s[0].innerHTML;
				var iIndex = sih.indexOf('"fields":');
				if(iIndex != -1)
				{
					var iToEnd = sih.indexOf('}]',iIndex);
					var columnJSON = sih.substring(iIndex+9, iToEnd+2);
					var jsonObject = JSON.parse(columnJSON);
					
					for(i=0; i<jsonObject.length; i++)
					{
						if(jsonObject[i].fieldType == 'PHONE' || 
							jsonObject[i].fieldType == 'FAX')
						{
							var fieldId = jsonObject[i].fieldId;
							
							var phoneElem = document.getElementById(fieldId+'_ileinner');
							if(phoneElem)
							{
								if(phoneElem.innerHTML != '&nbsp;' && phoneElem.innerHTML != '')
								{
									phoneElem.innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+objectId+'\', \''+phoneElem.innerHTML +'\');">'+phoneElem.innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
								}
							}
						}
					}
				}
			}
			
			//document.getElementById('objectDesc').innerHTML=objDesc; 
			
			/*
			//getting phone number html elements from related lists
			var cnt = 0; 
			var recordId = new Array(); 
			var recStart = 0; 
			var recLength = 15; 
			var datacellStr = document.getElementsByClassName(" dataRow"); 
			//alert(datacellStr.length);
			for (var i = 0; i < datacellStr.length; i++) 
			{ 
				var thisRecordId = '';
				var nameElement = datacellStr[i].getElementsByTagName('th');
				if(nameElement.length > 0)
				{
					var recordLink = nameElement[0].getElementsByTagName('a');
					//alert(nameElement[0].innerHTML);
					//alert(recordLink);
					if(recordLink.length > 0)
					{
						thisRecordId = recordLink[0].href;
						thisRecordId = thisRecordId.substring(thisRecordId.indexOf('.com/') + 5, thisRecordId.indexOf('.com/') + 20);
						thisRecordId=thisRecordId.replace('/','');
					}
				}
				
				var phone = datacellStr[i].getElementsByClassName(" dataCell PhoneNumberElement"); 
				for (var j = 0; j < phone.length; j++) 
				{
					if(phone[j].innerHTML != '&nbsp;') 
					{ 
						//alert('Required');
						phone[j].innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+thisRecordId+'\', \''+phone[j].innerHTML +'\');">'+phone[j].innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
						//'<a href="" onclick="opencallWindow(\''+recordId[i]+'\', \''+phone[i].innerHTML+'\');">'+phone[i].innerHTML+'<img src="/resource/synety__tinyPhoneIcon"/></a>'; 
					} 
				}
				
			} 
			
			///dynamic relatated lists code goes here
			setTimeout(function(){
				var datacellStr = document.getElementsByClassName(" dataRow"); 
				console.log('datacellStr.length='+datacellStr.length);
				for (var i = 0; i < datacellStr.length; i++) 
				{ 
					var thisRecordId = '';
					var nameElement = datacellStr[i].getElementsByTagName('th');
					if(nameElement.length > 0)
					{
						var recordLink = nameElement[0].getElementsByTagName('a');
						//alert(nameElement[0].innerHTML);
						//alert(recordLink);
						if(recordLink.length > 0)
						{
							thisRecordId = recordLink[0].href;
							thisRecordId = thisRecordId.substring(thisRecordId.indexOf('.com/') + 5, thisRecordId.indexOf('.com/') + 20);
							thisRecordId=thisRecordId.replace('/','');
						}
					}
					
					var phone = datacellStr[i].getElementsByClassName(" dataCell PhoneNumberElement"); 
					for (var j = 0; j < phone.length; j++) 
					{
						if(phone[j].innerHTML != '&nbsp;') 
						{ 
							
							phone[j].innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+thisRecordId+'\', \''+phone[j].innerHTML +'\');">'+phone[j].innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
							//'<a href="" onclick="opencallWindow(\''+recordId[i]+'\', \''+phone[i].innerHTML+'\');">'+phone[i].innerHTML+'<img src="/resource/synety__tinyPhoneIcon"/></a>'; 
						} 
					}
					
				} 		
			
			},5000);
			*/
			
			if(!isCTIOn)
			{
				//var relLists = document.getElementsByClassName("bPageBlock brandSecondaryBrd secondaryPalette");
				var relLists = null;
				if(document.getElementsByClassName) 
					relLists = document.getElementsByClassName('bPageBlock brandSecondaryBrd secondaryPalette');
				else
					relLists = getElementsByClassName(document.body, "bPageBlock brandSecondaryBrd secondaryPalette");
						
				for(var d=0; d<relLists.length; d++)
				{
					var relList = relLists[d];
					if(relList.innerHTML.indexOf('<span class="loadingText">Loading...</span>') <0)
					{
						createClick2DialLinksOnRelatedList(relList);
					}
					else
					{
						j$(relList).bind('DOMNodeInserted DOMNodeRemoved', function(event) { 
							if (event.type == 'DOMNodeInserted') 
							{
								var textNode = event.target;
								if(typeof textNode === 'Comment')
								{
									//nothing	
								}
								else
								{
									//call function 
									createClick2DialLinksOnRelatedList(this);
								}							
							} 
						} ); 
					}
				}
			
			//if(isAPIEnabled)
			//{
				//getting phone number divs from listviews and changing them into the link
				var listView = document.getElementsByTagName('div'); 
				for( var i = 0; i < listView.length; i++) 
				{ 
					if(/_listBody/i.test(listView[i].id)) 
					{ 
						j$('#'+listView[i].id).bind('DOMNodeInserted DOMNodeRemoved', function(event) { 
							if (event.type == 'DOMNodeInserted') 
							{
								var textNode = event.target;
								if(typeof textNode === 'Comment')
								{
									//nothing	
								}
								else
								{
									//document.getElementById('objectDesc').innerHTML+=textNode+';'+textNode.id+';'+textNode.className+'<br />';
									//var headers = document.getElementsByClassName('x-grid3-hd-inner ');
									//alert(this.fieldIdsFound);
									
									//var headers = document.getElementsByClassName('x-grid3-hd-inner ');
									var headers = null;
									if(document.getElementsByClassName) 
										headers = document.getElementsByClassName('x-grid3-hd-inner ');
									else
										headers = getElementsByClassName(document.body, "x-grid3-hd-inner");
										
									if(headers.length > 0 && this.fieldIdsFound != true)
									{
										this.fieldIdsFound = true;
										//alert(headers+','+headers.length);
										for(var a=0; a<phoneFieldsLabel.length; a++)
										{
											for(var b=0; b<headers.length; b++)
											{
												//alert(headers[b].title + '==' + phoneFieldsLabel[a]);
												if(headers[b].title == phoneFieldsLabel[a])
												{
													var className = headers[b].className;
													className = className.replace("x-grid3-hd-inner x-grid3-hd-","");
													phoneFieldsId[a] = className;
												}
											}
											
											//alert(phoneFieldsId[a]+';'+phoneFieldsName[a]);
										}
									}
									
									//alert('phoneFieldsId.length='+phoneFieldsId.length);
									
									for(var z=0; z<phoneFieldsId.length; z++)
									{
										//alert(phoneFieldsId[z]);
										if (typeof phoneFieldsId[z] === "undefined") 
										{
											//do nothing
										}
										else
										{
											//var phoneArray = document.getElementsByClassName("x-grid3-cell-inner x-grid3-col-"+phoneFieldsId[z]); 
											var phoneArray = null;
											if(document.getElementsByClassName) 
												phoneArray = document.getElementsByClassName("x-grid3-cell-inner x-grid3-col-"+phoneFieldsId[z]);
											else
												phoneArray = getElementsByClassName(document.body, "x-grid3-cell-inner x-grid3-col-"+phoneFieldsId[z]);
											
											//var recordArray = document.getElementsByClassName("x-grid3-cell-inner x-grid3-col-Name"); 
											//if (recordArray.length == 0 ) 
											//{ 
											//	recordArray = document.getElementsByClassName("x-grid3-cell-inner x-grid3-col-FULL_NAME"); 
											//} 
											
											//document.getElementById('phoneArrayCount').innerHTML += 'Count('+phoneFieldsId[z]+') = '+phoneArray.length; 
											for(var a=0; a<phoneArray.length; a++) 
											{ 
												if(phoneArray[a].innerHTML.indexOf("<!--do not replace-->") <0 && phoneArray[a].innerHTML != '&nbsp;' ) 
												{ 
													//phoneArray[a].innerHTML = '<!--do not replace--><a href="" onclick="opencallWindow(\''+recordArray[a].id.substr(0, recordArray[a].id.indexOf("_") )+'\', \''+phoneArray[a].innerHTML+'\');">'+phoneArray[a].innerHTML+'<img src="/resource/synety__tinyPhoneIcon"/></a>';
													phoneArray[a].innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+phoneArray[a].id.substr(0, phoneArray[a].id.indexOf("_") )+'\', \''+phoneArray[a].innerHTML+'\');">'+phoneArray[a].innerHTML+'<img src="/resource/synety__tinyPhoneIcon"/></a>';
												} 
											}   
										}
									}
								}							
							} 
						} ); 
					} 
				}
			//}
			}
			
			//replace the phone clicker ajax title and text
			//var sideBarHeaders = document.getElementsByClassName("brandPrimaryFgr");
			var sideBarHeaders = null;
			if(document.getElementsByClassName) 
				sideBarHeaders = document.getElementsByClassName("brandPrimaryFgr");
			else
				sideBarHeaders = getElementsByClassName(document.body, "brandPrimaryFgr");
				
			for( var i = 0; i < sideBarHeaders.length; i++) 
			{
				if(sideBarHeaders[i].innerHTML == 'PhoneClicker AJAX')
				{
					sideBarHeaders[i].innerHTML = 'SYNETY';
				}
				else if(sideBarHeaders[i].innerHTML == 'PhoneClicker')
				{
					if(isAPIEnabled)
					{
						sideBarHeaders[i].innerHTML = '&nbsp;';
					}
					else
					{
						sideBarHeaders[i].innerHTML = 'CloudCall Inbound Notifier';
					}
				}
			}
			
			var sideBarLinks = document.getElementsByTagName("a");
			for( var i = 0; i < sideBarLinks.length; i++) 
			{
				if(sideBarLinks[i].innerHTML == 'PhoneClicker AJAX Import')
				{
					sideBarLinks[i].innerHTML = 'CloudCall for Salesforce';
				}
				
				if(sideBarLinks[i].innerHTML == 'PhoneClicker AJAX Import 2')
				{
					sideBarLinks[i].innerHTML = '&nbsp';
				}
			}
			
			
			if(isAPIEnabled)
			{
				OnLoad();	
			}
			else
			{
				document.getElementById("iframePanel").innerHTML='<iframe src="/apex/synety__InboundPopupProf" frameborder="0" height="350px" width="180px"  scrolling="yes"></iframe>';
			}
			
		});
		
		 
		//} ); 
		
		
    }
}

function createClick2DialLinksOnRelatedList(thisList)
{
	//var datacellStr = thisList.getElementsByClassName(" dataRow"); 
	var datacellStr = null;
	if(document.getElementsByClassName) 
		datacellStr = thisList.getElementsByClassName("dataRow");
	else
		datacellStr = getElementsByClassName(thisList, "dataRow");
		
	console.log('datacellStr.length='+datacellStr.length);
	for (var i = 0; i < datacellStr.length; i++) 
	{ 
		var thisRecordId = '';
		var nameElement = datacellStr[i].getElementsByTagName('th');
		if(nameElement.length > 0)
		{
			var recordLink = nameElement[0].getElementsByTagName('a');
			//alert(nameElement[0].innerHTML);
			//alert(recordLink);
			if(recordLink.length > 0)
			{
				thisRecordId = recordLink[0].href;
				thisRecordId = thisRecordId.substring(thisRecordId.indexOf('.com/') + 5, thisRecordId.indexOf('.com/') + 20);
				thisRecordId=thisRecordId.replace('/','');
			}
		}
		
		var phone = null;
		if(document.getElementsByClassName) 
			phone = datacellStr[i].getElementsByClassName(" dataCell PhoneNumberElement"); 
		else
			phone = getElementsByClassName(datacellStr[i], "PhoneNumberElement");
		
		for (var j = 0; j < phone.length; j++) 
		{
			//if(phoneArray[a].innerHTML.indexOf("<!--do not replace-->") <0 && phoneArray[a].innerHTML != '&nbsp;' ) 
			
			if(phone[j].innerHTML.indexOf("<!--do not replace-->") <0 && phone[j].innerHTML != '&nbsp;') 
			{ 
				
				phone[j].innerHTML = '<!--do not replace--><a href="#" onclick="return openCallWindow(\''+thisRecordId+'\', \''+phone[j].innerHTML +'\');">'+phone[j].innerHTML +'<img src="/resource/synety__tinyPhoneIcon"/></a>';
				
			} 
		}
		
	}
}

function getElementsByClassName(node, classname) {
    var a = [];
    var re = new RegExp('(^| )'+classname+'( |$)');
    var els = node.getElementsByTagName("*");
    for(var i=0,j=els.length; i<j; i++)
        if(re.test(els[i].className))a.push(els[i]);
    return a;
}

function removejscssfile(filename, filetype){
 var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none" //determine element type to create nodelist from
 var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none" //determine corresponding attribute to test for
 var allsuspects=document.getElementsByTagName(targetelement)
 for (var i=allsuspects.length; i>=0; i--){ //search backwards within nodelist for matching elements to remove
  if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(filename)!=-1)
  {
	  alert('removing '+filename);
   	allsuspects[i].parentNode.removeChild(allsuspects[i]) //remove element by calling parentNode.removeChild()
  }
 }
}
