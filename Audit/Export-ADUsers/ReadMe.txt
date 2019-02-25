Below are step-by-step-guide on how to use the Export-ADUsers module

1. Download and Unzip Export_ADUsers.zip
2. Copy the folder Export_ADUsers (Contains the module) to the following locations:
   \Documents\WindowsPowerShell\Modules and \Program Files\WindowsPowerShell\Modules
3. Open a Powershell prompt and run the command Import-Module Export-ADUsers
   If you receive any error, run Import-Module <path to module>\Export_ADUsers.psm1
4. To get help type the command: Get-Help Export-ADUsers -Detailed
5. To run an AD Report on an OU called "Accounts Users", run the command:

Export-ADUsers -SearchLoc "Accounts Users" -CSVReportPath 'C:\CSV' -ADServer 70411SRV

Note: Amend the parameters as required


If you require further assistance, you might contact me via the link below:

www.itechguides.com/contact-me
