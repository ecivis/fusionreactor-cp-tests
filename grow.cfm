<cfsilent>
	<cfset ls = structNew()/>

	<!--- Percentage of free memory at which iterations will halt; between 0 and 100, obviously --->
	<cfset ls.limit = 25/>
	<!--- Number of milliseconds to wait between each iteration; between 0 and 10000 --->
	<cfset ls.delay = 100/>
	<!--- Number of Mb to waste on each iteration; between 0 and 1000 --->
	<cfset ls.step = 10/>
	<!--- Number of seconds to wait after wasting memory; between 0 and 300 --->
	<cfset ls.refractory = 0/>

	<cfif structKeyExists(url, "limit") and isNumeric(url.limit) and url.limit gt 0 and url.limit lt 100>
		<cfset ls.limit = url.limit/>
	</cfif>
	<cfif structKeyExists(url, "delay") and isNumeric(url.delay) and url.delay gte 0 and url.delay lte 10000>
		<cfset ls.delay = url.delay/>
	</cfif>
	<cfif structKeyExists(url, "step") and isNumeric(url.step) and url.step gte 0 and url.step lte 1000>
		<cfset ls.step = url.step/>
	</cfif>
	<cfif structKeyExists(url, "refractory") and isNumeric(url.refractory) and url.refractory gte 0 and url.refractory lte 300>
		<cfset ls.refractory = url.refractory/>
	</cfif>

	<cfset ls.nl = chr(10)/>
	<cfset ls.victor = createObject("java", "java.util.Vector")/>
	<cfset ls.byteClass = createObject("java", "java.lang.Byte").TYPE/>
	<cfset ls.runtime = createObject("java", "java.lang.Runtime").getRuntime()/>
	<cfset ls.maxMem = ls.runtime.maxMemory()/>

	<cfcontent type="text/plain" reset="true"/>
	<cfsetting enablecfoutputonly="true"/>
</cfsilent>
<cfloop condition="true">
	<cfset ls.free = 100 * ls.runtime.freeMemory() / ls.maxMem/>
	<cfoutput>#numberFormat(ls.free, "0.00")#%#ls.nl#</cfoutput>
	<cfflush/>
	<cfif ls.free lte ls.limit>
		<cfbreak/>
	</cfif>

	<cfset ls.bytes = createObject("java","java.lang.reflect.Array").newInstance(ls.byteClass, ls.step * 1048576)/>
	<cfset ls.victor.add(ls.bytes)/>
	<cfif ls.delay>
		<cfset sleep(ls.delay)/>
	</cfif>
</cfloop>
<cfif ls.refractory>
	<cfset sleep(ls.refractory * 1000)/>
</cfif>