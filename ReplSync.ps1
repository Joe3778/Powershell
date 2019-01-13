##Created by Joe Bechler
##01-11-2019
##This script can either be run manually or set as a scheduled task to send alert email and resume sync.


##Run command and store output
##The real check
$cmdOutput = symrdf list -all | Out-String
##Testing check
#$cmdOutput = type "C:\Scripts\Sample.out" | Out-String

$cmdOutputSplit = $cmdOutput -split "`n"

$SuspendedLines = $cmdOutputSplit | Select-String -Pattern 'Suspended' -AllMatches | Out-String
#write-host $SuspendedLines

if (!$SuspendedLines) {exit}

$SuspendedGroups = ($SuspendedLines | Select-String -Pattern 'R1:\d{1,}' -AllMatches).Matches.Value | Out-String
#write-host $SuspendedGroups

$SuspendedGroups = $SuspendedGroups -split "`n"

#write-host "All Groups found:"
#$SuspendedGroups

$TEST = @{}

## Remove Duplicates
$UniqueGroups = Foreach ($line in $SuspendedGroups)
{
 if ($TEST.$line)
    {
      #Write-Host "LINE WITH DUPLICATE: $LINE"
    }
 else
    { 
      $TEST.$line = $true
      $line
    }
    
}


#write-host "Duplicate Groups Rremoved:"
#$UniqueGroups


## Process EACH LINE
Foreach ($Group in $UniqueGroups)
{
 $UniqueGroupNum = ($Group | Select-String -Pattern ':\d{1,}').Matches.Value
 $UniqueGroupNum = $UniqueGroupNum -replace '[:]',''
 if ($UniqueGroupNum) {
	#Invoke-Expression 'symrdf resume -file D:\VMAX_CLI_Files\rdfg$UniqueGroupNum.txt -sid 696 -rdfg $UniqueGroupNum -noprompt'
	#Invoke-Expression 'symrdf $UniqueGroupNum' ##For Testing
	$WhatDone += "symrdf resume -file D:\VMAX_CLI_Files\rdfg$UniqueGroupNum.txt -sid 696 -rdfg $UniqueGroupNum -noprompt`n"
	$WhatDone += "`r`n"
	}
 
}
#write-host "Commands Run:"
#$WhatDone


##Add some text to the body and include the command output
$body =@"
Here are the suspended groups:
$SuspendedLines

Commands run to resume them:
$WhatDone

"@

##Send email message
Send-MailMessage -From s1vipems01@coop.org -To "Joe Bechler <joe.bechler@coop.org>", "Brad Lones <Brad.Lones@coop.org>", "Jonathan Lee <Jonathan.Lee@coop.org>" -Subject "VMAX Suspended Groups" -Body $body -Smtpserver TMGSMTP.tmg.net
