#!/bin/zsh

emulate -L zsh

local stopped=${1}
# run docker inspect on an id 
# to get some info about it
function inspect(){
  while read container; do 
    docker inspect ${container} | jq '.[]'; 
  done 
}

# format the inspect json dump to a 
# manageable json with just what we need
function jq_format(){
  jq -s '[.[] | {Name,Platform,Cmd: .Config.Cmd| join(" "),Id: .Config.Hostname,Image:.Config.Image,State: .State.Status, Running: .State.Running}]' 
}

# docker list running and just output id
# only running / started containers
function docker_containers(){
  
  [[ ${stopped} -eq 0 ]] && {
    # output only running containers
    docker ps -q 
  } || {
    # comment above, uncomment below to 
    # get ALL containers including exited / not running
    docker ps -a -q
  }

}


function main(){
  docker_containers | inspect | jq_format | tr -d " \n"
}

main
