﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using SecurityInnovation.TeamMentor.WebClient.WebServices;
using O2.Kernel;
using TeamMentor.CoreLib;

namespace SecurityInnovation.TeamMentor.Website
{
	public class Global : System.Web.HttpApplication
	{
		protected void Application_Error(object sender, EventArgs e)
		{			
			var lastError = Server.GetLastError();
			if (lastError is HttpException && (lastError as HttpException).GetHttpCode() == 404)
			{				
				new HandleUrlRequest().routeRequestUrl_for404();                                          
			}						
		}

		 
		protected void Application_Start				(object sender, EventArgs e)		
        {
            PublicDI.log.LogRedirectionTarget = new MemoryLogger();
        }
		protected void Session_Start					(object sender, EventArgs e)		{ }	

		protected void Application_BeginRequest			(object sender, EventArgs e)		
        {
            new HandleUrlRequest().routeRequestUrl();                                  
        }
        protected void Application_AcquireRequestState  (object sender, EventArgs e) // this doesn't work for non aspx requests
        {            
            //new HandleUrlRequest().routeRequestUrl();                                  
        }
        
		protected void Application_AuthenticateRequest	(object sender, EventArgs e)		{ }
		protected void Session_End						(object sender, EventArgs e)		{ }
		protected void Application_End					(object sender, EventArgs e)		{ }
	}
}