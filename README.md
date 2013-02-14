FusionReactor Test Pages
========================
The CFML files contained in this repository mimic the test pages mentioned in the [FusionReactor documentation](http://docs.intergral.com/display/FR452/Test+Pages).

pause.cfm
---------
Accepts a **timeout** (default: 0) argument in seconds between 0 and 300. The execution of the CFML will pause until the timeout has passed.

load.cfm
--------
Accepts multiple arguments:
- **requests** (default: 5) The number of threads to start, each one making an HTTP request. The response from the target server is not saved or displayed.
- **timeout** (default: 10) A value sent to the HTTP request target, instructing that server to wait the specific number of seconds before returning a response.
- **targetHost** (default: 127.0.0.1) The hostname or IP address to use in making the HTTP request.
- **targetPort** (default: 80) The TCP port to use in making the HTTP request. It should be numeric.
- **targetURI** (default: /tests/fusionreactor/pause.cfm) The URI to use in making the HTTP request. The timeout value above will be appended to this value as a query string. It should start with a leading slash.

While load.cfm will function to make long running requests to trigger FusionReactor request protection, it is limited by the number of threads that the CFML engine can spawn. To really blast a server with requests, it would be better to create a simple [JMeter](https://jmeter.apache.org/) test plan to hit pause.cfm with a few dozen user threads.

grow.cfm
--------
Accepts multiple arguments:
- **limit** (default: 25) This value represents a percent of maximum memory that is reported free. When the virtual machine indicates that less free memory is available than the specified value it will not continue to create new objects.
- **delay** (default: 100) The number of milliseconds to pause between iterations when creating new objects intended to consume memory.
- **step** (default: 10) The number of megabytes that each iteration step will allocate to a new object.
- **refractory** (default: 0) The number of seconds that the test page will wait after reaching the free memory limit before returning.

system.cfm
----------
This test page will output the Java version and return without delay.
