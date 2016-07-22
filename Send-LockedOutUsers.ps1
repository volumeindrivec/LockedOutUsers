function Send-LockedOutUsers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$true)]$InputObject,
        [Parameter(Mandatory=$True)][string[]]$Recipient,
        [Parameter(Mandatory=$True)][string]$Sender,
        [Parameter(Mandatory=$True)][string]$EmailServer
    )

    Begin {
        Write-Verbose "Entering BEGIN block - Send fucntion."
        Write-Verbose "Intitializing object arrays."
        $LockedUsers = @()
        $LockedUsersReport = @()
    }

    Process {
        Write-Verbose "Entering PROCESS block - Send function."
        Write-Verbose "Processing Object"
        $LUFormatted = Select-Object -InputObject $InputObject -Property @{n='Full Name'; e={$_.Name}},@{n='Logon Name'; e={$_.samaccountname}}
        $LockedUsers += $LUFormatted
    }

    End {
        Write-Verbose "Entering END block - Send function."
       
        $DateTime = Get-Date
        $LockedOutHTML = $LockedUsers | ConvertTo-Html -Fragment -PreContent "<H3>CURRENTLY LOCKED OUT USERS as of $DateTime</H3>" | Out-String
        $css = '<style>
            table { width:98%; }
            td { text-align:center; padding:5px; }
            th { background-color:blue; color:white; }
            h3 { text-align:center }
            h6 { text-align:center }
            </style>'

        $FooterHtml = ConvertTo-Html -Fragment -PostContent "<h6>This report was run from:  $env:COMPUTERNAME on $(Get-Date)</h6>" | Out-String
        $Report = ConvertTo-Html -Body "$LockedOutHTML $FooterHtml $css" | Out-String
        
        Write-Verbose "Sending Email:
          Recipient   : $Recipient
          Sender      : $Sender
          EmailServer : $EmailServer"
        
        if ( $LockedUsers.Count -ge 1 ) {
            Send-MailMessage -To $Recipient -From $Sender -Subject "Locked Out Users Report" -Body $Report -BodyAsHtml -SmtpServer $EmailServer
        }
        else {
            Write-Verbose "Nothing to send."
        }
        
    }
}