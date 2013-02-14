<cfsilent>
	<cfset ls = structNew()/>
	
	<cfset ls.props = createObject("java", "java.lang.System").getProperties()/>
	<cfset ls.runtime = createObject("java", "java.lang.Runtime").getRuntime()/>

	<cfset ls.mb = 1024 * 1024/>
	<cfset ls.mem = structNew()/>
	<cfset ls.mem.maxMem = ls.runtime.maxMemory() / ls.mb/>
	<cfset ls.mem.freeMem = ls.runtime.freeMemory() / ls.mb/>
	<cfset ls.mem.percentFree = 100 * ls.mem.freeMem / ls.mem.maxMem/>

	<cfcontent type="text/plain" reset="true"/>
	<cfsetting enablecfoutputonly="true"/>
</cfsilent>
<cfoutput>#ls.props["java.runtime.name"]# #ls.props["java.runtime.version"]#
Memory available: #numberFormat(ls.mem.freeMem, "0.0")# Mb of #numberFormat(ls.mem.maxMem, "0.0")# Mb (#numberFormat(ls.mem.percentFree, "0.00")#%)</cfoutput>
