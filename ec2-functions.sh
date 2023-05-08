

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

ec2-run() {
    declare name=$1

    : ${name:? required}

    aws ec2 run-instances \
      --image-id ami-0a0a0efaa60d3479f \
      --key-name boss \
      --instance-type t2.micro \
      --user-data file://user-data.sh \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${name}}]"
}

ec2-ips() {
    aws ec2 describe-instances \
      --filters Name=instance-state-name,Values=running \
    | jq .Reservations[].Instances[].PublicIpAddress -r
}