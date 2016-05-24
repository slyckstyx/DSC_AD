<#
    .SYNOPSIS Returns Computer objects from AD in proper DSC Configuration Data format.  The ObjectGUID is used as the DSC ConfigurationID.
    .PARAM
        ADAttribute Active Directory attribute that specifies the attribute the DSC NodeType is stored in.  Defaults to Description attribute.
    .EXAMPLE
        New-DscConfigData -ADAttribute "division"
#>
function New-DscConfigData
{
    param
    (
        # ADAttribute specifies the attribute the Node Type is stored in.  Defaults to Description.
        [Parameter()]
        [string] $ADAttribute = "Description"
    )
    
    $domainComputers = Get-ADComputer -Filter * -Properties Name, ObjectGUID, $ADAttribute
    $configData = @{
        AllNodes = @(
            @{
                NodeName='*'
            }
        )
    }
    $domainComputers | % { 
        $configData.AllNodes += @(
            @{
                NodeName = $_.Name
                ConfigurationID = $_.ObjectGUID
                NodeType = $_.$ADAttribute
            }
        )
    }
    
    return $configData
}
Export-ModuleMember -Function New-DscConfigData