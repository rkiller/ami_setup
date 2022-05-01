ARCHITECTURE=$(uname -m)
if [ "$ARCHITECTURE" = "aarch64" ]; then
	# For aarch64:
	wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/pdftk-java-3.3.2-1.el7.noarch.rpm
	sudo yum -y install apache-commons-lang3 bouncycastle
	sudo rpm -Uvh pdftk-java*rpm
	sudo rm -rf pdftk-java-3.3.2-1.el7.noarch.rpm
else
	sudo wget -O /usr/lib64/libgcj.so.10 https://github.com/lob/lambda-pdftk-example/raw/master/bin/libgcj.so.10
	sudo wget -O /usr/bin/pdftk https://github.com/lob/lambda-pdftk-example/raw/master/bin/pdftk
	sudo chmod a+x /usr/bin/pdftk
fi