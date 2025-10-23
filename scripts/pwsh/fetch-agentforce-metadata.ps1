$ErrorActionPreference = "Stop"

sf project retrieve start `
    --target-org community-scratch2 `
    --metadata Bot `
    --metadata BotVersion `
    --metadata GenAiPlannerBundle `
    --metadata GenAiPlugin `
    --metadata GenAiFunction
