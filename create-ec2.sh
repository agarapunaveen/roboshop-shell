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
done