param (
    [string]$TargetOrg
)

$ErrorActionPreference = "Stop"

#When using API Version >=64
sf project deploy start `
    --ignore-conflicts `
    --target-org $TargetOrg `
    --metadata Flow `
    --metadata Bot `
    --metadata BotVersion `
    --metadata GenAiPlannerBundle `
    --metadata GenAiPlugin `
    --metadata GenAiFunction `
    --metadata PermissionSet:sfdc_aiplanner_service_permset `
    --metadata PermissionSet:Agentforce_Service_Agent_Permissions `
    --metadata PermissionSet:sfdc_chatbot_service_permset

#Using API Version < 64
# sf project deploy start `
#     --target-org $TargetOrg `
#     --metadata Bot `
#     --metadata BotVersion `
#     --metadata GenAiPlanner `
#     --metadata GenAiPlugin `
#     --metadata GenAiFunction `
#     --metadata PermissionSet:Agentforce_Service_Agent_Permissions 
