# nube.pragmore.com server scripts

## nr - New repository

    nr <name> <domain>
    nr <domain>

Example

    nr default johndoe.nube.pragmore.com
    nr example.com

## nd - New domain

    nd <domain>

Example

    nd example.com

## ns - New subdomain

    ns <subdomain>

Example

    ns johndoe

## Create user

    add-user.sh <user> <email> [<pem>]

Example

    add-user.sh johndoe johndoe@example.com
    add-user.sh johndoe johndoe@example.com "ssh-rsa AAA...(public key pem)"

Creating a user and a default app

    add-user.sh johndoe johndoe@example.com "ssh-rsa AAA...(public key pem)"
    sudo runuser -u johndoe -- ns johndoe
    sudo runuser -u johndoe -- nr default johndoe.nube.pragmore.com | sudo mysql
