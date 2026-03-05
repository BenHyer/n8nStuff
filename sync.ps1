Function n8n-sync {
    # Get the folder where THIS script is saved
    $PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
    if (!$PSScriptRoot) { $PSScriptRoot = Get-Location }
    
    $WorkflowsPath = Join-Path $PSScriptRoot "workflows"
    Set-Location $PSScriptRoot

    Write-Host "--- Starting n8n Sync ---" -ForegroundColor Cyan

    # 1. Export from Docker
    Write-Host "Exporting from Docker..." -ForegroundColor Gray
    docker exec -it n8n-master n8n export:workflow --backup --output=/home/node/.n8n/workflows/

    # 2. Rename files based on the 'name' inside the JSON
    Write-Host "Renaming files to match workflow names..." -ForegroundColor Yellow
    $jsonFiles = Get-ChildItem -Path $WorkflowsPath -Filter "*.json"

    foreach ($file in $jsonFiles) {
        try {
            # Use -Raw and force UTF8 to ensure the JSON is read correctly
            $jsonRaw = Get-Content $file.FullName -Raw
            $data = $jsonRaw | ConvertFrom-Json
            $prettyName = $data.name

            if ($prettyName) {
                $safeName = $prettyName -replace '[\\\/:*?"<>|]', ''
                $newName = "$safeName.json"
                $newPath = Join-Path $WorkflowsPath $newName

                if ($file.Name -ne $newName) {
                    Write-Host "  > Renaming $($file.Name) to $newName" -ForegroundColor Gray
                    if (Test-Path $newPath) { Remove-Item $newPath -Force }
                    Rename-Item -Path $file.FullName -NewName $newName -Force
                }
            }
        } catch {
            Write-Host "  ! Failed to process $($file.Name)" -ForegroundColor Red
        }
    }

    # 3. Git routine
    Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
    git add .
    git commit -m "Update workflows: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push

    Write-Host "--- Sync Complete! ---" -ForegroundColor Green
}

# This actually runs the function when you execute the file
n8n-sync