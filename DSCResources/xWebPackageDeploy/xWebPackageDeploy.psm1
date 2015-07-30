#########################################################################################################################################
# xWebPackageDeploy module for deploying IIS WebSite using web deploy IIS extension. This resource assumes that WebDeploy tool
# is installed in IIS.
#########################################################################################################################################


#########################################################################################################################################
# Get-TargetResource ([string]$SourcePath, [string]$Destination) : given the package and IIS website name or content path, determine whether
# the package is deployed and return the result
#########################################################################################################################################

Add-PSSnapin -Name WDeploySnapin3.0

function Get-DeploymentParameters([string]$Package, [Hashtable]$Parameters) {
    $parameterSet = Get-WDParameters -FilePath $Package
    
    Write-Verbose -Message ("Default package paramters: " + ($parameterSet | Format-Table -AutoSize | Out-String)) -Verbose
    
    foreach ($kvp in $Parameters.GetEnumerator()) {
        $parameterSet[$kvp.Key] = $kvp.Value;
    }
    
    Write-Verbose -Message ("Package paramters: " + ($parameterSet | Format-Table -AutoSize | Out-String)) -Verbose
    
    return $parameterSet;
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Package,

        [Hashtable]
        $Parameters= @{}
    )
    $ensure = "Absent"
        
    $parameterSet = Get-DeploymentParameters -Package $Package -Parameters $Parameters
    
    $changeSummary = Restore-WDPackage -Package $Package -Parameters $Parameters -WhatIf
    
    Write-Verbose -Message ("Change summary: " + ($changeSummary | Out-String))
    
    if ($changeSummary.TotalChanges -eq 0) {
        $ensure = "Present"
    }

    $returnValue = @{
        Package = $Package         
        Parameters = $Parameters
        Ensure = $ensure
    }    

    $returnValue
}

#########################################################################################################################################
# Set-TargetResource ([string]$SourcePath, [string]$Destination, [string]$Ensure) : given the package and IIS website name or content path, deploy/remove
# the website content
#########################################################################################################################################

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Package,

        [Hashtable]
        $Parameters= @{}
        
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present"
    )

    $parameterSet = Get-DeploymentParameters -Package $Package -Parameters $Parameters
    
    if($Ensure -eq "Present")
    {     
        $changeSummary = Restore-WDPackage -Package $Package -Parameters $Parameters
        Write-Verbose -Message ("Change summary: " + ($changeSummary | Out-String))
    }
    else
    {
      #delete the website content    
      # & 'C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe' -verb:delete -source:package=C:\temp\pkg\wdtest.zip -dest:auto
      # but some providers aren't supported, but the rest we should be able to delete
      Write-Host "Not supported"
    }    
}

#########################################################################################################################################
# Test-TargetResource ([string]$SourcePath, [string]$Destination, [string]$Ensure) : given the package and IIS website name or content path, 
# determine whether the package is deployed or not.
#########################################################################################################################################

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Package,

        [Hashtable]
        $Parameters= @{}

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present"
    )
    $result = $false    

    $parameterSet = Get-DeploymentParameters -Package $Package -Parameters $Parameters

    if($Ensure -eq "Present")
    {
        $changeSummary = Restore-WDPackage -Package $Package -Parameters $Parameters -WhatIf
        
        Write-Verbose -Message ("Change summary: " + ($changeSummary | Out-String))
        
        $result = $changeSummary.TotalChanges -eq 0;
     }   
    else
    {       
        Write-Host "Not supported"
    }
    $result    
}





