echo Install tools
ARCHITECTURE=$(uname -m)
echo "Installing tools for $ARCHITECTURE architecture"

sudo yum update -y

# From ossec.sh
sudo yum install -y zlib-devel pcre2-devel make gcc zlib-devel pcre2-devel sqlite-devel openssl-devel libevent-devel systemd-devel

# from imagemagick.sh
sudo yum -y makecache
sudo yum -y install libtool
sudo yum -y install gcc-c++
sudo yum -y groupinstall "Development Tools"
sudo yum -y install jbigkit.$ARCHITECTURE jbigkit-devel.$ARCHITECTURE