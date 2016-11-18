* when we Working with Very Large SOQL Queries?
---> use a SOQL query "for loop" as in one of the following examples-
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

 
 
* When we use query for trigger they must be more selective Queries for processing in large amount of records.
 ---> If the count of records returned by SELECT COUNT() FROM Account WHERE CustomField__c = 'ValueA' is lower than the selectivity   threshold, and CustomField__c is indexed, the query is selective.
 "SELECT Id FROM Account WHERE Name != '' AND CustomField__c = 'ValueA' "


* How to avoid null values while searching records?
 ----> // Note WHERE clause verifies that threadId is not null

   for(CSO_CaseThread_Tag__c t : 
      [SELECT Name FROM CSO_CaseThread_Tag__c 
      WHERE Thread__c = :threadId AND
      threadID != null])
      
      
      
 
