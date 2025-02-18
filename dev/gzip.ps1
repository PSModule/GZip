function Expand-GZipArchive {
    <#
        .SYNOPSIS
        Expands a GZip-compressed file to its original form.

        .DESCRIPTION
        The Expand-GZipArchive function decompresses a GZip-compressed file and saves the output
        to a specified location. If no destination path is provided, the function removes the `.gz`
        extension from the input file path and saves the decompressed file there.

        .EXAMPLE
        Expand-GZipArchive -Path "C:\Temp\archive.gz"

        Output:
        ```powershell
        The file 'C:\Temp\archive.gz' is successfully decompressed to 'C:\Temp\archive'.
        ```

        Decompresses the GZip file 'C:\Temp\archive.gz' and saves it as 'C:\Temp\archive'.

        .OUTPUTS
        System.String. Returns the destination file path after successful extraction.

        .LINK
        https://psmodule.io/Expand/Functions/Expand-GZipArchive
    #>
    [CmdletBinding()]
    param(
        # Path to the GZip archive.
        [Parameter(Mandatory)]
        [string] $Path,

        # Path to the output file.
        [Parameter()]
        [string] $Destination = ($Path -replace '\.gz$', '')
    )

    $fileInput = New-Object System.IO.FileStream $Path, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
    $output = New-Object System.IO.FileStream $Destination, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
    $gzipStream = New-Object System.IO.Compression.GZipStream $fileInput, ([IO.Compression.CompressionMode]::Decompress)

    $buffer = New-Object byte[](1024)
    while ($true) {
        $read = $gzipstream.Read($buffer, 0, 1024)
        if ($read -le 0) { break }
        $output.Write($buffer, 0, $read)
    }

    $gzipStream.Close()
    $output.Close()
    $fileInput.Close()
}


function Compress-GZipArchive {
    <#
        .SYNOPSIS
        Compresses a file using GZip compression.

        .DESCRIPTION
        The Compress-GZipArchive function takes a specified file and compresses it using the GZip format.
        The output file name will be the same as the input file with a `.gz` extension unless a
        custom destination path is provided.

        .EXAMPLE
        Compress-GZipArchive -Path "C:\Temp\file.txt"

        Output:
        ```powershell
        The file 'C:\Temp\file.txt' is successfully compressed to 'C:\Temp\file.txt.gz'.
        ```

        Compresses 'C:\Temp\file.txt' into a GZip archive named 'C:\Temp\file.txt.gz'.

        .EXAMPLE
        Compress-GZipArchive -Path "C:\Temp\file.txt" -Destination "C:\Temp\compressed.gz"

        Output:
        ```powershell
        The file 'C:\Temp\file.txt' is successfully compressed to 'C:\Temp\compressed.gz'.
        ```

        Compresses 'C:\Temp\file.txt' into a GZip archive named 'C:\Temp\compressed.gz'.

        .OUTPUTS
        System.String. Returns the destination file path after successful compression.

        .LINK
        https://psmodule.io/Compress/Functions/Compress-GZipArchive
    #>
    [CmdletBinding()]
    param(
        # Path to the file to be compressed.
        [Parameter(Mandatory)]
        [string] $Path,

        # Path to the output compressed file.
        [Parameter()]
        [string] $Destination = "$Path.gz"
    )

    $fileInput = New-Object System.IO.FileStream $Path, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
    $output = New-Object System.IO.FileStream $Destination, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
    $gzipStream = New-Object System.IO.Compression.GZipStream $output, ([IO.Compression.CompressionMode]::Compress)

    $buffer = New-Object byte[](1024)
    while ($true) {
        $read = $fileInput.Read($buffer, 0, 1024)
        if ($read -le 0) { break }
        $gzipStream.Write($buffer, 0, $read)
    }

    $gzipStream.Close()
    $output.Close()
    $fileInput.Close()
}
