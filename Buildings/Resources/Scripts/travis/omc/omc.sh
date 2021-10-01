#!/bin/bash
#################################################
# Shell script that simulates with OpenModelica using
# a docker image of OMC
#
# The main purpose of this script is to export
# MODELICAPATH
# updated for the docker, and to mount the
# required directories.
#################################################
set -e
IMG_NAME=ubuntu-2004-omc:1.18.0
DOCKER_USERNAME=michaelwetter

# If the current directory is part of the argument list,
# replace it with . as the docker may have a different file structure
cur_dir=`pwd`
bas_nam=`basename ${cur_dir}`
arg_lis=`echo $@ | sed -e "s|${cur_dir}|.|g"`

# Set variable for shared directory
sha_dir=`dirname ${cur_dir}`

# Check if the python script should be run interactively (if -i is specified)
while [ $# -ne 0 ]
do
    arg="$1"
    case "$arg" in
        -i)
            interactive=true
            DOCKER_INTERACTIVE=-t
            ;;
    esac
    shift
done

# --user=${UID} \

docker run \
  --user=${UID} \
  -i \
  $DOCKER_INTERACTIVE \
  --detach=false \
  -v ${sha_dir}:/mnt/shared \
  --rm \
  ${DOCKER_USERNAME}/${IMG_NAME} /bin/bash -c \
  "cd /mnt/shared/${bas_nam} && \
  omc ${arg_lis}"
exit $?
