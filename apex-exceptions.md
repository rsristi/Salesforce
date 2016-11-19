### Apex Exceptions


### Table of contents

- [Quick start](#quick-start)
- [Bugs and feature requests](#bugs-and-feature-requests)
- [Documentation](#documentation)
- [Always Handle Your Exceptions](Always-Handle-Your-Exceptions)
- Design for Debugging
- Take Care of Performance
- [Know Your Governor Limits](#Know-Your-Governor-Limits])
- Bulkify your Code
- [Copyright and license](#copyright-and-license)



### Quick start


You can have multiple Catch blocks to catch any of the 20 different kinds of exceptions. If you use a generic exception catcher, it must be the last Catch block.

```
try{
     //Your code here
} catch (ListException e) {
     //Optional catch of a specific exception type
     //Specific exception handling code here
} catch (Exception e) {
     //Generic exception handling code here
} finally {
     //optional finally block
     //code to run whether there is an exception or not
}

```




Links
https://eltoro.secure.force.com/HowDoIConvertAnIdFrom15To18Characters
