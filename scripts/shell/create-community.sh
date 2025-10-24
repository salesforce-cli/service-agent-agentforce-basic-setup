#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/shell/create-community.sh -o <targetOrgAliasOrUsername>
# Example: ./scripts/shell/create-community.sh -o myScratch
#
# Notes:
# - Uses sf (not sfdx) per project standards.
# - Requires the Experience Cloud metadata to be present in force-app/main/default.
# - Publishes the community named "poc-agentforce-site".

TARGET_ORG=""

print_usage() {
  echo "Usage: $0 -o <targetOrgAliasOrUsername>"
  echo "Options:"
  echo "  -o    Salesforce org alias or username to target (required)"
  echo "  -h    Show help"
}

# Parse flags
while getopts ":o:h" opt; do
  case "$opt" in
    o) TARGET_ORG="$OPTARG" ;;
    h)
      print_usage
      exit 0
      ;;
    \?)
      echo "Error: Invalid option -$OPTARG" >&2
      print_usage
      exit 1
      ;;
    :)
      echo "Error: Option -$OPTARG requires an argument." >&2
      print_usage
      exit 1
      ;;
  esac
done

if [[ -z "${TARGET_ORG}" ]]; then
  echo "Error: -o <targetOrgAliasOrUsername> is required." >&2
  print_usage
  exit 1
fi

echo "Creating Experience Cloud site using Salesforce CLI in ${TARGET_ORG}..."

echo "Creating Network..."
sf project deploy start \
  --source-dir force-app/main/default/digitalExperiences \
  --source-dir force-app/main/default/digitalExperienceConfigs \
  --source-dir force-app/main/default/networks \
  --source-dir force-app/main/default/networkBranding \
  --source-dir force-app/main/default/audience \
  --source-dir force-app/main/default/sites \
  --source-dir force-app/main/default/aura \
  --source-dir force-app/main/default/pages \
  --source-dir force-app/main/default/classes \
  --source-dir "force-app/main/default/profiles/poc-agentforce-site Profile.profile-meta.xml" \
  --source-dir force-app/main/default/lwc \
  --source-dir force-app/main/default/profiles \
  --target-org "${TARGET_ORG}"

echo "Publishing site..."
sf community publish \
  --name "poc-agentforce-site" \
  --target-org "${TARGET_ORG}"

echo "Done!"
