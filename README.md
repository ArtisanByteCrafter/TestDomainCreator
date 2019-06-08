# Setup a Test Lab with AD domain, OUs, Security Groups and Users

## To Create a Test Lab:

**On domain controller, install xActiveDirectory module**

```
Install-Module xActiveDirectory
```

**Run `New-TestEnvironment.ps1`**

* This will output your MOF file to the root of your user profile.

**Invoke the DSC Configuration**

```
Start-DscConfiguration -Wait -Verbose -Force -Path $env:USERPROFILE\DSC
```

**Reboot for setup to be complete**