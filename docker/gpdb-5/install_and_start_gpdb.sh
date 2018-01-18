source /home/gp/.bash_profile
ssh-keygen -f /home/gp/.ssh/id_rsa -t rsa -N ""
echo `hostname` > /gpdata/hostlist_singlenode
sed -i 's/hostname_of_machine/`hostname`/g' /gpdata/gpinitsystem_singlenode
sudo /etc/init.d/ssh start

sudo su - gp bash -c 'gpssh-exkeys -f /gpdata/hostlist_singlenode'

pushd /gpdata
  gpinitsystem -ac gpinitsystem_singlenode
popd
