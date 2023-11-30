# run a function if a directory does not exist
function no-has-dir() {
  local dir=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -d $dir ]] && return 0
    return 1
  fi
  if [[ ! -d $dir ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    $func
  fi
}
# run a function if a directory exists
function has-dir() {
  local dir=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -d $dir ]] && return 1
    return 0
  fi
  if [[ -d $dir ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    $func
  fi
}
# run a function if a file does not exist
function no-has-file() {
  local file=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -f $file ]] && return 0
    return 1
  fi
  if [[ ! -f $file ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    $func
  fi
}
# run a function if a file exists
function has-file() {
  local file=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -f $file ]] && return 1
    return 0
  fi
  if [[ -f $file ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    $func
  fi
}

# run a function if a command does not exist
function no-has-cmd() {
  local cmd=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    which "$cmd" >/dev/null 2>&1 && return 0
    return 1
  fi
  if ! which "$cmd" >/dev/null 2>&1; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    $func
  fi
}
# run a function if a command exists
function has-cmd() {
  local cmd=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    which "$cmd" >/dev/null 2>&1 && return 1
    return 0
  fi
  if which "$cmd" >/dev/null 2>&1; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    $func
  fi
}

# tests if this is a mac
function is-mac() {
  [[ "$(uname -s)" == "Darwin" ]]
}
