<cfquery name="artQ" datasource="cfartgallery" >			  
    INSERT INTO ART (ARTISTID,ARTNAME,DESCRIPTION,PRICE,LARGEIMAGE,MEDIAID,ISSOLD)
        Values ( 2,'Test' ,'Test',6000 ,'as.jpg' ,1,0 ) 
</cfquery>