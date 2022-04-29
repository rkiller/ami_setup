echo Setup OSSEC
EB_APP_USER=$(sudo /opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
WORKSPACE=/home/$EB_APP_USER
WORKSPACE_OSSEC=${WORKSPACE}/ossec

echo Download OSSEC
wget -O ${WORKSPACE}/ossec.tar.gz https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz

echo Extract OSSEC package
sudo mkdir ${WORKSPACE_OSSEC} && tar -vxzf ${WORKSPACE}/ossec.tar.gz -C ${WORKSPACE_OSSEC} --strip-components 1

echo Configure install process
sudo cp -f ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf.example ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_LANGUAGE="en"^USER_LANGUAGE="en"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_NO_STOP="y"^USER_NO_STOP="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_INSTALL_TYPE="local"^USER_INSTALL_TYPE="local"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_DIR="/var/ossec"^USER_DIR="/var/ossec"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_DELETE_DIR="y"^USER_DELETE_DIR="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_ENABLE_ACTIVE_RESPONSE="y"^USER_ENABLE_ACTIVE_RESPONSE="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_ENABLE_SYSCHECK="y"^USER_ENABLE_SYSCHECK="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_ENABLE_ROOTCHECK="y"^USER_ENABLE_ROOTCHECK="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_UPDATE="y"^USER_UPDATE="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_UPDATE_RULES="y"^USER_UPDATE_RULES="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_ENABLE_EMAIL="y"^USER_ENABLE_EMAIL="n"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_ENABLE_SYSLOG="y"^USER_ENABLE_SYSLOG="y"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_ENABLE_FIREWALL_RESPONSE="y"^USER_ENABLE_FIREWALL_RESPONSE="n"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf
sudo sed -i -e 's^#USER_WHITE_LIST="192.168.2.1 192.168.1.0/24"^USER_WHITE_LIST="127.0.0.1"^' ${WORKSPACE_OSSEC}/etc/preloaded-vars.conf

echo Install PCRE2
#wget -O ${WORKSPACE_OSSEC}/pcre2-10.32.tar.gz https://ftp.pcre.org/pub/pcre/pcre2-10.32.tar.gz
wget -O ${WORKSPACE_OSSEC}/pcre2-10.32.tar.gz https://sourceforge.net/projects/pcre/files/pcre2/10.32/pcre2-10.32.tar.gz/download
tar xzf ${WORKSPACE_OSSEC}/pcre2-10.32.tar.gz -C ${WORKSPACE_OSSEC}/src/external

echo Install OSSEC
cd ${WORKSPACE_OSSEC}
sudo PCRE2_SYSTEM=no ZLIB_SYSTEM=no ./install.sh

echo Enabling JSON Alerts
sudo cp -f /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.copy
sudo sed -i '3 a <jsonout_output>yes</jsonout_output>' /var/ossec/etc/ossec.conf

echo $(sudo /var/ossec/bin/ossec-control status)

echo Starting/Restarting OSSEC
sudo /var/ossec/bin/ossec-control restart