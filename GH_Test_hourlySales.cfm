<cfoutput>
<cfset request.rmsdsn = "rms_live">

update script log
<cfquery name="scriptLogStart" datasource="#request.rmsdsn#">
update log_scriptExecution
set lastStarted = GETDATE ()
where scriptName = 'hourlySales.cfm'
</cfquery>
It is Running <br>
Step One:<br>
<cfquery name="Instore" datasource="#request.rmsdsn#">
select count(transactionnumber) as 'Transactions', sum(total) as 'Sales', cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar) as 'Time'
FROM         dbo.[Transaction] AS t INNER JOIN
                   dbo.Batch AS b ON b.BatchNumber = t.BatchNumber LEFT OUTER JOIN
                   dbo.Register AS r ON r.ID = b.RegisterID
 where  datediff(day, [Time], GETDATE()) = 0 and RegisterID not in (7, 8, 10, 9, 33, 36)
</cfquery>
 Step Two:<br>
<cfquery name="Online" datasource="#request.rmsdsn#">
select count(transactionnumber) as 'Transactions', sum(total) as 'Sales', cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar) as 'Time'
FROM         dbo.[Transaction] AS t INNER JOIN
                   dbo.Batch AS b ON b.BatchNumber = t.BatchNumber LEFT OUTER JOIN
                   dbo.Register AS r ON r.ID = b.RegisterID
 where  datediff(day, [Time], GETDATE()) = 0 and RegisterID  in (7, 8, 10, 9, 33, 36)
</cfquery>
Step Three:<br>
<cfquery name="Total" datasource="#request.rmsdsn#">
select count(transactionnumber) as 'Transactions', sum(total) as 'Sales', cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar) as 'Time'
FROM         dbo.[Transaction] AS t INNER JOIN
                   dbo.Batch AS b ON b.BatchNumber = t.BatchNumber LEFT OUTER JOIN
                   dbo.Register AS r ON r.ID = b.RegisterID
 where  datediff(day, [Time], GETDATE()) = 0 
</cfquery>
Step 4.2: Mail<br>

<cfmail
            to="Ed@USOUTDOOR.com"
			cc=	"Amber@USOUTDOOR.com, Jaime.Bitle@USOUTDOOR.com,Jamie@SOUTDOOR.com, jamieowhalen@gmail.com"                  
            from="Whalen@USOUTDOOR.com"
            subject="Hourly Sales #dateFormat(now(),"dddd")# #dollarFormat(total.Sales)#" type="html">

<div style="font-family:arial;font-weight:bold">
#timeformat(Instore.Time)# #DateFormat(now(),"MM/DD")#<br /><br />
Instore Transactions = #instore.Transactions#  Total #dollarFormat(instore.Sales)#<br /> <br />
Online Transactions = #Online.Transactions#    Total #dollarFormat(Online.Sales)#<br /> <br />
Total Transactions = #Total.Transactions#      Total #dollarFormat(total.Sales)#<br /> <br />

<br /> <br /> <br />
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
<br /> 
                                                                                                      
endscript
</div>





</cfmail>
done

<cfquery name="scriptLogLastRan" datasource="#request.rmsdsn#">
update log_scriptExecution
set lastFinished = GETDATE ()
where scriptName = 'hourlySales.cfm'
</cfquery>

</cfoutput>