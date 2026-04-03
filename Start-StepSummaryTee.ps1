#!/usr/bin/env pwsh
# -*- coding: utf-8, tab-width: 2 -*-
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

($runCmd, $runArgs) = $args

New-Item -ItemType Directory -Path $env:OUT_DIR `
  -ErrorAction Ignore | Out-Null

if ($runCmd -like '*.ps1') {
  # In case of a PowerShell script, it would not run as a subprocess,
  # so parsing errors would silently terminate this tee script.
  # In order to be able to report those, we have to invoke an
  # independent PowerShell process:
  $runArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass',
    '-File', $runCmd, $runArgs)
  $runCmd = if ($IsCoreCLR) { 'pwsh' } else { 'powershell' }
}


$progressSpinnerAnimationLineRegexp = '^[\s/\\|\\-]*$'
# Without this filter, the VS installer, when run via winget,
# would clutter the CI logs by printing thousands of lines of
# progress animation, quickly cycling through `-`, `/`, `|`, `\`.

$sharedRetval = [ref]0
& {
  echo '' '```text'
  & {
    $oldEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $retval = 0
    $LASTEXITCODE = $null
    try {
      echo "D: [stepsumm-tee] Run '$runCmd' with $($runArgs.Length) args:"
      & $runCmd $runArgs *>&1
      echo "D: [stepsumm-tee] Success, rv=$retval."
    } catch {
      $retval = $LASTEXITCODE
      echo "W: [stepsumm-tee] Failed (rv=$retval): $_"
      if (-not $retval) { $retval = 1 }
    }
    $ErrorActionPreference = $oldEAP
    $sharedRetval.Value = $retval
  } *>&1 |
    Where-Object { $_ -notmatch $progressSpinnerAnimationLineRegexp } |
    ForEach-Object { $_ -replace "`e\[[0-9;]*[mK]", '' } |
    Tee-Object -FilePath "${env:OUT_DIR}\stepsumm.log.txt" -Append
  echo '```' ''
} | Tee-Object -FilePath $env:GITHUB_STEP_SUMMARY -Append
exit $sharedRetval.Value
