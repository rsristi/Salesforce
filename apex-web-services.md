# Apex Web Services 


## Table of contents

- [Overview](#Overview)
- [Always Handle Your Exceptions](#Always-Handle-Your-Exceptions)
- [Design for Debugging](#Design-for-Debugging)
- [Take Care of Performance](#Take-Care-of-Performance)
- [Know Your Governor Limits](#Know-Your-Governor-Limits])
- [Other](#Other)

## Overview




1. Always catch the CalloutException

```
try {
    //Execute web service call here
    HTTPResponse res = http.send(req);

    //Helpful debug messages
    System.debug(res.toString());
    System.debug('STATUS:'+res.getStatus());
    System.debug('STATUS_CODE:'+res.getStatusCode());
} catch(System.CalloutException e) {
    //Exception handling goes here.... retry the call, whatever
}
```

2. Always set the timeout on the callout:
The default timeout is 10 seconds. The minimum is 1 millisecond and the maximum is 120 seconds.

```
HttpRequest req = new HttpRequest();
req.setTimeout(60000); // timeout in milliseconds - this is one minute
```

There is a maximum cumulative timeout for callouts by a single Apex transaction (currently 120 seconds - see the Apex Language Reference Guide for a definitive number). This time is additive across all callouts invoked by the Apex transaction.
The Apex callout request size must be smaller than a set maximum limit.
A governor limit is set on the number of web service calls or callouts per trigger or Apex class invocation.


If you have a JSON object as a String, you can return it by assigning it to the responseBody, like this

```
@RestResource(urlMapping='/MyService/*')
global class MyService {
    @HttpGet
    global static void sayHello() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{ "s" : "Hello", "i" : 1234 }');
    }


}

```

Alternatively, you can define an inline Apex class with the format you require. For example:

```
@RestResource(urlMapping='/MyService/*')
global class MyService {
    global class MyClass {
        public String s;
        public Integer i;

        public MyClass(String s, Integer i) {
            this.s = s;
            this.i = i;
        }
    }

    @HttpGet
    global static MyClass sayHello() {
        MyClass obj = new MyClass('Hello', 1234);

        return obj;
    }
}

```
