Function n8n-sync {
    # 1. Ensure we are in the correct folder
    $ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    Set-Location $ScriptPath

    Write-Host "Syncing workflows individually to $ScriptPath\workflows..." -ForegroundColor Cyan
    
    # 2. Export each workflow as its own file
    # We point to the folder path, not a specific filename
    docker exec -it n8n-master n8n export:workflow --backup --output=/home/node/.n8n/workflows/
    
    # 3. Git routine
    git add .
    # This automatically adds the date/time to your commit
    git commit -m "Update individual workflows: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push
    
    Write-Host "Done! Your workflows are now organized separately on GitHub." -ForegroundColor Green
}

# Run the function immediately
n8n-sync