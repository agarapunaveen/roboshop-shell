instances=("web" "mongodb" "catalogue" "redis" "user" "cart" "mysql" "shipping" "rabbitmq" "payment" "dispatch")

for name in ${instances[@]};
do
  if [ $name == "shipping" ] || [ $name == "mysql" ]
  then
   instance_type="t3.medium"
  else
   instance_type="t3.micro" 
  fi
  echo "creating instance for:$name with instance type: $instance_type"

  instance_id=$(aws ec2 run-instances --image-id ami-041e2ea9402c46c32  --instance-type $instance_type --key-name MyKeyPair --security-group-ids sg-09ea0a2725aa44306 --subnet-id subnet-07abc19bfb61f049f --query 'instances[0].InstanceId' --output text)
  aws ec2 create-tags \
    --resources $instance_id \
    --tags Key=name,Value=$name
    echo "instance created for:$name"
done