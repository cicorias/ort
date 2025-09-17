# download.ps1
# PowerShell 7.1+ script to download multiple files from Hugging Face

param(
  # Where to save files (default: current directory)
  [string]$OutDir = (Get-Location).Path
)

$BaseUrl = 'https://huggingface.co/microsoft/Phi-3-vision-128k-instruct-onnx-cpu/resolve/main/cpu-int4-rtn-block-32-acc-level-4/'

$Files = @(
  'phi-3-v-128k-instruct-text-embedding.onnx',
  'phi-3-v-128k-instruct-text-embedding.onnx.data',
  'phi-3-v-128k-instruct-text.onnx',
  'phi-3-v-128k-instruct-text.onnx.data',
  'phi-3-v-128k-instruct-vision.onnx',
  'phi-3-v-128k-instruct-vision.onnx.data',
  'tokenizer.json'
)

# Some hosts prefer an explicit User-Agent
$Headers = @{ 'User-Agent' = 'Mozilla/5.0' }

New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

foreach ($File in $Files) {
  $Url     = $BaseUrl + $File
  $OutFile = Join-Path $OutDir $File

  Write-Host ("Downloading {0} ..." -f $File)
  try {
    Invoke-WebRequest -Uri $Url -OutFile $OutFile -Headers $Headers
    Write-Host ("  Saved to {0}" -f $OutFile) -ForegroundColor Green
  } catch {
    Write-Warning ("  Failed to download {0}: {1}" -f $File, $_.Exception.Message)
  }
}
