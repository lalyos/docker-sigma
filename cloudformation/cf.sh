#!/usr/bin/env bash

debug() {
    if ((DEBUG)); then
       echo "===> [${FUNCNAME[1]}] $*" 1>&2
    fi
}

list-commands() {
  echo "available commands:"
  sed -n 's/\(.*\)().*/  ::\1/p' ${BASH_SOURCE} \
   | grep -v 'main\|debug\|sed\|list-commands' \
   | sort
}

events() {
  declare stack=$1
  : ${stack:? required}

  aws cloudformation describe-stack-events --stack-name ${stack} \
  | jq '.StackEvents[]|[.ResourceStatus,.ResourceType]' -c
}

main() {
  # if last arg is -d sets DEBUG
  [[ ${@:$#} =~ ^-d ]] && { set -- "${@:1:$(($#-1))}" ; DEBUG=1 ; } || :

  if [[ $1 =~ :: ]]; then 
    debug DIRECT-COMMAND  ...
    command=${1#::}
    shift
    $command "$@"
  else 
    debug default-command
    list-commands
  fi 
}

alias r=". $BASH_SOURCE"
[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
