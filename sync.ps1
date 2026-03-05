# 1. Setup paths simply
$CurrentFolder = $PSScriptRoot
if (!$CurrentFolder) { $CurrentFolder = Get-Location }
$WorkflowsFolder = Join-Path $CurrentFolder "workflows"

Write-Host "--- Starting n8n Sync ---" -ForegroundColor Cyan

# 2. Export from Docker
Write-Host "Exporting from Docker..." -ForegroundColor Gray
docker exec -it n8n-master n8n export:workflow --backup --output=/home/node/.n8n/workflows/

# 3. Rename files based on the 'name' inside the JSON
Write-Host "Renaming files to match workflow names..." -ForegroundColor Yellow
$jsonFiles = Get-ChildItem -Path $WorkflowsFolder -Filter "*.json"

foreach ($file in $jsonFiles) {
    try {
        # Read the file and find the name
        $data = Get-Content $file.FullName -Raw | ConvertFrom-Json
        $prettyName = $data.name

        if ($prettyName) {
            $safeName = $prettyName -replace '[\\\/:*?"<>|]', ''
            $newName = "$safeName.json"
            $newPath = Join-Path $WorkflowsFolder $newName

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

# 4. Git routine
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git add .
# We use -allow-empty just in case nothing changed to prevent errors
git commit -m "Update workflows: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" --allow-empty
git push

Write-Host "--- Sync Complete! ---" -ForegroundColor Green