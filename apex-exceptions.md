# Apex Exceptions


## Table of contents

- [Overview](#Overview)


## Overview

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


### Links
* https://eltoro.secure.force.com/HowDoIConvertAnIdFrom15To18Characters
