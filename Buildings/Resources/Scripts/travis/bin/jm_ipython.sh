#!/bin/bash
set -e
IMG_NAME=ubuntu-1804_jmodelica_trunk
DOCKER_USERNAME=michaelwetter
# Export the MODELICAPATH
if [ -z ${MODELICAPATH+x} ]; then
    MODELICAPATH=`pwd`
else
    # Add the current directory to the front of the Modelica path.
    # This will export the directory to the docker, and also set
    # it in the MODELICAPATH so that JModelica finds it.
    MODELICAPATH=`pwd`:${MODELICAPATH}
fi

# Each entry in the MODELICAPATH will be a mounted read-only volume
MOD_MOUNT=""
for ele in ${MODELICAPATH//:/ }; do
    MOD_MOUNT="${MOD_MOUNT} -v ${ele}:/mnt${ele}:ro"
done

 # On Darwin, the exported temporary folder needs to be /private/var/folders, not /var/folders
# see https://askubuntu.com/questions/600018/how-to-display-the-paths-in-path-separately
if [ `uname` == "Darwin" ]; then
    MOD_MOUNT=`echo ${MOD_MOUNT} | sed -e 's| /var/folders/| /private/var/folders/|g'`
fi

# Prepend /mnt/ in front of each entry, which will then be used as the MODELICAPATH
DOCKER_MODELICAPATH=`(set -f; IFS=:; printf "/mnt%s:" ${MODELICAPATH})`
# Cut the trailing ':'
DOCKER_MODELICAPATH=${DOCKER_MODELICAPATH%?}

# Replace in PYTHONPATH the current directory with /mnt/shared in front of each entry
CUR_DIR=`pwd`
PAR_DIR=`dirname ${CUR_DIR}`
DOCKER_PYTHONPATH=`echo ${PYTHONPATH//${PAR_DIR}/\/mnt\/shared}`

cur_dir=`pwd`
bas_nam=`basename ${cur_dir}`
sha_dir=`dirname ${cur_dir}`
# If the current directory is part of the argument list,
# replace it with . as the docker may have a different file structure
arg_lis=`echo $@ | sed -e "s|${cur_dir}|.|g"`

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
  -i \
  $DOCKER_INTERACTIVE \
  --detach=false \
  ${MOD_MOUNT} \
  -v ${sha_dir}:/mnt/shared \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --rm \
  ${DOCKER_USERNAME}/${IMG_NAME} /bin/bash -c \
  "export MODELICAPATH=${DOCKER_MODELICAPATH}:/usr/local/JModelica/ThirdParty/MSL && \
   export PYTHONPATH=${DOCKER_PYTHONPATH} && \
  cd /mnt/shared/${bas_nam} && \
  /usr/local/JModelica/bin/jm_ipython.sh ${arg_lis}"
exit $?
#  export PYTHONPATH=\"Buildings/Resources/Python-Sources\" && \
