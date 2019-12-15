#makes console aware that script shall run in sh shell
#!/bin/sh

#generates local SSH key-pair in the current directory with filename id_rsa (-f...), "CC1" as passphrase (-N...) and by default of type rsa. overwrites existing key with same name
yes y | ssh-keygen -f id_rsa -N "CC1"

#ensures, there is a default vpc by creating one, if there is none already
aws ec2 create-default-vpc

#imports key pair with name id_rsa from current directory
aws ec2 import-key-pair \
--key-name id_rsa \
--public-key-material file://./id_rsa.pub

#creates a security group with name "securitygroup_group01" with description "Security Group of Group 01" for the default vpc
aws ec2 create-security-group \
--group-name securitygroup_group01 \
--description "Security Group of Group 01"

#adds rule for incoming traffic for the security group "securitygroup_group01": allows all incoming icmp traffic for all IPs
aws ec2 authorize-security-group-ingress \
--group-name securitygroup_group01 \
--ip-permissions IpProtocol=icmp,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=0.0.0.0/0}]'

#adds rule for incoming traffic for the security group "securitygroup_group01": allows all incoming SSH traffic for all IPs
aws ec2 authorize-security-group-ingress \
--group-name securitygroup_group01 \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0

#runs an instance of type t2.micro (Ubuntu Server 18.04, Image ID ami-02ae2161f61b9102a) with created keypair and securitygroup_group01
aws ec2 run-instances \
--image-id ami-02ae2161f61b9102a \
--instance-type t2.micro \
--key-name id_rsa \
--security-groups "securitygroup_group01"

#### CRONTAB entry for regularly running the benchmark ####
#
#    */30 * * * *   root   /PATH/TO/SCRIPT/benchmark.sh
#
# explanation:
#   run script benchmark.sh with user root in intervals of 30 minutes
#   in every hour of every day of the week
