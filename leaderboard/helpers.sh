# Turn colors in this script off by setting the NO_COLOR variable in your
# environment to any value:
#
# $ NO_COLOR=1 test.sh
NO_COLOR=${NO_COLOR:-""}
if [ -z "$NO_COLOR" ]; then
  header=$'\e[1;33m'
  reset=$'\e[0m'
else
  header=''
  reset=''
fi

function header_text {
  printf "$header$*$reset"
}

# Checks if a flag is present in the arguments.
hasflag() {
  local flags="$@"
  for var in $ARGS; do
    for flag in $flags; do
      if [ "$var" = "$flag" ]; then
        echo 'true'
        return
      fi
    done
  done
  echo 'false'
}

# Read the value of an option.
readopt() {
  local opts="$@"
  for var in $ARGS; do
    for opt in $opts; do
      if [[ "$var" = ${opt}* ]]; then
        # TODO space handling
        local value="${var//${opt}=/}"
        if [ "$value" != "$var" ]; then
          # Value could be extracted
          echo $value
          return
        fi
      fi
    done
  done
  # Nothing found
  echo ""
}

check_error() {
  local msg="$*"
  if [ "${msg//ERROR/}" != "${msg}" ]; then
    echo "${msg}"
    exit 1
  fi
}

