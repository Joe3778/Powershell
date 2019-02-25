Import-Module ActiveDirectory
$Groups = Get-ADGroup -Properties * -Filter * -Server 'SCPDC2'

$Table = @()

$Record = [ordered]@{
    "Name" = ""
    "UserName" = ""
    "Email Address" = ""
    "Title" = ""
    "Company" = ""
    "Description" = ""
    "Enabled" = ""
    "Last Logon Date" = ""
    "Password Last Set" = ""
    "Group Name" = ""
    "Member of" = ""
}

Foreach($Group In $Groups){ 
    $Arrayofmembers = Get-ADGroupMember -identity $Group -recursive | Where-Object {$_.objectclass -eq 'user'} | Get-ADUser -Properties *
        foreach ($Member in $Arrayofmembers) {
            $Record."Name" = $Member.name
            $Record."UserName" = $Member.samaccountname
            $Record."Email Address" = $Member.EmailAddress
            $Record."Title" = $Member.Title
            $Record."Company" = $Member.Company
            $Record."Description" = $Member.Description
            $Record."Enabled" = $Member.Enabled
            $Record."Last Logon Date" = $Member.LastLogonDate
            $Record."Password Last Set" = $Member.PasswordLastSet
            $Record."Group Name" = $Group
            $Record."Member Of" = $Member.MemberOf            
            $objRecord = New-Object PSObject -property $Record
            $Table += $objrecord
        }
}
    
$Table | Export-Csv 'AD_Group_With_Members$(get-date -f yyyy-MM-dd).csv' -NoTypeInformation