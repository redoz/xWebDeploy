<# 
.summary
    Test suite for MSFT_xDhcpServerOption.psm1
    These tests require RSAT on client.
    On 8.1 it's found here: http://www.microsoft.com/en-us/download/confirmation.aspx?id=39296&6B49FDFB-8E5B-4B07-BC31-15695C5A2143=1
#>
[CmdletBinding()]
param()

$global:DhpcOptionTest=$true
Import-Module -Name $PSScriptRoot\..\DSCResources\xWebPackageDeploy -Force -DisableNameChecking

$ErrorActionPreference = 'stop'
Set-StrictMode -Version latest

if (! (Get-Module xDSCResourceDesigner))
{
    Import-Module -Name xDSCResourceDesigner -ErrorAction SilentlyContinue
}

function Suite.BeforeAll {
    # Remove any leftovers from previous test runs
    Suite.AfterAll 
}

function Suite.AfterAll {
    Remove-Module -Name xWebPackageDeploy -Force -ErrorAction SilentlyContinue
    $global:DhpcOptionTest=$null
}

function Suite.BeforeEach {
}

Describe 'Schema Validation for xWebPackageDeploy' {
    Copy-Item -Path ((get-item .).parent.FullName) -Destination $(Join-Path -Path $env:ProgramFiles -ChildPath 'WindowsPowerShell\Modules\') -Force -Recurse
    $result = Test-xDscResource xWebPackageDeploy
    It 'should pass Test-xDscResource' {
        $result | Should Be $true
    }
}

Describe 'Schema Validation for xWebPackageDeploy' {
    Copy-Item -Path ((get-item .).parent.FullName) -Destination $(Join-Path -Path $env:ProgramFiles -ChildPath 'WindowsPowerShell\Modules\') -Force -Recurse
    $result = Test-xDscResource xWebPackageDeploy
    It 'should pass Test-xDscResource' {
        $result | Should Be $true
    }
}