instances=("web" "mongodb" "catalogue" "redis" "user" "cart" "mysql" "shipping" "rabbitmq" "payment" "dispatch")
domain_name=naveencloud.online
hosted_zone_id=Z0976808CYP3KUCUVNE3
for name in ${instances[@]};
do
  if [ $name == "shipping" ] || [ $name == "mysql" ]
  then
   instance_type="t3.medium"
  else
   instance_type="t3.micro" 
  fi
  echo "creating instance for:$name with instance type: $instance_type"

  instance_id=$(aws ec2 run-instances --image-id ami-041e2ea9402c46c32  --instance-type $instance_type  --security-group-ids sg-09ea0a2725aa44306 --subnet-id subnet-01bb45782f2726bdf --query 'instances[0].InstanceId' --output text)
  aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$name
    echo "instance created for:$name"
   if [ $name == "web" ]
      then
      aws ec2 wait instance-running --instance-ids $instance_id
        public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
        ip_to_use=$public_ip
      else
        private_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
        ip_to_use=$private_ip

    fi
    echo "instance name:$name ip_address:$ip_to_use"

    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch '{"Changes":[{"Action":"UPSERT",
  "ResourceRecordSet":{"Name":"'$name.$domain_name'",
                       "Type":"A",
                       "TTL":1,
                       "ResourceRecords":
                       [{"Value":"'$ip_to_use'"}]}}]}'
done