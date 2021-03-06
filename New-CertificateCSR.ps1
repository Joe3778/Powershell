<# 
.Synopsis 
   Dynamically creates a certificate policy file and generates a CSR based on the file.   
   The INF and CSR are saved to a file with the same name as the hostname provided 
    
   Outputs:  
    
   hostname.inf (policy file) 
   hostname.req (CSR to provide to CA) 
  
.DESCRIPTION 
   Dynamically creates a certificate policy file and generates a CSR based on the file.   
   The INF and CSR are saved to a file with the same name as the hostname provided 
    
   Outputs:  
    
   hostname.inf (policy file) 
   hostname.req (CSR to provide to CA) 
  
.EXAMPLE 
   .\New-CertificateCSR.ps1 -HostName "Test.test.com"  
   CertReq: Request Created 
.EXAMPLE 
   .\New-CertificateCSR.ps1 -HostName "TTtemp1.temp.com" -OrganizationalUnit "Zelle" 
   CertReq: Request Created 
#> 
[CmdletBinding()] 
[Alias()] 
[OutputType([int])] 
Param 
( 
    # HostName provides the FQDN name of the service endpoint in the subject name (CN) 
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)] 
    [string]$HostName, 
  
    <# Output provides the Output filename for the inf file 
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=1)] 
    $Output, 

    #> 
    # OrganizationalUnit provides the Organizational Unit value to use in the subject name (OU) 
    [Parameter(Mandatory=$false)] 
    [string]$OrganizationalUnit, 
    
    # Organization provides the Organization value to use in the subject name (O) 
    [Parameter(Mandatory=$false)] 
    [string]$Organization = "CU Cooperative Systems, Inc.", 
    
    # Locality provides the Locality value to use in the subject name (L) 
    [Parameter(Mandatory=$false)] 
    [string]$Locality = "Rancho Cucamonga", 
     
    # State provides the State value to use in the subject name, no abbreviations (S) 
    [Parameter(Mandatory=$false)] 
    [string]$State = "California", 
     
    # CountryName provides the CountryName value to use in the subject name (C) 
    [Parameter(Mandatory=$false)] 
    [string]$CountryName = "US", 
     
    # Email provides the Email value to use in the subject name (E) 
    [Parameter(Mandatory=$false)] 
    [string]$Email 
  
) 
  
# Construct Subject Line 
if($HostName) {  
    # Ensure the hostname is all lowercase 
    $HostName = $HostName.ToLower() 
    $Subject = "CN=$HostName"  
} else { break; } 
if($OrganizationalUnit) { $Subject = "$Subject;OU=$OrganizationalUnit" } 
if($Organization) { $Subject = "$Subject;O=$Organization" } 
if($Locality) { $Subject = "$Subject;L=$Locality" } 
if($State) { $Subject = "$Subject;S=$State" } 
if($CountryName) { $Subject = "$Subject;C=$CountryName" } 
if($Email) { $Subject = "$Subject;E=$Email" } 
$InfOutput = Join-Path -Path $(Get-Location) -ChildPath "$HostName.inf" 
$CSROutput = Join-Path -Path $(Get-Location) -ChildPath "$HostName.req" 
  
$InputFileTemplate = @" 
[Version]  
Signature="`$Windows NT`$" 
  
[NewRequest] 
Subject = "$Subject" 
X500NameFlags = 0x40000000         ; Provides use of semi colon as separator 
Exportable = TRUE                  ; Private key is not exportable  
KeyLength = 2048                    ; Common key sizes: 512, 1024, 2048, 4096, 8192, 16384  
KeySpec = 1                         ; AT_KEYEXCHANGE  
KeyUsage = 0xA0                     ; Digital Signature, Key Encipherment  
MachineKeySet = True                ; The key belongs to the local computer account  
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"  
ProviderType = 12  
SMIME = FALSE  
RequestType = CMC 
  
[Strings]  
szOID_SUBJECT_ALT_NAME2 = "2.5.29.17"  
szOID_ENHANCED_KEY_USAGE = "2.5.29.37"  
szOID_PKIX_KP_SERVER_AUTH = "1.3.6.1.5.5.7.3.1"  
szOID_PKIX_KP_CLIENT_AUTH = "1.3.6.1.5.5.7.3.2" 
  
[Extensions]  
%szOID_SUBJECT_ALT_NAME2% = "{text}dns=$HostName&"  
%szOID_ENHANCED_KEY_USAGE% = "{text}%szOID_PKIX_KP_SERVER_AUTH%,%szOID_PKIX_KP_CLIENT_AUTH%" 
  
"@ 
$InputFileTemplate | Out-File -FilePath $InfOutput -Encoding ascii 
&certreq.exe -new "$InfOutput" "$CSROutput" 
