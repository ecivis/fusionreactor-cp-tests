<cfsilent>
	<cfset ls = structNew()/>
	
	<cfset ls.props = createObject("java", "java.lang.System").getProperties()/>

	<cfcontent type="text/plain" reset="true"/>
	<cfsetting enablecfoutputonly="true"/>
</cfsilent>
<cfoutput>#ls.props["java.runtime.name"]# #ls.props["java.runtime.version"]#</cfoutput>
