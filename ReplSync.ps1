#Created by Joe Bechler
#01-11-2019
#This script can either be run manually or set as a scheduled task to send alert email and resume sync.


#Run command and store output
##The real check
# $cmdOutput = symrdf list -all | Out-String
##Testing check
$cmdOutput = type "C:\Users\Joe\Documents\GitHub\Powershell\Sample.out" | Out-String

$cmdOutputSplit = $cmdOutput -split "`n"

#$SuspendedLine = ($cmdOutput | Select-String -Pattern 'Suspended').Matches.Value

#$SuspendedLines = $cmdOutputSplit | Select-String -Pattern 'Suspended' -AllMatches | %{$_.Line}
#$SuspendedLines = $cmdOutputSplit | Select-String -Pattern 'Suspended' -AllMatches 
$SuspendedLines = $cmdOutputSplit | Select-String -Pattern 'Suspended' -AllMatches | Out-String
#| %{$_.Line}

if (!$SuspendedLines) {exit}


#write-host $SuspendedLines

$SuspendedGroups = ($SuspendedLines | Select-String -Pattern 'R1:\d{1,}' -AllMatches).Matches.Value | Out-String

#write-host $SuspendedGroups

#$SuspendedUniqueGroup = Select-Object -InputObject $SuspendedGroups -Unique | Out-String

#$contents = $SuspendedGroups
#$hash = @{}

#foreach($content in $contents)
#{
#    $temp = $content.split(',')
#    if($hash.ContainsKey($temp[0]))  
#    {
#        $hash.Remove($temp[0])
 #   }
#    $hash.add($temp[0],$temp[1]);
#}

#$hash

$SuspendedGroups = $SuspendedGroups -split "`n"

write-host "All Groups found:"
$SuspendedGroups

#$lines = $SuspendedGroups
$TEST = @{}

# TEST EACH LINE
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


write-host "Duplicate Groups Rremoved:"
$UniqueGroups


# Process EACH LINE
Foreach ($Group in $UniqueGroups)
{
 $UniqueGroupNum = ($Group | Select-String -Pattern ':\d{1,}').Matches.Value
 $UniqueGroupNum = $UniqueGroupNum -replace '[:]',''
 if ($UniqueGroupNum) {
	$command = 'symrdf resume -file rdfg$UniqueGroupNum.txt -sid 696 -rdfg $UniqueGroupNum -noprompt'
	#$command = 'dir *.*$UniqueGroupNum'
	#Invoke-Expression $command
	#Invoke-Expression 'symrdf resume -file rdfg$UniqueGroupNum.txt -sid 696 -rdfg $UniqueGroupNum -noprompt'
	#$WhatDone += 'symrdf resume -file rdfg$UniqueGroupNum.txt -sid 696 -rdfg $UniqueGroupNum -noprompt' | out-string
	Invoke-Expression 'dir *.*$UniqueGroupNum'
	$WhatDone += "dir *.*$UniqueGroupNum" | out-string
	#$WhatDone += $command | out-string
	}
 
}
$WhatDone


#"& '.\Test Document.html'"







#$UniqueGroupsSplit = $UniqueGroups -split "`n"

#$UniqueGroupNum = $UniqueGroupsSplit | Select-String -Pattern '\d+$' -AllMatches | Out-String

#write-host "Should just be numbers:"
#$UniqueGroupNum

#symrdf resume -file rdfg1.txt -sid 696 -rdfg 1 -noprompt


#write-host $SuspendedUniqueGroup

##Add some text to the body and include the command output
#$body =@"
#Here is the sync report for s1vipems01 using 'symrdf list -all'
#$cmdOutput
#"@
#
##Send-MailMessage command to send the email.
#Send-MailMessage -From s1vipems01@coop.org -To "Joe Bechler <joe.bechler@coop.org>", "Brad Lones <Brad.Lones@coop.org>", "Jonathan Lee <Jonathan.Lee@coop.org>" -Subject "SYMRDF Results" -Body $body -Smtpserver TMGSMTP.tmg.net
