function Install-AgentService() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $DevOpsUrl,
        
        [Parameter(Mandatory = $true)]
        [string] $DevOps_PAT,

        [Parameter(Mandatory = $false)]
        [string] $AgentPool = "ALOPS-WARP10",

        [Parameter(Mandatory = $true)]
        [string] $AgentName,

        [Parameter(Mandatory = $false)]
        [string] $AgentFolder = "c:\vsts-agent-alops-warp10"
    )

    Write-Host "*** Add [Network Service] as Local Administrator"
    Add-LocalGroupMember -Group Administrators `
        -Member "Network Service" `
        -ErrorAction SilentlyContinue

    $Arguments = @()
    $Arguments += @("--url"       , "$DevOpsUrl")
    $Arguments += @("--auth"       , "pat")
    $Arguments += @("--token"      , "$($DevOps_PAT)")
    $Arguments += @("--unattended")
    $Arguments += @("--pool"       , "$($AgentPool)")
    $Arguments += @("--agent"      , "$($AgentName)")
    $Arguments += @("--replace")
    $Arguments += @("--runAsService")

    Write-Host "##[command]""$($AgentFolder)\config.cmd"" $Arguments"
    & "$($AgentFolder)\config.cmd" $Arguments

    $ServiceName = (get-service *vsts*).Name
    Write-Host "*** Set Startup=Auto for server [$($ServiceName)]"

    Write-Host "##[command]""sc.exe"" config $ServiceName start= auto "
    & sc.exe config $ServiceName start= auto           
}

#Download Agent

#Unblock and Unpack

#Set up
Install-AgentService `
    -DevOpsUrl "https://dev.azure.com/NAVTechDays19" `
    -DevOps_PAT "yourPAT" `
    -AgentPool "WaldoHetzner" `
    -AgentName "WaldoHetzner01" `
    -AgentFolder "C:\vsts-agent-win-x64-2.155.1_2" `
    -Verbose