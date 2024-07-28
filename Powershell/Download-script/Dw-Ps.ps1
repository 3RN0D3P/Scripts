Import-Module BitsTransfer

# Define source URL and destination path
$sourceUrl = 'https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt'
$destinationPath = 'C:\Users\Renaud\Desktop\emaonly.ckpt'

###################################################################################################

# Function to display progress bar
function Show-ProgressBar {
    param (
        [double]$Progress
    )

    $ProgressBarWidth = 50
    $CompletedChars = [Math]::Round(($Progress / 100) * $ProgressBarWidth)
    $RemainingChars = $ProgressBarWidth - $CompletedChars

    $ProgressBar = "[" + "-" * $CompletedChars + " " * $RemainingChars + "]"
    Write-Host "Progress: $($Progress) %  $ProgressBar"
}

# Define script block for BITS transfer monitoring
$monitorBITSJob = {
    param ($Source, $Destination)

    # Start BITS transfer asynchronously
    $bitsjob = Start-BitsTransfer -Source $Source -Destination $Destination -Asynchronous

    # Loop to monitor BITS job progress
    while ($bitsjob.JobState -eq 'Connecting' -or $bitsjob.JobState -eq 'Transferring')
    {
        Write-Host "Job State: $($bitsjob.JobState)"

        # Calculate progress
        if ($bitsjob.BytesTotal -gt 0)
        {
            $Progress = [Math]::Round(($bitsjob.BytesTransferred / $bitsjob.BytesTotal) * 100, 2)
            Show-ProgressBar -Progress $Progress
        }
        else
        {
            Write-Host "Progress: BytesTotal not yet available"
        }

        # Output additional information for debugging with spaces
        Write-Host ""  # Output an empty line for spacing
        Write-Host "BytesTransferred: $($bitsjob.BytesTransferred)"
        Write-Host "BytesTotal: $($bitsjob.BytesTotal)"
        Write-Host ""  # Output an empty line for spacing

        # Wait before checking again
        Start-Sleep -Seconds 5
    }

    # Check final job state
    Write-Host "Final Job State: $($bitsjob.JobState)"

    # Complete the BITS transfer job
    Complete-BitsTransfer -BitsJob $bitsjob

    # Final progress bar update (100%)
    Show-ProgressBar -Progress 100
}

# Example usage of the script block
& $monitorBITSJob -Source $sourceUrl -Destination $destinationPath
