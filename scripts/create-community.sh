#!/bin/bash

echo "Creating Experience Cloud site using Salesforce CLI..."

# Create the Experience Cloud site
echo "Creating Network..."
sf network create --name "Community Site" --status "Live" --url-path-prefix "community" --self-registration-enable

echo "Creating Site..."
sf site create --name "Community_Site" --type "BuildYourOwn" --subdomain "community-site" --url-path-prefix "community"

echo "Creating Experience Bundle..."
sf experience-bundle create --name "Community_Site_LWR" --type "LWR"

echo "Creating Home Page..."
sf experience-page create --name "home" --bundle "Community_Site_LWR" --template "home"

echo "Deploying LWC Component..."
sf project deploy start --source-dir "force-app/main/default/lwc/helloHome"

echo "Assigning permissions..."
sf permission-set assign --name "Community_Site_Permissions"

echo "Publishing site..."
sf site publish --name "Community_Site"

echo "Done!"
