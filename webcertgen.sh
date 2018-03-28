#!/bin/bash
##################################################################
## generate new keystore/cert and bind to jetty9                ##
## written specifically for RSA Security Analytics 10.4 to 10.6 ##
## Created by Jesse Carleton                                    ##
##################################################################

clear
echo "This script will remove the existing SSL configuration, and generate a new one."
echo ""
read -r -p "Are you sure you want to do this? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
        echo "WARNING: The hostname entered will be also used as the keystore's alias."
        echo -n "Enter the hostname and press [ENTER]: "
        read hostnameZ
        echo -n "Enter the IP address for this host and press [ENTER]: "
        read ipZ
        echo -n "Enter your desired keystore password and press [ENTER]: "
        read passwordZ

        mkdir ~/cert/new/
        mkdir ~/cert/backup/
        echo ""
        echo "Backing up old config to ~/cert/backup/"
        echo ""
        cp -r /opt/rsa/jetty9/etc ~/cert/backup/
        keytool -genkeypair -alias $hostnameZ -keyalg RSA -keysize 4096 - sigalg SHA256withRSA -keystore ~/cert/new/keystore -ext san=dns:$hostnameZ,ip:$ipZ
        keytool -certreq -alias $hostnameZ -keystore ~/cert/new/keystore -file ~/cert/new/sa.csr
        cat ~/cert/new/sa.csr
        echo ""
        echo ""
        echo "Get this CSR signed by your Certificate Authority."
        echo "Upload this as ~/cert/new/$hostnameZ.pem"
        read -p "Press any key when done to continue... " -n1 -s
        java -cp /opt/rsa/jetty9/lib/jetty-util* org.eclipse.jetty.util.security.Password '$passwordZ'
        echo ""
        echo ""
        echo "Copy the OBF string above and paste into the KeyStorePassword, KeyManagerPassword, and TrustStorePassword fields. Please note this in your KeePass DB for future reference, along with the original unobfuscated keystore password."
        echo "Jetty will also be stopped to prevent issues."
        read -p "Press any key to continue... " -n1 -s
        stop jettysrv
        nano /opt/rsa/jetty9/etc/jetty-ssl.xml
        rm -f /opt/rsa/jetty9/etc/keystore
        cp ~/cert/new/keystore /opt/rsa/jetty9/etc/keystore
        keytool -import -trustcacerts -keystore /opt/rsa/jetty9/etc/keystore -alias $hostnameZ -file /root/cert/new/$hostnameZ.pem
        cp /etc/puppet/modules/saserver/files/jetty-ssl.xml /etc/puppet/modules/saserver/files/jetty-ssl.xml.bakup
        cp /opt/rsa/jetty9/etc/jetty-ssl.xml  /etc/puppet/modules/saserver/files/jetty-ssl.xml
        keytool -list -keystore /opt/rsa/jetty9/etc/keystore
        echo ""
        echo ""
        echo "Please confirm that this appears to be correct."
        read -p "Press any key to continue... " -n1 -s
        start jettysrv

else
    echo -n "Quitting..."
        echo ""
fi
