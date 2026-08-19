$ErrorActionPreference = "Stop"

$Image = "ovelayos/docker-registry-wd-ex4100"
$Tag = "3.1.1-bullseye"

Write-Host "Building and pushing $Image`:$Tag for linux/arm/v7..."

docker buildx build `
  --platform linux/arm/v7 `
  -t "$Image`:$Tag" `
  -t "$Image`:latest" `
  --push `
  .

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Published:"
Write-Host "  $Image`:$Tag"
Write-Host "  $Image`:latest"
