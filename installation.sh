sudo apt install yum
#sudo yum update

# Java-11 Installation and Path Setup
    sudo yum -y install java-11-openjdk-devel
    echo "export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))" | sudo tee -a /etc/profile
    source /etc/profile
    echo "export PATH=$PATH:$JAVA_HOME/bin" | sudo tee -a /etc/profile
    echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" | sudo tee -a /etc/profile
    source /etc/profile


# Tomcat-9 Installation and Path Setup
    sudo groupadd tomcat
    sudo mkdir /opt/tomcat
    sudo useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

    sudo yum -y install wget

    cd ~
    wget http://apache.mirrors.pair.com/tomcat/tomcat-9/v9.0.21/bin/apache-tomcat-9.0.21.tar.gz
    sudo tar -zxvf apache-tomcat-9.0.21.tar.gz -C /opt/tomcat --strip-components=1
    sudo rm -r apache-tomcat-9.0.21.tar.gz

    cd /opt/tomcat
    sudo chgrp -R tomcat conf
    sudo chmod g+rwx conf
    sudo chmod -R g+r conf
    sudo chown -R tomcat logs/ temp/ webapps/ work/

    sudo chgrp -R tomcat bin
    sudo chgrp -R tomcat lib
    sudo chmod g+rwx bin
    sudo chmod -R g+r bin

    echo "[Unit]
    Description=Apache Tomcat Web Application Container
    After=syslog.target network.target
    [Service]
    Type=forking
    Environment=JAVA_HOME=/usr/lib/jvm/jre
    Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
    Environment=CATALINA_HOME=/opt/tomcat
    Environment=CATALINA_BASE=/opt/tomcat
    Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
    Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
    WorkingDirectory=/opt/tomcat
    ExecStart=/opt/tomcat/bin/startup.sh
    ExecStop=/bin/kill -15 $MAINPID
    User=tomcat
    Group=tomcat
    UMask=0007
    RestartSec=10
    Restart=always
    [Install]
    WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/tomcat.service

    sudo systemctl daemon-reload
    # sudo systemctl start tomcat.service
    sudo systemctl status tomcat.service

    sudo systemctl enable tomcat.service

    sudo sed -i '$ d' /opt/tomcat/conf/tomcat-users.xml
sudo echo -e "\t<role rolename=\"manager-gui\"/>
\t<user username=\"manager\" password=\"manager\" roles=\"manager-gui\"/>
</tomcat-users>" | sudo tee -a /opt/tomcat/conf/tomcat-users.xml
    # sudo systemctl restart tomcat.service

    # sudo systemctl stop tomcat.service

    sudo systemctl status tomcat.service
    sudo su
    sudo chmod -R 777 webapps
    sudo chmod -R 777 work
    sudo rm -rf /opt/tomcat/webapps/*
    sudo rm -rf /opt/tomcat/work/*
    sudo ls /opt/tomcat/webapps

    sudo systemctl start tomcat.service