# run a function if a directory does not exist
function no-has-dir() {
  local dir=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -d $dir ]] && return 1
    return 0
  fi
  if [[ ! -d $dir ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    eval ${func}
  fi
}
# run a function if a directory exists
function has-dir() {
  local dir=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -d $dir ]] && return 0
    return 1
  fi
  if [[ -d $dir ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    eval ${func}
  fi
}
# run a function if a file does not exist
function no-has-file() {
  local file=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -f $file ]] && return 1
    return 0
  fi
  if [[ ! -f $file ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    eval ${func}
  fi
}
# run a function if a file exists
function has-file() {
  local file=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    [[ -f $file ]] && return 0
    return 1
  fi
  if [[ -f $file ]]; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    eval ${func}
  fi
}

# run a function if a command does not exist
function no-has-cmd() {
  local cmd=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    which "$cmd" >/dev/null 2>&1 && return 1
    return 0
  fi
  if ! which "$cmd" >/dev/null 2>&1; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    eval ${func}
  fi
}
# run a function if a command exists
function has-cmd() {
  local cmd=$1
  local func=$2
  local msg=$3
  # if no function provided, just return the test
  if [[ -z "$func" ]]; then
    which "$cmd" >/dev/null 2>&1 && return 0
    return 1
  fi
  if which "$cmd" >/dev/null 2>&1; then
    [[ -n "$msg" ]] && echo "$msg" # print message if provided
    eval ${func}
  fi
}

function no-has-flag() {
  no-has-file "$FLAGSDIR/$1" "$2" "$3"
}
function has-flag() {
  has-file "$FLAGSDIR/$1" "$2" "$3"
}

# creates a file containing a timestamp (in unix seconds) when a flag is set
# to indicate various states (ex. when a machine is set up, when a script or function is run, etc.)
function wdh-write-flag() {
  name=$1
  if [[ -z "$name" ]]; then
    echo "no flag name provided"
    return 1
  fi
  mkdir -p $FLAGSDIR
  touch "'$FLAGSDIR/$name'" &>/dev/null
  echo $(date +%s) >"$FLAGSDIR/$name"
}
# reads the timestamp (in unix seconds) of a flag
function wdh-read-flag() {
  name=$1
  if [[ -z "$name" ]]; then
    echo "no flag name provided"
    return 1
  fi
  if [[ ! -f "$FLAGSDIR/$name" ]]; then
    echo "$FLAGSDIR/$name not found"
    return 1
  fi
  local ts=$(<"$FLAGSDIR/$name")
  return $ts
}
function wdh-clear-flag() {
  name=$1
  if [[ -z "$name" ]]; then
    echo "no flag name provided"
    return 1
  fi
  rm -f "$FLAGSDIR/$name"
}
function wdh-flags-reset() {
  rm -rf "$FLAGSDIR"
}

# tests if this is a mac
function is-mac() {
  [[ "$(uname -s)" == "Darwin" ]]
}

function is-silicon-mac() {
  if ! is-mac; then return 0; fi
  [[ "$(uname -m)" == "arm64" ]]
}

function addPath() {
  case ":$PATH:" in
    *":$1:"*) :;; # already there
    *) PATH="$1:$PATH";; # or PATH="$PATH:$1"
  esac
}

function addFPath() {
  case ":$FPATH:" in
    *":$1:"*) :;; # already there
    *) FPATH="$1:$FPATH";; # or FPATH="$FPATH:$1"
  esac
}