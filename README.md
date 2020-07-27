# SSL Certificate Converter

## What's this?
This is a useful PowerShell tool that can convert an SSL certificate and its private key from PEM format into PKCS12 (.PFX) format. 
PFX is the preferred format for Windows, so this is a tool created for Windows users.

## What problem does it solve?
Very frequently when requesting a new SSL certificate from any signing certificate provider you receive 2 files, the actual certificate (.crt or .cer) and the private key(.key) both in PEM format (plain text Base64 encoded).
This PowerShell script creates a GUI that allows to convert both files into a single PFX file, including (optional) intermediate and root CA certificates.

There are many Websites that offer you this service but uploading your certificate's private key over the Internet to a third party could expose and compromise the security of your SSL certificate. By running this converter locally in your machine, your private key remains private.

Advantages:
- Avoid disclosure of certificate private key
- Graphical User Interface, you don't need to type commands
- Store multiple files (certificate, private key, intermediate and root CA certificates) in a single file
- PFX is secured (encrypted) by a password and is a safe way to store and transfer your private key.

For instructions on how to use SSL Certificate Converter, please see the [Convert-SSL-Cert-from-PEM-to-PFX](Convert-SSL-Cert-from-PEM-to-PFX.pdf) PDF included in this repository files.
