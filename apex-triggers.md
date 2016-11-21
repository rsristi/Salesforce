# triggers

## Table of contents

- [Overview](#Overview)
- [Objects and Custom Fields](#Objects-and-Custom-Fields)
- [Design for Debugging](#Design-for-Debugging)
- [Take Care of Performance](#Take-Care-of-Performance)
- [Know Your Governor Limits](#Know-Your-Governor-Limits])
- [Other](#Other)

# Overview

After searching here and there and writing few triggers myself, I have come up with the following:

Follow proper naming conventions to make your code more logical and readable.
Write one-trigger per object.
Use trigger context-variables to identify specific event and performs tasks accordingly.
Logic-less triggers
Now, debugging in apex is itself serious pain, adding whole lot of logic in trigger and debugging it is... well you can guess. So, break your trigger logic in to trigger-handler classes.
Context-Specific Handler Methods
Using specific methods in your trigger-handler-class to keep your code clean and scalable.
Use a framework.
A framework! Why? It will make your code conform to the best practices, better testing, scalability and cleaner.
Keep the salesforce order-of-execution of events in mind (they will come in handy).
Understand when to use before-trigger and when to user after-trigger.
Write trigger logic to support bulk operations.
Triggers can't contain test methods. So, its unit tests must be saved in a separate file.
Use custom settings to turn the trigger On/Off.
Once deployed, any changes or making a trigger Active/Inactive, you would need to make the changes on sandbox and then push it from their using changeset or IDE. Using custom settings to make a decision on the trigger will make life easy.


### Links
* http://salesforce.stackexchange.com/questions/58454/what-are-the-best-practices-for-triggers
