/**
 * Copyright (c) 2016, VersatileCapitalist Software, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * ExceptionHandler Class to process and log different types of exceptions
 **/
public with sharing class ExceptionHandler
{


// A Simple logger. Maybe we should use a nested class/object
	private List<JobError> jobErrors = new List<JobError>();

  //constructor
	public ExceptionHandler()
	{

	}

	public saveLogs ()
	{

   //prepare the Logs
        try
        {

          // read some custom setting and accordingly
          LogConfig__c config = LogConfig__c.getInstance();
          config.APIKey__c = APIKey;

        	// save the logs in some object


        	// Next step

        }
        catch(Exception e)
        {
        	ApexPages.addMessages(e);
        }
		return null;
	}


	public showMessage()
	{
        try
        {
        	// Make Heroku API call to validate applicaiton name
        	makeRequest('https://api.heroku.com/apps/'+ApplicationName, 'GET', null);

        	// Store API key in a custom setting
        	HerokuConfig__c config = HerokuConfig__c.getInstance();
        	config.AppName__c = ApplicationName;
        	upsert config;

        	// Next step
        	CompletedStep2 = true;
        	ShowStep3 = true;
        }
        catch(Exception e)
        {
        	ApexPages.addMessages(e);
        }
		return null;
	}

	public sendToSentry()
	{
        try
        {
        	// Make Sentry API call to send log details from this org
			String body =
				'{' +
				  '"SFUSER": "' + UserName + '",' +
				  '"SFPASSWORD": "' + Password+Token + '"' +
				'}';
			makeSentryRequest('https://api.heroku.com/apps/' + ApplicationName + '/config_vars', 'PUT', body);

			// Restart page
			return init();
        }
        catch(Exception e)
        {
        	ApexPages.addMessages(e);
        }
		return null;
	}


// capability to send out logs and exceptions via email
  public void sendEmail ()
  {
    // Simple notifiation of any errors received via email
    if(jobErrors.size() > 0)
    {
      // Email address from user
      Map<Id, String> usersEmail =
        new UsersSelector().getUsersEmail(
          new Set<Id> { UserInfo.getUserId() });
      // Construct email body
      String emailBody = '';
      for(JobError jobError : jobErrors)
      {
        List<String> failedOpps = new List<String>();
        for(Opportunity opp : jobError.records)
          failedOpps.add(opp.Name);
        emailBody+= String.format('<p>Error {0} occured during the processing of Opportunities {1}</p>',
          new List<String> { jobError.message, String.join(failedOpps, ',') });
      }
      // Send email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(new String[] { usersEmail.get(UserInfo.getUserId()) });
      mail.setReplyTo(usersEmail.get(UserInfo.getUserId()));
      mail.setSenderDisplayName(userInfo.getUserName());
      mail.setSubject('Create Invoice Job Failures');
      mail.setHtmlBody(emailBody);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  }

  /**
   * Simple wrapper class containing the error message and the records in scope at the time
   **/
  public class JobError
  {
    public String message;
    public List<Opportunity> records;
  }
  }

//capability to send out email
	private String makeRequest(String url, String method, String body)
	{
		// Makes a REST call to the
		HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setHeader('Accept', 'application/json');
 		req.setHeader('Authorization', 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf( ':' + APIKey)));
        req.setEndpoint(url);
        req.setMethod(method);
        if(body!=null)
        	req.setBody(body);
        res = http.send(req);
        if(res.getStatusCode() != 200)
        	throw new ControllerException(res.toString() + ' ' + res.getBody());
        return res.getBody();
	}

	private class ExceptionHandlerException extends Exception
	{

	}
}
