#makes console aware that script shall run in sh shell
#!/bin/sh

#generates local SSH key-pair of type rsa (-t rsa) in the current directory with filename id_rsa (-f...),"member1" as username and "CC1" as passphrase (-N...)
yes y | ssh-keygen -t rsa -f id_rsa -C member1 -N "CC1"

#creates modified public key from a copy of the original key, that adds expiry date as 20.01.2020 and fits google cloud format
sed s/"member1"/"google-ssh {\"userName\":\"member1\",\"expireOn\":\"2020-01-20T05:10:00+0000\"}"/ id_rsa.pub > modified_key.pub

#creates text file that lists all public SSH keys that are supposed to be used project-wide (in this case by adding modified_ey.pub and its user name in the required format to the file)
echo -n "member1:" | cat > sshkeys_list.txt
cat modified_key.pub >> sshkeys_list.txt

#sets project-wide SSH keys by loading the sshkeys_list.txt file in the metadata
gcloud compute project-info add-metadata --metadata-from-file ssh-keys=sshkeys_list.txt

#creates firewall rule that allows all incoming icmp traffic for instances with tag "cloud-computing"
gcloud compute firewall-rules create allow-icmp \
--direction ingress \
--action allow \
--rules icmp \
--enable-logging \
--target-tags cloud-computing

#creates firewall rule that allows all incoming SSH traffic for instances with tag "cloud-computing"
gcloud compute firewall-rules create allow-ssh \
--direction ingress \
--action allow \
--rules tcp:22 \
--enable-logging \
--target-tags cloud-computing

#launches an instance with tag "cloud-computing", of machine type g1-small, for the specified public image (by ID), of the project family "gce-uefi-images" in the zone europe-north1-a
gcloud compute instances create group01instance \
--machine-type g1-small \
--tags=cloud-computing \
--image ubuntu-1804-bionic-v20191113 \
--image-project gce-uefi-images \
--zone europe-north1-a

#### CRONTAB entry for regularly running the benchmark ####
#
#    */30 * * * *   root   /PATH/TO/SCRIPT/benchmark.sh
#
# explanation:
#   run script benchmark.sh with user root in intervals of 30 minutes
#   in every hour of every day of the week
