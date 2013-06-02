component 
{
	this.name = "ConflictMSG";
	this.wschannels = [{name='ArtChannel'}];
	this.sessionManagement = true;
	
	public boolean function onRequestStart( string page )
	{
		if(isDefined("form.userName") && len(trim(form.userName)))
		{
			session.User = form.userName;
			return true;			
		}
		else if(!isDefined("Session.User"))
		{
			include "login.cfm";
			return false;
		}
		else
		{
			if(isdefined("URL.logout"))
			{
				structclear(session);
				include "login.cfm";
				return false;
			}
				
			return true;
		}
	}
}