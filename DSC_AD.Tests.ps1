Import-Module "$(Get-Location)\DSC_AD.psm1"

Describe "Unit testing the DSC_AD module's internal New-DSCConfigData function:" {

    It "Returns Computer objects from AD in DSC Configuration Data compatible format." {
        (New-DSCConfigData).GetType().Name -as [string] | Should Be 'hashtable'
    }
    It "Contains more than just the AllNodes data hash." {
        (New-DSCConfigData).allnodes.count -as [int] | Should BeGreaterThan 1
    }
}
