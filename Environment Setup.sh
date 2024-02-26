# Environment Setup Script for MySQL InnoDB Cluster

# Pre-requisites:
# - Oracle Enterprise Linux 8 systems prepared: PGPRI (192.168.56.2), PGSTB (192.168.56.3), PGBAK (192.168.56.4)
# - SSH access with sudo privileges on each system
# - Firewall configured to allow traffic on port 5566

# Step 1: Add MySQL APT Repository on all servers
sudo wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
sudo rpm -Uvh mysql80-community-release-el8-1.noarch.rpm

# Step 2: Install MySQL Server and Shell on all servers
sudo yum install -y mysql-community-server mysql-shell

# Step 3: Configure MySQL on all servers
# - Log into MySQL as root
# - Create the admin user
mysql -u root -p << EOF
CREATE USER 'lab'@'%' IDENTIFIED BY 'Lab@123';
GRANT ALL PRIVILEGES ON *.* TO 'lab'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Update MySQL configuration to listen on all interfaces and port 5566
echo "bind-address = 0.0.0.0" | sudo tee -a /etc/my.cnf.d/mysql-server.cnf
echo "port = 5566" | sudo tee -a /etc/my.cnf.d/mysql-server.cnf
sudo systemctl restart mysqld

# Add MySQL custom port to SELinux policy
sudo semanage port -a -t mysqld_port_t -p tcp 5566

# Step 4: Setup MySQL InnoDB Cluster
# On PGPRI
mysqlsh --uri lab@PGPRI:5566 --password=YourSecurePassword << EOF
dba.configureInstance('lab@PGPRI:5566', {clusterAdmin:"lab", clusterAdminPassword:"YourSecurePassword", interactive:false, restart:true});
var cluster = dba.createCluster('LabCluster');
cluster.addInstance('lab@PGSTB:5566', {recoveryMethod:'clone'});
cluster.addInstance('lab@PGBAK:5566', {recoveryMethod:'clone'});
cluster.status();
EOF