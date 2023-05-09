

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
cat -vet <<EOF
AWS_DEFAULT_PROFILE=$AWS_DEFAULT_PROFILE
DB_URL=$DB_URL
DB_TABLE=$DB_TABLE
TITLE=$TITLE
COLOR=$COLOR
EIP=$EIP
EOF
}

create-user-table() {
    declare user=$1
    : ${user:? reuired}

    sed "s/vip/vip${user}/g" ../sql/init.sql | tee tmp.sql
    psql $DB_URL -f tmp.sql 
}

insert-user-table() {
    declare user=$1
    : ${user:? reuired}

    cat > tmp.sql  <<EOF
insert into vip${user} values ('${user}', 33, 99);
EOF
  psql $DB_URL -f tmp.sql 
}

team() {                                                                                                
cat <<EOF                                                                                               
lalyos                                                                                                  
geri                                                                                                    
barna                                                                                                   
robin                                                                                                   
attila                                                                                                  
bencej                                                                                                  
laci                                                                                                    
gabor                                                                                                   
norbi                                                                                                   
andras                                                                                                  
kristof                                                                                                 
EOF
}


create-all-table() {
  for u in $(team); do 
    echo === next user: $u
    create-user-table $u
  done
}

insert-all-table() {
  for u in $(team); do 
    echo === next user: $u
    insert-user-table $u
  done
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
    
    echo wait for instance to start ...
    aws ec2 wait \
      instance-running \
      --instance-ids $(cat ec2-run.log | jq .Instances[0].InstanceId -r)
    
    ec2-assign
}


ec2-log() {
    echo === loggin user-data
    ssh ec2 tail -f /var/log/cloud-init-output.log
    echo === loggin flask
    ssh ec2 tail -f /var/log/flask.log
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