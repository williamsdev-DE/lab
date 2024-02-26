# Connect to MySQL
mysql -u lab -p -h PGPRI -P 5566

# Create roles
CREATE ROLE 'dba', 'devs', 'applications';

# Grant privileges to roles
GRANT ALL PRIVILEGES ON *.* TO 'dba';
GRANT SELECT ON music.* TO 'devs';
GRANT SELECT ON music.* TO 'applications';
FLUSH PRIVILEGES;

# Create users and assign them to roles
CREATE USER 'web_app'@'%' IDENTIFIED BY 'AppPassword';
GRANT 'applications' TO 'web_app'@'%';

#User creation for all DBAs
CREATE USER 'dba_1'@'%' IDENTIFIED BY 'Lab@d1';
CREATE USER 'dba_2'@'%' IDENTIFIED BY 'Lab@d1';
CREATE USER 'dba_3'@'%' IDENTIFIED BY 'Lab@d1';
GRANT 'dba' TO 'dba_1'@'%';
GRANT 'dba' TO 'dba_2'@'%';
GRANT 'dba' TO 'dba_3'@'%';

#User creation for all developers
CREATE USER 'dev_user1'@'%' IDENTIFIED BY 'Lab@d1';
CREATE USER 'dev_user2'@'%' IDENTIFIED BY 'Lab@d2';
CREATE USER 'dev_user3'@'%' IDENTIFIED BY 'Lab@d3';
CREATE USER 'dev_user4'@'%' IDENTIFIED BY 'Lab@d4';
CREATE USER 'dev_user5'@'%' IDENTIFIED BY 'Lab@d5';
CREATE USER 'dev_user6'@'%' IDENTIFIED BY 'Lab@d6';
CREATE USER 'dev_user7'@'%' IDENTIFIED BY 'Lab@d7';
CREATE USER 'dev_user8'@'%' IDENTIFIED BY 'Lab@d8';
CREATE USER 'dev_user9'@'%' IDENTIFIED BY 'Lab@d9';
CREATE USER 'dev_user10'@'%' IDENTIFIED BY 'Lab@10';
GRANT 'dev' TO 'dev_user1'@'%';
GRANT 'dev' TO 'dev_user2'@'%';
GRANT 'dev' TO 'dev_user3'@'%';
GRANT 'dev' TO 'dev_user4'@'%';
GRANT 'dev' TO 'dev_user5'@'%';
GRANT 'dev' TO 'dev_user6'@'%';
GRANT 'dev' TO 'dev_user7'@'%';
GRANT 'dev' TO 'dev_user8'@'%';
GRANT 'dev' TO 'dev_user9'@'%';
GRANT 'dev' TO 'dev_user10'@'%';

# Set default roles
SET DEFAULT ROLE 'application' TO 'webb_app'@'%';
SET DEFAULT ROLE 'dba' TO 'dba_1'@'%';
SET DEFAULT ROLE 'dba' TO 'dba_2'@'%';
SET DEFAULT ROLE 'dba' TO 'dba_3'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user1'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user2'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user3'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user4'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user5'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user6'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user7'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user8'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user9'@'%';
SET DEFAULT ROLE 'devs' TO 'dev_user10'@'%';

FLUSH PRIVILEGES;
