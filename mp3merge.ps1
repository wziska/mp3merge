param(
  [Parameter(Mandatory=$true)]
  [String] $Directory)

if ((Get-Item $Directory) -is [System.IO.DirectoryInfo]) {
  $files = Get-ChildItem -Path $Directory -Filter *.mp3 | Select-Object -ExpandProperty FullName
}
else {
  Write-Host 'not a directory'
  exit
}

$dirName = (Split-Path $Directory -Leaf)
$output = "$Directory\$dirName.mp3"
Write-Host "Merging mp3s to: $output"

lib/mp3wrap.exe -v tmp.mp3 $files
lib/id3cp.exe $files[0] tmp_MP3WRAP.mp3
lib/VbrfixConsole.exe --XingFrameCrcProtectIfCan tmp_MP3WRAP.mp3 $output

if ($LastExitCode -eq 255) {
  Move-Item -Path ./tmp_MP3WRAP.mp3 -Destination $output
} elseif ($LastExitCode -eq 0) {
  Remove-Item ./tmp_MP3WRAP.mp3
}