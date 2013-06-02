<cfcomponent>
	
	<cffunction name="listArts" access="remote" returntype="struct" output="false">
		<cfargument name="page" />
		<cfargument name="pageSize" />
		<cfargument name="gridSortColumn" />
		<cfargument name="gridSortDirection" />

		<cfquery name="qC" datasource="cfartgallery" >
			Select * From ART
		</cfquery>	
		
		<cfif Len(arguments.gridSortColumn)>
			<cfquery name="qC" dbtype="query">
				SELECT * FROM qC ORDER BY #arguments.gridSortColumn# #arguments.gridSortDirection#
			</cfquery>
		<cfelse>
		</cfif>	
		
		<cfif NOT qC.recordcount>
			<cfset QueryAddRow(qC, 1) />
			<cfloop list="#qC.ColumnList#" index="columnName">
				<cfset QuerySetCell(qC, columnName, "") />
			</cfloop>
			<cfset QuerySetCell(qC, "ARTID", "-1") />
		</cfif>	
		<cfreturn QueryConvertForGrid(qC, arguments.page, arguments.pageSize) />
	</cffunction>


	<cffunction name="editForm" access="remote" output="false">        
        <cftry>
        	<cfquery name="artQ" datasource="cfartgallery" >  
                update ART set ARTISTID =  #arguments.ARTISTIDtxt#
							 , ARTNAME = '#arguments.ARTNAMEtxt#'
							 , DESCRIPTION = '#arguments.DESCRIPTIONtxt#'
							 , ISSOLD = #arguments.ISSOLDtxt#
							 , LARGEIMAGE = '#arguments.LARGEIMAGEtxt#'
							 , MEDIAID = #arguments.MEDIAIDtxt#
							 , PRICE = #arguments.PRICEtxt#
                where ARTID = #arguments.ARTIDtxt# 
            </cfquery> 
            
            <cfreturn true>                
        <cfcatch type="Any" >
			<cfreturn cfcatch.message />
        </cfcatch>        	
        </cftry>	  
	</cffunction>
	
</cfcomponent>