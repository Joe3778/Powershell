#Created by Joe Bechler
#11-05-2018
#This script can either be run manually or set as a scheduled task to email the output of the command.
#Updated 11-15-2018 by JAB
#Added more description to the body, included the command run

#Run command and store output
$cmdOutput = symrdf list -all | Out-String

#Add some text to the body and include the command output
$body =@"
Here is the sync report for s1vipems01 using 'symrdf list -all'
$cmdOutput
"@

#Send-MailMessage command to send the email.
Send-MailMessage -From s1vipems01@coop.org -To "Joe Bechler <joe.bechler@coop.org>", "Brad Lones <Brad.Lones@coop.org>", "Jonathan Lee <Jonathan.Lee@coop.org>" -Subject "SYMRDF Results" -Body $body -Smtpserver TMGSMTP.tmg.net
