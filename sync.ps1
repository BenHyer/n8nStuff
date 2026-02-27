Function n8n-sync {
    $ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    Set-Location $ScriptPath

    Write-Host "Syncing n8n workflows..." -ForegroundColor Cyan
    
    # 1. Export
    docker exec -it n8n-master n8n export:workflow --all --output=/home/node/.n8n/workflows/all_workflows.json
    
    # 2. Git
    git add .
    git commit -m "Update workflows: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push
    
    Write-Host "Done!" -ForegroundColor Green
}

# THIS LINE IS THE SECRET SAUCE:
n8n-sync