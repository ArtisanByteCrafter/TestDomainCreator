Configuration DscConfiguration {

    Import-DscResource -Module cChoco
    Import-DscResource -ModuleName PowershellModule
    Import-DscResource -ModuleName NetworkingDsc
    Import-DscResource -Module xPSDesiredStateConfiguration
    Import-DscResource -Module xRemoteDesktopAdmin
    Import-DscResource -Module xWindowsUpdate

     Node $AllNodes.where( { $_.Purpose -eq 'Dsc Authoring' }).NodeName {

        LocalConfigurationManager {
            ConfigurationMode              = 'ApplyAndAutoCorrect'
            ConfigurationModeFrequencyMins = 30
            RefreshMode                    = 'Push'
            RebootNodeIfNeeded             = $False
        }

        $FirewallRules = @(
            'FPS-ICMP4-ERQ-In' # allow ping
            'FPS-SMB-In-TCP' # allow smb shares
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

        $ChocoPackages = @(
            'firefox'
            'vscode'
            'git'
        )
        Foreach ($Package in $ChocoPackages) {
            cChocoPackageInstaller $Package {
                Name        = $Package
                Ensure      = 'Present'
                AutoUpgrade = $True
                DependsOn   = "[cChocoInstaller]installChoco"
            }
        }

        PSModuleRepositoryResource PSGallery {
            Name               = 'PSGallery'
            SourceLocation     = 'https://www.powershellgallery.com/api/v2'
            InstallationPolicy = 'Trusted'
        }

        $PSGalleryModules = @(
            'PowershellGet'
            'KaceSMA'
            'CredentialManager'
        )
        Foreach ($Module in $PSGalleryModules) {
            PSModuleResource $Module {
                Ensure      = 'Present'
                Module_Name = $Module
            }
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