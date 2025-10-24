param (
    [string]$TargetOrg
)

$ErrorActionPreference = "Stop"

sf project retrieve start `
    --target-org $TargetOrg `
    --metadata Bot `
    --metadata BotVersion `
    --metadata GenAiPlannerBundle `
    --metadata GenAiPlugin `
    --metadata GenAiFunction
