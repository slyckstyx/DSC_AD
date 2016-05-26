#Requires -Version 4
#Requires -Modules ActiveDirectory
<#
    .SYNOPSIS Returns Computer objects from AD in proper DSC Configuration Data format.
    .PARAM
        ADAttribute Active Directory attribute that specifies the attribute the DSC NodeType is stored in.  Defaults to Description attribute.
    .PARAM
        Filter Allows passing in a filter query string if desired.  Defaults to "*".
    .PARAM
        TargetGUID Allows selection of an AD attribute other than ObjectGUID for security purposes.  Defaults to "ObjectGUID".
    .EXAMPLE
        New-DscConfigData -ADAttribute "division"
#>
function New-DscConfigData
{
    param
    (
        # ADAttribute specifies the attribute the Node Type is stored in.  Defaults to "Description".
        [Parameter()]
        [string] $ADAttribute = "Description",
        
        # Filter allows passing in a filter query string if desired.  Defaults to "*".
        [Parameter()]
        [string] $Filter = "*",
        
        # TargetGUID allows selection of an AD attribute other than ObjectGUID for security purposes.  Defaults to "ObjectGUID".
        [Parameter()]
        [string] $TargetGUID = "ObjectGUID"
    )

    $domainComputers = Get-ADComputer -Filter $Filter -Properties Name, $TargetGUID, $ADAttribute
    $configData = @{
        AllNodes = @(
            @{
                NodeName = "*"
            }
        )
    }
    $domainComputers | % { 
        $configData.AllNodes += @(
            @{
                NodeName = $_.Name
                ConfigurationID = $_.$TargetGUID
                NodeType = $_.$ADAttribute
            }
        )
    }

    return $configData
}
Export-ModuleMember -Function New-DscConfigData