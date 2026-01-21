--https://www.dbi-services.com/blog/reimage-your-oda-from-scratch/

cat /backup/Patch19.27/dbi_prepatch_backup.sh
# Backup important files before patching
export BKPPATH=/backup/Patch19.27/backup_ODA_`hostname`_`date +"%Y%m%d_%H%M"`
echo "Backing up to " $BKPPATH
mkdir -p $BKPPATH
odacli list-databases > $BKPPATH/list-databases.txt
ps -ef | grep pmon | grep -v ASM | grep -v APX | grep -v grep | cut -c 58- | sort > $BKPPATH/running-instances.txt
odacli list-dbhomes > $BKPPATH/list-dbhomes.txt
odacli list-dbsystems > $BKPPATH/list-dbsystems.txt
odacli list-vms > $BKPPATH/list-vms.txt
crontab -u oracle -l  > $BKPPATH/crontab-oracle.txt
crontab -u grid -l  > $BKPPATH/crontab-grid.txt
crontab -l  > $BKPPATH/crontab-root.txt

cat /etc/fstab >  $BKPPATH/fstab.txt
cat /etc/oratab >  $BKPPATH/oratab.txt
cat /etc/sysconfig/network >  $BKPPATH/etc-sysconfig-network.txt
cat /etc/hosts  >  $BKPPATH/hosts
cat /etc/resolv.conf  >  $BKPPATH/resolv.conf
cat /etc/sysctl.conf  >  $BKPPATH/

cp /etc/krb5.conf  $BKPPATH/
cp /etc/krb5.keytab  $BKPPATH/
mkdir $BKPPATH/network-scripts
cp  /etc/sysconfig/network-scripts/ifcfg*  $BKPPATH/network-scripts/
odacli describe-system > $BKPPATH/describe-system.txt
odacli  describe-component >  $BKPPATH/describe-component.txt
HISTFILE=~/.bash_history
set -o history
history > $BKPPATH/history-root.txt
cp /home/oracle/.bash_history $BKPPATH/history-oracle.txt
df -h >  $BKPPATH/filesystems-status.txt

for a in `odacli list-dbhomes -j | grep dbHomeLocation | awk -F '"' '{print $4}' | sort` ; do mkdir -p $BKPPATH/$a/network/admin/ ; cp $a/network/admin/tnsnames.ora $BKPPATH/$a/network/admin/; cp $a/network/admin/sqlnet.ora $BKPPATH/$a/network/admin/; done
for a in `odacli list-dbhomes -j | grep dbHomeLocation | awk -F '"' '{print $4}' | sort` ; do mkdir -p $BKPPATH/$a/owm/ ; cp -r $a/owm/* $BKPPATH/$a/owm/; done
cp `ps -ef | grep -v grep | grep LISTENER | awk -F ' ' '{print $8}' | awk -F 'bin' '{print $1}'`network/admin/listener.ora $BKPPATH/gridhome-listener.ora
cp `ps -ef | grep -v grep | grep LISTENER | awk -F ' ' '{print $8}' | awk -F 'bin' '{print $1}'`/network/admin/sqlnet.ora $BKPPATH/gridhome-sqlnet.ora

tar czf $BKPPATH/u01-app-oracle-admin.tgz /u01/app/oracle/admin/
tar czf $BKPPATH/u01-app-odaorabase-oracle-admin.tgz /u01/app/odaorabase/oracle/admin/
tar czf $BKPPATH/u01-app-oracle-local.tgz /u01/app/oracle/local/
tar czf $BKPPATH/home.tgz /home/
cp /etc/passwd $BKPPATH/
cp /etc/group $BKPPATH/

echo "End"
echo "Backup files size:"
du -hs  $BKPPATH
echo "Backup files content:"
ls -lrt  $BKPPATH

sh /backup/Patch19.27/dbi_prepatch_backup.sh
...
