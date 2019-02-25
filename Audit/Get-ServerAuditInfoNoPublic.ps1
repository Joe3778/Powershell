. \\tsclient\p\Brianb\Audit\Get-NetworkStatistics1.ps1

$env:COMPUTERNAME | Out-File -FilePath \\tsclient\p\Brianb\Audit\ServerAuditInfo.txt -Append

Get-Service * | Where-Object {$_.status -eq "Running"} | Out-File -FilePath \\tsclient\p\Brianb\Audit\ServerAuditInfo.txt -Append

Get-NetworkStatistics | Format-Table | Out-File -FilePath \\tsclient\p\Brianb\Audit\ServerAuditInfo.txt -Append

Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | Format-Table | Out-File -FilePath \\tsclient\p\Brianb\Audit\ServerAuditInfo.txt -Append
#Get-LocalUser | Format-Table | Out-File -FilePath \\tmg.net\dfs\Users\brianb\Desktop\Audit\PCI\ServerAuditInfo.txt -Append

# Add NTP Settings
w32tm /query /peers >> \\tsclient\p\Brianb\Audit\ServerAuditInfo.txt

net time >> \\tsclient\p\Brianb\Audit\ServerAuditInfo.txt

