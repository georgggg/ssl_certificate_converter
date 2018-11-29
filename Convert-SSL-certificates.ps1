#Converting SSL certificates to .PFX
#Script version 1.0

clear;
#Declare global variables
$inFile = "";
$inKey = "";
$inCACerts = "";
$inPass = "";

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


function convert([REF]$inFile, [REF]$inKey, [REF]$inCACerts, $inPass){
Write-Host "Executing convert function with parameters: " -ForegroundColor Green
Write-Host "inFile:    $($inFile.Value)" -ForegroundColor Green
Write-Host "inKey:     $($inKey.Value)" -ForegroundColor Green
Write-Host "inCACerts: $($inCACerts.Value)" -ForegroundColor Green
Write-Host "inPass:    *****" -ForegroundColor Green

if(($inFile.Value).ToString().Trim() -eq ""){
    [System.Windows.MessageBox]::Show("Not selecting a Certificate file? Try again and select a cert and private key files!")
    $false;
}

if(($inKey.Value).ToString().Trim() -eq ""){
    [System.Windows.MessageBox]::Show("Not selecting a private key file? Try again and select a cert and private key files!")
    $false;
}

$arr = ($inFile.Value).split(".")
$arr[$arr.length-1] = "pfx"
$outputFile = $arr -join "."

$expression = "$($PSScriptRoot)\OpenSSL\openssl.exe pkcs12 -export -out $($outputFile) -inkey $($inKey.Value) -in $($inFile.Value) -password pass:$($inPass)";
if($inCACerts.Value -ne ""){
    $expression = "$($expression) -certfile $($inCACerts.Value)";
}
Write-Host "Current dir: "$PSScriptRoot
Write-Host "OpenSSL referenced to: $($PSScriptRoot)\OpenSSL\openssl.exe"
Invoke-Expression $expression
Write-Host "PFX certificate saved to: $($outputFile )"
$SavedLabel.Text = "PFX certificate saved to: $($outputFile )"

}


Function selectInputFile($selectingElement, [REF]$inFile, [REF]$inKey, [REF]$inCACerts) {

    $openFileDialog = New-Object windows.forms.openfiledialog   
    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
    if($selectingElement -eq "key"){
        $openFileDialog.title = "Select Private Key File (PEM format)"
    }
    elseif($selectingElement -eq "cert"){
        $openFileDialog.title = "Select SSL Certificate File to Convert (PEM format)"
    }
    elseif($selectingElement -eq "ca"){
        $openFileDialog.title = "Select CAs Certificate Chain File (PEM format)"
    }
    else{ 
        Write-Host "Error selecting files: bad file type requested" -ForegroundColor Red 
        return;
    }
    
    $openFileDialog.filter = "All files (*.*)| *.*"   
    $openFileDialog.ShowHelp = $True

    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
    $result 
    if($result -eq "OK"){
        Write-Host $OpenFileDialog.filename
        Write-Host "$selectingElement file was selected!" -ForegroundColor Green
    }
    else { Write-Host "$selectingElement file not selected!" -ForegroundColor Yellow}

    if($selectingElement -eq "key"){
        $inKey.Value = $OpenFileDialog.filename;
        $KeyFilePath.text = $OpenFileDialog.filename;
    }
    elseif($selectingElement -eq "cert"){
        $inFile.Value = $OpenFileDialog.filename;
        $InputFilePath.text = $OpenFileDialog.filename;
    }
    elseif($selectingElement -eq "ca"){
        $inCACerts.Value = $OpenFileDialog.filename;
        $CAFilePath.text = $OpenFileDialog.filename;
    }
    else{}
}

#region begin GUI{ 

$SSLConverterForm                = New-Object system.Windows.Forms.Form
$SSLConverterForm.ClientSize     = '500,450'
$SSLConverterForm.text           = "SSL certificates converter (only PEM to PFX format) v1.0"
$SSLConverterForm.TopMost        = $false

$FileSelector                    = New-Object system.Windows.Forms.Button
$FileSelector.text               = "Select cert file"
$FileSelector.width              = 113
$FileSelector.height             = 30
$FileSelector.location           = New-Object System.Drawing.Point(10,20)
$FileSelector.Font               = 'Microsoft Sans Serif,10'

$InputFilePath                   = New-Object system.Windows.Forms.Label
$InputFilePath.text              = "Input cert file path"
$InputFilePath.AutoSize          = $true
$InputFilePath.MaximumSize       = New-Object System.Drawing.Point(300)
$InputFilePath.width             = 25
$InputFilePath.height            = 20
$InputFilePath.location          = New-Object System.Drawing.Point(156,20)
$InputFilePath.Font              = 'Microsoft Sans Serif,9'

$KeySelector                    = New-Object system.Windows.Forms.Button
$KeySelector.text               = "Select key file"
$KeySelector.width              = 113
$KeySelector.height             = 30
$KeySelector.location           = New-Object System.Drawing.Point(10,120)
$KeySelector.Font               = 'Microsoft Sans Serif,10'

$KeyFilePath                   = New-Object system.Windows.Forms.Label
$KeyFilePath.text              = "Private key file path: "
$KeyFilePath.AutoSize          = $true
$KeyFilePath.MaximumSize       = New-Object System.Drawing.Point(300)
$KeyFilePath.width             = 25
$KeyFilePath.height            = 10
$KeyFilePath.location          = New-Object System.Drawing.Point(156,120)
$KeyFilePath.Font              = 'Microsoft Sans Serif,9'


$SelectCAs                       = New-Object system.Windows.Forms.Button
$SelectCAs.text                  = "Intermediate CA"
$SelectCAs.width                 = 115
$SelectCAs.height                = 30
$SelectCAs.location              = New-Object System.Drawing.Point(10,220)
$SelectCAs.Font                  = 'Microsoft Sans Serif,10'

$CAFilePath                   = New-Object system.Windows.Forms.Label
$CAFilePath.text              = "Intermediate and/or root CA file path: "
$CAFilePath.AutoSize          = $true
$CAFilePath.MaximumSize       = New-Object System.Drawing.Point(300)
$CAFilePath.width             = 25
$CAFilePath.height            = 10
$CAFilePath.location          = New-Object System.Drawing.Point(156,220)
$CAFilePath.Font              = 'Microsoft Sans Serif,9'

$PassLabel                       = New-Object system.Windows.Forms.Label
$PassLabel.text                  = "Password:"
$PassLabel.AutoSize              = $true
$PassLabel.width                 = 25
$PassLabel.height                = 10
$PassLabel.location              = New-Object System.Drawing.Point(23,270)
$PassLabel.Font                  = 'Microsoft Sans Serif,10'

$Password                        = New-Object System.Windows.Forms.MaskedTextBox
$Password.PasswordChar           = "*"
$Password.multiline              = $false
$Password.width                  = 150
$Password.height                 = 20
$Password.location               = New-Object System.Drawing.Point(220,270)
$Password.Font                   = 'Microsoft Sans Serif,10'

$SavedLabel                      = New-Object System.Windows.Forms.Label
$SavedLabel.AutoSize             = $true
$SavedLabel.MaximumSize          = New-Object System.Drawing.Point(400)
$SavedLabel.width                = 150
$SavedLabel.height               = 20
$SavedLabel.text                 = ""
$SavedLabel.location             = New-Object System.Drawing.Point(23,300)
$SavedLabel.Font                 = 'Microsoft Sans Serif,9'

$convertButton                   = New-Object system.Windows.Forms.Button
$convertButton.text              = "Convert"
$convertButton.width             = 100
$convertButton.height            = 30
$convertButton.location          = New-Object System.Drawing.Point(245,380)
$convertButton.Font              = 'Microsoft Sans Serif,10'

$SSLConverterForm.controls.AddRange(@($FileSelector,$InputFilePath,$KeySelector,$KeyFilePath,$SelectCAs,$CAFilePath, $PassLabel, $Password, $convertButton, $SavedLabel))

#region gui events {
$FileSelector.Add_Click({ selectInputFile -selectingElement "cert" -inFile ([REF]$inFile) -inKey ([REF]$inKey) -inCACerts ([REF]$inCACerts) });
$KeySelector.Add_Click({ selectInputFile -selectingElement "key" -inFile ([REF]$inFile) -inKey ([REF]$inKey) -inCACerts ([REF]$inCACerts) });
$SelectCAs.Add_Click({ selectInputFile -selectingElement "ca" -inFile ([REF]$inFile) -inKey ([REF]$inKey) -inCACerts ([REF]$inCACerts) });
$convertButton.Add_Click({ convert -inFile ([REF]$inFile) -inKey ([REF]$inKey) -inCACerts ([REF]$inCACerts) -inPass ($Password.Text) });

#endregion events }

#endregion GUI }


#Write your logic code here

[void]$SSLConverterForm.ShowDialog()
