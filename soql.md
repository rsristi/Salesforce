# SOQL


## Table of contents

- [Overview](#Overview)
- [Always Handle Your Exceptions](#Always-Handle-Your-Exceptions)
- [Design for Debugging](#Design-for-Debugging)
- [Take Care of Performance](#Take-Care-of-Performance)
- [Know Your Governor Limits](#Know-Your-Governor-Limits])
- [Other](#Other)


## Overview



## Always Handle Your Exceptions



## Design for Debugging


## Take Care of Performance


## Know Your Governor Limits

* All queries should have Where AND Limit Clause

## Other

* When we Working with Very Large SOQL Queries?
  ```
    use a SOQL query "for loop" as in one of the following examples-
     // Use this format if you are not executing DML statements
     for (Account a : [SELECT Id, Name FROM Account
                  WHERE Name LIKE 'Acme%']) {
     // Your code without DML statements here
      }

      // Use this format for efficiency if you are executing DML statements
       for (List<Account> accts : [SELECT Id, Name FROM Account
                            WHERE Name LIKE 'Acme%']) {
      // Your code here
      update accts;
      }
 ```


* When we use query for trigger they must be more selective Queries for processing in large amount of records:
 ```

 // If the count of records returned by
 SELECT COUNT() FROM Account WHERE CustomField__c = 'ValueA'
 // is lower than the selectivity threshold, and CustomField__c is indexed, the query is selective.
 SELECT Id FROM Account WHERE Name != '' AND CustomField__c = 'ValueA'
 ```


* How to avoid null values while searching records?
 ```

 // Note WHERE clause verifies that threadId is not null
   for(CSO_CaseThread_Tag__c t :
      [SELECT Name FROM CSO_CaseThread_Tag__c
      WHERE Thread__c = :threadId AND
      threadID != null])
 ```     

* When you have to find all records from object including deleted records and archived activities?
 ```

 SELECT COUNT() FROM Contact WHERE AccountId = a.Id ALL ROWS
 //You can use ALL ROWS to query records in your organization's Recycle Bin. You cannot use the ALL ROWS keywords with
 the FOR UPDATE keywords.
 ```

* Creating a list from a SOQL query, with the DML update method.
 ```

 List<Account> accs = [SELECT Id, Name FROM Account WHERE Name = 'Siebel'];
  // Loop through the list and update the Name field
 for(Account a : accs){
   a.Name = 'Oracle';
 }
 // Update the database
 update accs;
 ```

* When you try to retrieves 200 contacts from a single account using for loop without any exception.
 ```

 //To avoid getting this exception, use a for loop to iterate over the child records
 for (Account acct : [SELECT Id, Name, (SELECT Id, Name FROM Contacts)
                    FROM Account WHERE Id IN ('<ID value>')]) {
    Integer count=0;
    for (Contact c : acct.Contacts) {
        count++;
    }
 }
 ```


* How to create a empty list in SOQl?
 ```
 List<Account> myList = new List<Account>();
```

* How to Auto-populating a List from a SOQL Query?
 ```

 List<Account> accts = [SELECT Id, Name FROM Account LIMIT 1000];
 ```
* How to add a Retrieving List Elements through SOQL quires?
 ```
  List<Account> myList = new List<Account>(); // Define a new list
  Account a = new Account(Name='Acme'); // Create the account first
  myList.add(a);                    // Add the account sObject
  Account a2 = myList.get(0);      // Retrieve the element at index 0
 ```

* When you have a million accounts records and you have to find the selected records by using their date?
 ```
 SELECT id FROM Account WHERE CreatedDate  > 2013-01-01T00:00:00Z //for standard field
 SELECT id FROM Account WHERE CustomIndexedDate__c  > 2013-01-01T00:00:00Z // for custmize field
 ```       

* Using NOT EQUAL TO by selective query?
 ```
 SELECT id FROM Case WHERE Status != ‘Closed’ // Generally used query
 SELECT id FROM Case WHERE Status IN (‘New’, ‘On Hold’, ‘Pending’, ‘ReOpened’) // Selective Query

 //In this case, you do want to add additional filters to reduce the number of records retrieved
 SELECT id FROM Case WHERE NOT (Status IN (‘On Hold’, ‘Pending’, ‘ReOpened’))
 SELECT id FROM Case WHERE Status IN ('New', 'Closed') AND Priority = ‘High’
 ```      
* How can LastModifiedDate filters affect SOQL performance?
 ```

 Select Id, Name from Account where LastModifiedDate > 2014-11-08T00:00:00Z
 Select Id, Name from Account where LastModifiedDate = CustomDate__c
 Select Id, Name from Account where LastModifiedDate < CutoffDate__c
 ```
* Selective query using of Date function
 ```

  SELECT Title FROM Position__c WHERE CALENDAR_MONTH(Date_Closed__c) = 2
 ```
* GROUP BY is used in conjunction with aggregate functions to group the result-set by one or more columns.
 ```

 SELECT Position__r.Department__c deptname, COUNT(id) total FROM Job_Application__c GROUP BY Position__r.Department__c
 ```
* use of HAVING clause along with GROUP BY clause to filter the results returned by aggregate functions.
 ```

 SELECT Position__r.Department__c deptname, COUNT(id) total FROM Job_Application__c GROUP BY
 Position__r.Department__c HAVING  COUNT(id)>1
 ```
* RELATIONSHIP QUERIES IN SOQL
 ```

 Select Id, Name, Account.Name From Contact   //Basic Child to Parent
 Select Id, Name, Account.Parent.Name From Contact   //Expanded Child to Parent
 Select Id, Name (Select Name From Contacts) From Account  //Basic Parent to Child
 Select Id, Name, Account.Name (Select Quantity, UnitPrice, TotalPrice, PricebookEntry.Name,
 PricebookEntry.Product2.Family From  OpportunityLineItems) From Opportunity  //Combined Child to Parent and Parent to Child
 ```
* SOQL has a list of functions that deal with dates which makes your life a lot easier
  ```

  1) CALENDAR functions: CALENDAR_MONTH, CALENDAR_QUARTER, CALENDAR_YEAR
  2) DAYDAY : DAY_IN_MONTH, DAY_IN_WEEK, DAY_IN_YEAR, DAY_ONLY
  3) FISCAL: FISCAL_MONTH, FISCAL_QUARTER, FISCAL_YEAR
  4) HOUR function: HOUR_IN_DAY
  5) WEEK function: WEEK_IN_MONTH, WEEK_IN_YEAR
  ```
