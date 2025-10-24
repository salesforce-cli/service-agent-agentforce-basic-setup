param (
    [string]$TargetOrg
)

$ErrorActionPreference = "Stop"

Write-Host "Creating Experience Cloud site using Salesforce CLI in $TargetOrg..." -ForegroundColor Cyan

# Create the Experience Cloud site
Write-Host "Creating Network..." -ForegroundColor Yellow
sf project deploy start `
    --source-dir force-app/main/default/digitalExperiences `
    --source-dir force-app/main/default/digitalExperienceConfigs `
    --source-dir force-app/main/default/networks `
    --source-dir force-app/main/default/networkBranding `
    --source-dir force-app/main/default/audience `
    --source-dir force-app/main/default/sites `
    --source-dir force-app/main/default/aura `
    --source-dir force-app/main/default/pages `
    --source-dir force-app/main/default/classes `
    --source-dir "force-app/main/default/profiles/poc-agentforce-site Profile.profile-meta.xml" `
    --source-dir "force-app/main/default/profiles/Customer Community Plus User Cloned.profile-meta.xml" `
    --source-dir force-app/main/default/lwc `
    --source-dir force-app/main/default/profiles `
    --target-org $TargetOrg

Write-Host "Publishing site..." -ForegroundColor Yellow
sf community publish `
    --name "poc-agentforce-site" `
    --target-org $TargetOrg

Write-Host "Done!" -ForegroundColor Green


