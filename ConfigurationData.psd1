@{
	AllNodes = @(
		@{
			NodeName = '*'
			PsDscAllowDomainUser = $true
            PsDscAllowPlainTextPassword = $true
		},
		@{
			NodeName = 'DC1'
            Purpose = 'Domain Controller'
            WindowsFeatures = 'AD-Domain-Services'
        },
        @{
			NodeName = 'dscpullserver'
            Purpose = 'DSC-Pull'
        },
        @{
			NodeName = 'web-server'
            Purpose = 'IIS'
        }
    )
    NonNodeData = @{
        DomainName = 'ad.natelab.us'
        AdGroups = 'Accounting','Information Technology','Executive Office','Janitorial Services'
        OrganizationalUnits = 'Accounting','Information Technology','Executive Office','Janitorial Services'
        AdUsers = @(
            @{
                FirstName = 'Katie'
                LastName = 'Green'
                Department = 'Accounting'
                Title = 'Manager of Accounting'
            }
            @{
                FirstName = 'Nate'
                LastName = 'Webb'
                Department = 'Information Technology'
                Title = 'System Administrator'
            }
            @{
                FirstName = 'Joe'
                LastName = 'Schmoe'
                Department = 'Information Technology'
                Title = 'Software Developer'
            }
            @{
                FirstName = 'Bill'
                LastName = 'Murray'
                Department = 'Executive Office'
                Title = 'CEO'
            }
            @{
                FirstName = 'Turd'
                LastName = 'Ferguson'
                Department = 'Janitorial Services'
                Title = 'Custodian'
            }
        )
    }
}