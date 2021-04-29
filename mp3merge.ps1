param(
  [Parameter(Mandatory=$true)] [String] $Directory,
  [Switch] $Recursive)

function Merge([System.IO.DirectoryInfo] $Directory) {
  Write-Host "Merging mp3s in $Directory"
  $files = Get-ChildItem -Path $Directory -Filter *.mp3 | Select-Object -ExpandProperty FullName

  if ($null -eq $files) {
    Write-Error "No mp3s found." -ErrorAction Stop
  }

  if ($files.GetType().Name -eq "String") {
    Write-Warning "Single mp3 - nothing to merge"
    return
  }

  $dirName = (Split-Path $Directory -Leaf)
  $output = "$Directory/$dirName.mp3"
  Write-Host "Merging mp3s to: $output"

  mp3wrap -v tmp.mp3 $files
  id3cp $files[0] tmp_MP3WRAP.mp3
  vbrfix tmp_MP3WRAP.mp3 $output

  $exited = $LastExitCode
  Write-Host "Exited with code: $exited"
  if ($exited -eq 255) {
    Move-Item -Path ./tmp_MP3WRAP.mp3 -Destination $output
  } elseif ($exited -eq 0) {
    Write-Host "removing temporary files..."
    Remove-Item -Path ./tmp_MP3WRAP.mp3
    Remove-Item -Path ./vbrfix.log
    Remove-Item -Path ./vbrfix.tmp
  }

  $dirName -match '.* - (?<Title>.*)'
  id3v2 -t $Matches.Title $output
}

if ($false -eq (Test-Path $Directory)) {
  Write-Error "Directory doesn't exist." -ErrorAction Stop
}

$dir = Get-Item $Directory
if (!($dir -is [System.IO.DirectoryInfo])) {
  Write-Error "Not a directory." -ErrorAction Stop
}

Write-Host "dir: $dir"
Write-Host "recursive: $Recursive"

if ($Recursive) {
  Get-ChildItem -Path $dir -Recurse -Directory | ForEach-Object {
    Merge($_)
  }
} else {
  Merge($dir)
}
