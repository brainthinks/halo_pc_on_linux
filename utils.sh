#!/usr/bin/env bash

# @see - https://stackoverflow.com/a/5947802
NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'

function print_info () {
  echo -e "${YELLOW}$1${NC}"
}

function print_success () {
  echo -e "${GREEN}$1${NC}"
}

function print_failure () {
  echo -e "${RED}$1${NC}"
}

function error_check () {
  local error_code=$?
  local successMessage="$1"
  local failureMessage="$2"

  if [ "$error_code" != "0" ]; then
    print_failure "$failureMessage"
    exit "$error_code"
  fi

  print_success "$successMessage"
}
