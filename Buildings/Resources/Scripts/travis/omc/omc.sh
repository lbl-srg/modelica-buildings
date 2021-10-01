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

# Function declarations
function create_mount_command()
{
   local pat="$1"
   # Each entry in pat will be a mounted read-only volume
   local mnt_cmd=""
   for ele in ${pat//:/ }; do
      mnt_cmd="${mnt_cmd} -v ${ele}:/mnt${ele}:ro"
   done

   # On Darwin, the exported temporary folder needs to be /private/var/folders, not /var/folders
   # see https://askubuntu.com/questions/600018/how-to-display-the-paths-in-path-separately
   if [ `uname` == "Darwin" ]; then
       mnt_cmd=`echo ${mnt_cmd} | sed -e 's| /var/folders/| /private/var/folders/|g'`
   fi
   echo "${mnt_cmd}"
}

function update_path_variable()
{
  # Prepend /mnt/ in front of each entry of a PATH variable in which the arguments are
  # separated by a colon ":"
  # This allows for example to create the new MODELICAPATH
  local pat="$1"
  local new_pat=`(set -f; IFS=:; printf "/mnt%s:" ${pat})`
  # Cut the trailing ':'
  new_pat=${new_pat%?}
  echo "${new_pat}"
}

# Export the MODELICAPATH
if [ -z ${MODELICAPATH+x} ]; then
    MODELICAPATH=`pwd`
else
    # Add the current directory to the front of the Modelica path.
    # This will export the directory to the docker, and also set
    # it in the MODELICAPATH so that JModelica finds it.
    MODELICAPATH=`pwd`:${MODELICAPATH}
fi

# Create the command to mount all directories in read-only mode
MOD_MOUNT=`create_mount_command ${MODELICAPATH}`

# Prepend /mnt/ in front of each entry, which will then be used as the MODELICAPATH
DOCKER_MODELICAPATH=`update_path_variable ${MODELICAPATH}`

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
  ${MOD_MOUNT} \
  -v ${sha_dir}:/mnt/shared \
  --rm \
  ${DOCKER_USERNAME}/${IMG_NAME} /bin/bash -c \
  "export OPENMODELICALIBRARY=${DOCKER_MODELICAPATH}:/usr/lib/omlibrary && \
  cd /mnt/shared/${bas_nam} && \
  omc ${arg_lis}"
exit $?
