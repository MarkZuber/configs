# Invoke-Expression (&starship init powershell)

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression

# Configuration Pieces
# Set-PSReadLineOption -PredictionViewStyle ListView

function doGitPushOrigin {
    $currentBranch = git rev-parse --abbrev-ref HEAD
    Write-Output "Pushing $currentBranch branch to origin"
    git push --set-upstream origin $currentBranch
}

Set-Alias gpusho doGitPushOrigin

function tailDesktopLogs {
    $logDateFormat = Get-Date -Format "yyyyMMdd";
    Get-Content -Path $env:LOCALAPPDATA\sanas.ai\local\logs\DesktopApp_$logDateFormat.log -Tail 10 -Wait
}

Set-Alias taildesklog tailDesktopLogs

function tailVoiceConverterLogs {
    $logDateFormat = Get-Date -Format "yyyy-MM-dd";
    Get-Content -Path $env:LOCALAPPDATA\sanas.ai\local\logs\VoiceConverter_$logDateFormat.log -Tail 10 -Wait
}

Set-Alias tailvoicelog tailVoiceConverterLogs

function vscodePowershellProfile {
    code $PROFILE
}

Set-Alias editprofile vscodePowershellProfile

function dirEnvironment {
    Get-ChildItem env:
}

Set-Alias env dirEnvironment