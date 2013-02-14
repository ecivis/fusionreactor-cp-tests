<cfsilent>
	<cfset ls = structNew()/>

	<!--- Number of almost-simultaneous requests to make; between 0 and 50 --->
	<cfset ls.requests = 5/>
	<!--- Number of seconds to pause execution; between 0 and 300 --->
	<cfset ls.timeout = 10/>
	<!--- Target --->
	<cfset ls.targetHost = "127.0.0.1"/>
	<cfset ls.targetPort = 80/>
	<cfset ls.targetURI = "/tests/fusionreactor/pause.cfm"/>

	<cfif structKeyExists(url, "requests") and isNumeric(url.requests) and url.requests gte 0 and url.requests lte 50>
		<cfset ls.requests = url.requests/>
	</cfif>
	<cfif structKeyExists(url, "timeout") and isNumeric(url.timeout) and url.timeout gte 0 and url.timeout lte 300>
		<cfset ls.timeout = url.timeout/>
	</cfif>
	<cfif structKeyExists(url, "targetHost") and len(url.targetHost)>
		<cfset ls.targetHost = url.targetHost/>
	</cfif>
	<cfif structKeyExists(url, "targetPort") and isNumeric(url.targetPort) and url.targetPort gte 1 and url.targetPort lte 65535>
		<cfset ls.targetPort = url.targetPort/>
	</cfif>
	<cfif structKeyExists(url, "targetURI") and len(url.targetURI)>
		<cfset ls.targetURI = url.targetURI/>
	</cfif>

	<cfset ls.nl = chr(10)/>
	<cfset ls.ticks = getTickCount()/>
	<cfset ls.threads = arrayNew(1)/>
	<cfset ls.threadList = ""/>
	<cfloop from="1" to="#ls.requests#" index="ls.i">
		<cfset ls.thread = structNew()/>
		<cfset ls.thread.name = "#ls.ticks#-#ls.i#"/>
		<cfset ls.thread.target =  "http://#ls.targetHost#:#ls.targetPort##ls.targetURI#?timeout=#ls.timeout#"/>
		<cfset ls.threadList = listAppend(ls.threadList, ls.thread.name)/>
		<cfset arrayAppend(ls.threads, duplicate(ls.thread))/>
	</cfloop>

	<cfcontent type="text/plain" reset="true"/>
	<cfsetting enablecfoutputonly="true"/>
</cfsilent>
<cfoutput>Starting #ls.requests# threads#ls.nl#</cfoutput>
<cfflush/>
<cfloop array="#ls.threads#" index="ls.thread">
	<cfoutput>Starting thread #ls.thread.name##ls.nl#</cfoutput>
	<cfthread action="run" name="#ls.thread.name#" priority="NORMAL" target="#ls.thread.target#">
		<cfhttp method="GET" url="#attributes.target#" timeout="300"/>
	</cfthread>
	<cfflush/>
</cfloop>
<cfthread action="join" name="#ls.threadList#"/>
<cfoutput>Completed in #(getTickCount() - ls.ticks)# ms</cfoutput>