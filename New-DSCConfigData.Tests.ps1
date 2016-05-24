$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "New-DSCConfigData" {
    It "Returns Computer objects from AD in DSC Configuration Data compatible format." {
        (New-DSCConfigData).GetType().Name -as [string] | Should Be 'hashtable'
    }
    It "Contains more than just the AllNodes data hash." {
        (New-DSCConfigData).allnodes.count -as [integer] | Should BeGreaterThan 1
    }
}
