#!/bin/bash
echo ">>>> Install Oracle preinstall package"
yum install -y oracle-rdbms-server-12cR1-preinstall.x86_64

echo ">>>> Setup Oracle user"
echo oracle:vagrant | chpasswd

echo ">>>> Oracle environment variables"
cat /vagrant/bashrc >>/home/oracle/.bashrc
cat /vagrant/bashrc >>/home/vagrant/.bashrc

echo ">>>> Prepare for Oracle installation"
mkdir -p /u01/app/oracle/distribs
mkdir -p /u01/app/oraInventory
for i in /vagrant/orafiles/*.zip; do unzip $i -d /u01/app/oracle/distribs >/dev/null; done
chown -R oracle:dba /u01
echo 'inventory_loc=/u01/app/oracle/oraInventory' > /etc/oraInst.loc
echo 'inst_group=oinstall' >> /etc/oraInst.loc

echo ">>>> Install Oracle"
echo ">>>> It's going to run in background, so we will peek at processed to see when it finishes"
sudo -u oracle bash -c 'source /home/oracle/.bashrc; $ORACLE_BASE/distribs/database/runInstaller -silent -responseFile $ORACLE_BASE/distribs/database/response/db_install.rsp oracle.install.option=INSTALL_DB_SWONLY ORACLE_HOME=$ORACLE_HOME ORACLE_BASE=$ORACLE_BASE oracle.install.db.InstallEdition=EE oracle.install.db.DBA_GROUP=dba oracle.install.db.BACKUPDBA_GROUP=dba oracle.install.db.DGDBA_GROUP=dba oracle.install.db.KMDBA_GROUP=dba DECLINE_SECURITY_UPDATES=true SECURITY_UPDATES_VIA_MYORACLESUPPORT=false oracle.installer.autoupdates.option=SKIP_UPDATES'
sleep 5
while [[ $(ps -ef | grep '^oracle' | wc -l) -gt 0 ]]; do
	sleep 20
	echo ">>>> ..."
done

echo ">>>> Post-install config"
/u01/app/oracle/product/12.1.0/db_1/root.sh

echo ">>>> Configure listener"
sudo -u oracle bash -c 'source /home/oracle/.bashrc; netca -silent -responsefile $ORACLE_HOME/network/install/netca_typ.rsp'

echo ">>>> Create database"
sudo -u oracle bash -c 'source /home/oracle/.bashrc; dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName cdb0 -createAsContainerDatabase true -sysPassword vagrant -systemPassword vagrant -emConfiguration NONE -storageType FS -characterSet AL32UTF8 -totalMemory 2048'

echo ">>>> Autostart listener and database"
sed -i 's/N$/Y/' /etc/oratab
\cp /vagrant/oracledb /etc/init.d/
chmod 755 /etc/init.d/oracledb
chkconfig --add oracledb

echo ">>>> Autostart PDBs"
sudo -u oracle bash -c 'source /home/oracle/.bashrc; sqlplus -L -s sys/vagrant@cdb0 as sysdba @/vagrant/startup_all_pdbs.sql'

echo ">>>> Deploy PDB management scripts"
mkdir /home/oracle/bin
\cp /vagrant/pdb /home/oracle/bin
chown -R oracle:oinstall /home/oracle
chmod a+rx /home/oracle
chmod -R a+rx /home/oracle/bin

echo ">>>> Remove installation files"
rm -rf /u01/app/oracle/distribs

