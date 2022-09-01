bn=$(aws s3 ls | grep mythicalbucket | awk '{print $3}')
reg=$(aws configure get region)
echo "http://$bn.s3-website.$reg.amazonaws.com/"