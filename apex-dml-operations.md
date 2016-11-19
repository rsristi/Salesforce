### Apex DML Operations


## Table of contents

- [Quick start](#quick-start)
- [Bugs and feature requests](#bugs-and-feature-requests)
- [Documentation](#documentation)
- [Always Handle Your Exceptions](Always-Handle-Your-Exceptions)
- Design for Debugging
- Take Care of Performance
- [Know Your Governor Limits](#Know-Your-Governor-Limits])
- Bulkify your Code
- [Copyright and license](#copyright-and-license)

## Quick start


You can perform DML operations using the Apex DML statements or the methods of the Database class.


### Always Handle Your Exceptions
1. Always Always Catch Your Exceptions
2. System.debug Your Exceptions
3. Log/Communicate Your Exceptions - When you catch exceptions, you lose the default notification mechanisms that exist with uncaught exceptions—we'll need to build our own. Stop hoping your users will report errors.
4. We may need to handle our own rollback using Apex transaction control.
5. Usually empty try-catch is a bad idea because you are silently swallowing an error condition and then continuing execution.
6. Don't over do it. Do not put all your code in one big try-catch - https://developer.salesforce.com/forums/?id=906F00000009BhUIAU


* DML Statements  
With DML statements, when you get a DMLException, you will get information for the failed records only, so you may have to work with a shorter set of data (assuming some records did not fail), so you need to maintain two indexes in your code. You can use this code as a template:

```
Savepoint sp = Database.setSavepoint();

List<Account> acs = new List<Account>();
acs.add(new Account());
try {
  insert acs;
  system.debug('Success');
  } catch (System.DMLException ex) {
    String msg = '';
    for (Integer exceptIdx = 0; exceptIdx < ex.getNumDml(); exceptIdx++) {
      Integer dataIdx = ex.getDmlIndex(exceptIdx);
      msg += 'Account: ' + acs[dataIdx].Name + ' failed!';
      msg += 'Error Type: ' +  ex.getDmlType(exceptIdx);
      msg += 'Error Message: ' +  ex.getDmlMessage(exceptIdx);
      msg += 'Fields with errors: ' + ex.getDmlFieldNames(exceptIdx);
      msg += '\r\n';
    }
    System.debug(msg);
    Database.rollback(sp); //may or may not need to rollback
  }

  finally {
    //optional finally block
    //code to run whether there is an exception or not
  }

```


* DML Database Methods
When you work with the List<SaveResult> you will information for all the records (failed or not), so you will have a set of data of exactly the same size of the original set of data records, so you only need to maintain one index, but check if the particular record was successful or not. You can use this code as a template:

```
List<Account> acs = new List<Account>();
acs.add(new Account());
List<Database.SaveResult> srs = Database.insert(acs, FALSE);
String msg = '';
for(Integer idx = 0; idx < srs.size(); idx++) {
	Database.SaveResult sr = srs[idx];
	if (!sr.isSuccess()) {
			msg += 'Account: ' + acs[idx].Name + ' failed!';
			for (Database.Error er : sr.getErrors()) {
				msg += 'Error (' +  er.getStatusCode() + '):' + er.getMessage();
				msg += '\r\n';
			}
	}
}
System.debug(msg);

```


### Design for Debugging
1. System.debug Your Exceptions
2. System.debug Your Successes
3. Communicate


* Make the insert not fail if one record fails
List<Account> accounts = new List<Account>();

// Populate the accounts list

// insert accounts; Instead of insert, use a DML database method with a value of false for the optional opt_allOrNone parameter

Database.SaveResult[] result = Database.Insert(accounts, false);

Use DML database methods if you want to allow partial success of a bulk DML operation—if a record fails, the remainder of the DML operation can still succeed. Your application can then inspect the rejected records and possibly retry the operation. When using this form, you can write code that never throws DML exception errors. Instead, your code can use the appropriate results array to judge success or failure. Note that DML database methods also include a syntax that supports thrown exceptions, similar to DML statements.

* Make the update not fail if one record fails


### Performance

SOQL / DML / Loops Performance

```
public void Method10(ID AccountID) {
	List<Contact> contacts = [SELECT ID
                              FROM Contact WHERE AccountID = :AccountID];
	Integer contactsSize = contacts.size();
	for (Integer i = 0; i < contactsSize; i++) {
		contacts[i].DoNotCall = true;
	}
	update contacts;
  ```


  ## Know Your Governor Limits
  Use of the Limits Apex Methods to Avoid Hitting Governor Limits

### Links
https://eltoro.secure.force.com/ArticleViewer?id=a07A000000PyGjkIAF
https://eltoro.secure.force.com/SoqlDmlLoopsPerformance
