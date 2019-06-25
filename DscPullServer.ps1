Configuration DscConfiguration {

    Import-DscResource -Module cChoco
    Import-DscResource -ModuleName NetworkingDsc
    Import-DscResource -Module PSDscResources
    Import-DscResource -Module xRemoteDesktopAdmin
    Import-DscResource -Module xWindowsUpdate

    Node $AllNodes.where( { $_.Purpose -eq 'DSC-Pull' }).NodeName {

        $FirewallRules = @(
            'FPS-ICMP4-ERQ-In' # allow ping
            'FPS-SMB-In-TCP' # allow smb shares
            'RemoteSvcAdmin-RPCSS-In-TCP' # allow Veeam RPC
            'RemoteDesktop-UserMode-In-TCP' # allow RDP
        )
        Foreach ($Rule in $FirewallRules) {
            Firewall $Rule {
                Name    = $Rule
                Ensure  = 'Present'
                Enabled = 'True'
                Profile = ('Domain', 'Private')
            }
        }

        cChocoInstaller InstallChoco {
            InstallDir = "c:\ProgramData\Chocolatey"
        }
        
        cChocoPackageInstaller firefox {
            Name        = 'firefox'
            Ensure      = 'Present'
            AutoUpgrade = $True
            DependsOn   = "[cChocoInstaller]installChoco"
        }

        xWindowsUpdateAgent MuSecurityImportant {
            IsSingleInstance = 'Yes'
            UpdateNow        = $false
            Category         = @('Security', 'Important')
            Source           = 'MicrosoftUpdate'
            Notifications    = 'Disabled'
        }

        xRemoteDesktopAdmin RemoteDesktopSettings {
            Ensure             = 'Present'
            UserAuthentication = 'Secure'
        }
    }
}

DscConfiguration -OutputPath $ENV:UserProfile\DSC -ConfigurationData .\ConfigurationData.psd1