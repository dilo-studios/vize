Write-Host "Starting Vize Pre-flight Checks..." -ForegroundColor Cyan

Write-Host "Formatting code..."
dart format .

Write-Host "Analyzing for linting issues..."
flutter analyze
if ($LASTEXITCODE -ne 0) { Write-Error "Analysis failed"; exit }

Write-Host "Running unit tests..."
flutter test
if ($LASTEXITCODE -ne 0) { Write-Error "Tests failed"; exit }

Write-Host "Running pub publish dry-run..."
dart pub publish --dry-run
if ($LASTEXITCODE -ne 0) { Write-Error "Dry-run failed"; exit }

Write-Host "All checks passed! Vize is ready to launch." -ForegroundColor Green