#
# Powershell Script to copy files from one odrive storage link to another
#

$O="$HOME\.odrive\common"
$SYNCBIN="$O\odrive.exe"
$SOURCEPATH="C:\Users\WINDOWS_USER_NAME\odrive\SOURCE_LINK_NAME\SOURCE_LINK_PATH"
$DESTPATH="C:\Users\WINDOWS_USER_NAME\odrive\DEST_LINK_NAME\DEST_REMOTE_PATH"

# Check Prerequisites
if(!(Test-Path -Path $SYNCBIN)) {
    echo "Downloading CLI binary ... "
    (New-Object System.Net.WebClient).DownloadFile("https://dl.odrive.com/odrivecli-win", "$O\oc.zip")
    $shl=new-object -com shell.application
    $shl.namespace("$O").copyhere($shl.namespace("$O\oc.zip").items(),0x10)
    del "$O\oc.zip"
    echo "Done!"
}
if (-Not ($SOURCEPATH) -or !(Test-Path -Path $SOURCEPATH)){
   echo "Missing or Invalid Source Path."
   break
}
if (-Not ($DESTPATH) -or !(Test-Path -Path $DESTPATH)){
   echo "Missing or Invalid Destination Path."
   break
}

# Download Source Path
echo "Downloading Source Path ... "
while ((Get-ChildItem -Path "$SOURCEPATH" -Filter "*.cloud*" -Recurse | Measure-Object).Count) {
   Get-ChildItem -Path "$SOURCEPATH" -Filter "*.cloud*" -Recurse | % { & "$SYNCBIN" "sync" "$($_.FullName)";}
}

# Copy from Source Path to Destination Path
echo "Copying ... "
robocopy $SOURCEPATH $DESTPATH /MIR

echo "Done."
