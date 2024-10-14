# Run PowerShell as Administrator
 
# 1. Leave Azure AD
dsregcmd /leave
 
# 2. Remove relevant registry keys
$keysToDelete = @(
    "HKLM:\SOFTWARE\Microsoft\Enrollments",
    "HKLM:\SOFTWARE\Microsoft\Enrollments\Status",
    "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers",
    "HKLM:\SOFTWARE\Microsoft\DeviceManageabilityCSP",
    "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts"
)
 
foreach ($key in $keysToDelete) {
    if (Test-Path $key) {
        Remove-Item -Path $key -Recurse -Force
        Write-Host "Deleted: $key"
    } else {
        Write-Host "Key not found: $key"
    }
}
 
# 3. Ensure required services are running and set to Automatic
$services = @(
    "dmwappushservice",  # Device Management Enrollment Service
    "wuauserv",          # Windows Update
    "TrkWks",            # Workstation Service (for Azure AD Join/Workplace Join)
    "Netlogon",          # Net Logon Service (for domain-joined systems)
    "UserManager"        # User Profile Service
)
 
foreach ($service in $services) {
    Set-Service -Name $service -StartupType Automatic
    Start-Service -Name $service
    Write-Host "Ensured service '$service' is set to Automatic and started."
}
 
# 4. Sync Time and Date with Internet Time Server
w32tm /resync
 
# 5. Restart the device (optional)
# Restart-Computer -Force
 
Write-Host "Completed the steps. Please restart the computer manually or uncomment the restart command."

 