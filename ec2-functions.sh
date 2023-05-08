

ec2-nuke() {
    ids=$(
        aws ec2 describe-instances \
          --filters Name=instance-state-name,Values=running \
          | jq .Reservations[].Instances[].InstanceId -r
    )
    echo instances: $ids

    for id in ${ids}; do
      echo === delete instance: $id
      aws ec2 terminate-instances --instance-ids $id
    done
}

alias r='. ec2-functions.sh '

ec2-envs() {
. ec2.env
cat <<EOF
DB_URL=$DB_URL
TITLE=$TITLE
COLOR=$COLOR
EIP=$EIP
EOF
}

ec2-run() {
    declare name=$1

    : ${name:? required}

    curl https://raw.githubusercontent.com/lalyos/docker-sigma/master/user-data.sh.tmpl \
      | envsubst > user-data.sh

    aws ec2 run-instances \
      --image-id ami-0a0a0efaa60d3479f \
      --key-name boss \
      --instance-type t2.micro \
      --user-data file://user-data.sh \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${name}}]" \
       > ec2-run.log
}

ec2-assign() {
    ins=$(cat ec2-run.log| jq -r .Instances[0].InstanceId)

   aws ec2 associate-address \
     --instance-id ${ins} \
     --public-ip ${EIP}
}


ec2-ips() {
    aws ec2 describe-instances \
      --filters Name=instance-state-name,Values=running \
    | jq '.Reservations[].Instances[]|[(.Tags[] | select(.Key == "Name").Value ),.PublicIpAddress]' -cr
}