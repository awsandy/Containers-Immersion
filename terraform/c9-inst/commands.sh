#!/bin/bash
echo 'Stack aws-cloud9-Project-mod-c24aacc7ec26455c-f18841777c90431a90805562ce34425f Importing 0 of 1 ..'
../../scripts/250-get-ec2-instances.sh i-0682333a3bef23ed1
echo 'Stack aws-cloud9-Project-mod-c24aacc7ec26455c-f18841777c90431a90805562ce34425f Importing 1 of 1 ..'
../../scripts/110-get-security-group.sh sg-04878d7caa7527a55
echo "Commands Done .."
