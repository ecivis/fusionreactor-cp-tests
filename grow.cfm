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
	<cfset ls.ticks = getTickCount()/>
	<cfset ls.victor = createObject("java", "java.util.Vector")/>
	<cfset ls.byteClass = createObject("java", "java.lang.Byte").TYPE/>
	<cfset ls.runtime = createObject("java", "java.lang.Runtime").getRuntime()/>
	<cfset ls.maxMem = ls.runtime.maxMemory()/>

	<cfset ls.watchdog = structNew()/>
	<cfset ls.watchdog.limits = structNew()/>
	<cfset ls.watchdog.limits.exceptions = 3/>
	<cfset ls.watchdog.limits.noops = 5/>
	<cfset ls.watchdog.triggered = ""/>
	<cfset ls.watchdog.caught = 0/>
	<cfset ls.watchdog.over = 0/>

	<cfcontent type="text/plain" reset="true"/>
	<cfsetting enablecfoutputonly="true"/>
</cfsilent>
<cfloop condition="true">
	<cfset ls.freeMem = ls.runtime.freeMemory()/>
	<cfset ls.percentFree = 100 * ls.freeMem / ls.maxMem/>
	<cfoutput>#numberFormat(ls.percentFree, "0.00")#%#ls.nl#</cfoutput>
	<cfflush/>
	<cfif ls.percentFree lte ls.limit>
		<cfbreak/>
	</cfif>

	<!--- Would the next step push us over the edge? --->
	<cfset ls.nextStep = ls.step * 1048576/>
	<cfif ls.nextStep gte ls.freeMem>
		<cfset ls.nextStep = ls.freeMem/>
		<cfset ls.watchdog.over = ls.watchdog.over + 1/>
	</cfif>

	<cftry>
		<cfset ls.bytes = createObject("java","java.lang.reflect.Array").newInstance(ls.byteClass, ls.nextStep)/>
		<cfset ls.victor.add(ls.bytes)/>
		<cfcatch>
			<cfset ls.watchdog.caught = ls.watchdog.caught + 1/>
			<cfset ls.watchdog.message = cfcatch.message/>
		</cfcatch>
	</cftry>

	<cfif ls.delay>
		<cfset sleep(ls.delay)/>
	</cfif>

	<cfif ls.watchdog.caught gt ls.watchdog.limits.exceptions>
		<cfset ls.watchdog.triggered = "caught"/>
		<cfbreak/>
	<cfelseif ls.watchdog.over gt ls.watchdog.limits.noops>
		<cfset ls.watchdog.triggered = "over"/>
		<cfbreak/>
	</cfif>
</cfloop>
<cfif ls.refractory>
	<cfset sleep(ls.refractory * 1000)/>
</cfif>
<cfif ls.watchdog.triggered eq "caught">
	<cfoutput>Warning: Watchdog abort was triggered after #ls.watchdog.limits.exceptions# exceptions.#ls.nl#</cfoutput>
	<cfoutput>#ls.watchdog.message##ls.nl#</cfoutput>
<cfelseif ls.watchdog.triggered eq "over">
	<cfoutput>Warning: Watchdog abort was triggered after #ls.watchdog.limits.noops# step size reductions.#ls.nl#</cfoutput>
</cfif>
<cfoutput>Completed in #(getTickCount() - ls.ticks)# ms</cfoutput>