reg=$(aws configure get region)
n=${#reg}
echo $n
if [[ $n .lt 0 ]];then
echo "region set incorrectly $reg"
exit
fi