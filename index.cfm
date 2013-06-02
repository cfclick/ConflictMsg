<cfajaximport tags="cfform,cfgrid" >
<cfajaxproxy cfc="Index" jsclassname="AjaxBinder" />
<script> 	
	var onGridCellChange = function()
	{	
		//Validate the for if there is validation on cfinput	
		if (! _CF_checkartForm(document.getElementById('artForm')) ) return;
		
		//create proxy object from coldfusion cfc index.cfc
		var ajaxProxy = new AjaxBinder();
		
		var artId = document.getElementById('ARTIDtxt').value;
		var ob = new Object();
		ob.artname = document.getElementById('ARTNAMEtxt').value;
		ob.user = document.getElementById('usertxt').value;
		ob.artId = artId;
		
		if (artId > 0)
		{		
			//Dynamically set forms to CF function arguments
			ajaxProxy.setForm('artForm');
			
			//Call the method
			result = ajaxProxy.editForm();
			
			if(result)
			{
				publishMSG(ob);
				ColdFusion.Grid.refresh('artGrid' ,true);
			}else{
				alert(result);
			}
		}		
	}
	
	var publishMSG = function(obj){
	    artSocket.publish("ArtChannel", obj);
	}
	
	/*var errorHandler = function(e){
	   // alert(e);
	}*/
	
	var messageHandler = function(messageobj){
	    var message = "";
	    if (messageobj.type == "data") 
		{
			message = messageobj.data;
			message = ColdFusion.JSON.decode(messageobj.data);
			
			if(message.user == document.getElementById('usertxt').value )
			{
				setTopMessage("Art " + message["artname"] + " has been updated.","statusOk");
				ColdFusion.Grid.refresh('artGrid' ,true);
			}
			else
			{
				if(message["artId"] == document.getElementById('ARTIDtxt').value )
				{
					respond = confirm("Conflict exist on " +  message["artname"] + ". This Art has been updated by " + message["user"] + ". Do you want to sync?");
					if(respond)
					{
						setTopMessage("Conflict resolved! Art " + message["artname"] + " has been updated by " + message["user"],"statusOk");
						ColdFusion.Grid.refresh('artGrid' ,true);
					}
					else
					{
						
					}
				}
				else
				{
					setTopMessage("Art " + message["artname"] + " has been updated by " + message["user"],"statusOk");
					ColdFusion.Grid.refresh('artGrid' ,true);
				}
				
			}
			
			
		}       			
	}
	
	var setTopMessage = function(message, reqStatusType) {
		
		Ext.fly("statusDiv").dom.innerHTML = message;
		Ext.fly("statusDiv").addClass(reqStatusType);
		
		Ext.fly("statusDiv").show();
		setTimeout(function() {
			Ext.fly("statusDiv").hide();
		}, 7000);
		
	}
</script>

<cfoutput>
	<div style="padding:10px">
		Welcome #Session.User#
		<div id="statusDiv" class="statusDiv"></div>
		<h2>Art table update/push using ColdFusion 10 web sockets</h2>
	<cfform name="artForm">
		<div style="float:left;">

		<cfgrid name="artGrid" format="html" 
			pagesize="11"  
            stripeRows="true" 
			bind="cfc:Index.listArts({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection})" 
			delete="no" selectmode="row" insert="no"
			> 
			<cfgridcolumn name="ARTID" display="true" >
			<cfgridcolumn name="ARTISTID" display="false" header="Artist ID">
			<cfgridcolumn name="ARTNAME" display="true" header="Art Name">
			<cfgridcolumn name="DESCRIPTION" display="false" header="Description">
			<cfgridcolumn name="PRICE" display="true" header="Price">
			<cfgridcolumn name="LARGEIMAGE" display="false" header="Large Image">
			<cfgridcolumn name="MEDIAID" display="false" header="Media ID">
			<cfgridcolumn name="ISSOLD" display="true" header="Is Sold">
		</cfgrid>
</div>
<div style="float:right;">

	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="ARTIDtxt"><B>Details:</B></label></span>
		<span class="rightColSpan">
			
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="ARTIDtxt">Art ID:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="ARTIDtxt" id="ARTIDtxt" bind="{artGrid.ARTID}" readonly="readonly"/>
			<cfinput type="hidden" name="usertxt" id="usertxt" value="#Session.User#" readonly="readonly"/>
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="ARTISTIDtxt">Artists ID:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="ARTISTIDtxt" id="ARTISTIDtxt" bind="{artGrid.ARTISTID}" readonly="readonly" />
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="ARTNAMEtxt">Art Name:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="ARTNAMEtxt" id="ARTNAMEtxt" bind="{artGrid.ARTNAME}" />
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="DESCRIPTIONtxt">Description:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="DESCRIPTIONtxt" id="DESCRIPTIONtxt" bind="{artGrid.DESCRIPTION}" />
		</span>
	</div>
		
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="PRICEtxt">Price:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="PRICEtxt" id="PRICEtxt" bind="{artGrid.PRICE}">
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="LARGEIMAGEtxt">Image:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="LARGEIMAGEtxt" id="LARGEIMAGEtxt" bind="{artGrid.LARGEIMAGE}">
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="LARGEIMAGEtxt">Media:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="MEDIAIDtxt" id="MEDIAIDtxt" bind="{artGrid.MEDIAID}" />
		</span>
	</div>
	
	<div class="rowDiv">
		<span class="leftColSpan">
			<label for="ISSOLDtxt">Is Sold?:</label></span>
		<span class="rightColSpan">
			<cfinput type="text" name="ISSOLDtxt" id="ISSOLDtxt" bind="{artGrid.ISSOLD}" label="Is Sold?"  />
		</span>
	</div>
		
	<div id="FormToolbar" class="formToolbar">
		<cfinput type="button" value="Save" name="savebtn" id="savebtn" onclick="onGridCellChange()"/>
	</div>
</div>
	</cfform>
	</div>
</cfoutput>

<cfwebsocket name="artSocket" onmessage="messageHandler" subscribeto="ArtChannel" >

<link rel="stylesheet" href="main.css" type="text/css" media="screen"/>