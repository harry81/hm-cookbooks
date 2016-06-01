#!/bin/bash

echo 'Packaging.'
berks package /tmp/cookbooks-temp.tar.gz
pushd /tmp
rm -rf /tmp/cookbooks-temp

mkdir /tmp/cookbooks-temp
cd /tmp/cookbooks-temp
tar -xzf  /tmp/cookbooks-temp.tar.gz
rm  /tmp/cookbooks-temp.tar.gz

echo 'Creating tar file.'
cd cookbooks
tar -czf  ../../hm-cookbooks.tar.gz *
cd ..
rm -rf cookbooks

echo 'Moving to S3'
aws s3 cp /tmp/hm-cookbooks.tar.gz s3://hm-cookbooks/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
popd
