function Get-LockedOutUsers {
    [CmdletBinding()]
    param(
    )

    Begin {
    Write-Verbose 'Entering BEGIN block - Get function.'

    try {
        Write-Verbose 'Attempting to import the ActiveDirectory module.'
        Import-Module -Name ActiveDirectory
    }
    catch {
        Write-Error 'ERROR:  There was an error importing the module.'
    }

    try {
        Write-Verbose 'Performing Active Directory search for locked out users.'
        Search-ADAccount -LockedOut -UsersOnly
    }
    catch {
        Write-Error 'ERROR: There was an errror.  No con permiso.'
    }

}

    Process {
        Write-Verbose 'Entering PROCESS block - Get function.'
    }

    End {
        Write-Verbose 'Entering END block - Get function.'
    }

    
}