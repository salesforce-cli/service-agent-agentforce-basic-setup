$ErrorActionPreference = "Stop"

Write-Host "Creating Experience Cloud site using Salesforce CLI..." -ForegroundColor Cyan

# Create the Experience Cloud site
Write-Host "Creating Network..." -ForegroundColor Yellow
sf network create --name "Community Site" --status "Live" --url-path-prefix "community" --self-registration-enable

Write-Host "Creating Site..." -ForegroundColor Yellow
sf site create --name "Community_Site" --type "BuildYourOwn" --subdomain "community-site" --url-path-prefix "community"

Write-Host "Creating Experience Bundle..." -ForegroundColor Yellow
sf experience-bundle create --name "Community_Site_LWR" --type "LWR"

Write-Host "Creating Home Page..." -ForegroundColor Yellow
sf experience-page create --name "home" --bundle "Community_Site_LWR" --template "home"

Write-Host "Deploying LWC Component..." -ForegroundColor Yellow
sf project deploy start --source-dir "force-app/main/default/lwc/helloHome"

Write-Host "Assigning permissions..." -ForegroundColor Yellow
sf permission-set assign --name "Community_Site_Permissions"

Write-Host "Publishing site..." -ForegroundColor Yellow
sf community publish --name "poc-agentforce-site"

Write-Host "Done!" -ForegroundColor Green
