#$ldapSearcher = new-object directoryservices.directorysearcher;
#$ldapSearcher.filter = "(objectclass=computer)";
Import-Module ActiveDirectory


$computers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"}
#-SearchBase "OU=Dev, OU=Non_PCI_Prod,OU=Servers, OU=TMG, DC=TMG, DC=NET"

foreach ($computer in $computers)
{
    #$compname = $computer.properties["name"]
	$compname = $computer.Name
    $ping = gwmi win32_pingstatus -f "Address = '$compname'"
    if($ping.statuscode -eq 0)
    {   
	   try
       {
            $ErrorActionPreference = "Stop"
            $wpa = Get-WmiObject -class SoftwareLicensingProduct -ComputerName $compname | Where{$_.LicenseStatus -NotMatch "0"}
                        if($wpa)
            {
                 foreach($item in $wpa)
                 {
                    $status = switch($item.LicenseStatus)
                    {
                      0 {"Unlicensed"}
                      1 {"Licensed"}
                      2 {"Out-Of-Box Grace Period"}
                      3 {"Out-Of-Tolerance Grace Period"}
                      4 {"Non-Genuine Grace Period"}
                      5 {"Notification"}
                      6 {"Extended Grace"}
                      default {"Unknown value"}
                    }
                    $compstat="Activation Status;{0}" -f $status
					write-output $compname";"$compstat
                 }
             }
             else
             {
                write-output $compname";Server;Unlicensed"
             }
       }
       catch 
       {
            write-output $compname";Server;does not have SoftwareLicensingProduct class, you have insufficient rights to query the computer or the RPC server is not available"
       }
       finally
       {
            $ErrorActionPreference = "Continue"
       }

    }
    else
    {
         write-output $compname";Server;Offline"
    }
    #[console]::WriteLine()
}