#!/bin/bash
#################################################
# Shell script that simulates OPTIMICA using
# a docker image of OPTIMICA.
#
# The main purpose of this script is to export
# MODELICAPATH and PYTHONPATH with their values
# updated for the docker, and to mount the
# required directories.
#################################################
set -e

IMG_NAME=${OPTIMICA_VERSION}
DOCKER_REPONAME=lbnlblum

NAME=${DOCKER_REPONAME}/${IMG_NAME}

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

# Make sure MAC_ADDRESS is set
if [ -z ${OPTIMICA_MAC_ADDRESS+x} ]; then
    echo "Error: Environment variable OPTIMICA_MAC_ADDRESS is not set."
    exit 1
fi

# Export the MODELICAPATH
if [ -z ${MODELICAPATH+x} ]; then
    MODELICAPATH=`pwd`
else
    # Add the current directory to the front of the Modelica path.
    # This will export the directory to the docker, and also set
    # it in the MODELICAPATH so that OPTIMICA finds it.
    MODELICAPATH=`pwd`:${MODELICAPATH}
fi

# Create the command to mount all directories in read-only mode
# a) for MODELICAPATH
MOD_MOUNT=`create_mount_command ${MODELICAPATH}`
# b) for PYTHONPATH
PYT_MOUNT=`create_mount_command ${PYTHONPATH}`

# Prepend /mnt/ in front of each entry, which will then be used as the MODELICAPATH
DOCKER_MODELICAPATH=`update_path_variable ${MODELICAPATH}`
DOCKER_PYTHONPATH=`update_path_variable ${PYTHONPATH}`

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

DOCKER_FLAGS="\
  --mac-address=${OPTIMICA_MAC_ADDRESS} \
  --detach=false \
  --rm \
  --user=${UID} \
  ${MOD_MOUNT} \
  ${PYT_MOUNT} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=${DISPLAY} \
  -v ${sha_dir}:/mnt/shared \
  -w /mnt/shared/${bas_nam} \
  ${NAME}"

# The command below adds various folders in /opt/oct/ThirdParty/MSL to MODELICAPATH
# to accomodate the change in OCT between oct-r19089 and oct-r26446
docker run ${DOCKER_FLAGS} /bin/bash -c \
  "export MODELICAPATH=${DOCKER_MODELICAPATH} && \
   export PYTHONPATH=${DOCKER_PYTHONPATH} && \
   export IPYTHONDIR=/mnt/shared &&
   alias ipython=ipython3 && \
   /opt/oct/bin/jm_ipython.sh ${arg_lis}"
exit $?
