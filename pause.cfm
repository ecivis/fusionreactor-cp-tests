<cfsilent>
	<cfset ls = structNew()/>

	<!--- Number of seconds to pause execution --->
	<cfset ls.timeout = 0/>
	
	<cfif structKeyExists(url, "timeout") and isNumeric(url.timeout) and url.timeout gte 0 and url.timeout lte 300>
		<cfset ls.timeout = url.timeout/>
	</cfif>

	<cfset ls.ticks = getTickCount()/>
	<cfif ls.timeout>
		<cfset sleep(ls.timeout * 1000)/>
	</cfif>

	<cfcontent type="text/plain" reset="true"/>
	<cfsetting enablecfoutputonly="true"/>
</cfsilent>
<cfoutput>Completed in #(getTickCount() - ls.ticks)# ms</cfoutput>